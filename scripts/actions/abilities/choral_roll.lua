-----------------------------------
-- Ability: Choral Roll
-- Decreases spell interruption rate for party members within area of effect
-- Optimal Job: Bard
-- Lucky Number: 2
-- Unlucky Number: 6
-- Level: 26
-- Phantom Roll +1 Value: 4
--
-- Die Roll     |No BRD     |With BRD
-- --------     --------    -------
-- 1            |-4         |-12
-- 2            |-17        |-25
-- 3            |-5         |-13
-- 4            |-6         |-14
-- 5            |-7         |-15
-- 6            |-2         |-10
-- 7            |-8         |-16
-- 8            |-10        |-18
-- 9            |-11        |-19
-- 10           |-12        |-20
-- 11           |-21        |-29
-- Bust         |+8         |+8
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
