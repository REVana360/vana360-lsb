-----------------------------------
-- Module: Spell Adjustments (Rhapsodies of Vana'diel Era)
-- Desc: Reverts spell changes introduced during the RoV era
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('rov_spell_adjustments', xi.pre(xi.expansion.ROV))

-----------------------------------
-- Enfeebling Magic
-----------------------------------

-- TODO: Blind II / Blind
-- Source: https://forum.square-enix.com/ffxi/threads/46531-Mar-26-2015-%28JST%29-Version-Update
--  - Remove fixed 180 duration, revert to between 80 and 300 seconds
--  - Potency: Blind: (User INT - Opponent MND + 60)/4   Blind II: (User INT - Opponent MND + 100)/4

-- TODO: Paralyze / Paralyze II
--  - Remove fixed 120 duration, revert to between 30 and 120 seconds

-- TODO: Poison / Poison II / Poisonga
--  - Revert potencies to pre-RoV values

-----------------------------------
-- Dark Magic
-----------------------------------

-- TODO Absorb-STAT: Add decay tick and set 90 second duration to boost effects
-- TODO Drain II: Set duration of max HP boost to 60 seconds.
-- Source:
--   Decay Removal: http://forum.square-enix.com/ffxi/threads/46531-Mar-26-2015-%28JST%29-Version-Update
--   Duration Change: https://forum.square-enix.com/ffxi/threads/48564-Sep-16-2015-%28JST%29-Version-Update

-----------------------------------
-- Singing
-----------------------------------

-- TODO (pending exposure of pTables in magic scripts):
-- Update scripts/globals/spells/enhancing_song.lua pTable entries:
-- Source: https://forum.square-enix.com/ffxi/threads/55899-September.-10-2019-%28JST%29-Version-Update?p=619588&viewfull=1#post619588
--  xi.magic.spell.FOE_SIRVENTE      : MERIT_ID 0 -> xi.merit.FOE_SIRVENTE,      POWER_BASE 35 -> 0
--  xi.magic.spell.ADVENTURERS_DIRGE : MERIT_ID 0 -> xi.merit.ADVENTURERS_DIRGE, POWER_BASE 32 -> 5

--  POWER_CAP value: current -> target:
--  Source: https://forum.square-enix.com/ffxi/threads/52095-Feb.-10-2017-%28JST%29-Version-Update
--  xi.magic.spell.FIRE_CAROL       : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.ICE_CAROL        : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.WIND_CAROL       : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.EARTH_CAROL      : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.LIGHTNING_CAROL  : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.WATER_CAROL      : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.LIGHT_CAROL      : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.DARK_CAROL       : POWER_CAP 80  -> 50, MULTIPLIER 8   -> 5
--  xi.magic.spell.SWORD_MADRIGAL   : POWER_CAP 45  -> 15, MULTIPLIER 4.5 -> 2, DIVISOR 18 -> 23.25, SKILL_REQUIREMENT 85 -> 40
--  xi.magic.spell.BLADE_MADRIGAL   : POWER_CAP 60  -> 30, MULTIPLIER 6   -> 2
--  xi.magic.spell.SHEEPFOE_MAMBO   : POWER_CAP 48  -> 15, MULTIPLIER 5   -> 2.5
--  xi.magic.spell.DRAGONFOE_MAMBO  : POWER_CAP 72  -> 23, MULTIPLIER 7   -> 2.5
--  xi.magic.spell.ADVANCING_MARCH  : POWER_CAP 108 -> 64, MULTIPLIER 11  -> 16
--  xi.magic.spell.VICTORY_MARCH    : POWER_CAP 163 -> 96, POWER_BASE 43  -> 53
--  xi.magic.spell.KNIGHTS_MINNE    : POWER_CAP 30  -> 13, MULTIPLIER 3   -> 2.5, DIVISOR 10  -> 15, POWER_BASE 8  -> 5
--  xi.magic.spell.KNIGHTS_MINNE_II : POWER_CAP 69  -> 27, MULTIPLIER 7   -> 2.5, DIVISOR 10  -> 15, POWER_BASE 12 -> 6
--  xi.magic.spell.KNIGHTS_MINNE_III: POWER_CAP 108 -> 40, MULTIPLIER 11  -> 2.5, DIVISOR 10  -> 15, POWER_BASE 18 -> 10
--  xi.magic.spell.KNIGHTS_MINNE_IV : POWER_CAP 164 -> 48, MULTIPLIER 16  -> 2.5, DIVISOR 10  -> 15, POWER_BASE 30 -> 12
--  xi.magic.spell.VALOR_MINUET     : POWER_CAP 30  -> 16, MULTIPLIER 3   -> 2.5, DIVISOR 4.3 -> 6
--  xi.magic.spell.VALOR_MINUET_II  : POWER_CAP 69  -> 32, MULTIPLIER 6   -> 2.5, DIVISOR 3.9 -> 6, SKILL_REQUIREMENT 100 -> 85
--  xi.magic.spell.VALOR_MINUET_III : POWER_CAP 108 -> 48, MULTIPLIER 9   -> 2.5, DIVISOR 3.5 -> 6
--  xi.magic.spell.VALOR_MINUET_IV  : POWER_CAP 164 -> 56, MULTIPLIER 11  -> 2.5, DIVISOR 3.3 -> 15, POWER_BASE 31 -> 29
--  xi.magic.spell.HUNTERS_PRELUDE  : POWER_CAP 45  -> 15, MULTIPLIER 4.5 -> 2
--  xi.magic.spell.ARCHERS_PRELUDE  : POWER_CAP 60  -> 30, MULTIPLIER 6   -> 2

-----------------------------------
-- Ninjutsu
-----------------------------------

-- San Spells: Add +5 Magic Attack and +5 Magic Accuracy per merit rank
-- Source: https://forum.square-enix.com/ffxi/threads/55525-June.-10-2019-%28JST%29-Version-Update
local sanSpellOverrides =
{
    { path = 'xi.actions.spells.ninjutsu.katon_san.onSpellCast',  merit = xi.merit.KATON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.hyoton_san.onSpellCast', merit = xi.merit.HYOTON_SAN },
    { path = 'xi.actions.spells.ninjutsu.huton_san.onSpellCast',  merit = xi.merit.HUTON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.doton_san.onSpellCast',  merit = xi.merit.DOTON_SAN  },
    { path = 'xi.actions.spells.ninjutsu.raiton_san.onSpellCast', merit = xi.merit.RAITON_SAN },
    { path = 'xi.actions.spells.ninjutsu.suiton_san.onSpellCast', merit = xi.merit.SUITON_SAN },
}

for _, entry in ipairs(sanSpellOverrides) do
    m:addOverride(entry.path, function(caster, target, spell)
        local meritBonus = caster:getMerit(entry.merit)
        caster:addMod(xi.mod.MATT, meritBonus)
        caster:addMod(xi.mod.MACC, meritBonus)

        local damage = super(caster, target, spell)

        caster:delMod(xi.mod.MATT, meritBonus)
        caster:delMod(xi.mod.MACC, meritBonus)

        return damage
    end)
end
