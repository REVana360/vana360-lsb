-----------------------------------
-- ID: 4164
-- Prism Powder
-- When applied, it makes things invisible.
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemCheck = function(target, item, caster)
    return 0
end

-- Restored to the duration used before the December 7, 2010 adjustment.
-- Source: https://www.playonline.com/pcd/verup/ff11/detail/6024/detail.html
itemObject.onItemUse = function(target, user)
    if target:hasStatusEffect(xi.effect.INVISIBLE) then
        target:delStatusEffect(xi.effect.INVISIBLE)
    end

    target:addStatusEffect(xi.effect.INVISIBLE, { power = 1, duration = math.floor(math.random(90, 360) * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER), origin = user, tick = 10 })
end

return itemObject
