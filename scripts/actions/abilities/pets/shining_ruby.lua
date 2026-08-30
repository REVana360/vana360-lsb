-----------------------------------
-- Shining Ruby
-- Era source: Reverts doubled ward duration and skill-over-cap scaling.
-- Source: http://www.playonline.com/pcd/update/ff11us/20061017UJ0a71/detail.html
--         https://www.bg-wiki.com/ffxi/Version_Update_(09/08/2010)
-- Notes : https://wiki.ffo.jp/html/14112.html
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    local duration = 180

    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    target:delStatusEffect(xi.effect.SHINING_RUBY)
    target:addStatusEffect(xi.effect.SHINING_RUBY, { power = 1, duration = duration, origin = pet })

    if target:getID() == action:getPrimaryTargetID() then
        petskill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT_2)
    else
        petskill:setMsg(xi.msg.basic.JA_GAIN_EFFECT)
    end

    return xi.effect.SHINING_RUBY
end

return abilityObject
