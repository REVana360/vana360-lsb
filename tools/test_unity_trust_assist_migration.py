import importlib
import re
import unittest
from copy import deepcopy
from pathlib import Path


MIGRATION = importlib.import_module(
    "tools.migrations.065_remove_unity_trust_assist_data"
)

EXPECTED_SPELL_IDS = {
    953,
    954,
    955,
    956,
    957,
    980,
    981,
    1005,
    1006,
    1007,
    1008,
}
EXPECTED_POOL_IDS = {
    5953,
    5954,
    5955,
    5956,
    5957,
    5980,
    5981,
    6005,
    6006,
    6007,
    6008,
}
EXPECTED_REWARD_ITEM_IDS = {
    25734,
    25735,
    25736,
    25737,
    25738,
    25739,
    25740,
    25741,
    25742,
    25743,
    25744,
}
EXPECTED_EMINENT_ITEM_IDS = {6269, 6270, 6271}
EXPECTED_REMOVED_ITEM_IDS = EXPECTED_REWARD_ITEM_IDS | EXPECTED_EMINENT_ITEM_IDS
EXPECTED_SPELL_LISTS = {
    "TRUST_Pieuje_UC",
    "TRUST_Apururu_UC",
    "TRUST_Yoran-Oran_UC",
    "TRUST_Sylvie_UC",
}
EXPECTED_SKILL_LISTS = {
    "TRUST_Pieuje_UC",
    "TRUST_Invincible_Shield_UC",
    "TRUST_Apururu_UC",
    "TRUST_Jakoh_Wahcondalo_UC",
    "TRUST_Flaviria_UC",
    "TRUST_Yoran-Oran_UC",
    "TRUST_Sylvie_UC",
    "TRUST_Ayame_UC",
    "TRUST_Maat_UC",
    "TRUST_Aldo_UC",
    "TRUST_Naja_Salaheem_UC",
}
EXPECTED_ASSIST_VARS = {
    "[ASSIST][Warnings]Cooldown",
    "[ASSIST][ThumbsUp]Cooldown",
    "[ASSIST][Evaluations]Eligible",
    "[ASSIST][Evaluations]Today",
    "[ASSIST][Evaluations]Count",
    "[ASSIST]Eligible",
    "[ASSIST]Muted",
}
EXPECTED_ROE_UNITY_VARS = {
    "weekly_sparks_spent",
    "weekly_accolades_spent",
    "unity_changed",
}
EXPECTED_REMOVED_VARS = EXPECTED_ASSIST_VARS | EXPECTED_ROE_UNITY_VARS


def _values(text):
    if text.startswith("'"):
        return {
            value.replace("''", "'") for value in re.findall(r"'((?:''|[^'])*)'", text)
        }
    return {int(value.strip()) for value in text.split(",")}


def _porter_extra(*, previous=0, first=0, second=0, length=24):
    data = bytearray(length)
    if length > 17:
        data[17] = previous
    if length > 18:
        data[18] = first
    if length > 19:
        data[19] = second
    return bytes(data)


def _slip_02_entries():
    source = (
        Path(__file__).resolve().parent.parent / "scripts/globals/porter_slip_items.lua"
    ).read_text(encoding="utf-8")
    start = source.index("    [xi.item.MOOGLE_STORAGE_SLIP_02] =")
    end = source.index("    [xi.item.MOOGLE_STORAGE_SLIP_03] =", start)
    return [
        match.group(1)
        for match in re.finditer(
            r"(?m)^\s*(xi\.item\.[A-Z0-9_]+|0),\s*$", source[start:end]
        )
    ]


class FakeCursor:
    EXPECTED_COLUMNS = {
        "char_vars": "varname",
        "spell_list": "spellid",
        "mob_pools": "poolid",
        "item_basic": "itemid",
        "item_usable": "itemid",
        "item_equipment": "itemId",
        "char_inventory": "itemId",
        "delivery_box": "itemid",
        "auction_house": "itemid",
        "auction_house_items": "itemid",
    }

    def __init__(self, legacy=True):
        self.columns = {"chars": set(), "char_flags": set()}
        if legacy:
            self.columns = {"chars": {"last_logout"}, "char_flags": {"muted"}}

        self.rows = {
            "char_vars": set(EXPECTED_REMOVED_VARS) if legacy else set(),
            "spell_list": (
                set(EXPECTED_SPELL_IDS) | {952, 958} if legacy else {952, 958}
            ),
            "mob_pools": (set(EXPECTED_POOL_IDS) if legacy else set())
            | {5952, 5958, 5979, 5982, 6004, 6009},
            "item_basic": (EXPECTED_REMOVED_ITEM_IDS if legacy else set())
            | {25733, 25745, 6268, 6272},
            "item_usable": (EXPECTED_EMINENT_ITEM_IDS if legacy else set())
            | {6268, 6272},
            "item_equipment": (EXPECTED_REWARD_ITEM_IDS if legacy else set())
            | {25733, 25745},
            "mob_spell_lists": (set(EXPECTED_SPELL_LISTS) if legacy else set())
            | {"TRUST_Shantotto"},
            "mob_skill_lists": (set(EXPECTED_SKILL_LISTS) if legacy else set())
            | {"TRUST_Naji"},
            "auction_house_items": (EXPECTED_REMOVED_ITEM_IDS if legacy else set())
            | {25733},
        }
        self.inventory = [
            {"charid": 1, "location": 0, "slot": 4, "itemId": 25734},
            {"charid": 2, "location": 1, "slot": 3, "itemId": 6269},
            {"charid": 3, "location": 0, "slot": 4, "itemId": 25733},
            {
                "charid": 4,
                "location": 0,
                "slot": 5,
                "itemId": MIGRATION.MOOGLE_STORAGE_SLIP_02,
                "extra": _porter_extra(previous=0x03, first=0xFF, second=0xFF),
            },
            {
                "charid": 5,
                "location": 0,
                "slot": 5,
                "itemId": MIGRATION.MOOGLE_STORAGE_SLIP_02,
                "extra": None,
            },
        ]
        if not legacy:
            self.inventory = [self.inventory[2], self.inventory[3]]
            self.inventory[1]["extra"] = _porter_extra()

        self.equip = [
            {"charid": 1, "slotid": 4, "containerid": 0},
            {"charid": 2, "slotid": 3, "containerid": 1},
            {"charid": 3, "slotid": 4, "containerid": 0},
        ]
        if not legacy:
            self.equip = [self.equip[2]]

        self.equip_saved = [
            {"body": 25734, "ammo": 6269, "main": 25733},
        ]
        if not legacy:
            self.equip_saved = [{"body": 0, "ammo": 0, "main": 25733}]

        self.style = [{"body": 25734, "main": 25733}]
        if not legacy:
            self.style = [{"body": 0, "main": 25733}]

        self.delivery = [25734, 25733, 6269]
        if not legacy:
            self.delivery = [25733]

        self.auction_house = [
            {"itemid": 25734, "buyer_name": None},
            {"itemid": 6269, "buyer_name": None},
            {"itemid": 25734, "buyer_name": "buyer"},
            {"itemid": 25733, "buyer_name": None},
        ]
        if not legacy:
            self.auction_house = [self.auction_house[-1]]
        self.result = None

    def _assert_column(self, table, column):
        expected = self.EXPECTED_COLUMNS.get(table)
        if expected is not None and column != expected:
            raise AssertionError(
                "unexpected {} column: {} (expected {})".format(table, column, expected)
            )

    def _has_rows(self, table, column, values):
        self._assert_column(table, column)
        if table == "char_inventory":
            return any(row["itemId"] in values for row in self.inventory)
        if table == "delivery_box":
            return any(item_id in values for item_id in self.delivery)
        if table == "auction_house_items":
            return bool(self.rows[table] & values)
        return bool(self.rows[table] & values)

    def _has_char_equip_rows(self):
        inventory_keys = {
            (row["charid"], row["slot"], row["location"])
            for row in self.inventory
            if row["itemId"] in EXPECTED_REMOVED_ITEM_IDS
        }
        return any(
            (row["charid"], row["slotid"], row["containerid"]) in inventory_keys
            for row in self.equip
        )

    def _has_saved_equipment_rows(self):
        return any(
            value in EXPECTED_REMOVED_ITEM_IDS
            for row in self.equip_saved
            for value in row.values()
        )

    def _has_style_rows(self):
        return any(
            value in EXPECTED_REMOVED_ITEM_IDS
            for row in self.style
            for value in row.values()
        )

    def _has_porter_bits(self):
        for row in self.inventory:
            if row["itemId"] != MIGRATION.MOOGLE_STORAGE_SLIP_02:
                continue
            extra = row.get("extra")
            if extra is not None and (
                (len(extra) > 18 and extra[18] & 0xFF)
                or (len(extra) > 19 and extra[19] & 0x07)
            ):
                return True
        return False

    def execute(self, query):
        query = " ".join(query.split())

        column = re.fullmatch(
            r"SHOW COLUMNS FROM `([^`]+)` LIKE '([^']+)'", query, re.IGNORECASE
        )
        if column:
            table, name = column.groups()
            self.result = (1,) if name in self.columns.get(table, set()) else None
            return

        if query.startswith("SELECT") and "FROM `char_equip` AS `equip`" in query:
            self.result = (1,) if self._has_char_equip_rows() else None
            return
        if query.startswith("SELECT") and "FROM `char_equip_saved` WHERE" in query:
            self.result = (1,) if self._has_saved_equipment_rows() else None
            return
        if query.startswith("SELECT") and "FROM `char_style` WHERE" in query:
            self.result = (1,) if self._has_style_rows() else None
            return
        if query.startswith("SELECT") and "ORD(SUBSTRING(`extra`" in query:
            self.result = (1,) if self._has_porter_bits() else None
            return
        if query.startswith("SELECT") and "FROM `auction_house` WHERE" in query:
            self._assert_column("auction_house", "itemid")
            self.result = (
                (1,)
                if any(
                    row["itemid"] in EXPECTED_REMOVED_ITEM_IDS
                    and row["buyer_name"] is None
                    for row in self.auction_house
                )
                else None
            )
            return

        select = re.fullmatch(
            r"SELECT 1 FROM `([^`]+)` WHERE `([^`]+)` IN \(([^)]+)\) LIMIT 1",
            query,
            re.IGNORECASE,
        )
        if select:
            table, column, values = select.groups()
            self.result = (
                (1,) if self._has_rows(table, column, _values(values)) else None
            )
            return

        if query.startswith("DELETE `equip` FROM `char_equip`"):
            inventory_keys = {
                (row["charid"], row["slot"], row["location"])
                for row in self.inventory
                if row["itemId"] in EXPECTED_REMOVED_ITEM_IDS
            }
            self.equip = [
                row
                for row in self.equip
                if (row["charid"], row["slotid"], row["containerid"])
                not in inventory_keys
            ]
            return

        delete = re.search(
            r"DELETE FROM `([^`]+)` WHERE `([^`]+)` IN \(([^)]+)\)",
            query,
            re.IGNORECASE,
        )
        if delete:
            table, column, values = delete.groups()
            values = _values(values)
            self._assert_column(table, column)
            if table == "char_inventory":
                self.inventory = [
                    row for row in self.inventory if row["itemId"] not in values
                ]
            elif table == "delivery_box":
                self.delivery = [
                    item_id for item_id in self.delivery if item_id not in values
                ]
            elif table == "auction_house_items":
                self.rows[table].difference_update(values)
            elif table == "auction_house":
                self.auction_house = [
                    row
                    for row in self.auction_house
                    if row["itemid"] not in values or row["buyer_name"] is not None
                ]
            else:
                self.rows[table].difference_update(values)
            return

        update = re.fullmatch(
            r"UPDATE `char_inventory` SET `extra` = RPAD\(COALESCE\(`extra`, ''\), 24, CHAR\(0\)\) WHERE `itemId` = (\d+)",
            query,
            re.IGNORECASE,
        )
        if update:
            item_id = int(update.group(1))
            for row in self.inventory:
                if row["itemId"] == item_id:
                    row["extra"] = (row.get("extra") or b"").ljust(24, b"\0")
            return

        update = re.fullmatch(
            r"UPDATE `char_inventory` SET `extra` = INSERT\(`extra`, (\d+), 1, CHAR\(ORD\(SUBSTRING\(`extra`, \d+, 1\)\) & (\d+)\)\) WHERE `itemId` = (\d+)",
            query,
            re.IGNORECASE,
        )
        if update:
            position, mask, item_id = map(int, update.groups())
            for row in self.inventory:
                if row["itemId"] == item_id:
                    data = bytearray((row.get("extra") or b"").ljust(24, b"\0"))
                    data[position - 1] &= mask
                    row["extra"] = bytes(data)
            return

        update = re.fullmatch(
            r"UPDATE `char_equip_saved` SET `([^`]+)` = 0 WHERE `([^`]+)` IN \(([^)]+)\)",
            query,
            re.IGNORECASE,
        )
        if update:
            target, column, values = update.groups()
            if target != column or column not in MIGRATION.EQUIPMENT_COLUMNS:
                raise AssertionError(
                    "unexpected saved equipment column: {}".format(column)
                )
            values = _values(values)
            for row in self.equip_saved:
                if row.get(column, 0) in values:
                    row[column] = 0
            return

        update = re.fullmatch(
            r"UPDATE `char_style` SET `([^`]+)` = 0 WHERE `([^`]+)` IN \(([^)]+)\)",
            query,
            re.IGNORECASE,
        )
        if update:
            target, column, values = update.groups()
            if target != column or column not in MIGRATION.STYLE_COLUMNS:
                raise AssertionError("unexpected style column: {}".format(column))
            values = _values(values)
            for row in self.style:
                if row.get(column, 0) in values:
                    row[column] = 0
            return

        column = re.fullmatch(
            r"ALTER TABLE `([^`]+)` DROP COLUMN `([^`]+)`", query, re.IGNORECASE
        )
        if column:
            table, name = column.groups()
            self.columns[table].discard(name)
            return

        raise AssertionError("unexpected SQL: {}".format(query))

    def fetchone(self):
        result, self.result = self.result, None
        return result


class FakeDatabase:
    def __init__(self):
        self.commits = 0

    def commit(self):
        self.commits += 1


class UnityTrustAssistMigrationTest(unittest.TestCase):
    def test_migration_removes_feature_rows_and_keeps_shared_rows(self):
        cursor = FakeCursor()
        database = FakeDatabase()

        self.assertTrue(MIGRATION.needs_to_run(cursor))
        MIGRATION.migrate(cursor, database)

        self.assertFalse(cursor.rows["char_vars"])
        self.assertFalse(cursor.rows["spell_list"] & EXPECTED_SPELL_IDS)
        self.assertFalse(cursor.rows["mob_pools"] & EXPECTED_POOL_IDS)
        self.assertFalse(cursor.rows["item_basic"] & EXPECTED_REMOVED_ITEM_IDS)
        self.assertFalse(cursor.rows["item_usable"] & EXPECTED_EMINENT_ITEM_IDS)
        self.assertFalse(cursor.rows["item_equipment"] & EXPECTED_REWARD_ITEM_IDS)
        self.assertFalse(cursor.rows["mob_spell_lists"] & EXPECTED_SPELL_LISTS)
        self.assertFalse(cursor.rows["mob_skill_lists"] & EXPECTED_SKILL_LISTS)
        self.assertEqual(cursor.rows["spell_list"], {952, 958})
        self.assertEqual(
            cursor.rows["mob_pools"],
            {5952, 5958, 5979, 5982, 6004, 6009},
        )
        self.assertEqual(cursor.rows["item_basic"], {25733, 25745, 6268, 6272})
        self.assertEqual(cursor.rows["item_usable"], {6268, 6272})
        self.assertEqual(cursor.rows["item_equipment"], {25733, 25745})
        self.assertEqual(cursor.rows["mob_spell_lists"], {"TRUST_Shantotto"})
        self.assertEqual(cursor.rows["mob_skill_lists"], {"TRUST_Naji"})
        self.assertNotIn("last_logout", cursor.columns["chars"])
        self.assertNotIn("muted", cursor.columns["char_flags"])

        self.assertEqual(
            [row["itemId"] for row in cursor.inventory],
            [25733, MIGRATION.MOOGLE_STORAGE_SLIP_02, MIGRATION.MOOGLE_STORAGE_SLIP_02],
        )
        self.assertEqual(len(cursor.equip), 1)
        self.assertEqual(cursor.equip[0]["charid"], 3)
        self.assertTrue(
            all(
                value not in EXPECTED_REMOVED_ITEM_IDS
                for row in cursor.equip_saved + cursor.style
                for value in row.values()
            )
        )
        self.assertEqual(cursor.delivery, [25733])
        self.assertEqual(
            cursor.auction_house,
            [
                {"itemid": 25734, "buyer_name": "buyer"},
                {"itemid": 25733, "buyer_name": None},
            ],
        )
        self.assertEqual(cursor.rows["auction_house_items"], {25733})
        for row in cursor.inventory[1:]:
            self.assertEqual(len(row["extra"]), 24)
            self.assertEqual(row["extra"][18] & 0xFF, 0)
            self.assertEqual(row["extra"][19] & 0x07, 0)
        self.assertEqual(cursor.inventory[1]["extra"][17] & 0x03, 0x03)
        self.assertEqual(cursor.inventory[1]["extra"][19] & 0xF8, 0xF8)
        self.assertEqual(database.commits, 1)
        self.assertFalse(MIGRATION.needs_to_run(cursor))

    def test_migration_contract_is_independent_and_exact(self):
        self.assertEqual(set(MIGRATION.UNITY_TRUST_SPELL_IDS), EXPECTED_SPELL_IDS)
        self.assertEqual(set(MIGRATION.UNITY_TRUST_POOL_IDS), EXPECTED_POOL_IDS)
        self.assertEqual(set(MIGRATION.UNITY_REWARD_ITEM_IDS), EXPECTED_REWARD_ITEM_IDS)
        self.assertEqual(set(MIGRATION.EMINENT_ITEM_IDS), EXPECTED_EMINENT_ITEM_IDS)
        self.assertEqual(set(MIGRATION.REMOVED_ITEM_IDS), EXPECTED_REMOVED_ITEM_IDS)
        self.assertEqual(
            set(MIGRATION.UNITY_TRUST_SPELL_LIST_NAMES), EXPECTED_SPELL_LISTS
        )
        self.assertEqual(
            set(MIGRATION.UNITY_TRUST_SKILL_LIST_NAMES), EXPECTED_SKILL_LISTS
        )
        self.assertEqual(set(MIGRATION.ASSIST_CHAR_VARS), EXPECTED_ASSIST_VARS)
        self.assertEqual(set(MIGRATION.ROE_UNITY_CHAR_VARS), EXPECTED_ROE_UNITY_VARS)
        self.assertEqual(set(MIGRATION.REMOVED_CHAR_VARS), EXPECTED_REMOVED_VARS)

    def test_porter_placeholders_match_migration_masks(self):
        entries = _slip_02_entries()
        self.assertEqual(len(entries), 155)
        self.assertEqual(
            [position for position, entry in enumerate(entries, 1) if entry == "0"],
            list(range(145, 156)),
        )
        masks = dict(MIGRATION.PORTER_SLIP_ITEM_BYTE_MASKS)
        for position, entry in enumerate(entries, 1):
            byte_position = (position - 1) // 8 + 1
            bit = 1 << ((position - 1) % 8)
            mask = masks.get(byte_position, 0xFF)
            if entry == "0":
                self.assertEqual(mask & bit, 0)
            else:
                self.assertNotEqual(mask & bit, 0)

    def test_fresh_schema_does_not_need_legacy_migration(self):
        self.assertFalse(MIGRATION.needs_to_run(FakeCursor(legacy=False)))

    def test_migration_repairs_stale_ownership_after_old_upgrade(self):
        cursor = FakeCursor(legacy=False)
        database = FakeDatabase()
        cursor.inventory.append(
            {"charid": 9, "location": 0, "slot": 1, "itemId": 25734}
        )
        cursor.inventory[1]["extra"] = _porter_extra(
            previous=0x03, first=0xFF, second=0xFF
        )

        self.assertTrue(MIGRATION.needs_to_run(cursor))
        MIGRATION.migrate(cursor, database)

        self.assertEqual(
            [row["itemId"] for row in cursor.inventory],
            [25733, MIGRATION.MOOGLE_STORAGE_SLIP_02],
        )
        self.assertEqual(cursor.inventory[1]["extra"][18] & 0xFF, 0)
        self.assertEqual(cursor.inventory[1]["extra"][19] & 0x07, 0)
        self.assertEqual(cursor.inventory[1]["extra"][17] & 0x03, 0x03)
        self.assertEqual(cursor.inventory[1]["extra"][19] & 0xF8, 0xF8)
        self.assertEqual(database.commits, 1)

    def test_migration_is_idempotent_after_legacy_upgrade(self):
        cursor = FakeCursor()
        database = FakeDatabase()
        MIGRATION.migrate(cursor, database)
        snapshot = (
            deepcopy(cursor.rows),
            deepcopy(cursor.inventory),
            deepcopy(cursor.equip),
            deepcopy(cursor.equip_saved),
            deepcopy(cursor.style),
            deepcopy(cursor.delivery),
            deepcopy(cursor.auction_house),
        )

        self.assertFalse(MIGRATION.needs_to_run(cursor))
        MIGRATION.migrate(cursor, database)
        self.assertEqual(
            (
                cursor.rows,
                cursor.inventory,
                cursor.equip,
                cursor.equip_saved,
                cursor.style,
                cursor.delivery,
                cursor.auction_house,
            ),
            snapshot,
        )

    def test_fake_rejects_wrong_column_mutation(self):
        cursor = FakeCursor()
        with self.assertRaises(AssertionError):
            cursor.execute("DELETE FROM `item_basic` WHERE `item_equipment` IN (25734)")

    def test_canonical_sql_removes_unity_rows_and_preserves_neighbors(self):
        root = Path(__file__).resolve().parent.parent / "sql"

        spell_content = (root / "spell_list.sql").read_text(encoding="utf-8")
        spell_ids = {
            int(match.group(1))
            for match in re.finditer(
                r"^INSERT INTO `spell_list` VALUES \((\d+),", spell_content, re.M
            )
        }
        self.assertFalse(spell_ids & EXPECTED_SPELL_IDS)
        self.assertTrue({952, 958, 979, 982, 1004, 1009} <= spell_ids)

        pool_content = (root / "mob_pools.sql").read_text(encoding="utf-8")
        pool_ids = {
            int(match.group(1))
            for match in re.finditer(
                r"^INSERT INTO `mob_pools` VALUES \((\d+),", pool_content, re.M
            )
        }
        self.assertFalse(pool_ids & EXPECTED_POOL_IDS)
        self.assertTrue({5952, 5958, 5979, 5982, 6004, 6009} <= pool_ids)

        for filename, generic_name in (
            ("mob_spell_lists.sql", "TRUST_Shantotto"),
            ("mob_skill_lists.sql", "TRUST_Naji"),
        ):
            content = (root / filename).read_text(encoding="utf-8")
            self.assertNotRegex(content, r"TRUST_[^\r\n]*_UC")
            self.assertIn("'{}'".format(generic_name), content)

        for filename, table in (
            ("item_basic.sql", "item_basic"),
            ("item_equipment.sql", "item_equipment"),
        ):
            content = (root / filename).read_text(encoding="utf-8")
            for item_id in EXPECTED_REWARD_ITEM_IDS:
                self.assertNotRegex(
                    content,
                    r"(?m)^INSERT INTO `{}` VALUES \({},".format(table, item_id),
                )
            self.assertRegex(
                content,
                r"(?m)^INSERT INTO `{}` VALUES \(25733,".format(table),
            )
            self.assertRegex(
                content,
                r"(?m)^INSERT INTO `{}` VALUES \(25745,".format(table),
            )

        item_basic = (root / "item_basic.sql").read_text(encoding="utf-8")
        for item_id in EXPECTED_EMINENT_ITEM_IDS:
            self.assertNotRegex(
                item_basic,
                r"(?m)^INSERT INTO `item_basic` VALUES \({},".format(item_id),
            )
        item_usable = (root / "item_usable.sql").read_text(encoding="utf-8")
        for item_id in EXPECTED_EMINENT_ITEM_IDS:
            self.assertNotRegex(
                item_usable,
                r"(?m)^INSERT INTO `item_usable` VALUES \({},".format(item_id),
            )
        self.assertRegex(item_basic, r"(?m)^INSERT INTO `item_basic` VALUES \(6268,")
        self.assertRegex(item_usable, r"(?m)^INSERT INTO `item_usable` VALUES \(6272,")

    def test_assist_columns_and_add_migration_are_removed(self):
        root = Path(__file__).resolve().parent.parent
        self.assertNotIn("`last_logout`", (root / "sql/chars.sql").read_text())
        self.assertNotIn("`muted`", (root / "sql/char_flags.sql").read_text())
        self.assertFalse((root / "tools/migrations/046_assist_channel.py").exists())
        self.assertNotIn("Unity Ranking", (root / "sql/item_mods.sql").read_text())
        self.assertNotIn("Unity Ranking", (root / "sql/item_latents.sql").read_text())


if __name__ == "__main__":
    unittest.main()
