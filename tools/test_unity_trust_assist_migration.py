import importlib
import re
import unittest
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


class FakeCursor:
    def __init__(self):
        self.columns = {"chars": {"last_logout"}, "char_flags": {"muted"}}
        self.rows = {
            "char_vars": set(EXPECTED_REMOVED_VARS),
            "spell_list": set(EXPECTED_SPELL_IDS) | {952, 958},
            "mob_pools": set(EXPECTED_POOL_IDS) | {5952, 5958, 5979, 5982, 6004, 6009},
            "item_basic": set(EXPECTED_REWARD_ITEM_IDS) | {25733, 25745},
            "item_equipment": set(EXPECTED_REWARD_ITEM_IDS) | {25733, 25745},
            "mob_spell_lists": set(EXPECTED_SPELL_LISTS) | {"TRUST_Shantotto"},
            "mob_skill_lists": set(EXPECTED_SKILL_LISTS) | {"TRUST_Naji"},
        }
        self.result = None

    def execute(self, query):
        column = re.search(
            r"SHOW COLUMNS FROM `([^`]+)` LIKE '([^']+)'", query, re.IGNORECASE
        )
        if column:
            table, name = column.groups()
            self.result = (1,) if name in self.columns.get(table, set()) else None
            return

        select = re.search(
            r"SELECT 1 FROM `([^`]+)` WHERE `([^`]+)` IN \(([^)]+)\) LIMIT 1",
            query,
            re.IGNORECASE,
        )
        if select:
            table, _column, values = select.groups()
            if values.startswith("'"):
                values = {
                    value.replace("''", "'")
                    for value in re.findall(r"'((?:''|[^'])*)'", values)
                }
            else:
                values = {int(value.strip()) for value in values.split(",")}
            self.result = (1,) if self.rows[table] & values else None
            return

        delete = re.search(
            r"DELETE FROM `([^`]+)` WHERE `([^`]+)` IN \(([^)]+)\)",
            query,
            re.IGNORECASE,
        )
        if delete:
            table, _column, values = delete.groups()
            if values.startswith("'"):
                values = {
                    value.replace("''", "'")
                    for value in re.findall(r"'((?:''|[^'])*)'", values)
                }
            else:
                values = {int(value.strip()) for value in values.split(",")}
            self.rows[table].difference_update(values)
            return

        column = re.search(
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
        self.assertFalse(cursor.rows["item_basic"] & EXPECTED_REWARD_ITEM_IDS)
        self.assertFalse(cursor.rows["item_equipment"] & EXPECTED_REWARD_ITEM_IDS)
        self.assertFalse(cursor.rows["mob_spell_lists"] & EXPECTED_SPELL_LISTS)
        self.assertFalse(cursor.rows["mob_skill_lists"] & EXPECTED_SKILL_LISTS)
        self.assertEqual(cursor.rows["spell_list"], {952, 958})
        self.assertEqual(cursor.rows["mob_pools"], {5952, 5958, 5979, 5982, 6004, 6009})
        self.assertEqual(cursor.rows["item_basic"], {25733, 25745})
        self.assertEqual(cursor.rows["item_equipment"], {25733, 25745})
        self.assertEqual(cursor.rows["mob_spell_lists"], {"TRUST_Shantotto"})
        self.assertEqual(cursor.rows["mob_skill_lists"], {"TRUST_Naji"})
        self.assertNotIn("last_logout", cursor.columns["chars"])
        self.assertNotIn("muted", cursor.columns["char_flags"])
        self.assertEqual(database.commits, 1)
        self.assertFalse(MIGRATION.needs_to_run(cursor))

    def test_migration_contract_is_independent_and_exact(self):
        self.assertEqual(set(MIGRATION.UNITY_TRUST_SPELL_IDS), EXPECTED_SPELL_IDS)
        self.assertEqual(set(MIGRATION.UNITY_TRUST_POOL_IDS), EXPECTED_POOL_IDS)
        self.assertEqual(set(MIGRATION.UNITY_REWARD_ITEM_IDS), EXPECTED_REWARD_ITEM_IDS)
        self.assertEqual(
            set(MIGRATION.UNITY_TRUST_SPELL_LIST_NAMES), EXPECTED_SPELL_LISTS
        )
        self.assertEqual(
            set(MIGRATION.UNITY_TRUST_SKILL_LIST_NAMES), EXPECTED_SKILL_LISTS
        )
        self.assertEqual(set(MIGRATION.ASSIST_CHAR_VARS), EXPECTED_ASSIST_VARS)
        self.assertEqual(set(MIGRATION.ROE_UNITY_CHAR_VARS), EXPECTED_ROE_UNITY_VARS)
        self.assertEqual(set(MIGRATION.REMOVED_CHAR_VARS), EXPECTED_REMOVED_VARS)

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

    def test_assist_columns_and_add_migration_are_removed(self):
        root = Path(__file__).resolve().parent.parent
        self.assertNotIn("`last_logout`", (root / "sql/chars.sql").read_text())
        self.assertNotIn("`muted`", (root / "sql/char_flags.sql").read_text())
        self.assertFalse((root / "tools/migrations/046_assist_channel.py").exists())
        self.assertNotIn("Unity Ranking", (root / "sql/item_mods.sql").read_text())
        self.assertNotIn("Unity Ranking", (root / "sql/item_latents.sql").read_text())


if __name__ == "__main__":
    unittest.main()
