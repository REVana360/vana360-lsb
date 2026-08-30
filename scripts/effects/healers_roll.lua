-----------------------------------
-- xi.effect.HEALERS_ROLL
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- July 2009: Healer's Roll restored MP over time, not cure potency.
    -- Source: https://forum.square-enix.com/ffxi/threads/20744?p=278735#post278735
    effect:addMod(xi.mod.MPHEAL, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    xi.job_utils.corsair.onRollEffectLose(target, effect)
end

return effectObject
