-----------------------------------
-- Ability: Drachen Roll
-- Enhances pet magic attack and magic accuracy for party members within area of effect
-- Optimal Job: Dragoon
-- Lucky Number: 4
-- Unlucky Number: 8
-- Level: 23
-- Phantom Roll +1 Value: 5
--
-- Die Roll    |No DRG  |With DRG
-- --------    -------  -----------
-- 1           |+4      |+12
-- 2           |+5      |+13
-- 3           |+18     |+26
-- 4           |+7      |+15
-- 5           |+9      |+17
-- 6           |+10     |+18
-- 7           |+2      |+10
-- 8           |+11     |+19
-- 9           |+13     |+21
-- 10          |+15     |+23
-- 11          |+22     |+30
-- Bust        |-8      |-8
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
