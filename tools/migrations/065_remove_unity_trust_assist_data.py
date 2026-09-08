import mariadb


UNITY_TRUST_SPELL_IDS = (953, 954, 955, 956, 957, 980, 981, 1005, 1006, 1007, 1008)

UNITY_TRUST_POOL_IDS = (
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
)

UNITY_REWARD_ITEM_IDS = (
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
)

EMINENT_ITEM_IDS = (6269, 6270, 6271)
REMOVED_ITEM_IDS = UNITY_REWARD_ITEM_IDS + EMINENT_ITEM_IDS

MOOGLE_STORAGE_SLIP_02 = 29313
PORTER_SLIP_ITEM_BYTE_MASKS = ((19, 0x00), (20, 0xF8))

EQUIPMENT_COLUMNS = (
    "main",
    "sub",
    "ranged",
    "ammo",
    "head",
    "body",
    "hands",
    "legs",
    "feet",
    "neck",
    "waist",
    "ear1",
    "ear2",
    "ring1",
    "ring2",
    "back",
)

STYLE_COLUMNS = ("head", "body", "hands", "legs", "feet", "main", "sub", "ranged")

UNITY_TRUST_SPELL_LIST_NAMES = (
    "TRUST_Pieuje_UC",
    "TRUST_Apururu_UC",
    "TRUST_Yoran-Oran_UC",
    "TRUST_Sylvie_UC",
)

UNITY_TRUST_SKILL_LIST_NAMES = (
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
)

ASSIST_CHAR_VARS = (
    "[ASSIST][Warnings]Cooldown",
    "[ASSIST][ThumbsUp]Cooldown",
    "[ASSIST][Evaluations]Eligible",
    "[ASSIST][Evaluations]Today",
    "[ASSIST][Evaluations]Count",
    "[ASSIST]Eligible",
    "[ASSIST]Muted",
)

ROE_UNITY_CHAR_VARS = (
    "weekly_sparks_spent",
    "weekly_accolades_spent",
    "unity_changed",
)

REMOVED_CHAR_VARS = ASSIST_CHAR_VARS + ROE_UNITY_CHAR_VARS


def migration_name():
    return "Remove Unity Trust and Assist Channel data"


def check_preconditions(cur):
    return


def _sql_strings(values):
    return ", ".join("'{}'".format(value.replace("'", "''")) for value in values)


def _has_rows(cur, table, column, values):
    if isinstance(values[0], int):
        sql_values = ", ".join(str(value) for value in values)
    else:
        sql_values = _sql_strings(values)

    cur.execute(
        "SELECT 1 FROM `{}` WHERE `{}` IN ({}) LIMIT 1".format(
            table, column, sql_values
        )
    )
    return bool(cur.fetchone())


def _column_exists(cur, table, column):
    cur.execute("SHOW COLUMNS FROM `{}` LIKE '{}'".format(table, column))
    return bool(cur.fetchone())


def _has_char_equip_rows(cur):
    cur.execute(
        "SELECT 1 FROM `char_equip` AS `equip` "
        "INNER JOIN `char_inventory` AS `inventory` "
        "ON `inventory`.`charid` = `equip`.`charid` "
        "AND `inventory`.`location` = `equip`.`containerid` "
        "AND `inventory`.`slot` = `equip`.`slotid` "
        "WHERE `inventory`.`itemId` IN ({}) LIMIT 1".format(
            ", ".join(str(value) for value in REMOVED_ITEM_IDS)
        )
    )
    return bool(cur.fetchone())


def _has_saved_equipment_rows(cur):
    predicates = " OR ".join(
        "`{}` IN ({})".format(
            column, ", ".join(str(value) for value in REMOVED_ITEM_IDS)
        )
        for column in EQUIPMENT_COLUMNS
    )
    cur.execute("SELECT 1 FROM `char_equip_saved` WHERE {} LIMIT 1".format(predicates))
    return bool(cur.fetchone())


def _has_style_rows(cur):
    predicates = " OR ".join(
        "`{}` IN ({})".format(
            column, ", ".join(str(value) for value in REMOVED_ITEM_IDS)
        )
        for column in STYLE_COLUMNS
    )
    cur.execute("SELECT 1 FROM `char_style` WHERE {} LIMIT 1".format(predicates))
    return bool(cur.fetchone())


def _has_porter_slip_bits(cur):
    cur.execute(
        "SELECT 1 FROM `char_inventory` "
        "WHERE `itemId` = {} "
        "AND ((ORD(SUBSTRING(`extra`, 19, 1)) & 255) <> 0 "
        "OR (ORD(SUBSTRING(`extra`, 20, 1)) & 7) <> 0) LIMIT 1".format(
            MOOGLE_STORAGE_SLIP_02
        )
    )
    return bool(cur.fetchone())


def _has_active_auction_rows(cur):
    cur.execute(
        "SELECT 1 FROM `auction_house` WHERE `itemid` IN ({}) "
        "AND `buyer_name` IS NULL LIMIT 1".format(
            ", ".join(str(value) for value in REMOVED_ITEM_IDS)
        )
    )
    return bool(cur.fetchone())


def needs_to_run(cur):
    return any(
        (
            _column_exists(cur, "chars", "last_logout"),
            _column_exists(cur, "char_flags", "muted"),
            _has_rows(cur, "char_vars", "varname", REMOVED_CHAR_VARS),
            _has_rows(cur, "spell_list", "spellid", UNITY_TRUST_SPELL_IDS),
            _has_rows(cur, "mob_pools", "poolid", UNITY_TRUST_POOL_IDS),
            _has_rows(cur, "item_basic", "itemid", UNITY_REWARD_ITEM_IDS),
            _has_rows(cur, "item_basic", "itemid", EMINENT_ITEM_IDS),
            _has_rows(cur, "item_usable", "itemid", EMINENT_ITEM_IDS),
            _has_rows(cur, "item_equipment", "itemId", UNITY_REWARD_ITEM_IDS),
            _has_rows(cur, "char_inventory", "itemId", REMOVED_ITEM_IDS),
            _has_char_equip_rows(cur),
            _has_saved_equipment_rows(cur),
            _has_style_rows(cur),
            _has_rows(cur, "delivery_box", "itemid", REMOVED_ITEM_IDS),
            _has_active_auction_rows(cur),
            _has_rows(cur, "auction_house_items", "itemid", REMOVED_ITEM_IDS),
            _has_porter_slip_bits(cur),
            _has_rows(
                cur,
                "mob_spell_lists",
                "spell_list_name",
                UNITY_TRUST_SPELL_LIST_NAMES,
            ),
            _has_rows(
                cur,
                "mob_skill_lists",
                "skill_list_name",
                UNITY_TRUST_SKILL_LIST_NAMES,
            ),
        )
    )


def migrate(cur, db):
    try:
        # Remove dependent Trust lists before removing their pools and spells.
        cur.execute(
            "DELETE FROM `mob_skill_lists` WHERE `skill_list_name` IN ({})".format(
                _sql_strings(UNITY_TRUST_SKILL_LIST_NAMES)
            )
        )
        cur.execute(
            "DELETE FROM `mob_spell_lists` WHERE `spell_list_name` IN ({})".format(
                _sql_strings(UNITY_TRUST_SPELL_LIST_NAMES)
            )
        )
        cur.execute(
            "DELETE FROM `mob_pools` WHERE `poolid` IN ({})".format(
                ", ".join(str(value) for value in UNITY_TRUST_POOL_IDS)
            )
        )
        cur.execute(
            "DELETE FROM `spell_list` WHERE `spellid` IN ({})".format(
                ", ".join(str(value) for value in UNITY_TRUST_SPELL_IDS)
            )
        )
        # Remove retired items from every owning character location.  char_equip
        # stores a slot reference, so reconcile it before char_inventory rows.
        cur.execute(
            "DELETE `equip` FROM `char_equip` AS `equip` "
            "INNER JOIN `char_inventory` AS `inventory` "
            "ON `inventory`.`charid` = `equip`.`charid` "
            "AND `inventory`.`location` = `equip`.`containerid` "
            "AND `inventory`.`slot` = `equip`.`slotid` "
            "WHERE `inventory`.`itemId` IN ({})".format(
                ", ".join(str(value) for value in REMOVED_ITEM_IDS)
            )
        )
        cur.execute(
            "DELETE FROM `char_inventory` WHERE `itemId` IN ({})".format(
                ", ".join(str(value) for value in REMOVED_ITEM_IDS)
            )
        )
        for column in EQUIPMENT_COLUMNS:
            cur.execute(
                "UPDATE `char_equip_saved` SET `{}` = 0 WHERE `{}` IN ({})".format(
                    column,
                    column,
                    ", ".join(str(value) for value in REMOVED_ITEM_IDS),
                )
            )
        for column in STYLE_COLUMNS:
            cur.execute(
                "UPDATE `char_style` SET `{}` = 0 WHERE `{}` IN ({})".format(
                    column,
                    column,
                    ", ".join(str(value) for value in REMOVED_ITEM_IDS),
                )
            )
        cur.execute(
            "DELETE FROM `delivery_box` WHERE `itemid` IN ({})".format(
                ", ".join(str(value) for value in REMOVED_ITEM_IDS)
            )
        )
        # Sold auction rows are historical records; only active listings own
        # an item and are removed.  The searchable item index has no history.
        cur.execute(
            "DELETE FROM `auction_house` WHERE `itemid` IN ({}) "
            "AND `buyer_name` IS NULL".format(
                ", ".join(str(value) for value in REMOVED_ITEM_IDS)
            )
        )
        cur.execute(
            "DELETE FROM `auction_house_items` WHERE `itemid` IN ({})".format(
                ", ".join(str(value) for value in REMOVED_ITEM_IDS)
            )
        )

        # Slip 02 stores the retired shirts at positions 145-155: all of byte
        # 19 and the low three bits of byte 20. Keep later positions stable;
        # padding handles legacy rows with short or NULL extra blobs.
        cur.execute(
            "UPDATE `char_inventory` SET `extra` = RPAD(COALESCE(`extra`, ''), 24, CHAR(0)) "
            "WHERE `itemId` = {}".format(MOOGLE_STORAGE_SLIP_02)
        )
        for position, mask in PORTER_SLIP_ITEM_BYTE_MASKS:
            cur.execute(
                "UPDATE `char_inventory` SET `extra` = INSERT(`extra`, {}, 1, "
                "CHAR(ORD(SUBSTRING(`extra`, {}, 1)) & {})) "
                "WHERE `itemId` = {}".format(
                    position, position, mask, MOOGLE_STORAGE_SLIP_02
                )
            )

        for table, column in (
            ("item_basic", "itemid"),
            ("item_usable", "itemid"),
            ("item_equipment", "itemId"),
        ):
            cur.execute(
                "DELETE FROM `{}` WHERE `{}` IN ({})".format(
                    table,
                    column,
                    ", ".join(str(value) for value in REMOVED_ITEM_IDS),
                )
            )
        cur.execute(
            "DELETE FROM `char_vars` WHERE `varname` IN ({})".format(
                _sql_strings(REMOVED_CHAR_VARS)
            )
        )

        for table, column in (("chars", "last_logout"), ("char_flags", "muted")):
            if _column_exists(cur, table, column):
                cur.execute("ALTER TABLE `{}` DROP COLUMN `{}`".format(table, column))

        db.commit()
    except mariadb.Error as err:
        print("Something went wrong: {}".format(err))
        raise
