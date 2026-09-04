import json
import tempfile
import unittest
from pathlib import Path

from tools.client.zone_event_audit import (
    audit,
    audit_zone,
    extract_event_usages,
    normalize_entity_name,
)


def client_entity(entity_id, name):
    return {
        "entity_id": entity_id,
        "name": name,
        "normalized_name": normalize_entity_name(name),
    }


def event_block(entity_id, event_ids):
    return {
        "entity_id": entity_id,
        "event_ids": sorted(set(event_ids)),
        "event_count": len(event_ids),
    }


class ZoneEventAuditTest(unittest.TestCase):
    def test_loads_tinkerer_catalogs_and_zone_scripts(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "npcs").mkdir()
            (root / "npcs/Field_Manual.lua").write_text(
                "player:startEvent(115)\n", encoding="utf-8"
            )
            entities_path = root / "zone-entities.json"
            entities_path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 100,
                                "entries": [{"id": 0x01064001, "name": "Field Manual"}],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            events_path = root / "zone-events.json"
            events_path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 100,
                                "event_blocks": [
                                    {"entity_id": 0x01064001, "events": [{"id": 115}]}
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            report = audit_zone(events_path, entities_path, 100, root)

            self.assertEqual(report["counts"]["exact_matches"], 1)
            self.assertEqual(report["entity_matches"][0]["script"], "Field_Manual.lua")

    def test_normalizes_entity_names_for_lua_filenames(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "npcs").mkdir()
            (root / "npcs/Door_Raimbroy_s_Grocery.lua").write_text(
                "player:startEvent(1744)\n", encoding="utf-8"
            )

            report = audit(
                [event_block(0x0100E001, [1744])],
                [client_entity(0x0100E001, "Door:Raimbroy's Grocery")],
                root,
                230,
            )

            self.assertEqual(report["counts"]["exact_matches"], 1)
            self.assertEqual(report["entity_matches"][0]["entity_id"], 0x0100E001)
            self.assertEqual(report["entity_matches"][0]["status"], "match")

    def test_reports_duplicate_entity_names_as_ambiguous(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "npcs").mkdir()
            (root / "npcs/Echo_NPC.lua").write_text(
                "player:startEvent(1)\n", encoding="utf-8"
            )

            report = audit(
                [event_block(0x0100E001, [1]), event_block(0x0100E002, [1])],
                [
                    client_entity(0x0100E001, "Echo NPC"),
                    client_entity(0x0100E002, "Echo_NPC"),
                ],
                root,
                230,
            )

            self.assertEqual(report["counts"]["ambiguous_entity_matches"], 1)
            self.assertEqual(
                [
                    candidate["entity_id"]
                    for candidate in report["ambiguous_entity_matches"][0]["candidates"]
                ],
                [0x0100E001, 0x0100E002],
            )
            self.assertEqual(
                report["counts"]["client_entities_with_events_without_script"], 2
            )

    def test_reports_mismatched_literal_event_ids(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "Cletae.lua").write_text(
                "player:startEvent(45)\nquest:event(45)\nquest:progressEvent(99)\n",
                encoding="utf-8",
            )

            report = audit(
                [event_block(0x0100E001, [45, 46])],
                [client_entity(0x0100E001, "Cletae")],
                root,
                230,
            )

            mismatch = report["mismatches"][0]
            self.assertEqual(mismatch["client_event_ids"], [45, 46])
            self.assertEqual(mismatch["literal_event_ids"], [45, 99])
            self.assertEqual(
                [usage["kind"] for usage in mismatch["literal_usages"]],
                ["startEvent", "quest:event", "quest:progressEvent"],
            )
            self.assertEqual(report["counts"]["mismatches"], 1)
            self.assertEqual(
                report["incompatible_literal_event_ids"],
                [{"script": "Cletae.lua", "entity_id": 0x0100E001, "event_ids": [99]}],
            )

    def test_unused_client_events_do_not_make_script_incompatible(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "Cletae.lua").write_text(
                "player:startEvent(45)\n", encoding="utf-8"
            )

            report = audit(
                [event_block(0x0100E001, [45, 46, 47])],
                [client_entity(0x0100E001, "Cletae")],
                root,
                230,
            )

            self.assertEqual(report["entity_matches"][0]["status"], "match")
            self.assertEqual(report["counts"]["matches"], 1)
            self.assertEqual(report["counts"]["compatible_matches"], 1)
            self.assertEqual(report["counts"]["exact_matches"], 0)
            self.assertEqual(report["counts"]["mismatches"], 0)
            self.assertEqual(
                report["entity_matches"][0]["incompatible_literal_event_ids"], []
            )

    def test_event_sentinel_is_ignored_for_compatibility(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "Adaunel.lua").write_text("", encoding="utf-8")

            report = audit(
                [event_block(0x0100E001, [656, 65535])],
                [client_entity(0x0100E001, "Adaunel")],
                root,
                230,
            )

            self.assertEqual(report["entity_matches"][0]["client_event_ids"], [656])
            self.assertEqual(report["entity_matches"][0]["status"], "match")
            self.assertEqual(report["counts"]["mismatches"], 0)

    def test_extracts_literal_and_dynamic_calls_without_comments(self):
        literal, dynamic = extract_event_usages(
            "-- player:startEvent(777)\n"
            'local ignored = "startEvent(666)"\n'
            "player:startEvent(107 + offset)\n"
            "quest:event(player:getVar('event'))\n"
            "quest:progressEvent(123)\n"
            "--[[ quest:progressEvent(888) ]]\n"
        )

        self.assertEqual([usage["id"] for usage in literal], [123])
        self.assertEqual(
            [usage["kind"] for usage in dynamic], ["startEvent", "quest:event"]
        )
        self.assertEqual([usage["line"] for usage in dynamic], [3, 4])

    def test_dynamic_calls_are_reported_and_not_called_exact(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "Dynamic_NPC.lua").write_text(
                "player:startEvent(107 + offset)\nquest:progressEvent(123)\n",
                encoding="utf-8",
            )

            report = audit(
                [event_block(0x0100E001, [123])],
                [client_entity(0x0100E001, "Dynamic NPC")],
                root,
                230,
            )

            self.assertEqual(report["counts"]["dynamic_scripts"], 1)
            self.assertEqual(report["counts"]["dynamic_usages"], 1)
            self.assertEqual(report["counts"]["unresolved_usages"], 1)
            self.assertEqual(report["counts"]["exact_matches"], 1)

    def test_reports_unmatched_server_and_client_records_and_is_deterministic(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / "npcs").mkdir()
            (root / "npcs/Zulu.lua").write_text(
                "player:startEvent(2)\n", encoding="utf-8"
            )
            (root / "npcs/Alpha.lua").write_text(
                "player:startEvent(1)\n", encoding="utf-8"
            )

            kwargs = {
                "zone_events": [
                    event_block(0x0100E002, [2]),
                    event_block(0x0100E003, [3]),
                ],
                "zone_entities": [
                    client_entity(0x0100E002, "Zulu"),
                    client_entity(0x0100E003, "Missing Script"),
                ],
                "scripts_dir": root,
                "zone_id": 230,
            }
            first = audit(**kwargs)
            second = audit(**kwargs)

            self.assertEqual(first, second)
            self.assertEqual(first["counts"]["server_scripts_absent_from_client"], 1)
            self.assertEqual(
                first["counts"]["client_entities_with_events_without_script"], 1
            )
            rendered = json.dumps(first, indent=2, sort_keys=True)
            self.assertNotIn(str(root), rendered)
            self.assertEqual(
                [match["script"] for match in first["entity_matches"]], ["Zulu.lua"]
            )


if __name__ == "__main__":
    unittest.main()
