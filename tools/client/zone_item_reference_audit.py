#!/usr/bin/env python3
"""Audit static zone script item references against a client item catalog."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any

from tools.client.item_audit import load_client_entries


REPORT_SCHEMA_VERSION = 1
ENUM_PATTERN = re.compile(r"^\s*([A-Z][A-Z0-9_]*)\s*=\s*(\d+)\s*,?")
REFERENCE_PATTERN = re.compile(r"\bxi\.item\.([A-Z][A-Z0-9_]*)\b")


def load_item_constants(enum_path: Path) -> dict[str, int]:
    constants: dict[str, int] = {}
    for line_number, line in enumerate(
        enum_path.read_text(encoding="utf-8-sig").splitlines(), start=1
    ):
        match = ENUM_PATTERN.match(line)
        if match is None:
            continue
        name, raw_id = match.groups()
        if name in constants:
            raise ValueError(f"item enum repeats {name} at line {line_number}")
        constants[name] = int(raw_id, 10)
    if not constants:
        raise ValueError("item enum contains no constants")
    return constants


def script_files(paths: list[Path]) -> list[Path]:
    files: set[Path] = set()
    for path in paths:
        if path.is_file():
            if path.suffix == ".lua":
                files.add(path)
        elif path.is_dir():
            files.update(candidate for candidate in path.rglob("*.lua") if candidate.is_file())
        else:
            raise ValueError(f"script path does not exist: {path}")
    return sorted(files, key=lambda path: path.as_posix())


def audit(
    catalog_path: Path, enum_path: Path, paths: list[Path]
) -> dict[str, Any]:
    active_items = {
        entry["id"]: entry
        for entry in load_client_entries(catalog_path)
        if not entry["placeholder"]
    }
    constants = load_item_constants(enum_path)
    files = script_files(paths)
    references: dict[str, list[dict[str, Any]]] = {}
    for path in files:
        for line_number, line in enumerate(
            path.read_text(encoding="utf-8-sig").splitlines(), start=1
        ):
            for match in REFERENCE_PATTERN.finditer(line):
                references.setdefault(match.group(1), []).append(
                    {"file": path.as_posix(), "line": line_number}
                )

    active_references = []
    absent_references = []
    missing_constants = []
    for name, usages in sorted(references.items()):
        item_id = constants.get(name)
        if item_id is None:
            missing_constants.append({"constant": name, "usages": usages})
            continue
        result = {"constant": name, "id": item_id, "usages": usages}
        client = active_items.get(item_id)
        if client is None:
            absent_references.append(result)
        else:
            result["client_name"] = client["name"]
            active_references.append(result)

    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "counts": {
            "files": len(files),
            "unique_references": len(references),
            "active_references": len(active_references),
            "absent_references": len(absent_references),
            "missing_constants": len(missing_constants),
        },
        "active_references": active_references,
        "absent_references": absent_references,
        "missing_constants": missing_constants,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path, help="export-items schema-1 JSON")
    parser.add_argument("item_enum", type=Path, help="scripts/enum/item.lua")
    parser.add_argument("paths", type=Path, nargs="+", help="Lua files or directories")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = audit(args.catalog, args.item_enum, args.paths)
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    failures = report["counts"]["absent_references"] + report["counts"]["missing_constants"]
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
