-----------------------------------
-- xi.effect.BUST
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    if effect:getSubType() == xi.mod.DMG then
        target:addMod(xi.mod.DMG, effect:getPower())
    else
        if effect:getSubType() == xi.mod.ACC then
            target:addMod(xi.mod.RACC, -effect:getPower())
        elseif effect:getSubType() == xi.mod.ATTP then
            target:addMod(xi.mod.RATTP, -effect:getPower())
        -- July pet-roll bust ownership remains unproven; keep the bust on the
        -- rolled entity. Pet-only roll entries use xi.mod.NONE for bustMod.
        end

        target:addMod(effect:getSubType(), -effect:getPower())
    end
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    if effect:getSubType() == xi.mod.DMG then
        target:delMod(xi.mod.DMG, effect:getPower())
    else
        if effect:getSubType() == xi.mod.ACC then
            target:delMod(xi.mod.RACC, -effect:getPower())
        elseif effect:getSubType() == xi.mod.ATTP then
            target:delMod(xi.mod.RATTP, -effect:getPower())
        -- July pet-roll bust ownership remains unproven; keep the bust on the
        -- rolled entity. Pet-only roll entries use xi.mod.NONE for bustMod.
        end

        target:delMod(effect:getSubType(), -effect:getPower())
    end
end

return effectObject
