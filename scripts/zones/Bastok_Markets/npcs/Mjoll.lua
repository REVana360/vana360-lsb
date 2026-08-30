-----------------------------------
-- Area: Batok Markets
--  NPC: Mjoll
-- !pos -318.902 -10.319 -178.087 235
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.WOODEN_ARROW,                4, 2 },
        { xi.item.IRON_ARROW,                  8, 3 },
        { xi.item.SILVER_ARROW,               17, 1 },
        { xi.item.SCROLL_OF_DARK_THRENODY,   217, 3 },
        { xi.item.SCROLL_OF_ICE_THRENODY,   1088, 3 },
    }

    player:showText(npc, zones[xi.zone.BASTOK_MARKETS].text.MJOLL_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end

return entity
