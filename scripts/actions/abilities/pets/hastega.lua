-----------------------------------
-- Hastega
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    -- Reverts doubled base duration and Slow overwrites the Haste tier
    -- Source: https://www.bg-wiki.com/ffxi/Version_Update_(04/08/2009)
    local duration = math.min(90 + xi.summon.getSummoningSkillOverCap(pet) * 3, 180)

    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    -- Garuda's Hastega is a weird exception and uses 153/1024 instead of 150/1024 like Haste spell
    -- That's why it overwrites some things regular haste won't. 153/1024 ~14.94%
    local typeEffect = xi.effect.HASTE
    if target:addStatusEffect(typeEffect, { power = 1494, duration = duration, origin = pet, tier = 1 }) then
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
