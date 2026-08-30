-----------------------------------
-- Ability: Warlock's Roll
-- Enhances magic accuracy for party members within area of effect
-- Optimal Job: Red Mage
-- Lucky Number: 4
-- Unlucky Number: 8
-- Level: 46
-- Phantom Roll +1 Value: 1
--
-- Die Roll    |No RDM  |With RDM
-- --------    -------- -----------
-- 1           |+2      |+6
-- 2           |+3      |+7
-- 3           |+4      |+8
-- 4           |+10     |+14
-- 5           |+4      |+8
-- 6           |+5      |+9
-- 7           |+6      |+10
-- 8           |+1      |+5
-- 9           |+7      |+11
-- 10          |+7      |+11
-- 11          |+12     |+16
-- Bust        |-4      |-4
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
