-----------------------------------
-- xi.effect.WEIGHT
-----------------------------------
---@type TEffect
local effectObject = {}

-- Source: https://forum.square-enix.com/ffxi/threads/43135-Jul-8-2014-(JST)-Version-Update
effectObject.onEffectGain = function(target, effect)
    effect:addMod(xi.mod.MOVE_SPEED_WEIGHT_PENALTY, effect:getPower())
    effect:addMod(xi.mod.EVA, -10)

    -- Immunobreak reset.
    target:setMod(xi.mod.GRAVITY_IMMUNOBREAK, 0)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
