-----------------------------------
-- Area: Lower Jeuno
--  NPC: Hasim
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_CURE_IV,        23400 },
        { xi.item.SCROLL_OF_CURAGA_II,      11200 },
        { xi.item.SCROLL_OF_CURAGA_III,     19932 },
        { xi.item.SCROLL_OF_PROTECT_III,    32000 },
        { xi.item.SCROLL_OF_BARFIRE,         1760 },
        { xi.item.SCROLL_OF_BARBLIZZARD,     3624 },
        { xi.item.SCROLL_OF_BARAERO,          930 },
        { xi.item.SCROLL_OF_BARSTONE,         156 },
        { xi.item.SCROLL_OF_BARTHUNDER,      5754 },
        { xi.item.SCROLL_OF_BARWATER,         360 },
        { xi.item.SCROLL_OF_BARFIRA,         1760 },
        { xi.item.SCROLL_OF_BARBLIZZARA,     3624 },
        { xi.item.SCROLL_OF_BARAERA,          930 },
        { xi.item.SCROLL_OF_BARSTONRA,        156 },
        { xi.item.SCROLL_OF_BARTHUNDRA,      5754 },
        { xi.item.SCROLL_OF_BARWATERA,        360 },
        { xi.item.SCROLL_OF_BARSLEEP,         244 },
    }

    player:showText(npc, zones[xi.zone.LOWER_JEUNO].text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
