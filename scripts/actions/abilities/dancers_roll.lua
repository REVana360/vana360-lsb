-----------------------------------
-- Ability: Dancer's Roll
-- Grants Regen status to party members within area of effect
-- Optimal Job: Dancer
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 61
-- Phantom Roll +1 Value: 2
--
-- Die Roll    |No DNC              |With DNC
-- --------    ----------           ----------
-- 1           |3HP/Tick            |6HP/Tick
-- 2           |4HP/Tick            |7HP/Tick
-- 3           |11HP/Tick           |14HP/Tick
-- 4           |4HP/Tick            |7HP/Tick
-- 5           |5HP/Tick            |8HP/Tick
-- 6           |6HP/Tick            |9HP/Tick
-- 7           |1HP/Tick            |4HP/Tick
-- 8           |7HP/Tick            |10HP/Tick
-- 9           |8HP/Tick            |11HP/Tick
-- 10          |8HP/Tick            |11HP/Tick
-- 11          |14HP/Tick           |17HP/Tick
-- 12+         |-3hp(regen)/Tick    |-3hp(regen)/Tick
-- A bust reduces an active regen effect by 3; it does not drain HP without regen.
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.corsair.onRollAbilityCheck(player, target, ability)
end

abilityObject.onUseAbility = function(caster, target, ability, action)
    return xi.job_utils.corsair.onRollUseAbility(caster, target, ability, action)
end

return abilityObject
