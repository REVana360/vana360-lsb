import mariadb


DROPPED_COLUMNS = {
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
}

DROPPED_INDEXES = {
    "accounts_sessions": ("idx_accounts_sessions_unitychat",),
}

DROPPED_TABLES = ("unity_system",)


def migration_name():
    return "Remove Records of Eminence and Unity persistence"


def check_preconditions(cur):
    return


def _column_exists(cur, table, column):
    cur.execute("SHOW COLUMNS FROM `{}` LIKE '{}'".format(table, column))
    return bool(cur.fetchone())


def _index_exists(cur, table, index):
    cur.execute("SHOW INDEX FROM `{}` WHERE Key_name = '{}'".format(table, index))
    return bool(cur.fetchone())


def _table_exists(cur, table):
    cur.execute("SHOW TABLES LIKE '{}'".format(table))
    return bool(cur.fetchone())


def needs_to_run(cur):
    for table, columns in DROPPED_COLUMNS.items():
        for column in columns:
            if _column_exists(cur, table, column):
                return True

    for table, indexes in DROPPED_INDEXES.items():
        for index in indexes:
            if _index_exists(cur, table, index):
                return True

    return any(_table_exists(cur, table) for table in DROPPED_TABLES)


def migrate(cur, db):
    try:
        # Drop the index before its Unity-only column.
        for table, indexes in DROPPED_INDEXES.items():
            for index in indexes:
                if _index_exists(cur, table, index):
                    cur.execute("DROP INDEX `{}` ON `{}`".format(index, table))

        for table, columns in DROPPED_COLUMNS.items():
            for column in columns:
                if _column_exists(cur, table, column):
                    cur.execute(
                        "ALTER TABLE `{}` DROP COLUMN `{}`".format(table, column)
                    )

        for table in DROPPED_TABLES:
            cur.execute("DROP TABLE IF EXISTS `{}`".format(table))

        db.commit()
    except mariadb.Error as err:
        print("Something went wrong: {}".format(err))
        raise
