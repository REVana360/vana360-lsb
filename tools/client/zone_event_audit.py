#!/usr/bin/env python3
"""Audit one zone's server event scripts against July client event DATs.

The audit is intentionally read-only.  It uses the Tinkerer zone-entities and
zone-events exports to match NPC script filenames to client entities, then
compares the literal event IDs used by the scripts with each entity's client
event block.  Dynamic expressions are reported for manual review and are never
guessed or rewritten.
"""

from __future__ import annotations

import argparse
import json
import re
import unicodedata
from collections import defaultdict
from pathlib import Path
from typing import Any, Iterable


REPORT_SCHEMA_VERSION = 1
EVENT_SENTINEL = 0xFFFF
CALL_PATTERN = re.compile(
    r"(?<![A-Za-z0-9_])(?P<kind>startEvent|quest:event|quest:progressEvent)\s*\(",
    re.IGNORECASE,
)
NUMERIC_LITERAL = re.compile(r"(?P<sign>[+-]?)(?P<value>0[xX][0-9A-Fa-f]+|[0-9]+)")


def normalize_entity_name(value: str) -> str:
    """Normalize DAT names and Lua filenames for exact name matching."""

    value = unicodedata.normalize("NFKC", value).casefold()
    result: list[str] = []
    for character in value:
        result.append(character if character.isalnum() else " ")
    return " ".join("".join(result).split())


def _zone_record(catalog: dict[str, Any], zone_id: int, label: str) -> dict[str, Any]:
    if catalog.get("schema_version") != 1 or not isinstance(catalog.get("zones"), list):
        raise ValueError(f"{label} must use schema 1")
    matches = [
        zone
        for zone in catalog["zones"]
        if isinstance(zone, dict) and zone.get("zone_id") == zone_id
    ]
    if len(matches) != 1:
        raise ValueError(f"{label} has {len(matches)} records for zone {zone_id}")
    return matches[0]


def _read_json(path: Path, label: str) -> dict[str, Any]:
    with path.open(encoding="utf-8") as source:
        value = json.load(source)
    if not isinstance(value, dict):
        raise ValueError(f"{label} must be an object")
    return value


def load_client_entities(catalog_path: Path, zone_id: int) -> list[dict[str, Any]]:
    """Load one zone's July entity names, preserving catalog order."""

    zone = _zone_record(
        _read_json(catalog_path, "zone-entities catalog"),
        zone_id,
        "zone-entities catalog",
    )
    raw_entries = zone.get("entries")
    if not isinstance(raw_entries, list):
        raise ValueError(f"zone-entities zone {zone_id} entries must be a list")

    entities: list[dict[str, Any]] = []
    seen_ids: set[int] = set()
    for position, raw_entry in enumerate(raw_entries):
        if not isinstance(raw_entry, dict):
            raise ValueError(f"client entity {position} must be an object")
        entity_id = raw_entry.get("id")
        name = raw_entry.get("name")
        if type(entity_id) is not int or not isinstance(name, str):
            raise ValueError(
                f"client entity {position} must contain integer id and string name"
            )
        if entity_id in seen_ids:
            raise ValueError(f"client entity catalog repeats ID {entity_id}")
        seen_ids.add(entity_id)
        entities.append(
            {
                "entity_id": entity_id,
                "name": name,
                "normalized_name": normalize_entity_name(name),
            }
        )
    return entities


def load_client_event_blocks(
    catalog_path: Path, zone_id: int
) -> dict[int, dict[str, Any]]:
    """Load one zone's July event blocks keyed by entity ID."""

    zone = _zone_record(
        _read_json(catalog_path, "zone-events catalog"),
        zone_id,
        "zone-events catalog",
    )
    raw_blocks = zone.get("event_blocks")
    if not isinstance(raw_blocks, list):
        raise ValueError(f"zone-events zone {zone_id} event_blocks must be a list")

    blocks: dict[int, dict[str, Any]] = {}
    for position, raw_block in enumerate(raw_blocks):
        if not isinstance(raw_block, dict):
            raise ValueError(f"client event block {position} must be an object")
        entity_id = raw_block.get("entity_id")
        raw_events = raw_block.get("events")
        if type(entity_id) is not int or not isinstance(raw_events, list):
            raise ValueError(
                f"client event block {position} must contain integer entity_id and events list"
            )
        if entity_id in blocks:
            raise ValueError(f"client event catalog repeats entity ID {entity_id}")
        event_ids: list[int] = []
        sentinel_event_count = 0
        for event_position, raw_event in enumerate(raw_events):
            if not isinstance(raw_event, dict) or type(raw_event.get("id")) is not int:
                raise ValueError(
                    f"client event block {position} event {event_position} must contain integer id"
                )
            event_id = raw_event["id"]
            if event_id == EVENT_SENTINEL:
                sentinel_event_count += 1
            else:
                event_ids.append(event_id)
        blocks[entity_id] = {
            "entity_id": entity_id,
            "event_ids": sorted(set(event_ids)),
            "event_count": len(event_ids),
            "sentinel_event_count": sentinel_event_count,
        }
    return blocks


def _strip_lua_comments(source: str) -> str:
    """Remove Lua comments while retaining strings and line positions."""

    result: list[str] = []
    index = 0
    quote: str | None = None
    while index < len(source):
        character = source[index]
        if quote:
            result.append(character)
            if character == "\\" and index + 1 < len(source):
                result.append(source[index + 1])
                index += 2
                continue
            if character == quote:
                quote = None
            index += 1
            continue
        if character in {"'", '"'}:
            quote = character
            result.append(character)
            index += 1
            continue
        if source.startswith("--[[", index):
            end = source.find("]]", index + 4)
            if end < 0:
                result.extend("\n" for _ in source[index:].splitlines())
                break
            comment = source[index : end + 2]
            result.extend("\n" if item == "\n" else " " for item in comment)
            index = end + 2
            continue
        if source.startswith("--", index):
            end = source.find("\n", index + 2)
            if end < 0:
                result.extend(" " for _ in source[index:])
                break
            result.extend(" " for _ in source[index:end])
            result.append("\n")
            index = end + 1
            continue
        result.append(character)
        index += 1
    return "".join(result)


def _first_argument(source: str, opening: int) -> str:
    """Return the first argument and its end offset after an opening paren."""

    start = opening + 1
    index = start
    depth = 0
    quote: str | None = None
    while index < len(source):
        character = source[index]
        if quote:
            if character == "\\":
                index += 2
                continue
            if character == quote:
                quote = None
            index += 1
            continue
        if character in {"'", '"'}:
            quote = character
        elif character in "([{":
            depth += 1
        elif character in ")]}":
            if depth == 0:
                return source[start:index]
            depth -= 1
        elif character == "," and depth == 0:
            return source[start:index]
        index += 1
    return source[start:]


def _iter_call_matches(source: str) -> Iterable[re.Match[str]]:
    """Yield event calls outside quoted Lua strings."""

    index = 0
    while index < len(source):
        character = source[index]
        if character in {"'", '"'}:
            quote = character
            index += 1
            while index < len(source):
                if source[index] == "\\":
                    index += 2
                elif source[index] == quote:
                    index += 1
                    break
                else:
                    index += 1
            continue
        match = CALL_PATTERN.match(source, index)
        if match:
            yield match
            index = match.end()
        else:
            index += 1


def extract_event_usages(
    source: str,
) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    """Extract literal and dynamic event calls from one Lua source file."""

    source = _strip_lua_comments(source)
    literal: list[dict[str, Any]] = []
    dynamic: list[dict[str, Any]] = []
    for match in _iter_call_matches(source):
        expression = _first_argument(source, match.end() - 1)
        expression = expression.strip()
        line = source.count("\n", 0, match.start()) + 1
        numeric = NUMERIC_LITERAL.fullmatch(expression)
        usage = {
            "kind": match.group("kind"),
            "line": line,
            "expression": expression,
        }
        if numeric:
            literal_text = numeric.group("value")
            base = 16 if literal_text.casefold().startswith("0x") else 10
            value = int(literal_text, base)
            if numeric.group("sign") == "-":
                value = -value
            literal.append({"id": value, **usage})
        else:
            dynamic.append(usage)
    return literal, dynamic


def _script_root(scripts_dir: Path) -> Path:
    npc_dir = scripts_dir / "npcs"
    return npc_dir if npc_dir.is_dir() else scripts_dir


def _script_files(scripts_dir: Path) -> Iterable[tuple[str, Path]]:
    root = _script_root(scripts_dir)
    if not root.is_dir():
        raise ValueError(f"scripts directory does not exist: {scripts_dir}")
    for path in sorted(
        (path for path in root.rglob("*") if path.suffix.casefold() == ".lua"),
        key=lambda item: (item.as_posix().casefold(), item.as_posix()),
    ):
        if path.is_file():
            yield path.relative_to(root).as_posix(), path


def _public_entity(entity: dict[str, Any]) -> dict[str, Any]:
    return {"entity_id": entity["entity_id"], "name": entity["name"]}


def audit(
    zone_events: Iterable[dict[str, Any]],
    zone_entities: list[dict[str, Any]],
    scripts_dir: Path,
    zone_id: int,
) -> dict[str, Any]:
    """Audit one zone using already loaded client records."""

    event_blocks: dict[int, dict[str, Any]] = {}
    for block in zone_events:
        entity_id = block["entity_id"]
        if entity_id in event_blocks:
            raise ValueError(f"event records repeat entity ID {entity_id}")
        event_blocks[entity_id] = {
            **block,
            "event_ids": sorted(
                {
                    event_id
                    for event_id in block["event_ids"]
                    if event_id != EVENT_SENTINEL
                }
            ),
        }
    entities_by_name: dict[str, list[dict[str, Any]]] = defaultdict(list)
    entities_by_id: dict[int, dict[str, Any]] = {}
    for entity in zone_entities:
        entities_by_name[entity["normalized_name"]].append(entity)
        entities_by_id[entity["entity_id"]] = entity

    entity_matches: list[dict[str, Any]] = []
    exact_matches: list[dict[str, Any]] = []
    mismatches: list[dict[str, Any]] = []
    missing_event_blocks: list[dict[str, Any]] = []
    incompatible_literal_ids: list[dict[str, Any]] = []
    compatible_matches: list[dict[str, Any]] = []
    dynamic_usages: list[dict[str, Any]] = []
    ambiguous_matches: list[dict[str, Any]] = []
    server_scripts_absent: list[dict[str, Any]] = []
    matched_entity_ids: set[int] = set()

    scripts = list(_script_files(scripts_dir))
    for script_name, script_path in scripts:
        script_stem = Path(script_name).stem
        normalized_name = normalize_entity_name(script_stem)
        source = script_path.read_text(encoding="utf-8")
        literal, dynamic = extract_event_usages(source)
        literal_ids = sorted({usage["id"] for usage in literal})
        dynamic_record = {
            "script": script_name,
            "usages": dynamic,
        }
        if dynamic:
            dynamic_usages.append(dynamic_record)

        candidates = entities_by_name.get(normalized_name, [])
        if len(candidates) != 1:
            if len(candidates) > 1:
                ambiguous_matches.append(
                    {
                        "script": script_name,
                        "script_name": script_stem,
                        "normalized_name": normalized_name,
                        "candidates": [
                            _public_entity(entity)
                            for entity in sorted(
                                candidates, key=lambda item: item["entity_id"]
                            )
                        ],
                        "literal_event_ids": literal_ids,
                        "dynamic_usages": dynamic,
                    }
                )
            else:
                server_scripts_absent.append(
                    {
                        "script": script_name,
                        "script_name": script_stem,
                        "normalized_name": normalized_name,
                        "literal_event_ids": literal_ids,
                        "dynamic_usages": dynamic,
                    }
                )
            continue

        entity = candidates[0]
        entity_id = entity["entity_id"]
        matched_entity_ids.add(entity_id)
        block = event_blocks.get(entity_id)
        client_ids = block["event_ids"] if block else []
        incompatible_ids = sorted(set(literal_ids) - set(client_ids))
        status = "match" if block is not None and not incompatible_ids else "mismatch"
        if block is None:
            status = "missing_event_block"
        record = {
            "script": script_name,
            "script_name": script_stem,
            "entity_id": entity_id,
            "client_name": entity["name"],
            "client_event_ids": client_ids,
            "literal_event_ids": literal_ids,
            "incompatible_literal_event_ids": incompatible_ids,
            "literal_usages": literal,
            "dynamic_usages": dynamic,
            "status": status,
        }
        entity_matches.append(record)
        if status == "match":
            compatible_matches.append(record)
            if literal_ids == client_ids:
                exact_matches.append(record)
        elif status == "mismatch":
            mismatches.append(record)
            incompatible_literal_ids.append(
                {
                    "script": script_name,
                    "entity_id": entity_id,
                    "event_ids": incompatible_ids,
                }
            )
        else:
            missing_event_blocks.append(record)

    client_entities_with_events_without_script = []
    for entity_id, block in sorted(event_blocks.items()):
        if not block["event_ids"] or entity_id in matched_entity_ids:
            continue
        entity = entities_by_id.get(entity_id)
        client_entities_with_events_without_script.append(
            {
                "entity_id": entity_id,
                "name": entity["name"] if entity else None,
                "event_ids": block["event_ids"],
            }
        )

    event_blocks_without_entity = [
        {
            "entity_id": entity_id,
            "event_ids": block["event_ids"],
        }
        for entity_id, block in sorted(event_blocks.items())
        if entity_id not in entities_by_id
    ]

    entity_matches.sort(key=lambda item: item["script"].casefold())
    exact_matches.sort(key=lambda item: item["script"].casefold())
    compatible_matches.sort(key=lambda item: item["script"].casefold())
    mismatches.sort(key=lambda item: item["script"].casefold())
    missing_event_blocks.sort(key=lambda item: item["script"].casefold())
    incompatible_literal_ids.sort(key=lambda item: item["script"].casefold())
    dynamic_usages.sort(key=lambda item: item["script"].casefold())
    ambiguous_matches.sort(key=lambda item: item["script"].casefold())
    server_scripts_absent.sort(key=lambda item: item["script"].casefold())

    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "zone_id": zone_id,
        "counts": {
            "client_entities": len(zone_entities),
            "client_event_blocks": len(event_blocks),
            "client_entities_with_events": sum(
                bool(block["event_ids"]) for block in event_blocks.values()
            ),
            "server_scripts": len(scripts),
            "matched_scripts": len(entity_matches),
            "matches": len(compatible_matches),
            "compatible_matches": len(compatible_matches),
            "exact_matches": len(exact_matches),
            "mismatches": len(mismatches),
            "missing_event_blocks": len(missing_event_blocks),
            "incompatible_literal_event_ids": sum(
                len(record["event_ids"]) for record in incompatible_literal_ids
            ),
            "dynamic_scripts": len(dynamic_usages),
            "dynamic_usages": sum(len(record["usages"]) for record in dynamic_usages),
            "unresolved_usages": sum(
                len(record["usages"]) for record in dynamic_usages
            ),
            "ambiguous_entity_matches": len(ambiguous_matches),
            "client_entities_with_events_without_script": len(
                client_entities_with_events_without_script
            ),
            "event_blocks_without_entity": len(event_blocks_without_entity),
            "server_scripts_absent_from_client": len(server_scripts_absent),
            "server_entities_absent_from_client": len(server_scripts_absent),
        },
        "entity_matches": entity_matches,
        "matches": compatible_matches,
        "compatible_matches": compatible_matches,
        "exact_matches": exact_matches,
        "mismatches": mismatches,
        "missing_event_blocks": missing_event_blocks,
        "incompatible_literal_event_ids": incompatible_literal_ids,
        "dynamic_usages": dynamic_usages,
        "unresolved_usages": dynamic_usages,
        "ambiguous_entity_matches": ambiguous_matches,
        "client_entities_with_events_without_script": client_entities_with_events_without_script,
        "event_blocks_without_entity": event_blocks_without_entity,
        "server_scripts_absent_from_client": server_scripts_absent,
        "server_entities_absent_from_client": server_scripts_absent,
    }


def audit_zone(
    zone_events_path: Path,
    zone_entities_path: Path,
    zone_id: int,
    scripts_dir: Path,
) -> dict[str, Any]:
    """Load catalogs and audit one zone's scripts."""

    return audit(
        load_client_event_blocks(zone_events_path, zone_id).values(),
        load_client_entities(zone_entities_path, zone_id),
        scripts_dir,
        zone_id,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "zone_events", type=Path, help="export-zone-events schema-1 JSON"
    )
    parser.add_argument(
        "zone_entities", type=Path, help="export-zone-entities schema-1 JSON"
    )
    parser.add_argument("zone_id", type=int, help="numeric client zone ID")
    parser.add_argument(
        "scripts_dir", type=Path, help="zone scripts or NPC scripts directory"
    )
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = audit_zone(
        args.zone_events,
        args.zone_entities,
        args.zone_id,
        args.scripts_dir,
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
