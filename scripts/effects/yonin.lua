-----------------------------------
-- xi.effect.YONIN
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect) -- power = 30 initially
    effect:addMod(xi.mod.ACC, -effect:getPower())
    effect:addMod(xi.mod.NINJA_TOOL, effect:getPower())
    effect:addMod(xi.mod.ENMITY, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
    -- Tick down the effect and reduce the overall power.
    effect:setPower(effect:getPower() - 1)
    effect:addMod(xi.mod.ACC, 1)
    effect:addMod(xi.mod.NINJA_TOOL, -1)
    effect:addMod(xi.mod.ENMITY, -1)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
