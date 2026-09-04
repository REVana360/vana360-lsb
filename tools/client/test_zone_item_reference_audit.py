import json
import tempfile
import unittest
from pathlib import Path

from tools.client.item_audit import RESOURCE_NAMES
from tools.client.zone_item_reference_audit import audit, load_item_constants


def catalog_with(entries):
    return {
        "schema_version": 1,
        "resources": [
            {
                "name": resource,
                "entries": entries if resource == "general_items" else [],
            }
            for resource in RESOURCE_NAMES
        ],
    }


def item_entry(index, item_id, name):
    return {
        "index": index,
        "id": item_id,
        "stack_size": 1,
        "text": {"english": {"name": name}},
    }


class ZoneItemReferenceAuditTests(unittest.TestCase):
    def test_audit_separates_active_absent_and_unknown_references(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog_path = root / "items.json"
            enum_path = root / "item.lua"
            scripts = root / "scripts"
            scripts.mkdir()
            catalog_path.write_text(
                json.dumps(
                    catalog_with(
                        [
                            item_entry(0, 100, "Era Item"),
                            item_entry(1, 101, "."),
                        ]
                    )
                ),
                encoding="utf-8",
            )
            enum_path.write_text(
                "ERA_ITEM = 100,\nMODERN_ITEM = 101,\n", encoding="utf-8"
            )
            (scripts / "npc.lua").write_text(
                "local a = xi.item.ERA_ITEM\n"
                "local b = xi.item.MODERN_ITEM\n"
                "local c = xi.item.UNKNOWN_ITEM\n",
                encoding="utf-8",
            )

            report = audit(catalog_path, enum_path, [scripts])

            self.assertEqual(report["counts"]["active_references"], 1)
            self.assertEqual(report["counts"]["absent_references"], 1)
            self.assertEqual(report["counts"]["missing_constants"], 1)
            self.assertEqual(report["absent_references"][0]["id"], 101)

    def test_audit_deduplicates_constants_and_records_all_usages(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog_path = root / "items.json"
            enum_path = root / "item.lua"
            catalog_path.write_text(
                json.dumps(catalog_with([item_entry(0, 100, "Era Item")])),
                encoding="utf-8",
            )
            enum_path.write_text("ERA_ITEM = 100,\n", encoding="utf-8")
            first = root / "first.lua"
            second = root / "second.lua"
            first.write_text("return xi.item.ERA_ITEM\n", encoding="utf-8")
            second.write_text("return xi.item.ERA_ITEM\n", encoding="utf-8")

            report = audit(catalog_path, enum_path, [first, second])

            self.assertEqual(report["counts"]["unique_references"], 1)
            self.assertEqual(len(report["active_references"][0]["usages"]), 2)

    def test_item_enum_rejects_duplicate_names(self):
        with tempfile.TemporaryDirectory() as temporary:
            enum_path = Path(temporary) / "item.lua"
            enum_path.write_text("ITEM = 100,\nITEM = 101,\n", encoding="utf-8")

            with self.assertRaises(ValueError):
                load_item_constants(enum_path)


if __name__ == "__main__":
    unittest.main()
