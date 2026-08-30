-----------------------------------
-- Ability: Beast Roll
-- Enhances pet attacks for party members within area of effect
-- Optimal Job: Beastmaster
-- Lucky Number: 4
-- Unlucky Number: 8
-- Level: 34
-- Phantom Roll +1 Value: 3
--
-- Die Roll |No BST     |With BST
-- -------- --------    -----------
-- 1        |20         |52
-- 2        |24         |56
-- 3        |28         |60
-- 4        |76         |108
-- 5        |32         |64
-- 6        |36         |68
-- 7        |48         |80
-- 8        |8          |40
-- 9        |52         |84
-- 10       |56         |88
-- 11       |92         |124
-- Bust     |-8         |-8
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
