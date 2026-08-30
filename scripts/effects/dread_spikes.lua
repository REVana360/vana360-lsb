-----------------------------------
-- xi.effect.DREAD_SPIKES
-----------------------------------
---@type TEffect
local effectObject = {}

-- Source: https://forum.square-enix.com/ffxi/threads/48564-Sep-16-2015-%28JST%29-Version-Update
effectObject.onEffectGain = function(target, effect)
    target:addMod(xi.mod.SPIKES, 3)
    effect:setDuration(60000)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    target:delMod(xi.mod.SPIKES, 3)
end

return effectObject
