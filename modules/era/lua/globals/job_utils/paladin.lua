-----------------------------------
-- Module: Paladin Job Adjustments
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('era_job_utils_paladin')

-- Shield Bash: Remove shield size damage bonuses and job point additions
-- TODO: find a patch note or source for this change
m:addOverrideByEra('xi.job_utils.paladin.useShieldBash', {
    [xi.expansion.ABYSSEA] = function(player, target, ability)
        local damage = math.floor(player:getMainLvl() * 0.28)

        -- Main job factors
        if player:getMainJob() ~= xi.job.PLD then
            damage = math.floor(damage / 2.5)
        else
            damage = math.floor(damage)
        end

        damage = damage + player:getMod(xi.mod.SHIELD_BASH)

        -- Apply stun effect
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
                target:addStatusEffect(xi.effect.STUN, { power = 1, duration = math.randomInt(2, 8) * resistanceRate, origin = player })
            end
        end

        -- Randomize damage
        local randomizer = 1 + (math.randomInt(1, 5) / 100)

        damage = damage * randomizer
        damage = utils.handleStoneskin(target, damage)

        target:takeDamage(damage, player, xi.attackType.PHYSICAL, xi.damageType.BLUNT)
        target:updateEnmityFromDamage(player, damage)
        ability:setMsg(xi.msg.basic.JA_DAMAGE)

        return damage
    end,
})
