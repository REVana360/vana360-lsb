-----------------------------------
-- Shock Absorber
-- Grants a 100-point Stoneskin effect to the automaton for 3 minutes.
-- https://wiki.ffo.jp/html/12927.html
-----------------------------------
---@type TAbilityAutomaton
local abilityObject = {}

abilityObject.onAutomatonAbilityCheck = function(target, automaton, skill)
    return 0
end

abilityObject.onAutomatonAbility = function(target, automaton, skill, master, action)
    automaton:addRecast(xi.recast.ABILITY, skill:getID(), 180)

    if target:addStatusEffect(xi.effect.STONESKIN, { power = 100, duration = 180, origin = automaton, tier = 4 }) then
        skill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT)
    else
        skill:setMsg(xi.msg.basic.SKILL_NO_EFFECT)
    end

    return xi.effect.STONESKIN
end

return abilityObject
