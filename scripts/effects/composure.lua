-----------------------------------
-- xi.effect.COMPOSURE
-- Increases accuracy and lengthens recast time. Enhancement effects gained through white
-- and black magic you cast on yourself last longer.
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- Accuracy scaled at one point per five levels before the February 2019 adjustment.
    -- Source: https://forum.square-enix.com/ffxi/threads/55025-February.-8-2019-%28JST%29-Version-Update
    local power = math.floor(target:getMainLvl() / 5)

    effect:addMod(xi.mod.ACC, power)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
