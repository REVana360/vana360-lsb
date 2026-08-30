-----------------------------------
-- xi.effect.ANCIENT_CIRCLE
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- Ancient Circle's job-point resistance bonus was added later.
    -- Source: https://www.bg-wiki.com/ffxi/Version_Update_(02/13/2012)
    effect:addMod(xi.mod.DRAGON_KILLER, effect:getPower())
    effect:addMod(xi.mod.DRAGON_DMG_MULTIPLIER, effect:getPower())
    effect:addMod(xi.mod.DRAGON_RES_MULTIPLIER, effect:getPower())
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
