-----------------------------------
-- Ability: Rampart
-- Raises party members' defense and provides a barrier against magic damage.
-- Obtained: Paladin Level 62
-- Recast Time: 5:00
-- Duration: 0:30
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.paladin.useRampart(player, target, ability)
end

return abilityObject
