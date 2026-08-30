-----------------------------------
-- xi.effect.SPIRIT_SURGE
-----------------------------------
---@type TEffect
local effectObject = {}

-- https://www.bg-wiki.com/ffxi/Spirit_Surge
-- Haste and stat behavior source: https://www.bg-wiki.com/ffxi/Version_Update_(02/13/2012)
-- Master attack and defense removal source: https://forum.square-enix.com/ffxi/threads/44090-Sep-9-2014-%28JST%29-Version-Update

effectObject.onEffectGain = function(target, effect)
    -- The dragoon's MAX HP increases by % of wyvern MaxHP
    effect:addMod(xi.mod.HP, effect:getPower())
    target:updateHealth()

    -- The dragoon gets a Strength boost relative to his level
    effect:addMod(xi.mod.STR, effect:getSubPower())

    -- The dragoon gets a 50 Accuracy boost
    effect:addMod(xi.mod.ACC, 50)

    -- July 2009 uses magic haste, without master-stat or job-point bonuses.
    effect:addMod(xi.mod.HASTE_MAGIC, 2500)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
end

return effectObject
