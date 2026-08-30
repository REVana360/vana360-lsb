-----------------------------------
-- Crimson Howl
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    local duration = math.min(30 + xi.summon.getSummoningSkillOverCap(pet), 180)

    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local typeEffect = xi.effect.WARCRY
    if target:addStatusEffect(typeEffect, { power = 9, duration = duration, origin = pet }) then
        if target:getID() == action:getPrimaryTargetID() then
            petskill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT_2)
        else
            petskill:setMsg(xi.msg.basic.JA_GAIN_EFFECT)
        end
    else
        petskill:setMsg(xi.msg.basic.JA_NO_EFFECT_2)
        return
    end

    return typeEffect
end

return abilityObject
