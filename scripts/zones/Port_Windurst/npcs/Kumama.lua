-----------------------------------
-- Area: Port Windurst
--  NPC: Kumama
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.BRAIS,              2110, 3 },
        { xi.item.SLOPS,               192, 3 },
        { xi.item.LEATHER_TROUSERS,    536, 2 },
        { xi.item.COTTON_BRAIS,      10800, 2 },
        { xi.item.LINEN_SLOPS,        2520, 1 },
        { xi.item.GAITERS,            1410, 3 },
        { xi.item.ASH_CLOGS,           124, 3 },
        { xi.item.LEATHER_HIGHBOOTS,   336, 2 },
        { xi.item.SOLEA,               605, 2 },
        { xi.item.COTTON_GAITERS,     7208, 2 },
        { xi.item.HOLLY_CLOGS,        1625, 1 },
        { xi.item.LAUAN_SHIELD,        120, 3 },
        { xi.item.MAPLE_SHIELD,        605, 2 },
        { xi.item.MAHOGANY_SHIELD,    4980, 1 },
    }

    player:showText(npc, zones[xi.zone.PORT_WINDURST].text.KUMAMA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end

return entity
