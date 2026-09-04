#!/usr/bin/env python3
"""Compare one dense Tinkerer name resource with a canonical LSB SQL table."""

from __future__ import annotations

import argparse
import json
import re
import unicodedata
from collections import defaultdict
from pathlib import Path
from typing import Any


REPORT_SCHEMA_VERSION = 1
RESOURCE_SQL = {
    "ability_names": "abilities",
    "spell_names": "spell_list",
}
APOSTROPHES = str.maketrans("", "", "'`\u2018\u2019\u02bc")


def normalize_name(value: str) -> str:
    value = unicodedata.normalize("NFKC", value).casefold().translate(APOSTROPHES)
    value = value.replace("_", " ")
    return " ".join(re.sub(r"[^a-z0-9]+", " ", value).split())


def is_placeholder(resource_name: str, name: str) -> bool:
    stripped = name.strip()
    if stripped in {"", "."}:
        return True
    if resource_name == "spell_names":
        return stripped.casefold() in {"(null)", "dummy"} or bool(
            re.fullmatch(r"\(magic [0-9]+\)", stripped.casefold())
        )
    return False


def load_client_entries(catalog_path: Path, resource_name: str) -> list[dict[str, Any]]:
    if resource_name not in RESOURCE_SQL:
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
    lists = data.get("lists") if isinstance(data, dict) else None
    if not isinstance(lists, dict):
        raise ValueError(f"{resource_name} selected source must contain lists")

    entries = []
    for raw_id, values in lists.items():
        if not isinstance(raw_id, str) or not raw_id.isdigit():
            raise ValueError(f"{resource_name} has invalid list ID {raw_id!r}")
        entry_id = int(raw_id, 10)
        if not isinstance(values, list) or not values or not isinstance(values[0], dict):
            raise ValueError(f"{resource_name} ID {entry_id} has invalid values")
        name = values[0].get("string")
        if not isinstance(name, str):
            raise ValueError(f"{resource_name} ID {entry_id} name must be a string")
        entries.append(
            {
                "id": entry_id,
                "name": name,
                "normalized_name": normalize_name(name),
                "placeholder": is_placeholder(resource_name, name),
            }
        )
    return sorted(entries, key=lambda entry: entry["id"])


def load_server_entries(sql_path: Path, table: str) -> list[dict[str, Any]]:
    if table not in RESOURCE_SQL.values():
        raise ValueError(f"unsupported server table {table}")
    row = re.compile(
        rf"^\s*INSERT INTO `{re.escape(table)}` VALUES\s*"
        r"\((?P<id>[0-9]+),'(?P<name>(?:''|[^'])*)',"
    )
    entries = []
    for line_number, line in enumerate(
        sql_path.read_text(encoding="utf-8-sig").splitlines(), start=1
    ):
        if not line.lstrip().startswith(f"INSERT INTO `{table}`"):
            continue
        match = row.match(line)
        if not match:
            raise ValueError(f"server SQL line {line_number} has an invalid {table} row")
        name = match.group("name").replace("''", "'")
        entries.append(
            {
                "id": int(match.group("id"), 10),
                "name": name,
                "normalized_name": normalize_name(name),
                "line": line_number,
            }
        )
    if not entries:
        raise ValueError(f"server SQL contains no {table} entries")
    return entries


def compare(
    resource_name: str,
    table: str,
    client_entries: list[dict[str, Any]],
    server_entries: list[dict[str, Any]],
) -> dict[str, Any]:
    client_real = [entry for entry in client_entries if not entry["placeholder"]]
    client_placeholders = [entry for entry in client_entries if entry["placeholder"]]
    client_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    server_by_id: dict[int, list[dict[str, Any]]] = defaultdict(list)
    client_by_name: dict[str, list[dict[str, Any]]] = defaultdict(list)
    server_by_name: dict[str, list[dict[str, Any]]] = defaultdict(list)
    placeholder_ids = {entry["id"] for entry in client_placeholders}
    for entry in client_real:
        client_by_id[entry["id"]].append(entry)
        if entry["normalized_name"]:
            client_by_name[entry["normalized_name"]].append(entry)
    for entry in server_entries:
        server_by_id[entry["id"]].append(entry)
        if entry["normalized_name"]:
            server_by_name[entry["normalized_name"]].append(entry)

    direct_matches = []
    same_id_name_mismatches = []
    client_only_ids = []
    unique_name_shift_candidates = []
    for entry_id, clients in sorted(client_by_id.items()):
        if len(clients) != 1:
            continue
        client = clients[0]
        servers = server_by_id.get(entry_id, [])
        if len(servers) == 1:
            server = servers[0]
            target = (
                direct_matches
                if client["normalized_name"] == server["normalized_name"]
                else same_id_name_mismatches
            )
            target.append(
                {
                    "id": entry_id,
                    "client_name": client["name"],
                    "server_name": server["name"],
                    "server_line": server["line"],
                }
            )
        elif not servers:
            client_only_ids.append(client)

        name = client["normalized_name"]
        name_servers = server_by_name.get(name, [])
        if (
            name
            and len(client_by_name[name]) == 1
            and len(name_servers) == 1
            and name_servers[0]["id"] != entry_id
        ):
            server = name_servers[0]
            unique_name_shift_candidates.append(
                {
                    "client_id": entry_id,
                    "client_name": client["name"],
                    "server_id": server["id"],
                    "server_name": server["name"],
                    "server_line": server["line"],
                }
            )

    client_ids = set(client_by_id)
    server_at_client_placeholder = []
    server_only_ids = []
    for entry_id, servers in sorted(server_by_id.items()):
        if entry_id in client_ids:
            continue
        target = (
            server_at_client_placeholder
            if entry_id in placeholder_ids
            else server_only_ids
        )
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
    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "resource": resource_name,
        "server_table": table,
        "counts": {
            "client_entries": len(client_entries),
            "client_ids": len(client_real),
            "client_placeholders": len(client_placeholders),
            "server_ids": len(server_entries),
            "direct_matches": len(direct_matches),
            "same_id_name_mismatches": len(same_id_name_mismatches),
            "unique_name_shift_candidates": len(unique_name_shift_candidates),
            "client_only_ids": len(client_only_ids),
            "server_at_client_placeholder": len(server_at_client_placeholder),
            "server_only_ids": len(server_only_ids),
            "duplicate_client_ids": len(duplicate_client_ids),
            "duplicate_server_ids": len(duplicate_server_ids),
        },
        "direct_matches": direct_matches,
        "same_id_name_mismatches": same_id_name_mismatches,
        "unique_name_shift_candidates": unique_name_shift_candidates,
        "client_only_ids": client_only_ids,
        "server_at_client_placeholder": server_at_client_placeholder,
        "server_only_ids": server_only_ids,
        "duplicate_client_ids": duplicate_client_ids,
        "duplicate_server_ids": duplicate_server_ids,
        "client_placeholders": client_placeholders,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("resource", choices=RESOURCE_SQL)
    parser.add_argument("sql", type=Path)
    parser.add_argument("--out", type=Path)
    args = parser.parse_args()
    table = RESOURCE_SQL[args.resource]
    report = compare(
        args.resource,
        table,
        load_client_entries(args.catalog, args.resource),
        load_server_entries(args.sql, table),
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
