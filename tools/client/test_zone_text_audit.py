import json
import tempfile
import unittest
from pathlib import Path

from tools.client.zone_text_audit import (
    compare,
    load_client_zone,
    load_lsb_text,
    normalize_text,
)


class ZoneTextAuditTest(unittest.TestCase):
    def test_normalizes_dat_markup_and_typography(self):
        self.assertEqual(
            normalize_text(
                "Obtained: ${lettercase: 1}${item-singular: 0[2]}.${prompt}"
            ),
            "obtained: <arg>.",
        )
        self.assertEqual(
            normalize_text("A mog tablet: “${number: 0}”\n${selection-lines}"),
            'a mog tablet: "<arg>"',
        )
        self.assertEqual(
            normalize_text("The item #/#/# at #:#."),
            "the item <arg>/<arg>/<arg> at <arg>:<arg>.",
        )
        self.assertEqual(
            normalize_text(
                "Your Mog Locker lease is valid until "
                "${ts-year: 0}/${ts-month: 0}/${ts-day: 0} "
                "${ts-hour: 0}:${ts-minute: 0}:${ts-second: 0}, kupo.${prompt}"
            ),
            "your mog locker lease is valid until <timestamp>, kupo.",
        )

    def test_loads_zone_json_and_lua_comments(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "zone-text.json"
            ids = root / "IDs.lua"
            catalog.write_text(
                json.dumps(
                    {
                        "schema_version": 1,
                        "language": "english",
                        "zones": [
                            {
                                "zone_id": 230,
                                "entries": [
                                    {"id": 24, "text": "Home point set!${prompt}"}
                                ],
                            }
                        ],
                    }
                ),
                encoding="utf-8",
            )
            ids.write_text(
                "zones = zones or {}\n"
                "zones[xi.zone.SOUTHERN_SAN_DORIA] =\n"
                "{\n"
                "    text =\n"
                "    {\n"
                "        HOMEPOINT_SET = 24, -- Home point set!\n"
                "    },\n"
                "    mob =\n"
                "    {},\n"
                "}\n",
                encoding="utf-8",
            )

            self.assertEqual(load_client_zone(catalog, 230)[0]["id"], 24)
            self.assertEqual(load_lsb_text(ids)[0]["constant"], "HOMEPOINT_SET")
            report = compare(load_client_zone(catalog, 230), load_lsb_text(ids), 230)
            self.assertEqual(
                report["direct_id_matches"],
                [{"id": 24, "constant": "HOMEPOINT_SET", "text": "Home point set!"}],
            )

    def test_classifies_moved_unique_ambiguous_and_unmatched_text(self):
        client = [
            {"constant": "", "id": 8, "text": "Unique", "normalized_text": "unique"},
            {"constant": "", "id": 9, "text": "Echo", "normalized_text": "echo"},
            {"constant": "", "id": 10, "text": "Echo", "normalized_text": "echo"},
        ]
        lsb = [
            {
                "constant": "MOVED",
                "id": 1,
                "text": "Unique",
                "normalized_text": "unique",
            },
            {
                "constant": "AMBIGUOUS",
                "id": 2,
                "text": "Echo",
                "normalized_text": "echo",
            },
            {
                "constant": "MISSING",
                "id": 3,
                "text": "Missing",
                "normalized_text": "missing",
            },
        ]

        report = compare(client, lsb, 230)

        self.assertEqual(report["unique_text_matches"][0]["old_id"], 1)
        self.assertEqual(report["unique_text_matches"][0]["new_id"], 8)
        self.assertEqual(report["ambiguous_matches"][0]["candidate_ids"], [9, 10])
        self.assertEqual(report["unmatched_entries"][0]["id"], 3)
        self.assertEqual(
            report["client_only_entries"],
            [{"id": 9, "text": "Echo"}, {"id": 10, "text": "Echo"}],
        )

    def test_direct_id_mismatch_can_still_find_unique_text_move(self):
        client = [
            {
                "constant": "",
                "id": 1,
                "text": "Different",
                "normalized_text": "different",
            },
            {
                "constant": "",
                "id": 7,
                "text": "Expected",
                "normalized_text": "expected",
            },
        ]
        lsb = [
            {
                "constant": "EXPECTED",
                "id": 1,
                "text": "Expected",
                "normalized_text": "expected",
            }
        ]

        report = compare(client, lsb, 230)

        self.assertEqual(report["direct_id_mismatches"][0]["id"], 1)
        self.assertEqual(report["unique_text_matches"][0]["new_id"], 7)
        self.assertEqual(
            report["client_only_entries"], [{"id": 1, "text": "Different"}]
        )

    def test_rejects_missing_text_table(self):
        with tempfile.TemporaryDirectory() as temporary:
            ids = Path(temporary) / "IDs.lua"
            ids.write_text("zones = {}\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "missing text table"):
                load_lsb_text(ids)


if __name__ == "__main__":
    unittest.main()
