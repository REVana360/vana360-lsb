#!/usr/bin/env python3
"""Reconcile one Tinkerer zone-text export with an LSB zone IDs.lua file.

The audit is intentionally read-only.  It compares the text comments attached
to constants in the ``text`` table and classifies each constant as a direct
ID match, a moved unique-text match, an ambiguous text match, or unmatched.
DAT control tags are reduced to the placeholders used by LSB comments; the
original source text is retained in the JSON report for review.
"""

from __future__ import annotations

import argparse
import json
import re
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


REPORT_SCHEMA_VERSION = 1
TEXT_BLOCK_START = re.compile(r"^\s*text\s*=\s*\{\s*$")
TEXT_ASSIGNMENT = re.compile(r"^\s*text\s*=\s*$")
TEXT_BLOCK_END = re.compile(r"^\s*\},\s*(?:--.*)?$")
TEXT_ENTRY = re.compile(
    r"^\s*(?P<constant>[A-Za-z_][A-Za-z0-9_]*)\s*=\s*"
    r"(?P<id>0[xX][0-9A-Fa-f]+|[0-9]+)\s*,\s*"
    r"(?:--\s*(?P<comment>.*))?\s*$"
)
DAT_TAG = re.compile(r"\$\{([^{}]*)\}")
DAT_TIMESTAMP = re.compile(
    r"\$\{ts-year(?::[^{}]*)?\}\s*/\s*"
    r"\$\{ts-month(?::[^{}]*)?\}\s*/\s*"
    r"\$\{ts-day(?::[^{}]*)?\}\s+"
    r"\$\{ts-hour(?::[^{}]*)?\}\s*:\s*"
    r"\$\{ts-minute(?::[^{}]*)?\}\s*:\s*"
    r"\$\{ts-second(?::[^{}]*)?\}"
)
LSB_TAG = re.compile(r"<\s*([A-Za-z][A-Za-z0-9_-]*)\s*>")
STANDALONE_HASH = re.compile(r"(?<![A-Za-z0-9])#(?![A-Za-z0-9])")
STANDALONE_PERCENT = re.compile(r"(?<![A-Za-z0-9])%(?![A-Za-z0-9])")


def _canonical_tag(expression: str) -> str:
    """Turn a Tinkerer tag into an LSB-style placeholder or control text."""

    tag = expression.split(":", 1)[0].strip().casefold()
    if tag in {"prompt", "lettercase"}:
        return ""
    if tag == "selection-lines":
        return " "
    if tag.startswith("item"):
        return "<arg>"
    if tag.startswith("keyitem"):
        return "<arg>"
    if tag.startswith("number") or tag in {"countdown-seconds", "gil"}:
        return "<arg>"
    if tag.startswith("name") or tag in {
        "player",
        "entity",
        "entity-source",
        "entity-target",
    }:
        return "<arg>"
    if tag.startswith("spell"):
        return "<arg>"
    if tag.startswith("skill"):
        return "<arg>"
    if tag.startswith("weather"):
        return "<arg>"
    if tag.startswith("ts-") or tag in {"earthtime", "vanatime"}:
        return "<timestamp>"
    if tag == "zone":
        return "<arg>"
    if tag in {"color", "color-alt"}:
        return ""
    if tag.startswith("choice") or tag in {
        "article",
        "status-effect-noun",
        "status-effect-adjective",
        "weather-adjective",
        "weather-noun",
    }:
        # Choice and article tags carry formatting/selection state; the
        # literal alternatives or noun that follows remains comparable.
        return ""
    return f"<{tag}>" if tag else ""


def _canonical_lsb_tag(tag: str) -> str:
    """Use one placeholder for LSB's typed and legacy argument markers."""

    normalized = tag.casefold()
    if normalized in {
        "item",
        "keyitem",
        "number",
        "name",
        "player",
        "npc",
        "spell",
        "skill",
        "zone",
    } or normalized.startswith(("item-", "keyitem-", "number-")):
        return "<arg>"
    if normalized == "timestamp":
        return "<timestamp>"
    return f"<{normalized}>"


def normalize_text(value: str) -> str:
    """Normalize DAT markup and typography without rewriting source text."""

    text = unicodedata.normalize("NFKC", value)
    text = text.translate(
        str.maketrans(
            {
                "\u2018": "'",
                "\u2019": "'",
                "\u201a": "'",
                "\u201b": "'",
                "\u201c": '"',
                "\u201d": '"',
                "\u201e": '"',
                "\u2026": "...",
                "\u2010": "-",
                "\u2011": "-",
                "\u2012": "-",
                "\u2013": "-",
                "\u2014": "-",
                "\u2015": "-",
                "\u00a0": " ",
            }
        )
    )
    text = DAT_TIMESTAMP.sub("<timestamp>", text)
    text = DAT_TAG.sub(lambda match: _canonical_tag(match.group(1)), text)
    text = LSB_TAG.sub(lambda match: _canonical_lsb_tag(match.group(1)), text)
    text = STANDALONE_HASH.sub("<arg>", text)
    text = STANDALONE_PERCENT.sub("<arg>", text)
    return " ".join(text.casefold().split())


def _entry(constant: str, entry_id: int, comment: str) -> dict[str, Any]:
    return {
        "constant": constant,
        "id": entry_id,
        "text": comment,
        "normalized_text": normalize_text(comment),
    }


def load_lsb_text(ids_path: Path) -> list[dict[str, Any]]:
    """Read text constants and trailing comments from one zone IDs.lua."""

    lines = ids_path.read_text(encoding="utf-8").splitlines()
    in_text = False
    awaiting_text_open = False
    entries: list[dict[str, Any]] = []
    seen_ids: set[int] = set()
    for line_number, line in enumerate(lines, start=1):
        if not in_text:
            if TEXT_BLOCK_START.match(line):
                in_text = True
            elif TEXT_ASSIGNMENT.match(line):
                awaiting_text_open = True
            elif awaiting_text_open and line.strip() == "{":
                in_text = True
                awaiting_text_open = False
            continue
        if TEXT_BLOCK_END.match(line):
            break
        if not line.strip() or line.lstrip().startswith("--"):
            continue
        match = TEXT_ENTRY.match(line)
        if not match:
            raise ValueError(f"{ids_path}:{line_number}: invalid text entry")
        entry_id = int(match.group("id"), 0)
        if entry_id in seen_ids:
            raise ValueError(f"{ids_path}:{line_number}: repeated text ID {entry_id}")
        seen_ids.add(entry_id)
        entries.append(
            _entry(match.group("constant"), entry_id, match.group("comment") or "")
        )
    if not in_text:
        raise ValueError(f"{ids_path}: missing text table")
    if not entries:
        raise ValueError(f"{ids_path}: text table has no entries")
    return entries


def load_client_zone(catalog_path: Path, zone_id: int) -> list[dict[str, Any]]:
    """Read one zone from a Tinkerer export-zone-text schema-1 JSON file."""

    with catalog_path.open(encoding="utf-8") as source:
        catalog = json.load(source)
    if not isinstance(catalog, dict):
        raise ValueError("zone-text catalog must be an object")
    if catalog.get("schema_version") != 1 or not isinstance(catalog.get("zones"), list):
        raise ValueError("zone-text catalog must use export-zone-text schema 1")
    zones = catalog["zones"]
    matches = [
        zone
        for zone in zones
        if isinstance(zone, dict) and zone.get("zone_id") == zone_id
    ]
    if len(matches) != 1:
        raise ValueError(
            f"zone-text catalog has {len(matches)} records for zone {zone_id}"
        )
    raw_entries = matches[0].get("entries")
    if not isinstance(raw_entries, list):
        raise ValueError(f"zone-text zone {zone_id} entries must be a list")
    entries: list[dict[str, Any]] = []
    seen_ids: set[int] = set()
    for position, raw_entry in enumerate(raw_entries):
        if not isinstance(raw_entry, dict):
            raise ValueError(f"client text entry {position} must be an object")
        entry_id = raw_entry.get("id")
        text = raw_entry.get("text")
        if type(entry_id) is not int or not isinstance(text, str):
            raise ValueError(
                f"client text entry {position} must contain integer id and string text"
            )
        if entry_id in seen_ids:
            raise ValueError(f"client text catalog repeats ID {entry_id}")
        seen_ids.add(entry_id)
        entries.append(_entry("", entry_id, text))
    return entries


def _public_entry(
    entry: dict[str, Any], include_constant: bool = True
) -> dict[str, Any]:
    result: dict[str, Any] = {"id": entry["id"], "text": entry["text"]}
    if include_constant:
        result["constant"] = entry["constant"]
    return result


def compare(
    client_entries: list[dict[str, Any]],
    lsb_entries: list[dict[str, Any]],
    zone_id: int,
) -> dict[str, Any]:
    """Classify one zone's IDs.lua entries against client text entries."""

    client_by_id = {entry["id"]: entry for entry in client_entries}
    client_by_text: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for entry in sorted(client_entries, key=lambda item: item["id"]):
        if entry["normalized_text"]:
            client_by_text[entry["normalized_text"]].append(entry)
    lsb_text_counts = Counter(
        entry["normalized_text"] for entry in lsb_entries if entry["normalized_text"]
    )

    direct_id_matches: list[dict[str, Any]] = []
    direct_id_mismatches: list[dict[str, Any]] = []
    unique_text_matches: list[dict[str, Any]] = []
    ambiguous_matches: list[dict[str, Any]] = []
    unmatched_entries: list[dict[str, Any]] = []
    matched_client_ids: set[int] = set()

    for lsb_entry in sorted(lsb_entries, key=lambda item: item["id"]):
        client_entry = client_by_id.get(lsb_entry["id"])
        if (
            client_entry
            and client_entry["normalized_text"] == lsb_entry["normalized_text"]
        ):
            direct_id_matches.append(
                {
                    "id": lsb_entry["id"],
                    "constant": lsb_entry["constant"],
                    "text": lsb_entry["text"],
                }
            )
            matched_client_ids.add(client_entry["id"])
            continue
        if client_entry:
            direct_id_mismatches.append(
                {
                    "id": lsb_entry["id"],
                    "constant": lsb_entry["constant"],
                    "lsb_text": lsb_entry["text"],
                    "client_text": client_entry["text"],
                }
            )
        normalized = lsb_entry["normalized_text"]
        candidates = client_by_text.get(normalized, []) if normalized else []
        if normalized and len(candidates) == 1 and lsb_text_counts[normalized] == 1:
            candidate = candidates[0]
            unique_text_matches.append(
                {
                    "old_id": lsb_entry["id"],
                    "new_id": candidate["id"],
                    "constant": lsb_entry["constant"],
                    "text": lsb_entry["text"],
                }
            )
            matched_client_ids.add(candidate["id"])
        elif candidates:
            ambiguous_matches.append(
                {
                    "id": lsb_entry["id"],
                    "constant": lsb_entry["constant"],
                    "text": lsb_entry["text"],
                    "candidate_ids": [candidate["id"] for candidate in candidates],
                }
            )
        else:
            unmatched_entries.append(_public_entry(lsb_entry))

    client_only_entries = [
        _public_entry(entry, include_constant=False)
        for entry in sorted(client_entries, key=lambda item: item["id"])
        if entry["id"] not in matched_client_ids
    ]
    return {
        "schema_version": REPORT_SCHEMA_VERSION,
        "zone_id": zone_id,
        "counts": {
            "client_entries": len(client_entries),
            "lsb_entries": len(lsb_entries),
            "direct_id_matches": len(direct_id_matches),
            "direct_id_mismatches": len(direct_id_mismatches),
            "unique_text_matches": len(unique_text_matches),
            "ambiguous_matches": len(ambiguous_matches),
            "unmatched_entries": len(unmatched_entries),
            "client_only_entries": len(client_only_entries),
        },
        "direct_id_matches": direct_id_matches,
        "direct_id_mismatches": direct_id_mismatches,
        "unique_text_matches": unique_text_matches,
        "ambiguous_matches": ambiguous_matches,
        "unmatched_entries": unmatched_entries,
        "client_only_entries": client_only_entries,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "zone_text", type=Path, help="Tinkerer export-zone-text schema-1 JSON"
    )
    parser.add_argument("zone_id", type=int, help="numeric zone ID")
    parser.add_argument("ids_lua", type=Path, help="LSB zone IDs.lua file")
    parser.add_argument("--out", type=Path, help="write JSON here instead of stdout")
    args = parser.parse_args()

    report = compare(
        load_client_zone(args.zone_text, args.zone_id),
        load_lsb_text(args.ids_lua),
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
