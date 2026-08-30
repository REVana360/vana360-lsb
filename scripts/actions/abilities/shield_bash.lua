-----------------------------------
-- Ability: Shield Bash
-- Delivers an attack that can stun the target. Shield required.
-- Obtained: Paladin Level 15, Valoredge automaton frame Level 1
-- Recast Time: 5:00 minutes (3:00 for Valoredge version)
-- Duration: Instant
-----------------------------------
---@type TAbility
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.paladin.checkShieldBash(player, target, ability)
end

abilityObject.onUseAbility = function(player, target, ability)
    return xi.job_utils.paladin.useShieldBash(player, target, ability)
end

return abilityObject
