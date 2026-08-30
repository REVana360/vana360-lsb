-----------------------------------
-- Ability: Gallant's Roll
-- Reflects a portion of physical damage taken by party members within area of effect
-- Optimal Job: Paladin
-- Lucky Number: 3
-- Unlucky Number: 7
-- Level: 55
-- Phantom Roll +1 Value: 2.34
--
-- Die Roll    |No PLD  |With PLD
-- --------    -------  -----------
-- 1           |+4%     |+14%
-- 2           |+5%     |+15%
-- 3           |+15%    |+25%
-- 4           |+6%     |+16%
-- 5           |+7%     |+17%
-- 6           |+8%     |+18%
-- 7           |+3%     |+13%
-- 8           |+9%     |+19%
-- 9           |+10%    |+20%
-- 10          |+12%    |+22%
-- 11          |+20%    |+30%
-- Bust        |-5%     |-5%
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
