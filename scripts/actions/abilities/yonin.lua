-----------------------------------
-- Ability: Yonin
-- Increases enmity and Ninja Tool Expertise, but impairs accuracy.
-- Obtained: Ninja Level 40
-- Recast Time: 3:00
-- Duration: 5:00
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.ninja.checkYonin(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability, action)
    return xi.job_utils.ninja.useYonin(player, target, ability, action)
end

return abilityObject
