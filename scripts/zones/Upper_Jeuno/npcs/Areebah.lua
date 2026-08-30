-----------------------------------
-- Area: Upper Jeuno
--  NPC: Areebah
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.CHAMOMILE,           130 },
        { xi.item.WIJNRUIT,            120 },
        { xi.item.CARNATION,            60 },
        { xi.item.RED_ROSE,             80 },
        { xi.item.RAIN_LILY,            96 },
        { xi.item.LILAC,               120 },
        { xi.item.AMARYLLIS,           120 },
        { xi.item.MARGUERITE,          120 },
        { xi.item.BAG_OF_FLOWER_SEEDS, 520 },
    }

    player:showText(npc, zones[xi.zone.UPPER_JEUNO].text.MP_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
