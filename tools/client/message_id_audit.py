#!/usr/bin/env python3
"""Compare a selected-client message table with its canonical server enum."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Any


REPORT_SCHEMA_VERSION = 1
RESOURCE_ENUM = {
    "system_messages2": "MsgStd",
    "system_messages4": "MsgBasic",
}


def is_placeholder(resource_name: str, text: str) -> bool:
    stripped = text.strip()
    if not stripped:
        return True
    if stripped.casefold().startswith("dummy"):
        return True
    if resource_name == "system_messages4":
        return stripped == "${prompt}"
    return False


def load_client_entries(catalog_path: Path, resource_name: str) -> list[dict[str, Any]]:
    if resource_name not in RESOURCE_ENUM:
        raise ValueError(f"unsupported client resource {resource_name}")
    with catalog_path.open(encoding="utf-8") as source:
        catalog = json.load(source)
    if not isinstance(catalog, dict) or catalog.get("schema_version") != 1:
        raise ValueError("client resource catalog must use schema 1")
    resources = catalog.get("resources")
    if not isinstance(resources, list):
        raise ValueError("client resource catalog resources must be a list")
    matches = [
        resource
        for resource in resources
        if isinstance(resource, dict) and resource.get("name") == resource_name
    ]
    if len(matches) != 1:
        raise ValueError(f"catalog must contain exactly one {resource_name} resource")
    sources = matches[0].get("sources")
    if not isinstance(sources, list):
        raise ValueError(f"{resource_name} sources must be a list")
    english = [
        source
        for source in sources
        if isinstance(source, dict)
        and source.get("language") == "english"
        and source.get("status") == "selected"
    ]
    if len(english) != 1:
        raise ValueError(f"{resource_name} must have one selected English source")
    data = english[0].get("data")
    entries = data.get("entries") if isinstance(data, dict) else None
    if not isinstance(entries, dict):
        raise ValueError(f"{resource_name} selected source must contain entries")

    result = []
    for raw_id, text in entries.items():
        if not isinstance(raw_id, str) or not raw_id.isdigit():
            raise ValueError(f"{resource_name} has invalid entry ID {raw_id!r}")
        if not isinstance(text, str):
            raise ValueError(f"{resource_name} ID {raw_id} text must be a string")
        result.append(
            {
                "id": int(raw_id, 10),
                "text": text,
                "placeholder": is_placeholder(resource_name, text),
            }
        )
    return sorted(result, key=lambda entry: entry["id"])


def load_server_entries(enum_path: Path, enum_name: str) -> list[dict[str, Any]]:
    if enum_name not in RESOURCE_ENUM.values():
        raise ValueError(f"unsupported server enum {enum_name}")
    start = re.compile(rf"^enum class {re.escape(enum_name)}\s*:")
    entry = re.compile(
        r"^\s*(?P<name>[A-Za-z][A-Za-z0-9_]*)\s*=\s*"
        r"(?P<id>[0-9]+)\s*,?(?:\s*//\s*(?P<comment>.*))?$"
    )
    inside = False
    result = []
    for line_number, line in enumerate(
        enum_path.read_text(encoding="utf-8-sig").splitlines(), start=1
    ):
        if not inside:
            if start.match(line):
                inside = True
            continue
        if line.strip() == "};":
            break
        match = entry.match(line)
        if not match:
            continue
        result.append(
            {
                "id": int(match.group("id"), 10),
                "name": match.group("name"),
                "comment": match.group("comment") or "",
                "line": line_number,
            }
        )
    if not inside:
        raise ValueError(f"server header does not contain enum {enum_name}")
    if not result:
        raise ValueError(f"server enum {enum_name} contains no explicit entries")
    return result


def compare(
    resource_name: str,
    enum_name: str,
    client_entries: list[dict[str, Any]],
    server_entries: list[dict[str, Any]],
) -> dict[str, Any]:
    client_by_id = {entry["id"]: entry for entry in client_entries}
    if len(client_by_id) != len(client_entries):
        raise ValueError("client resource contains duplicate IDs")
    server_by_id: dict[int, list[dict[str, Any]]] = {}
    for entry in server_entries:
        server_by_id.setdefault(entry["id"], []).append(entry)

    supported_server_ids = []
    server_at_client_placeholder = []
    server_outside_client = []
    for entry_id, entries in sorted(server_by_id.items()):
        client = client_by_id.get(entry_id)
        row = {"id": entry_id, "server_entries": entries}
        if client is None:
            server_outside_client.append(row)
        elif client["placeholder"]:
            row["client_text"] = client["text"]
            server_at_client_placeholder.append(row)
        else:
            row["client_text"] = client["text"]
            supported_server_ids.append(row)

    client_without_server_enum = [
        entry
        for entry in client_entries
        if not entry["placeholder"] and entry["id"] not in server_by_id
    ]
    client_placeholders = [entry for entry in client_entries if entry["placeholder"]]
    duplicate_server_ids = [
        {"id": entry_id, "server_entries": entries}
        for entry_id, entries in sorted(server_by_id.items())
        if len(entries) > 1
    ]
    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "resource": resource_name,
        "server_enum": enum_name,
        "counts": {
            "client_entries": len(client_entries),
            "client_placeholders": len(client_placeholders),
            "server_entries": len(server_entries),
            "supported_server_ids": len(supported_server_ids),
            "server_at_client_placeholder": len(server_at_client_placeholder),
            "server_outside_client": len(server_outside_client),
            "client_without_server_enum": len(client_without_server_enum),
            "duplicate_server_ids": len(duplicate_server_ids),
        },
        "supported_server_ids": supported_server_ids,
        "server_at_client_placeholder": server_at_client_placeholder,
        "server_outside_client": server_outside_client,
        "client_without_server_enum": client_without_server_enum,
        "duplicate_server_ids": duplicate_server_ids,
        "client_placeholders": client_placeholders,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("resource", choices=RESOURCE_ENUM)
    parser.add_argument("enum_header", type=Path)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    enum_name = RESOURCE_ENUM[args.resource]
    report = compare(
        args.resource,
        enum_name,
        load_client_entries(args.catalog, args.resource),
        load_server_entries(args.enum_header, enum_name),
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
