import json
import tempfile
import unittest
from pathlib import Path

from tools.client.item_audit import (
    RESOURCE_NAMES,
    compare,
    load_client_entries,
    load_server_entries,
    normalize_name,
)


def catalog_with(entries_by_resource):
    return {
        "schema_version": 1,
        "resources": [
            {"name": resource, "entries": entries_by_resource.get(resource, [])}
            for resource in RESOURCE_NAMES
        ],
    }


def client_entry(index, entry_id, name, stack_size=1):
    return {
        "index": index,
        "id": entry_id,
        "stack_size": stack_size,
        "text": {"english": {"name": name, "singular_name": name}},
    }


class ItemAuditTests(unittest.TestCase):
    def test_normalize_name_matches_sql_names(self):
        self.assertEqual(normalize_name("Onion Sword"), "onion sword")
        self.assertEqual(normalize_name("pile_of_chocobo_bedding"), "pile of chocobo bedding")
        self.assertEqual(normalize_name("Valkyrie\u2019s Mask"), "valkyries mask")

    def test_loaders_validate_categories_and_sql_columns(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog_path = root / "items.json"
            sql_path = root / "item_basic.sql"
            catalog_path.write_text(
                json.dumps(
                    catalog_with(
                        {"weapons": [client_entry(0, 16534, "Onion Sword")]}
                    )
                ),
                encoding="utf-8",
            )
            sql_path.write_text(
                "INSERT INTO `item_basic` VALUES "
                "(16534,0,'onion_sword','onion_sword','',@WEAPON_TYPE,1,0,@NONE,0);"
                " -- July fixture\n",
                encoding="utf-8",
            )

            self.assertEqual(load_client_entries(catalog_path)[0]["resource"], "weapons")
            server = load_server_entries(sql_path)[0]
            self.assertEqual(server["resource"], "weapons")
            self.assertEqual(server["line"], 1)

    def test_compare_separates_placeholders_and_review_candidates(self):
        client = [
            {
                "resource": "weapons",
                "index": 0,
                "id": 16534,
                "name": "Onion Sword",
                "names": ["Onion Sword"],
                "normalized_names": ["onion sword"],
                "stack_size": 1,
                "placeholder": False,
            },
            {
                "resource": "weapons",
                "index": 1,
                "id": 16535,
                "name": ".",
                "names": ["."],
                "normalized_names": [],
                "stack_size": 1,
                "placeholder": True,
            },
            {
                "resource": "armor",
                "index": 2,
                "id": 11266,
                "name": "Shifted Mask",
                "names": ["Shifted Mask"],
                "normalized_names": ["shifted mask"],
                "stack_size": 1,
                "placeholder": False,
            },
        ]
        server = [
            {
                "id": 16534,
                "name": "onion_sword",
                "normalized_name": "onion sword",
                "resource": "weapons",
                "stack_size": 1,
                "line": 1,
            },
            {
                "id": 16535,
                "name": "modern_sword",
                "normalized_name": "modern sword",
                "resource": "weapons",
                "stack_size": 1,
                "line": 2,
            },
            {
                "id": 11267,
                "name": "shifted_mask",
                "normalized_name": "shifted mask",
                "resource": "armor",
                "stack_size": 2,
                "line": 3,
            },
        ]

        report = compare(client, server)

        self.assertEqual(report["counts"]["direct_matches"], 1)
        self.assertEqual(report["counts"]["server_at_client_placeholder"], 1)
        self.assertEqual(report["counts"]["unique_name_shift_candidates"], 1)
        self.assertEqual(report["unique_name_shift_candidates"][0]["server_id"], 11267)

    def test_zero_id_with_text_is_a_structural_placeholder(self):
        with tempfile.TemporaryDirectory() as temporary:
            catalog_path = Path(temporary) / "items.json"
            catalog_path.write_text(
                json.dumps(
                    catalog_with(
                        {"general_items": [client_entry(0, 0, "Structural Label")]}
                    )
                ),
                encoding="utf-8",
            )

            entry = load_client_entries(catalog_path)[0]
            self.assertTrue(entry["placeholder"])

    def test_loader_rejects_missing_resource_and_unknown_server_type(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog_path = root / "items.json"
            sql_path = root / "item_basic.sql"
            catalog_path.write_text(
                json.dumps({"schema_version": 1, "resources": []}), encoding="utf-8"
            )
            with self.assertRaises(ValueError):
                load_client_entries(catalog_path)

            sql_path.write_text(
                "INSERT INTO `item_basic` VALUES "
                "(1,0,'bad','bad','',@UNKNOWN_TYPE,1,0,@NONE,0);\n",
                encoding="utf-8",
            )
            with self.assertRaises(ValueError):
                load_server_entries(sql_path)


if __name__ == "__main__":
    unittest.main()
