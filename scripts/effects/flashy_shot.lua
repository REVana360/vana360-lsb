-----------------------------------
-- xi.effect.FLASHY_SHOT
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    -- Flashy Shot ignored level-difference penalties before June 2015.
    -- Source: https://forum.square-enix.com/ffxi/threads/47481-Jun-25-2015-%28JST%29-Version-Update
    effect:addMod(xi.mod.ENMITY, 50)
    effect:addMod(xi.mod.RA_IGNORE_LVL_DIFF, 1)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
