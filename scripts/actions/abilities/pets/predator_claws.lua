-----------------------------------
-- Predator Claws
-- Family: Avatar (Garuda)
-- Description: Delivers a threefold attack to a target.
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)

    local params = {}

    params.baseDamage        = pet:getWeaponDmg()
    params.numHits           = 3
    params.fTP               = { 10.0, 10.0, 10.0 }
    params.fTPSubsequentHits = { 1.00, 1.00, 1.00 }
    params.dex_wSC           = 0.30
    params.attackType        = xi.attackType.PHYSICAL
    params.damageType        = xi.damageType.SLASHING
    params.shadowBehavior    = xi.mobskills.shadowBehavior.NUMSHADOWS_3
    params.primaryMessage    = xi.msg.basic.USES_JA_TAKE_DAMAGE

    local info = xi.mobskills.mobPhysicalMove(pet, target, petskill, action, params)

    if xi.mobskills.processDamage(pet, target, petskill, action, info) then
        target:takeDamage(info.damage, pet, info.attackType, info.damageType)
    end

    return info.damage
end

return abilityObject
