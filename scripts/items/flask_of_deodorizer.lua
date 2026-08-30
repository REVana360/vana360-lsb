-----------------------------------
-- ID: 4166
-- Deodorizer
-- When applied, this powerful deodorant neutralizes even the strongest of odors!!.
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemCheck = function(target, item, caster)
    return 0
end

-- Restored to the duration used before the December 7, 2010 adjustment.
-- Source: https://www.playonline.com/pcd/verup/ff11/detail/6024/detail.html
itemObject.onItemUse = function(target, user)
    if  not target:hasStatusEffect(xi.effect.DEODORIZE) then
        target:addStatusEffect(xi.effect.DEODORIZE, { power = 1, duration = math.random(90, 360), origin = user, tick = 10 })
    else
        target:messageBasic(xi.msg.basic.NO_EFFECT)
    end
end

return itemObject
