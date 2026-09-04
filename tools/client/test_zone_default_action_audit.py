import tempfile
import unittest
from pathlib import Path

from tools.client.zone_default_action_audit import (
    audit,
    load_default_events,
    load_normal_npcs,
)


class ZoneDefaultActionAuditTests(unittest.TestCase):
    def test_audit_reports_each_normal_entity_and_skips_cutscene_actors(self):
        blocks = {
            100: {"event_ids": [10]},
            101: {"event_ids": [11]},
            102: {"event_ids": [12]},
        }
        npcs = {
            "Shared": [
                {"entity_id": 100, "display_name": "First"},
                {"entity_id": 101, "display_name": "Second"},
            ]
        }
        defaults = [{"script": "Shared", "event_id": 10, "line": 1}]

        report = audit(blocks, npcs, defaults)

        self.assertEqual(report["counts"]["matches"], 1)
        self.assertEqual(report["counts"]["incompatible"], 1)
        self.assertEqual(report["incompatible"][0]["entity_id"], 101)

    def test_loaders_parse_literal_events_and_normal_npcs(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            defaults = root / "DefaultActions.lua"
            npcs = root / "npcs.yaml"
            defaults.write_text(
                "return { ['Npc'] = { event = 0x10 } }\n", encoding="utf-8"
            )
            npcs.write_text(
                "npcs:\n"
                "  100:\n"
                "    script: Npc\n"
                "    display_name: NPC\n"
                "  101:\n"
                "    script: Npc\n"
                "    status: cutscene_only\n",
                encoding="utf-8",
            )

            self.assertEqual(load_default_events(defaults)[0]["event_id"], 16)
            self.assertEqual(len(load_normal_npcs(npcs)["Npc"]), 1)


if __name__ == "__main__":
    unittest.main()
