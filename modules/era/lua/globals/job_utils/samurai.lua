-----------------------------------
-- Module: Samurai Job Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('era_job_utils_samurai', xi.pre(xi.expansion.ABYSSEA))

-- Blade Bash: Apply merit recast reduction, remove extra plague duration from merits
-- TODO: find a patch note or source for this change
m:addOverride('xi.job_utils.samurai.useBladeBash', function(player, target, ability, action)
    local recastReduction = player:getMerit(xi.merit.BLADE_BASH) - 150
    action:setRecast(action:getRecast() - recastReduction)

    -- Damage
    -- TODO: Verify damage formula and DRK interaction
    local jobLevel = utils.getActiveJobLevel(player, xi.job.DRK)
    local damage   = math.floor((jobLevel + 11) / 4 + player:getMod(xi.mod.WEAPON_BASH))
    damage = utils.handleStoneskin(target, damage)
    target:takeDamage(damage, player, xi.attackType.PHYSICAL, xi.damageType.BLUNT)
    target:updateEnmityFromDamage(player, damage)

    -- Stun
    if
        not xi.data.statusEffect.isTargetImmune(target, xi.effect.STUN, xi.element.THUNDER) and
        not xi.data.statusEffect.isTargetResistant(player, target, xi.effect.STUN) and
        not xi.data.statusEffect.isEffectNullified(target, xi.effect.STUN, 0)
    then
        local maccParams =
        {
            effectId       = xi.effect.STUN,
            magicalElement = xi.element.THUNDER,
            skillRank      = xi.skillRank.A_PLUS,
            actorStat      = xi.mod.INT,
        }

        local resistanceRate = xi.combat.magicHitRate.calculateResistRate(player, target, maccParams)
        if xi.data.statusEffect.isResistRateSuccessfull(xi.effect.STUN, resistanceRate, 0) then
            target:addStatusEffect(xi.effect.STUN, { power = 1, duration = 6 * resistanceRate, origin = player })
        end
    end

    -- Plague
    if
        not xi.data.statusEffect.isTargetImmune(target, xi.effect.PLAGUE, xi.element.FIRE) and
        not xi.data.statusEffect.isTargetResistant(player, target, xi.effect.PLAGUE) and
        not xi.data.statusEffect.isEffectNullified(target, xi.effect.PLAGUE, 0)
    then
        local maccParams =
        {
            effectId       = xi.effect.PLAGUE,
            magicalElement = xi.element.FIRE,
            skillRank      = xi.skillRank.A_PLUS,
            actorStat      = xi.mod.INT,
        }

        local resistanceRate = xi.combat.magicHitRate.calculateResistRate(player, target, maccParams)
        if xi.data.statusEffect.isResistRateSuccessfull(xi.effect.PLAGUE, resistanceRate, 0) then
            target:addStatusEffect(xi.effect.PLAGUE, { power = 5, duration = 15 * resistanceRate, origin = player })
        end
    end

    -- Animation
    local animationTable =
    {
        -- [weapon type] = animation ID
        [xi.skill.GREAT_SWORD ] = 201,
        [xi.skill.GREAT_KATANA] = 201,
        [xi.skill.GREAT_AXE   ] = 202,
        [xi.skill.SCYTHE      ] = 202,
        [xi.skill.STAFF       ] = 202,
        [xi.skill.POLEARM     ] = 203,
    }

    local animation = animationTable[player:getWeaponSkillType(xi.slot.MAIN)] or 0
    action:setAnimation(target:getID(), animation)

    ability:setMsg(xi.msg.basic.JA_DAMAGE)

    return damage
end)

-- Hasso: Remove Zanshin bonus
-- TODO: find a patch note or source for this change
m:addOverride('xi.effects.hasso.onEffectGain', function(target, effect)
    effect:addMod(xi.mod.TWOHAND_STR, effect:getPower())
    effect:addMod(xi.mod.TWOHAND_HASTE_ABILITY, 1000)
    effect:addMod(xi.mod.TWOHAND_ACC, 10)
end)

-- Seigan: Remove Zanshin-based counter bonus
-- TODO: find a patch note or source for this change
m:addOverride('xi.effects.seigan.onEffectGain', function(target, effect)
    local jpValue = target:getJobPointLevel(xi.jp.SEIGAN_EFFECT)

    effect:addMod(xi.mod.DEF, jpValue * 3)
end)
