-----------------------------------
-- Eraser
-- Changes Eraser to consume all Maneuvers on activation.
-- https://wiki.ffo.jp/html/5365.html
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    return 0
end

local maneuvers =
{
    xi.effect.FIRE_MANEUVER,
    xi.effect.ICE_MANEUVER,
    xi.effect.WIND_MANEUVER,
    xi.effect.EARTH_MANEUVER,
    xi.effect.THUNDER_MANEUVER,
    xi.effect.WATER_MANEUVER,
    xi.effect.LIGHT_MANEUVER,
    xi.effect.DARK_MANEUVER,
}

local function removeAllManeuvers(master)
    -- The July 2009 behavior consumes all active maneuvers, not just Light Maneuvers.
    for _, maneuverId in ipairs(maneuvers) do
        for _ = 1, master:countEffect(maneuverId) do
            master:delStatusEffectSilent(maneuverId)
        end
    end
end

local removables =
{
    -- Songs
    xi.effect.ELEGY,
    xi.effect.REQUIEM,
    xi.effect.THRENODY,

    -- Enfeebling
    xi.effect.BLINDNESS,
    xi.effect.PARALYSIS,
    xi.effect.SILENCE,
    xi.effect.POISON,
    xi.effect.CURSE_I,
    xi.effect.CURSE_II,
    xi.effect.DISEASE,
    xi.effect.PLAGUE,
    xi.effect.WEIGHT,
    xi.effect.BIND,
    xi.effect.ADDLE,
    xi.effect.SLOW,
    xi.effect.PETRIFICATION,

    -- DoTs
    xi.effect.BIO,
    xi.effect.DIA,
    xi.effect.BURN,
    xi.effect.FROST,
    xi.effect.CHOKE,
    xi.effect.RASP,
    xi.effect.SHOCK,
    xi.effect.DROWN,

    -- Main Stat Downs
    xi.effect.STR_DOWN,
    xi.effect.DEX_DOWN,
    xi.effect.VIT_DOWN,
    xi.effect.AGI_DOWN,
    xi.effect.INT_DOWN,
    xi.effect.MND_DOWN,
    xi.effect.CHR_DOWN,

    -- Combat Stat Downs
    xi.effect.ACCURACY_DOWN,
    xi.effect.ATTACK_DOWN,
    xi.effect.EVASION_DOWN,
    xi.effect.DEFENSE_DOWN,

    -- Magic Stat Downs
    xi.effect.MAGIC_ACC_DOWN,
    xi.effect.MAGIC_ATK_DOWN,
    xi.effect.MAGIC_EVASION_DOWN,
    xi.effect.MAGIC_DEF_DOWN,

    -- HP/MP/TP Stat Downs
    xi.effect.MAX_TP_DOWN,
    xi.effect.MAX_MP_DOWN,
    xi.effect.MAX_HP_DOWN
}

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    automaton:addRecast(xi.recast.ABILITY, skill:getID(), 30)

    local lightManeuvers = xi.automaton.getManeuverCount(master, master:countEffect(xi.effect.LIGHT_MANEUVER))

    local effectsRemoved = 0

    for _, effectId in ipairs(removables) do
        if target:hasStatusEffect(effectId) then
            target:delStatusEffectSilent(effectId)
            effectsRemoved = effectsRemoved + 1

            if effectsRemoved >= lightManeuvers then
                break
            end
        end
    end

    removeAllManeuvers(master)
    master:updateAttachments()

    if effectsRemoved > 0 then
        skill:setMsg(xi.msg.basic.DISAPPEAR_NUM)
    else
        skill:setMsg(xi.msg.basic.USES)
    end

    return effectsRemoved
end

return abilityObject
