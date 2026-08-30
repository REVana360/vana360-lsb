-----------------------------------
-- xi.effect.RAMPART
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    effect:addMod(xi.mod.DEF, effect:getSubPower())

    -- Iron will trait and augment. TODO: Why player only?
    if target:isPC() and target:hasTrait(xi.trait.IRON_WILL) then
        effect:addMod(xi.mod.SPELLINTERRUPT, target:getMerit(xi.merit.IRON_WILL))

        if target:getMod(xi.mod.ENHANCES_IRON_WILL) > 0 then
            effect:addMod(xi.mod.FASTCAST, target:getMod(xi.mod.ENHANCES_IRON_WILL) * target:getMerit(xi.merit.IRON_WILL) / 19)
        end
    end
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
