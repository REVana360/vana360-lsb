#!/usr/bin/env python3
"""Compare a Tinkerer item catalog with LSB's canonical item_basic SQL.

The audit is read-only. Dense DAT slots with ID zero or an empty/dot English
name are placeholders, not client items. Names are comparison anchors only;
the report never authorizes an ID rewrite.
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
ITEM_ID_LIMIT = 0xFFFF
RESOURCE_NAMES = (
    "general_items",
    "usable_items",
    "weapons",
    "armor",
    "puppet_items",
    "currency",
)
SERVER_TYPE_RESOURCES = {
    "@GENERAL_TYPE": "general_items",
    "@LINKSHELL_TYPE": "general_items",
    "@FURNISHING_TYPE": "general_items",
    "@FLOWERPOT_TYPE": "general_items",
    "@USABLE_TYPE": "usable_items",
    "@WEAPON_TYPE": "weapons",
    "@EQUIPMENT_TYPE": "armor",
    "@PUPPET_TYPE": "puppet_items",
    "@CURRENCY_TYPE": "currency",
}
APOSTROPHES = str.maketrans("", "", "'`\u2018\u2019\u02bc")
INSERT_PREFIX = "INSERT INTO `item_basic` VALUES ("


def normalize_name(value: str) -> str:
    value = unicodedata.normalize("NFKC", value).casefold().translate(APOSTROPHES)
    value = value.replace("_", " ")
    return " ".join(re.sub(r"[^a-z0-9]+", " ", value).split())


def _split_sql_values(value: str, line_number: int) -> list[str]:
    fields: list[str] = []
    field: list[str] = []
    quoted = False
    index = 0
    while index < len(value):
        char = value[index]
        if char == "'":
            field.append(char)
            if quoted and index + 1 < len(value) and value[index + 1] == "'":
                field.append("'")
                index += 1
            else:
                quoted = not quoted
        elif char == "," and not quoted:
            fields.append("".join(field).strip())
            field = []
        else:
            field.append(char)
        index += 1
    if quoted:
        raise ValueError(f"server SQL line {line_number} has an unterminated string")
    fields.append("".join(field).strip())
    return fields


def _sql_string(value: str, line_number: int, column: str) -> str:
    if len(value) < 2 or value[0] != "'" or value[-1] != "'":
        raise ValueError(f"server SQL line {line_number} {column} must be quoted")
    return value[1:-1].replace("''", "'")


def load_client_entries(catalog_path: Path) -> list[dict[str, Any]]:
    with catalog_path.open(encoding="utf-8") as source:
        catalog = json.load(source)
    if not isinstance(catalog, dict) or catalog.get("schema_version") != 1:
        raise ValueError("item catalog must use schema 1")
    resources = catalog.get("resources")
    if not isinstance(resources, list):
        raise ValueError("item catalog resources must be a list")
    resources_by_name = {
        resource.get("name"): resource for resource in resources if isinstance(resource, dict)
    }
    if set(resources_by_name) != set(RESOURCE_NAMES) or len(resources) != len(RESOURCE_NAMES):
        raise ValueError("item catalog must contain each supported resource exactly once")

    entries: list[dict[str, Any]] = []
    for resource_name in RESOURCE_NAMES:
        raw_entries = resources_by_name[resource_name].get("entries")
        if not isinstance(raw_entries, list):
            raise ValueError(f"{resource_name} entries must be a list")
        indexes: set[int] = set()
        for position, raw_entry in enumerate(raw_entries):
            if not isinstance(raw_entry, dict):
                raise ValueError(f"{resource_name} entry {position} must be an object")
            index = raw_entry.get("index")
            entry_id = raw_entry.get("id")
            if type(index) is not int or index < 0:
                raise ValueError(f"{resource_name} entry {position} has an invalid index")
            if index in indexes:
                raise ValueError(f"{resource_name} repeats index {index}")
            indexes.add(index)
            if type(entry_id) is not int or not 0 <= entry_id <= ITEM_ID_LIMIT:
                raise ValueError(f"{resource_name} entry {position} has an invalid ID")
            stack_size = raw_entry.get("stack_size")
            if type(stack_size) is not int or stack_size < 0:
                raise ValueError(f"{resource_name} entry {position} has an invalid stack size")
            text = raw_entry.get("text")
            english = text.get("english") if isinstance(text, dict) else None
            if english is not None and not isinstance(english, dict):
                raise ValueError(f"{resource_name} entry {position} English text is invalid")
            names = []
            for key in ("name", "singular_name", "plural_name"):
                name = english.get(key) if isinstance(english, dict) else None
                if name is not None and not isinstance(name, str):
                    raise ValueError(
                        f"{resource_name} entry {position} English {key} must be a string"
                    )
                if name:
                    names.append(name)
            display_name = names[0] if names else ""
            normalized_names = sorted(
                {normalize_name(name) for name in names if normalize_name(name)}
            )
            placeholder = entry_id == 0 or display_name.strip() in {"", "."}
            entries.append(
                {
                    "resource": resource_name,
                    "index": index,
                    "id": entry_id,
                    "name": display_name,
                    "names": names,
                    "normalized_names": normalized_names,
                    "stack_size": stack_size,
                    "placeholder": placeholder,
                }
            )
    return entries


def load_server_entries(sql_path: Path) -> list[dict[str, Any]]:
    entries: list[dict[str, Any]] = []
    for line_number, line in enumerate(
        sql_path.read_text(encoding="utf-8-sig").splitlines(), start=1
    ):
        stripped = line.strip()
        if not stripped.startswith(INSERT_PREFIX):
            continue
        tuple_end = stripped.rfind(");")
        if tuple_end < 0:
            raise ValueError(f"server SQL line {line_number} has an invalid item tuple")
        trailing = stripped[tuple_end + 2 :].strip()
        if trailing and not trailing.startswith("--"):
            raise ValueError(f"server SQL line {line_number} has invalid trailing text")
        fields = _split_sql_values(
            stripped[len(INSERT_PREFIX) : tuple_end], line_number
        )
        if len(fields) != 10:
            raise ValueError(f"server SQL line {line_number} must contain 10 columns")
        entry_id = int(fields[0], 10)
        if not 0 <= entry_id <= ITEM_ID_LIMIT:
            raise ValueError(f"server SQL line {line_number} has an invalid item ID")
        resource = SERVER_TYPE_RESOURCES.get(fields[5])
        if resource is None:
            raise ValueError(
                f"server SQL line {line_number} has unknown item type {fields[5]}"
            )
        stack_size = int(fields[6], 10)
        name = _sql_string(fields[2], line_number, "name")
        entries.append(
            {
                "id": entry_id,
                "name": name,
                "normalized_name": normalize_name(name),
                "resource": resource,
                "stack_size": stack_size,
                "line": line_number,
            }
        )
    if not entries:
        raise ValueError("server item_basic SQL contains no entries")
    return entries


def compare(
    client_entries: list[dict[str, Any]], server_entries: list[dict[str, Any]]
) -> dict[str, Any]:
    client_real = [entry for entry in client_entries if not entry["placeholder"]]
    client_placeholders = [entry for entry in client_entries if entry["placeholder"]]
    client_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    server_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    client_by_name: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
    server_by_name: dict[tuple[str, str], list[dict[str, Any]]] = defaultdict(list)
    placeholders_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)

    for entry in client_real:
        client_by_id[entry["id"]].append(entry)
        for name in entry["normalized_names"]:
            client_by_name[(entry["resource"], name)].append(entry)
    for entry in client_placeholders:
        if entry["id"] != 0:
            placeholders_by_id[entry["id"]].append(entry)
    for entry in server_entries:
        server_by_id[entry["id"]].append(entry)
        if entry["normalized_name"]:
            server_by_name[(entry["resource"], entry["normalized_name"])].append(entry)

    direct_matches = []
    same_id_name_mismatches = []
    same_id_category_mismatches = []
    stack_size_mismatches = []
    client_only_items = []
    unique_name_shift_candidates = []
    for entry_id, clients in sorted(client_by_id.items()):
        if len(clients) != 1:
            continue
        client = clients[0]
        servers = server_by_id.get(entry_id, [])
        if len(servers) == 1:
            server = servers[0]
            base = {
                "id": entry_id,
                "client_resource": client["resource"],
                "client_index": client["index"],
                "client_name": client["name"],
                "server_resource": server["resource"],
                "server_name": server["name"],
                "server_line": server["line"],
            }
            if client["resource"] != server["resource"]:
                same_id_category_mismatches.append(base)
            elif server["normalized_name"] in client["normalized_names"]:
                direct_matches.append(base)
            else:
                same_id_name_mismatches.append(base)
            # Gil's DAT value is 57599, while SQL uses zero and CItemCurrency
            # supplies its own unlimited runtime stack. These fields differ in meaning.
            if (
                client["resource"] != "currency"
                and client["stack_size"] != server["stack_size"]
            ):
                stack_size_mismatches.append(
                    {
                        **base,
                        "client_stack_size": client["stack_size"],
                        "server_stack_size": server["stack_size"],
                    }
                )
        elif not servers:
            client_only_items.append(
                {
                    "id": entry_id,
                    "resource": client["resource"],
                    "index": client["index"],
                    "client_name": client["name"],
                }
            )

        candidates: dict[int, dict[str, Any]] = {}
        for name in client["normalized_names"]:
            if len(client_by_name[(client["resource"], name)]) != 1:
                continue
            name_servers = server_by_name.get((client["resource"], name), [])
            if len(name_servers) == 1 and name_servers[0]["id"] != entry_id:
                candidates[name_servers[0]["id"]] = name_servers[0]
        if len(candidates) == 1:
            server = next(iter(candidates.values()))
            unique_name_shift_candidates.append(
                {
                    "client_id": entry_id,
                    "client_resource": client["resource"],
                    "client_index": client["index"],
                    "client_name": client["name"],
                    "server_id": server["id"],
                    "server_name": server["name"],
                    "server_line": server["line"],
                }
            )

    client_ids = set(client_by_id)
    server_at_client_placeholder = []
    server_only_items = []
    for entry_id, servers in sorted(server_by_id.items()):
        if entry_id in client_ids:
            continue
        target = server_at_client_placeholder if entry_id in placeholders_by_id else server_only_items
        target.append({"id": entry_id, "server_entries": servers})

    duplicate_client_ids = [
        {"id": entry_id, "client_entries": entries}
        for entry_id, entries in sorted(client_by_id.items())
        if len(entries) > 1
    ]
    duplicate_server_ids = [
        {"id": entry_id, "server_entries": entries}
        for entry_id, entries in sorted(server_by_id.items())
        if len(entries) > 1
    ]

    def resource_counts(entries: list[dict[str, Any]]) -> dict[str, int]:
        return {
            resource: sum(entry["resource"] == resource for entry in entries)
            for resource in RESOURCE_NAMES
        }

    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "counts": {
            "client_entries": len(client_entries),
            "client_items": len(client_real),
            "client_placeholders": len(client_placeholders),
            "server_items": len(server_entries),
            "direct_matches": len(direct_matches),
            "same_id_name_mismatches": len(same_id_name_mismatches),
            "same_id_category_mismatches": len(same_id_category_mismatches),
            "stack_size_mismatches": len(stack_size_mismatches),
            "unique_name_shift_candidates": len(unique_name_shift_candidates),
            "client_only_items": len(client_only_items),
            "server_at_client_placeholder": len(server_at_client_placeholder),
            "server_only_items": len(server_only_items),
            "duplicate_client_ids": len(duplicate_client_ids),
            "duplicate_server_ids": len(duplicate_server_ids),
            "client_items_by_resource": resource_counts(client_real),
            "client_placeholders_by_resource": resource_counts(client_placeholders),
            "server_items_by_resource": resource_counts(server_entries),
        },
        "direct_matches": direct_matches,
        "same_id_name_mismatches": same_id_name_mismatches,
        "same_id_category_mismatches": same_id_category_mismatches,
        "stack_size_mismatches": stack_size_mismatches,
        "unique_name_shift_candidates": unique_name_shift_candidates,
        "client_only_items": client_only_items,
        "server_at_client_placeholder": server_at_client_placeholder,
        "server_only_items": server_only_items,
        "duplicate_client_ids": duplicate_client_ids,
        "duplicate_server_ids": duplicate_server_ids,
        "client_placeholders": client_placeholders,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path, help="export-items schema-1 JSON")
    parser.add_argument("item_basic", type=Path, help="sql/item_basic.sql")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = compare(
        load_client_entries(args.catalog), load_server_entries(args.item_basic)
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
