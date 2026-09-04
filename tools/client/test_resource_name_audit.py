import json
import tempfile
import unittest
from pathlib import Path

from tools.client.resource_name_audit import (
    compare,
    is_placeholder,
    load_client_entries,
    load_server_entries,
)


class ResourceNameAuditTests(unittest.TestCase):
    def test_spell_placeholder_labels_are_structural(self):
        self.assertTrue(is_placeholder("spell_names", "(NULL)"))
        self.assertTrue(is_placeholder("spell_names", "(magic 286)"))
        self.assertTrue(is_placeholder("spell_names", "dummy"))
        self.assertFalse(is_placeholder("spell_names", "Cure"))
        self.assertFalse(is_placeholder("ability_names", "dummy"))

    def test_loaders_select_english_and_parse_sql(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "resources.json"
            sql = root / "abilities.sql"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "resources": [
                            {
                                "name": "ability_names",
                                "sources": [
                                    {
                                        "language": "english",
                                        "status": "selected",
                                        "data": {
                                            "lists": {
                                                "16": [{"string": "Mighty Strikes"}],
                                                "32": [{"string": "."}],
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
            sql.write_text(
                "INSERT INTO `abilities` VALUES "
                "(16,'mighty_strikes',1,0);\n",
                encoding="utf-8",
            )

            client = load_client_entries(catalog, "ability_names")
            server = load_server_entries(sql, "abilities")
            self.assertEqual(client[0]["id"], 16)
            self.assertFalse(client[0]["placeholder"])
            self.assertTrue(client[1]["placeholder"])
            self.assertEqual(server[0]["name"], "mighty_strikes")

    def test_compare_classifies_matches_placeholders_and_shifts(self):
        client = [
            {"id": 16, "name": "Mighty Strikes", "normalized_name": "mighty strikes", "placeholder": False},
            {"id": 32, "name": ".", "normalized_name": "", "placeholder": True},
            {"id": 33, "name": "Shifted", "normalized_name": "shifted", "placeholder": False},
        ]
        server = [
            {"id": 16, "name": "mighty_strikes", "normalized_name": "mighty strikes", "line": 1},
            {"id": 32, "name": "modern", "normalized_name": "modern", "line": 2},
            {"id": 34, "name": "shifted", "normalized_name": "shifted", "line": 3},
        ]

        report = compare("ability_names", "abilities", client, server)

        self.assertEqual(report["counts"]["direct_matches"], 1)
        self.assertEqual(report["counts"]["server_at_client_placeholder"], 1)
        self.assertEqual(report["counts"]["unique_name_shift_candidates"], 1)
        self.assertEqual(report["unique_name_shift_candidates"][0]["server_id"], 34)

    def test_loader_rejects_wrong_resource_and_malformed_sql(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "resources.json"
            sql = root / "abilities.sql"
            catalog.write_text(
                json.dumps({"schema_version": 1, "resources": []}), encoding="utf-8"
            )
            with self.assertRaises(ValueError):
                load_client_entries(catalog, "ability_names")

            sql.write_text(
                "INSERT INTO `abilities` VALUES malformed;\n", encoding="utf-8"
            )
            with self.assertRaises(ValueError):
                load_server_entries(sql, "abilities")


if __name__ == "__main__":
    unittest.main()
