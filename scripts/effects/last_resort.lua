-----------------------------------
-- xi.effect.LAST_RESORT
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    local targetMerit = target:getMerit(xi.merit.LAST_RESORT_EFFECT)

    -- Last Resort's attack bonus and defense penalty increased from 15% to 25% in May 2015.
    -- Source: https://forum.square-enix.com/ffxi/threads/46976-May-14-2015-%28JST%29-Version-Update
    effect:addMod(xi.mod.ATTP, 15 + targetMerit)
    effect:addMod(xi.mod.RATTP, 15 + targetMerit)
    effect:addMod(xi.mod.DEFP, -15 - targetMerit)

    effect:addMod(xi.mod.TWOHAND_HASTE_ABILITY, target:getMod(xi.mod.DESPERATE_BLOWS) + target:getMerit(xi.merit.DESPERATE_BLOWS))
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
