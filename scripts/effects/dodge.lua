-----------------------------------
-- xi.effect.DODGE
-- Note: Glanzfaust bonus is implemented as a latent effect while wearing the equipment and having the effect
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    local bonusPower = effect:getPower()

    effect:addMod(xi.mod.EVA, 20 + bonusPower)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
