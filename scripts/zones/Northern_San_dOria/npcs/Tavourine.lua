-----------------------------------
-- Area: Northern San d'Oria
--  NPC: Tavourine
-----------------------------------
local ID = zones[xi.zone.NORTHERN_SAN_DORIA]
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.BRONZE_KNIFE,       164, 2 },
        { xi.item.KNIFE,             2425, 1 },
        { xi.item.BRONZE_ROD,         100, 3 },
        { xi.item.BRASS_ROD,          690, 2 },
        { xi.item.ROD,               2652, 1 },
        { xi.item.BRONZE_MACE,        188, 3 },
        { xi.item.MACE,              4848, 2 },
        { xi.item.BRONZE_AXE,         316, 2 },
        { xi.item.CLAYMORE,          2720, 2 },
        { xi.item.MYTHRIL_CLAYMORE, 42000, 1 },
    }

    player:showText(npc, ID.text.TAVOURINE_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.SANDORIA)
end

return entity
