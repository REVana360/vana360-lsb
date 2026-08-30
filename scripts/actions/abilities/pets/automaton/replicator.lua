-----------------------------------
-- Replicator
-- Description: Consumes Wind Maneuvers to apply Blink when HP is below a certain threshold. Cooldown of 1 minute.
-- If Automaton has a Damage Gauge equipped, activation threshold is increased to 75% HP
-- Grants 2 / 3 / 4 shadows for 1 / 2 / 3 maneuvers.
-- https://wiki.ffo.jp/html/12225.html
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

local shadowTable =
{
    [1] = 2,
    [2] = 3,
    [3] = 4,
}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    return 0
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    local windManeuvers = xi.automaton.getManeuverCount(master, master:countEffect(xi.effect.WIND_MANEUVER))
    local shadows       = shadowTable[windManeuvers]

    automaton:addRecast(xi.recast.ABILITY, skill:getID(), 60)

    for i = 1, windManeuvers do
        master:delStatusEffectSilent(xi.effect.WIND_MANEUVER)
    end

    master:updateAttachments()

    if
        shadows and
        target:addStatusEffect(xi.effect.BLINK, { power = shadows, duration = 300, origin = automaton })
    then
        skill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT)
    else
        skill:setMsg(xi.msg.basic.SKILL_NO_EFFECT)
    end

    return xi.effect.BLINK
end

return abilityObject
