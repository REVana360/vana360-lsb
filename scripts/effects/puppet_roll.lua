-----------------------------------
-- xi.effect.PUPPET_ROLL
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- July 2009: Puppet Roll granted pet accuracy and ranged accuracy.
    -- Source: https://forum.square-enix.com/ffxi/threads/20744?p=278735#post278735
    target:addPetMod(xi.mod.ACC, effect:getPower())
    target:addPetMod(xi.mod.RACC, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:delPetMod(xi.mod.ACC, effect:getPower())
    target:delPetMod(xi.mod.RACC, effect:getPower())
    xi.job_utils.corsair.onRollEffectLose(target, effect)
end

return effectObject
