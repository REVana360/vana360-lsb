import json
import tempfile
import unittest
from pathlib import Path

from tools.client.message_id_audit import (
    compare,
    is_placeholder,
    load_client_entries,
    load_server_entries,
)


class MessageIdAuditTests(unittest.TestCase):
    def test_placeholder_policy_is_resource_specific(self):
        self.assertTrue(is_placeholder("system_messages2", "dummy"))
        self.assertTrue(is_placeholder("system_messages4", "${prompt}"))
        self.assertFalse(is_placeholder("system_messages2", "${prompt}"))
        self.assertFalse(is_placeholder("system_messages4", "Attack hits."))

    def test_loaders_select_message_table_and_enum(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "resources.json"
            header = root / "msg_basic.h"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "resources": [
                            {
                                "name": "system_messages4",
                                "sources": [
                                    {
                                        "language": "english",
                                        "status": "selected",
                                        "data": {
                                            "entries": {
                                                "8": "Gains experience.",
                                                "9": "${prompt}",
                                            }
                                        },
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            header.write_text(
                "enum class MsgBasic : uint16_t\n"
                "{\n"
                "    ExperiencePointsGained = 8, // Gains experience.\n"
                "    LevelUp = 9,\n"
                "};\n",
                encoding="utf-8",
            )

            client = load_client_entries(catalog, "system_messages4")
            server = load_server_entries(header, "MsgBasic")

            self.assertEqual(client[0]["id"], 8)
            self.assertFalse(client[0]["placeholder"])
            self.assertTrue(client[1]["placeholder"])
            self.assertEqual(server[0]["name"], "ExperiencePointsGained")
            self.assertEqual(server[0]["line"], 3)

    def test_compare_classifies_client_boundaries(self):
        client = [
            {"id": 1, "text": "Attack hits.", "placeholder": False},
            {"id": 2, "text": "dummy", "placeholder": True},
            {"id": 3, "text": "Client only.", "placeholder": False},
        ]
        server = [
            {"id": 1, "name": "AttackHits", "comment": "", "line": 1},
            {"id": 2, "name": "ModernSlot", "comment": "", "line": 2},
            {"id": 4, "name": "TooNew", "comment": "", "line": 3},
        ]

        report = compare("system_messages4", "MsgBasic", client, server)

        self.assertEqual(report["counts"]["supported_server_ids"], 1)
        self.assertEqual(report["counts"]["server_at_client_placeholder"], 1)
        self.assertEqual(report["counts"]["server_outside_client"], 1)
        self.assertEqual(report["counts"]["client_without_server_enum"], 1)

    def test_loaders_reject_wrong_resource_and_missing_enum(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "resources.json"
            header = root / "msg_basic.h"
            catalog.write_text(
                json.dumps({"schema_version": 1, "resources": []}),
                encoding="utf-8",
            )
            header.write_text("enum class Other : int {};\n", encoding="utf-8")

            with self.assertRaises(ValueError):
                load_client_entries(catalog, "system_messages4")
            with self.assertRaises(ValueError):
                load_server_entries(header, "MsgBasic")


if __name__ == "__main__":
    unittest.main()
