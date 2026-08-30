-----------------------------------
-- xi.effect.GALLANTS_ROLL
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- July 2009: Gallant's Roll reflected physical damage taken.
    -- Source: https://forum.square-enix.com/ffxi/threads/20744?p=278735#post278735
    effect:addMod(xi.mod.SPIKES, xi.subEffect.BLAZE_SPIKES)
    target:addListener('TAKE_DAMAGE', 'GALLANTS_ROLL_REFLECT', function(entity, amount, attacker, attackType, damageType)
        if
            amount > 0 and
            attackType == xi.attackType.PHYSICAL
        then
            entity:setMod(xi.mod.SPIKES_DMG, math.floor(amount * effect:getPower() / 100))
        end
    end)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:removeListener('GALLANTS_ROLL_REFLECT')
    target:setMod(xi.mod.SPIKES_DMG, 0)
    xi.job_utils.corsair.onRollEffectLose(target, effect)
end

return effectObject
