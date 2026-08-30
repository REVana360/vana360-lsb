-----------------------------------
-- xi.effect.DRACHEN_ROLL
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- July 2009: Drachen Roll granted pet magic attack and magic accuracy.
    -- Source: https://forum.square-enix.com/ffxi/threads/20744?p=278735#post278735
    target:addPetMod(xi.mod.MATT, effect:getPower())
    target:addPetMod(xi.mod.MACC, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:delPetMod(xi.mod.MATT, effect:getPower())
    target:delPetMod(xi.mod.MACC, effect:getPower())
    xi.job_utils.corsair.onRollEffectLose(target, effect)
end

return effectObject
