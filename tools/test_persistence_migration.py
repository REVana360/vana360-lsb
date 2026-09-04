import importlib
import re
import unittest
from pathlib import Path


MIGRATION = importlib.import_module("tools.migrations.064_remove_roe_unity_persistence")


class FakeCursor:
    def __init__(self):
        expected_columns = {
            "chars": {"eminence"},
            "char_points": {
                "spark_of_eminence",
                "unity_accolades",
                "deeds",
                "current_accolades",
                "prev_accolades",
                "plaudits",
            },
            "char_profile": {"unity_leader"},
            "char_unlocks": {"claimed_deeds"},
            "accounts_sessions": {"unitychat"},
            "audit_chat": {"unity"},
        }
        self.columns = {
            table: set(columns) for table, columns in expected_columns.items()
        }
        self.columns["char_points"].add("aman_vouchers")
        self.columns["char_unlocks"].add("unique_event")
        self.indexes = {
            table: set(indexes) for table, indexes in MIGRATION.DROPPED_INDEXES.items()
        }
        self.tables = set(MIGRATION.DROPPED_TABLES)
        self.result = None

    def execute(self, query):
        column = re.search(
            r"SHOW COLUMNS FROM `?(\w+)`? LIKE '([^']+)'", query, re.IGNORECASE
        )
        if column:
            table, name = column.groups()
            self.result = (1,) if name in self.columns.get(table, set()) else None
            return

        index = re.search(
            r"SHOW INDEX FROM `?(\w+)`? WHERE Key_name = '([^']+)'",
            query,
            re.IGNORECASE,
        )
        if index:
            table, name = index.groups()
            self.result = (1,) if name in self.indexes.get(table, set()) else None
            return

        table = re.search(r"SHOW TABLES LIKE '([^']+)'", query, re.IGNORECASE)
        if table:
            self.result = (1,) if table.group(1) in self.tables else None
            return

        index = re.search(r"DROP INDEX `([^`]+)` ON `([^`]+)`", query, re.IGNORECASE)
        if index:
            name, table = index.groups()
            self.indexes.get(table, set()).discard(name)
            return

        column = re.search(
            r"ALTER TABLE `([^`]+)` DROP COLUMN `([^`]+)`", query, re.IGNORECASE
        )
        if column:
            table, name = column.groups()
            self.columns.get(table, set()).discard(name)
            return

        table = re.search(r"DROP TABLE IF EXISTS `([^`]+)`", query, re.IGNORECASE)
        if table:
            self.tables.discard(table.group(1))
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


class PersistenceMigrationTest(unittest.TestCase):
    def test_removed_schema_contract_is_explicit(self):
        self.assertEqual(
            MIGRATION.DROPPED_COLUMNS,
            {
                "chars": ("eminence",),
                "char_points": (
                    "spark_of_eminence",
                    "unity_accolades",
                    "deeds",
                    "current_accolades",
                    "prev_accolades",
                    "plaudits",
                ),
                "char_profile": ("unity_leader",),
                "char_unlocks": ("claimed_deeds",),
                "accounts_sessions": ("unitychat",),
                "audit_chat": ("unity",),
            },
        )
        self.assertEqual(
            MIGRATION.DROPPED_INDEXES,
            {"accounts_sessions": ("idx_accounts_sessions_unitychat",)},
        )
        self.assertEqual(MIGRATION.DROPPED_TABLES, ("unity_system",))

    def test_drops_retired_objects_and_preserves_shared_columns(self):
        cursor = FakeCursor()
        database = FakeDatabase()

        self.assertTrue(MIGRATION.needs_to_run(cursor))
        MIGRATION.migrate(cursor, database)

        for columns in MIGRATION.DROPPED_COLUMNS.values():
            for column in columns:
                self.assertFalse(
                    any(column in values for values in cursor.columns.values())
                )
        self.assertFalse(cursor.indexes["accounts_sessions"])
        self.assertFalse(cursor.tables)
        self.assertIn("aman_vouchers", cursor.columns["char_points"])
        self.assertIn("unique_event", cursor.columns["char_unlocks"])
        self.assertEqual(database.commits, 1)
        self.assertFalse(MIGRATION.needs_to_run(cursor))

    def test_retired_add_migrations_are_not_loaded(self):
        migrations = Path(__file__).resolve().parent / "migrations"
        for module_name in (
            "012_eminence_blob",
            "017_char_points_weekly_unity",
            "018_char_profile_unity_leader",
            "033_deeds_of_heroism",
            "041_plaudits",
            "046_assist_channel",
        ):
            self.assertFalse((migrations / (module_name + ".py")).exists())

        for module_name in (
            "014_currency_columns",
            "016_convert_tables_to_innodb",
            "026_abyssea_unlocks",
            "037_unique_events",
            "038_timed_vars",
            "060_perf_indexes",
        ):
            content = (migrations / (module_name + ".py")).read_text(encoding="utf-8")
            for columns in MIGRATION.DROPPED_COLUMNS.values():
                for column in columns:
                    self.assertNotIn("`{}`".format(column), content)
            for indexes in MIGRATION.DROPPED_INDEXES.values():
                for index in indexes:
                    self.assertNotIn(index, content)
            for table in MIGRATION.DROPPED_TABLES:
                self.assertNotIn(table, content)

    def test_canonical_sql_has_no_retired_persistence(self):
        root = Path(__file__).resolve().parent.parent
        expected_files = {
            "chars.sql": ("eminence", "last_logout"),
            "char_points.sql": (
                "spark_of_eminence",
                "unity_accolades",
                "deeds",
                "current_accolades",
                "prev_accolades",
                "plaudits",
            ),
            "char_profile.sql": ("unity_leader",),
            "char_unlocks.sql": ("claimed_deeds",),
            "accounts_sessions.sql": ("unitychat", "idx_accounts_sessions_unitychat"),
            "audit_chat.sql": ("unity",),
        }
        for filename, columns in expected_files.items():
            content = (root / "sql" / filename).read_text(encoding="utf-8")
            for column in columns:
                self.assertNotIn("`{}`".format(column), content)
        self.assertFalse((root / "sql" / "unity_system.sql").exists())
        char_flags = (root / "sql" / "char_flags.sql").read_text(encoding="utf-8")
        self.assertNotIn("`muted`", char_flags)
        self.assertNotIn(
            '"unity_system.sql"', (root / "tools" / "dbtool.py").read_text()
        )


if __name__ == "__main__":
    unittest.main()
