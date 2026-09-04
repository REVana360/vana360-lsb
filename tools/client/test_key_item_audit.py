import json
import tempfile
import unittest
from pathlib import Path

from tools.client.key_item_audit import (
    compare,
    load_client_entries,
    load_server_entries,
    normalize_name,
)


class KeyItemAuditTests(unittest.TestCase):
    def test_normalize_name_matches_lua_constants(self):
        self.assertEqual(normalize_name("Tonberry key"), "tonberry key")
        self.assertEqual(normalize_name("TONBERRY_KEY"), "tonberry key")
        self.assertEqual(normalize_name("Li'Telor"), "litelor")
        self.assertEqual(normalize_name("Guard\u2019s lantern"), "guards lantern")
        self.assertEqual(normalize_name("I.D. tag"), "id tag")

    def test_loaders_validate_and_preserve_source_lines(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog_path = root / "key-items.json"
            enum_path = root / "key_item.lua"
            catalog_path.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "resources": [
                            {
                                "name": "key_items",
                                "entries": [
                                    {
                                        "index": 1,
                                        "id": 7,
                                        "text": {"english": {"name": "test key"}},
                                    }
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            enum_path.write_text(
                "xi.keyItem =\n{\n    TEST_KEY = 7,\n}\n", encoding="utf-8"
            )

            self.assertEqual(load_client_entries(catalog_path)[0]["name"], "test key")
            self.assertEqual(load_server_entries(enum_path)[0]["line"], 3)

    def test_loader_rejects_malformed_resource_and_entry_metadata(self):
        invalid_catalogs = (
            {"schema_version": 1, "resources": [None]},
            {
                "schema_version": 1,
                "resources": [{"name": "items", "entries": []}],
            },
            {
                "schema_version": 1,
                "resources": [
                    {"name": "key_items", "entries": [{"index": -1, "id": 1}]}
                ],
            },
            {
                "schema_version": 1,
                "resources": [
                    {
                        "name": "key_items",
                        "entries": [
                            {"index": 1, "id": 1},
                            {"index": 1, "id": 2},
                        ],
                    }
                ],
            },
            {
                "schema_version": 1,
                "resources": [
                    {"name": "key_items", "entries": [{"index": 1, "id": 65536}]}
                ],
            },
        )
        with tempfile.TemporaryDirectory() as temporary:
            catalog_path = Path(temporary) / "key-items.json"
            for catalog in invalid_catalogs:
                with self.subTest(catalog=catalog):
                    catalog_path.write_text(json.dumps(catalog), encoding="utf-8")
                    with self.assertRaises(ValueError):
                        load_client_entries(catalog_path)

    def test_compare_classifies_matches_shifts_and_structural_entries(self):
        client = [
            {"index": 0, "id": 0, "name": "heading", "normalized_name": "heading"},
            {"index": 1, "id": 0, "name": "heading 2", "normalized_name": "heading 2"},
            {"index": 2, "id": 1, "name": "exact key", "normalized_name": "exact key"},
            {
                "index": 3,
                "id": 2,
                "name": "shifted key",
                "normalized_name": "shifted key",
            },
            {
                "index": 4,
                "id": 3,
                "name": "client only",
                "normalized_name": "client only",
            },
            {
                "index": 5,
                "id": None,
                "name": "missing id",
                "normalized_name": "missing id",
            },
        ]
        server = [
            {
                "id": 1,
                "constant": "EXACT_KEY",
                "normalized_name": "exact key",
                "line": 4,
            },
            {
                "id": 2,
                "constant": "OTHER_KEY",
                "normalized_name": "other key",
                "line": 5,
            },
            {
                "id": 8,
                "constant": "SHIFTED_KEY",
                "normalized_name": "shifted key",
                "line": 6,
            },
            {
                "id": 9,
                "constant": "SERVER_ONLY",
                "normalized_name": "server only",
                "line": 7,
            },
        ]

        report = compare(client, server)

        self.assertEqual(report["counts"]["direct_matches"], 1)
        self.assertEqual(report["counts"]["same_id_mismatches"], 1)
        self.assertEqual(report["counts"]["unique_name_shift_candidates"], 1)
        self.assertEqual(report["counts"]["client_only_ids"], 1)
        self.assertEqual(report["counts"]["server_only_ids"], 2)
        self.assertEqual(report["counts"]["structural_zero_entries"], 2)
        self.assertEqual(report["counts"]["null_id_entries"], 1)
        self.assertEqual(report["direct_matches"][0]["client_index"], 2)
        self.assertEqual(report["unique_name_shift_candidates"][0]["server_id"], 8)

    def test_compare_does_not_shift_ambiguous_or_empty_names(self):
        client = [
            {"index": 1, "id": 1, "name": "same", "normalized_name": "same"},
            {"index": 2, "id": 2, "name": "same", "normalized_name": "same"},
            {"index": 3, "id": 3, "name": "", "normalized_name": ""},
        ]
        server = [{"id": 8, "constant": "SAME", "normalized_name": "same", "line": 4}]

        report = compare(client, server)

        self.assertEqual(report["counts"]["unique_name_shift_candidates"], 0)
        self.assertEqual(report["counts"]["client_only_ids"], 3)

    def test_compare_reports_duplicate_nonzero_ids(self):
        client = [
            {"index": 1, "id": 7, "name": "one", "normalized_name": "one"},
            {"index": 2, "id": 7, "name": "two", "normalized_name": "two"},
        ]
        server = [
            {"id": 7, "constant": "ONE", "normalized_name": "one", "line": 4},
            {"id": 7, "constant": "TWO", "normalized_name": "two", "line": 5},
        ]

        report = compare(client, server)

        self.assertEqual(report["counts"]["duplicate_client_ids"], 1)
        self.assertEqual(report["counts"]["duplicate_server_ids"], 1)


if __name__ == "__main__":
    unittest.main()
