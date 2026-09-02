#!/usr/bin/env python3
"""Compare a client entity-name export with one zone's maintained entity IDs."""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

from ruamel.yaml import YAML


ENTITY_BASE = 0x01000000
TARGET_MASK = 0xFFF
ENTITY_TARGET_LIMIT = 0x400
YAML_LOADER = YAML(typ="safe")


def expected_prefix(zone_id: int) -> int:
    if not 0 <= zone_id <= 0xFFF:
        raise ValueError(f"zone ID {zone_id} is outside 0..4095")
    return ENTITY_BASE | (zone_id << 12)


def normalized_name(value: Any) -> str:
    if not isinstance(value, str):
        return ""
    return " ".join(value.replace("_", " ").split()).casefold()


def load_client_zone(catalog_path: Path, zone_id: int) -> dict[int, str]:
    with catalog_path.open(encoding="utf-8") as source:
        catalog = json.load(source)

    if not isinstance(catalog, dict):
        raise ValueError("client catalog must be an object")
    if catalog.get("schema_version") != 1 or not isinstance(catalog.get("zones"), list):
        raise ValueError("client catalog must use export-zone-entities schema 1")

    if not all(isinstance(zone, dict) for zone in catalog["zones"]):
        raise ValueError("client catalog zones must be objects")
    matches = [zone for zone in catalog["zones"] if zone.get("zone_id") == zone_id]
    if len(matches) != 1:
        raise ValueError(
            f"client catalog has {len(matches)} records for zone {zone_id}"
        )

    prefix = expected_prefix(zone_id)
    raw_entries = matches[0].get("entries")
    if not isinstance(raw_entries, list):
        raise ValueError(f"client catalog zone {zone_id} entries must be a list")
    entries: dict[int, str] = {}
    for position, entry in enumerate(raw_entries):
        if not isinstance(entry, dict):
            raise ValueError(f"client entry {position} must be an object")
        raw_id = entry.get("id")
        name = entry.get("name")
        if not isinstance(raw_id, int) or not isinstance(name, str):
            raise ValueError(
                f"client entry {position} must contain integer id and string name"
            )
        if raw_id & ~TARGET_MASK != prefix:
            raise ValueError(
                f"client entity {raw_id:#010x} does not belong to zone {zone_id}"
            )
        target = raw_id & TARGET_MASK
        if target >= ENTITY_TARGET_LIMIT:
            raise ValueError(
                f"client entity {raw_id:#010x} uses the player or dynamic target range"
            )
        if target in entries:
            raise ValueError(f"client catalog repeats target {target:#05x}")
        entries[target] = name
    return entries


def mob_display_name(
    record: dict[str, Any], templates: dict[str, dict[str, Any]]
) -> str:
    template_name = record.get("template")
    if not isinstance(template_name, str) or not template_name:
        return ""
    template = templates.get(template_name)
    if not isinstance(template, dict):
        return ""
    return template.get("display_name") or template_name


def load_server_zone(zone_dir: Path, zone_id: int) -> dict[int, list[dict[str, Any]]]:
    prefix = expected_prefix(zone_id)
    entities: dict[int, list[dict[str, Any]]] = defaultdict(list)
    for filename, root_key, kind in (
        ("npcs.yaml", "npcs", "npc"),
        ("mobs.yaml", "spawns", "mob"),
    ):
        path = zone_dir / filename
        if not path.exists():
            continue
        with path.open(encoding="utf-8") as source:
            document = YAML_LOADER.load(source)
        if document is None:
            document = {}
        if not isinstance(document, dict):
            raise ValueError(f"{path}: document must be a mapping")
        records = document.get(root_key, {})
        if not isinstance(records, dict):
            raise ValueError(f"{path}: {root_key} must be a mapping")
        templates = document.get("templates", {}) if kind == "mob" else {}
        if not isinstance(templates, dict):
            raise ValueError(f"{path}: templates must be a mapping")
        for raw_id, record in records.items():
            if not isinstance(raw_id, int) or not isinstance(record, dict):
                raise ValueError(
                    f"{path}: entity keys must be integers with mapping values"
                )
            if raw_id & ~TARGET_MASK != prefix:
                raise ValueError(
                    f"{path}: entity {raw_id:#010x} does not belong to zone {zone_id}"
                )
            target = raw_id & TARGET_MASK
            if target >= ENTITY_TARGET_LIMIT:
                raise ValueError(
                    f"{path}: entity {raw_id:#010x} uses the player or dynamic target range"
                )
            if any(entity["kind"] == kind for entity in entities[target]):
                raise ValueError(f"{path}: repeated {kind} target {target:#05x}")
            placed = kind == "npc" or any(
                record.get(field) is not None
                for field in ("at", "region", "path", "circuit")
            )
            template_name = record.get("template") if kind == "mob" else None
            if template_name and template_name not in templates:
                raise ValueError(
                    f"{path}: entity {raw_id:#010x} references unknown template "
                    f"{template_name!r}"
                )
            name = (
                record.get("display_name") or ""
                if kind == "npc"
                else mob_display_name(record, templates)
            )
            entities[target].append(
                {
                    "full_id": raw_id,
                    "kind": kind,
                    "name": name,
                    "reserved": kind == "mob" and (not placed or not template_name),
                }
            )
    return dict(entities)


def compare(
    client: dict[int, str],
    server: dict[int, list[dict[str, Any]]],
    zone_id: int,
) -> dict[str, Any]:
    client_names = {target: normalized_name(name) for target, name in client.items()}
    server_names = {
        target: [
            normalized_name(entity["name"]) if not entity["reserved"] else ""
            for entity in entities
        ]
        for target, entities in server.items()
    }
    client_counts = Counter(name for name in client_names.values() if name)
    server_counts = Counter(
        name for names in server_names.values() for name in names if name
    )
    server_by_name: dict[str, list[tuple[int, str]]] = defaultdict(list)
    for target, entities in server.items():
        for entity, name in zip(entities, server_names[target]):
            if name:
                server_by_name[name].append((target, entity["kind"]))

    direct_matches = []
    same_index_mismatches = []
    unique_name_candidates = []
    ambiguous_client_targets = []
    unmatched_client_targets = []
    for target, client_name in sorted(client.items()):
        normalized = client_names[target]
        current = server.get(target, [])
        if current and normalized and normalized in server_names[target]:
            direct_matches.append(target)
            continue
        if current:
            same_index_mismatches.append(
                {
                    "target": target,
                    "client_name": client_name,
                    "server_entities": [
                        {
                            "kind": entity["kind"],
                            "name": entity["name"],
                            "reserved": entity["reserved"],
                        }
                        for entity in current
                    ],
                }
            )
        candidates = server_by_name.get(normalized, []) if normalized else []
        if (
            normalized
            and client_counts[normalized] == 1
            and server_counts[normalized] == 1
        ):
            unique_name_candidates.append(
                {
                    "old_target": candidates[0][0],
                    "new_target": target,
                    "kind": candidates[0][1],
                    "name": client_name,
                }
            )
        elif candidates:
            ambiguous_client_targets.append(target)
        else:
            unmatched_client_targets.append(target)

    server_only_targets = sorted(set(server) - set(client))
    reserved_server_targets = sorted(
        target
        for target, entities in server.items()
        if all(entity["reserved"] for entity in entities)
    )
    cross_type_collisions = [
        {
            "target": target,
            "entities": [
                {
                    "kind": entity["kind"],
                    "name": entity["name"],
                    "reserved": entity["reserved"],
                }
                for entity in entities
            ],
        }
        for target, entities in sorted(server.items())
        if len(entities) > 1
    ]
    return {
        "schema_version": 1,
        "zone_id": zone_id,
        "counts": {
            "client": len(client),
            "server_targets": len(server),
            "server_entities": sum(len(entities) for entities in server.values()),
            "direct_matches": len(direct_matches),
            "same_index_mismatches": len(same_index_mismatches),
            "unique_name_candidates": len(unique_name_candidates),
            "ambiguous_client_targets": len(ambiguous_client_targets),
            "unmatched_client_targets": len(unmatched_client_targets),
            "server_only_targets": len(server_only_targets),
            "reserved_server_targets": len(reserved_server_targets),
            "cross_type_collisions": len(cross_type_collisions),
        },
        "direct_matches": direct_matches,
        "same_index_mismatches": same_index_mismatches,
        "unique_name_candidates": unique_name_candidates,
        "ambiguous_client_targets": ambiguous_client_targets,
        "unmatched_client_targets": unmatched_client_targets,
        "server_only_targets": server_only_targets,
        "reserved_server_targets": reserved_server_targets,
        "cross_type_collisions": cross_type_collisions,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path, help="export-zone-entities schema-1 JSON")
    parser.add_argument("zone_id", type=int, help="numeric client zone ID")
    parser.add_argument("zone_dir", type=Path, help="data/zones/<zone> directory")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = compare(
        load_client_zone(args.catalog, args.zone_id),
        load_server_zone(args.zone_dir, args.zone_id),
        args.zone_id,
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
