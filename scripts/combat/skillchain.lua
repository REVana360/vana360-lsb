-----------------------------------
-- Global file for skillchain calculations.
-----------------------------------
require('scripts/globals/spells/damage_spell')
-----------------------------------
xi = xi or {}
xi.combat = xi.combat or {}
xi.combat.skillchain = xi.combat.skillchain or {}
-----------------------------------

local chainMultipliers =
{
    [1] = { 0.50, 0.60, 0.70, 0.80, 0.90, 1.00 }, -- Level 1
    [2] = { 0.60, 0.75, 1.00, 1.25, 1.50, 1.75 }, -- Level 2
    [3] = { 1.00, 1.50, 1.75, 2.00, 2.25, 2.50 }, -- Level 3
}

local function getSkillchainElementToUse(target, skillchainType)
    -- Build skillchain available elements table.
    local elementTable = {}
    for i = xi.element.FIRE, xi.element.DARK do
        if xi.data.element.skillchainElementTable[i][skillchainType] > 0 then
            table.insert(elementTable, #elementTable + 1, i)
        end
    end

    -- Early return: Single elemental SC. No need to continue.
    if #elementTable == 1 then
        return elementTable[1]
    end

    -- Get lowest resistance rank value.
    local lowestResRank = 11
    local lowestElement = xi.element.FIRE

    for j = #elementTable, 1, -1 do
        local resRankValue = target:getMod(xi.data.element.getElementalResistanceRankModifier(elementTable[j]))
        if resRankValue <= lowestResRank then
            lowestResRank = resRankValue
            lowestElement = elementTable[j]
        end
    end

    return lowestElement
end

-- Handles skillchain magic damage multipliers, called from C++ (battleutils::TakeSkillchainDamage)
xi.combat.skillchain.calculateSkillchainDamage = function(actor, target, baseDamage)
    local skillchainEffect = target:getStatusEffect(xi.effect.SKILLCHAIN)
    if not skillchainEffect then
        return 0
    end

    local skillchainType = skillchainEffect:getPower()
    if skillchainType == 0 then
        return 0
    end

    local skillchainLevel = skillchainEffect:getTier()
    if skillchainLevel < 1 or skillchainLevel > 3 then
        return 0
    end

    local skillchainCount = skillchainEffect:getSubPower()
    if skillchainCount < 1 or skillchainCount > 6 then
        return 0
    end

    local skillchainElement = getSkillchainElementToUse(target, skillchainType)
    if not skillchainElement then
        return 0
    end

    if xi.spells.damage.calculateNullification(target, skillchainElement, false, true, false, false) == 0 then
        return 0
    end

    -- Skillchains could be resisted before the June 2014 adjustment.
    -- Source: https://forum.square-enix.com/ffxi/threads/42614
    -- Calculate resist, base damage and multipliers.
    local finalDamage          = math.abs(baseDamage) -- Damage from skillchain, no matter if absorbed or not.
    local levelMultiplier      = chainMultipliers[skillchainLevel][skillchainCount]
    local dayWeatherMultiplier = xi.spells.damage.calculateDayAndWeather(actor, skillchainElement, false)
    local staffMultiplier      = xi.spells.damage.calculateElementalStaffBonus(actor, skillchainElement)
    local resistRate           = xi.combat.magicHitRate.calculateResistRate(actor, target, { magicalElement = skillchainElement, skillRank = xi.skillRank.A_PLUS })
    local magicTakenMultiplier = xi.combat.damage.calculateDamageAdjustment(target, false, true, false, false)
    local absorptionMultiplier = xi.spells.damage.calculateAbsorption(target, skillchainElement, false, true, false, false)

    -- Apply multipliers in order and floor after each step.
    finalDamage = math.floor(finalDamage * levelMultiplier)
    finalDamage = math.floor(finalDamage * dayWeatherMultiplier)
    finalDamage = math.floor(finalDamage * staffMultiplier)
    finalDamage = math.floor(finalDamage * resistRate)
    finalDamage = math.floor(finalDamage * magicTakenMultiplier)
    finalDamage = math.floor(finalDamage * absorptionMultiplier)

    -- Handle other damage alterations.
    if finalDamage > 0 then
        finalDamage = utils.clamp(utils.handlePhalanx(target, finalDamage), 0, 99999)
        finalDamage = utils.clamp(utils.handleStoneskin(target, finalDamage), 0, 99999)
        finalDamage = target:checkDamageCap(finalDamage)

        target:takeDamage(finalDamage, actor, xi.attackType.SPECIAL, xi.damageType.ELEMENTAL + skillchainElement)

    -- Handle absorption.
    else
        target:addHP(-finalDamage)
    end

    return finalDamage
end
