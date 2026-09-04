#!/usr/bin/env python3
"""Audit literal zone DefaultActions events against client event blocks."""

from __future__ import annotations

import argparse
import json
import re
from collections import defaultdict
from pathlib import Path
from typing import Any

from ruamel.yaml import YAML

from tools.client.zone_event_audit import load_client_event_blocks


REPORT_SCHEMA_VERSION = 1
DEFAULT_EVENT = re.compile(
    r"\[['\"](?P<name>[^'\"]+)['\"]\]\s*=\s*\{\s*event\s*=\s*"
    r"(?P<event>0[xX][0-9A-Fa-f]+|[0-9]+)"
)
YAML_LOADER = YAML(typ="safe")


def load_default_events(path: Path) -> list[dict[str, Any]]:
    events = []
    for line_number, line in enumerate(
        path.read_text(encoding="utf-8-sig").splitlines(), start=1
    ):
        match = DEFAULT_EVENT.search(line)
        if match:
            events.append(
                {
                    "script": match.group("name"),
                    "event_id": int(match.group("event"), 0),
                    "line": line_number,
                }
            )
    return events


def load_normal_npcs(path: Path) -> dict[str, list[dict[str, Any]]]:
    with path.open(encoding="utf-8") as source:
        document = YAML_LOADER.load(source)
    records = document.get("npcs") if isinstance(document, dict) else None
    if not isinstance(records, dict):
        raise ValueError("NPC YAML must contain an npcs mapping")

    by_script: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for entity_id, record in records.items():
        if type(entity_id) is not int or not isinstance(record, dict):
            raise ValueError("NPC YAML entries must use integer IDs and mappings")
        script = record.get("script")
        if not isinstance(script, str) or record.get("status") == "cutscene_only":
            continue
        by_script[script].append(
            {
                "entity_id": entity_id,
                "display_name": record.get("display_name", ""),
            }
        )
    return dict(by_script)


def audit(
    event_blocks: dict[int, dict[str, Any]],
    npcs_by_script: dict[str, list[dict[str, Any]]],
    default_events: list[dict[str, Any]],
) -> dict[str, Any]:
    matches = []
    incompatible = []
    unmapped = []
    for action in default_events:
        npcs = npcs_by_script.get(action["script"], [])
        if not npcs:
            unmapped.append(action)
            continue
        for npc in npcs:
            block = event_blocks.get(npc["entity_id"])
            client_events = block["event_ids"] if block else []
            result = {**action, **npc, "client_event_ids": client_events}
            if action["event_id"] in client_events:
                matches.append(result)
            else:
                incompatible.append(result)

    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "counts": {
            "default_events": len(default_events),
            "matches": len(matches),
            "incompatible": len(incompatible),
            "unmapped": len(unmapped),
        },
        "matches": matches,
        "incompatible": incompatible,
        "unmapped": unmapped,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("zone_events", type=Path, help="export-zone-events schema-1 JSON")
    parser.add_argument("zone_id", type=int, help="numeric client zone ID")
    parser.add_argument("npcs", type=Path, help="data/zones/<zone>/npcs.yaml")
    parser.add_argument("default_actions", type=Path, help="zone DefaultActions.lua")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = audit(
        load_client_event_blocks(args.zone_events, args.zone_id),
        load_normal_npcs(args.npcs),
        load_default_events(args.default_actions),
    )
    output = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if args.out:
        args.out.write_text(output, encoding="utf-8", newline="\n")
    else:
        print(output, end="")
    failures = report["counts"]["incompatible"] + report["counts"]["unmapped"]
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
