-----------------------------------
-- Ability: Chivalry
-- Converts TP to MP.
-- Obtained: Paladin Level 75 (Must be Purchased with Merit Points)
-- Recast Time: 0:20:00
-- Duration: Instant
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.job_utils.paladin.useChivalry(player, target, ability, action)
end

return abilityObject
