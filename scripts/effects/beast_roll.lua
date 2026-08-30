-----------------------------------
-- xi.effect.BEAST_ROLL
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- July 2009: Beast Roll granted pet attack. Pet ranged attack was added in 2015.
    -- Source: https://forum.square-enix.com/ffxi/threads/20744?p=278735#post278735
    target:addPetMod(xi.mod.ATTP, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:delPetMod(xi.mod.ATTP, effect:getPower())
    xi.job_utils.corsair.onRollEffectLose(target, effect)
end

return effectObject
