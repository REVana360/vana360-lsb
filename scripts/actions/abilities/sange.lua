-----------------------------------
-- Ability: Sange
-- Consumes Utsusemi shadows to add hits to the next ranged attack.
-- Obtained: Ninja Level 75 Merits
-- Recast Time: 15 minutes
-- Duration: 1 minute
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.ninja.checkSange(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.job_utils.ninja.useSange(player, target, ability, action)
end

return abilityObject
