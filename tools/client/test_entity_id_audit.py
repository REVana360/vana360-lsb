import json
import tempfile
import unittest
from pathlib import Path

from tools.client.entity_id_audit import compare, load_client_zone, load_server_zone


def active_entity(full_id, kind, name):
    return {"full_id": full_id, "kind": kind, "name": name, "reserved": False}


class EntityIdAuditTest(unittest.TestCase):
    def test_classifies_matches_and_candidates(self):
        client = {1: "Alpha", 2: "Beta", 3: "Echo", 4: "Echo", 5: "Missing"}
        server = {
            1: [active_entity(0x0100A001, "npc", "Alpha")],
            6: [active_entity(0x0100A006, "mob", "Beta")],
            7: [active_entity(0x0100A007, "npc", "Echo")],
            8: [active_entity(0x0100A008, "npc", "Echo")],
        }

        report = compare(client, server, 10)

        self.assertEqual(report["direct_matches"], [1])
        self.assertEqual(
            report["unique_name_candidates"],
            [{"old_target": 6, "new_target": 2, "kind": "mob", "name": "Beta"}],
        )
        self.assertEqual(report["ambiguous_client_targets"], [3, 4])
        self.assertEqual(report["unmatched_client_targets"], [5])
        self.assertEqual(report["server_only_targets"], [6, 7, 8])

    def test_loads_catalog_and_runtime_npc_name(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "catalog.json"
            zone = root / "zone"
            zone.mkdir()
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 10,
                                "entries": [{"id": 0x0100A001, "name": "Test NPC"}],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            (zone / "npcs.yaml").write_text(
                "npcs:\n  16818177:\n    script: Internal_Name\n"
                "    display_name: Test_NPC\n",
                encoding="utf-8",
            )

            self.assertEqual(load_client_zone(catalog, 10), {1: "Test NPC"})
            self.assertEqual(load_server_zone(zone, 10)[1][0]["name"], "Test_NPC")

    def test_uses_template_mob_name_and_separates_reservations(self):
        with tempfile.TemporaryDirectory() as temporary:
            zone = Path(temporary)
            (zone / "mobs.yaml").write_text(
                "templates:\n"
                "  Internal_Mob:\n"
                "    display_name: Packet_Mob\n"
                "spawns:\n"
                "  16818177:\n"
                "    template: Internal_Mob\n"
                "    at: [0, 0, 0]\n"
                "  16818178:\n"
                "    template: Internal_Mob\n",
                encoding="utf-8",
            )

            entities = load_server_zone(zone, 10)
            report = compare({1: "Packet Mob", 2: "Packet Mob"}, entities, 10)

            self.assertEqual(entities[1][0]["name"], "Packet_Mob")
            self.assertFalse(entities[1][0]["reserved"])
            self.assertTrue(entities[2][0]["reserved"])
            self.assertEqual(report["direct_matches"], [1])
            self.assertEqual(report["reserved_server_targets"], [2])

    def test_missing_npc_display_name_is_unnamed(self):
        with tempfile.TemporaryDirectory() as temporary:
            zone = Path(temporary)
            (zone / "npcs.yaml").write_text(
                "npcs:\n  16818177:\n    script: Internal_Name\n", encoding="utf-8"
            )

            entity = load_server_zone(zone, 10)[1][0]

            self.assertEqual(entity["name"], "")
            self.assertFalse(entity["reserved"])

    def test_preserves_cross_type_target_collisions(self):
        with tempfile.TemporaryDirectory() as temporary:
            zone = Path(temporary)
            (zone / "npcs.yaml").write_text(
                "npcs:\n  16818177:\n    display_name: Shared_NPC\n",
                encoding="utf-8",
            )
            (zone / "mobs.yaml").write_text(
                "templates:\n  Shared_Mob: {}\n"
                "spawns:\n  16818177:\n    template: Shared_Mob\n"
                "    at: [0, 0, 0]\n",
                encoding="utf-8",
            )

            entities = load_server_zone(zone, 10)

            self.assertEqual(
                [(entity["kind"], entity["name"]) for entity in entities[1]],
                [("npc", "Shared_NPC"), ("mob", "Shared_Mob")],
            )
            report = compare({1: "Shared NPC"}, entities, 10)
            self.assertEqual(report["counts"]["cross_type_collisions"], 1)
            self.assertEqual(report["cross_type_collisions"][0]["target"], 1)

    def test_rejects_wrong_zone_bits(self):
        with tempfile.TemporaryDirectory() as temporary:
            catalog = Path(temporary) / "catalog.json"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 10,
                                "entries": [{"id": 0x0100B001, "name": "Wrong Zone"}],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            with self.assertRaisesRegex(ValueError, "does not belong"):
                load_client_zone(catalog, 10)

    def test_rejects_duplicate_client_targets(self):
        with tempfile.TemporaryDirectory() as temporary:
            catalog = Path(temporary) / "catalog.json"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 10,
                                "entries": [
                                    {"id": 0x0100A001, "name": "First"},
                                    {"id": 0x0100A001, "name": "Second"},
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            with self.assertRaisesRegex(ValueError, "repeats target"):
                load_client_zone(catalog, 10)

    def test_rejects_player_or_dynamic_client_target(self):
        with tempfile.TemporaryDirectory() as temporary:
            catalog = Path(temporary) / "catalog.json"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "zones": [
                            {
                                "zone_id": 10,
                                "entries": [{"id": 0x0100A400, "name": "Player"}],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )

            with self.assertRaisesRegex(ValueError, "player or dynamic target range"):
                load_client_zone(catalog, 10)

    def test_rejects_non_mapping_documents(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "catalog.json"
            catalog.write_text("[]", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "must be an object"):
                load_client_zone(catalog, 10)

            zone = root / "zone"
            zone.mkdir()
            (zone / "npcs.yaml").write_text("[]\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "must be a mapping"):
                load_server_zone(zone, 10)


if __name__ == "__main__":
    unittest.main()
