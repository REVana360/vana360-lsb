#!/usr/bin/env python3
"""Compare a Tinkerer key-item catalog with LSB's canonical key-item enum.

The audit is read-only and conservative. It reports exact ID/name matches,
same-ID name conflicts, unique-name shift candidates, client-only IDs, and
server-only IDs. ID-zero DAT headings are retained as structural metadata and
are not treated as duplicate key items.
"""

from __future__ import annotations

import argparse
import json
import re
import unicodedata
from collections import defaultdict
from pathlib import Path
from typing import Any


REPORT_SCHEMA_VERSION = 1
KEY_ITEM_ID_LIMIT = 0xFFFF
ENUM_ENTRY = re.compile(
    r"^\s*(?P<constant>[A-Z][A-Z0-9_]*)\s*=\s*" r"(?P<id>0[xX][0-9A-Fa-f]+|[0-9]+)\s*,"
)
APOSTROPHES = str.maketrans("", "", "'`\u2018\u2019\u02bc")


def normalize_name(value: str) -> str:
    value = unicodedata.normalize("NFKC", value).casefold().translate(APOSTROPHES)
    value = re.sub(r"(?<=[a-z0-9])\.(?=[a-z0-9])", "", value)
    value = value.replace("_", " ")
    return " ".join(re.sub(r"[^a-z0-9]+", " ", value).split())


def load_client_entries(catalog_path: Path) -> list[dict[str, Any]]:
    with catalog_path.open(encoding="utf-8") as source:
        catalog = json.load(source)
    if not isinstance(catalog, dict) or catalog.get("schema_version") != 1:
        raise ValueError("key-item catalog must use schema 1")
    resources = catalog.get("resources")
    if not isinstance(resources, list) or len(resources) != 1:
        raise ValueError("key-item catalog must contain exactly one resource")
    resource = resources[0]
    if not isinstance(resource, dict) or resource.get("name") != "key_items":
        raise ValueError("key-item catalog resource must be named key_items")
    raw_entries = resource.get("entries")
    if not isinstance(raw_entries, list):
        raise ValueError("key-item resource entries must be a list")

    entries: list[dict[str, Any]] = []
    indexes: set[int] = set()
    for position, raw_entry in enumerate(raw_entries):
        if not isinstance(raw_entry, dict):
            raise ValueError(f"client entry {position} must be an object")
        index = raw_entry.get("index")
        if type(index) is not int or index < 0:
            raise ValueError(
                f"client entry {position} index must be a nonnegative integer"
            )
        if index in indexes:
            raise ValueError(f"client catalog repeats index {index}")
        indexes.add(index)
        entry_id = raw_entry.get("id")
        if entry_id is not None and type(entry_id) is not int:
            raise ValueError(f"client entry {position} ID must be an integer or null")
        if entry_id is not None and not 0 <= entry_id <= KEY_ITEM_ID_LIMIT:
            raise ValueError(
                f"client entry {position} ID must be within 0..{KEY_ITEM_ID_LIMIT}"
            )
        text = raw_entry.get("text")
        english = text.get("english") if isinstance(text, dict) else None
        name = english.get("name") if isinstance(english, dict) else None
        if name is not None and not isinstance(name, str):
            raise ValueError(f"client entry {position} English name must be a string")
        entries.append(
            {
                "index": index,
                "id": entry_id,
                "name": name or "",
                "normalized_name": normalize_name(name or ""),
            }
        )
    return entries


def load_server_entries(enum_path: Path) -> list[dict[str, Any]]:
    entries: list[dict[str, Any]] = []
    for line_number, line in enumerate(
        enum_path.read_text(encoding="utf-8").splitlines(), start=1
    ):
        match = ENUM_ENTRY.match(line)
        if not match:
            continue
        constant = match.group("constant")
        entries.append(
            {
                "id": int(match.group("id"), 0),
                "constant": constant,
                "normalized_name": normalize_name(constant),
                "line": line_number,
            }
        )
    if not entries:
        raise ValueError("server key-item enum contains no entries")
    return entries


def _duplicates(
    grouped: dict[int, list[dict[str, Any]]], label: str
) -> list[dict[str, Any]]:
    duplicates = []
    for entry_id, entries in sorted(grouped.items()):
        if entry_id != 0 and len(entries) > 1:
            duplicates.append(
                {
                    "id": entry_id,
                    label: entries,
                }
            )
    return duplicates


def compare(
    client_entries: list[dict[str, Any]], server_entries: list[dict[str, Any]]
) -> dict[str, Any]:
    client_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    server_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    client_by_name: dict[str, list[dict[str, Any]]] = defaultdict(list)
    server_by_name: dict[str, list[dict[str, Any]]] = defaultdict(list)
    null_id_entries = []

    for entry in client_entries:
        if entry["id"] is None:
            null_id_entries.append(entry)
            continue
        client_by_id[entry["id"]].append(entry)
        if entry["id"] != 0 and entry["normalized_name"]:
            client_by_name[entry["normalized_name"]].append(entry)
    for entry in server_entries:
        server_by_id[entry["id"]].append(entry)
        if entry["id"] != 0 and entry["normalized_name"]:
            server_by_name[entry["normalized_name"]].append(entry)

    direct_matches = []
    same_id_mismatches = []
    unique_name_shift_candidates = []
    client_only_ids = []
    for entry_id, entries in sorted(client_by_id.items()):
        if entry_id == 0 or len(entries) != 1:
            continue
        client = entries[0]
        servers = server_by_id.get(entry_id, [])
        if len(servers) == 1:
            server = servers[0]
            if client["normalized_name"] == server["normalized_name"]:
                direct_matches.append(
                    {
                        "id": entry_id,
                        "client_index": client["index"],
                        "client_name": client["name"],
                        "server_constant": server["constant"],
                        "server_line": server["line"],
                    }
                )
            else:
                same_id_mismatches.append(
                    {
                        "id": entry_id,
                        "client_index": client["index"],
                        "client_name": client["name"],
                        "server_constant": server["constant"],
                        "server_line": server["line"],
                    }
                )
        elif not servers:
            client_only_ids.append(
                {
                    "id": entry_id,
                    "client_name": client["name"],
                    "index": client["index"],
                }
            )

        name = client["normalized_name"]
        name_clients = client_by_name.get(name, [])
        name_servers = server_by_name.get(name, [])
        if (
            name
            and len(name_clients) == 1
            and len(name_servers) == 1
            and name_servers[0]["id"] != entry_id
        ):
            server = name_servers[0]
            unique_name_shift_candidates.append(
                {
                    "client_id": entry_id,
                    "client_index": client["index"],
                    "server_id": server["id"],
                    "client_name": client["name"],
                    "server_constant": server["constant"],
                    "server_line": server["line"],
                }
            )

    client_ids = {entry_id for entry_id in client_by_id if entry_id != 0}
    server_only_ids = [
        {
            "id": entry_id,
            "server_entries": entries,
        }
        for entry_id, entries in sorted(server_by_id.items())
        if entry_id != 0 and entry_id not in client_ids
    ]
    duplicate_client_ids = _duplicates(client_by_id, "client_entries")
    duplicate_server_ids = _duplicates(server_by_id, "server_entries")
    structural_zero_entries = client_by_id.get(0, [])

    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "counts": {
            "client_entries": len(client_entries),
            "client_nonzero_ids": len(client_ids),
            "server_entries": len(server_entries),
            "server_nonzero_ids": len(
                {entry["id"] for entry in server_entries if entry["id"] != 0}
            ),
            "direct_matches": len(direct_matches),
            "same_id_mismatches": len(same_id_mismatches),
            "unique_name_shift_candidates": len(unique_name_shift_candidates),
            "client_only_ids": len(client_only_ids),
            "server_only_ids": len(server_only_ids),
            "duplicate_client_ids": len(duplicate_client_ids),
            "duplicate_server_ids": len(duplicate_server_ids),
            "structural_zero_entries": len(structural_zero_entries),
            "null_id_entries": len(null_id_entries),
        },
        "direct_matches": direct_matches,
        "same_id_mismatches": same_id_mismatches,
        "unique_name_shift_candidates": unique_name_shift_candidates,
        "client_only_ids": client_only_ids,
        "server_only_ids": server_only_ids,
        "duplicate_client_ids": duplicate_client_ids,
        "duplicate_server_ids": duplicate_server_ids,
        "structural_zero_entries": structural_zero_entries,
        "null_id_entries": null_id_entries,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path, help="export-key-items schema-1 JSON")
    parser.add_argument("enum", type=Path, help="scripts/enum/key_item.lua")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = compare(load_client_entries(args.catalog), load_server_entries(args.enum))
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
