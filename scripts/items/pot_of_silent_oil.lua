-----------------------------------
-- ID: 4165
-- Silent oil
-- This lubricant cuts down 99.99% of all friction
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemCheck = function(target, item, caster)
    return 0
end

-- Restored to the duration used before the December 7, 2010 adjustment.
-- Source: https://www.playonline.com/pcd/verup/ff11/detail/6024/detail.html
itemObject.onItemUse = function(target, user)
    if not target:hasStatusEffect(xi.effect.SNEAK) then
        target:addStatusEffect(xi.effect.SNEAK, { power = 1, duration = math.floor(math.random(90, 360) * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER), origin = user, tick = 10 })
    end
end

return itemObject
