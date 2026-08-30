-----------------------------------
-- Ability: Killer Instinct
-- Grants your pet's Killer Effect to party members within area of effect.
-- Obtained: Beastmaster Level 75 (Merit)
-- Recast Time: 15:00
-- Duration: 1:00
-----------------------------------
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.beastmaster.checkKillerInstinct(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.job_utils.beastmaster.useKillerInstinct(player, target, ability, action)
end

return abilityObject
