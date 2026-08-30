-----------------------------------
-- Area: Bastok Markets
--  NPC: Ciqala
-- Type: Merchant
-- !pos -283.147 -11.319 -143.680 235
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.BRONZE_KNUCKLES,   244, 3 },
        { xi.item.BRASS_KNUCKLES,    900, 2 },
        { xi.item.METAL_KNUCKLES,   5188, 1 },
        { xi.item.BATTLEAXE,       12150, 1 },
        { xi.item.GREATAXE,         4732, 1 },
        { xi.item.BRONZE_HAMMER,     340, 3 },
        { xi.item.BRASS_HAMMER,     2315, 2 },
        { xi.item.WARHAMMER,        6496, 1 },
        { xi.item.BRONZE_AXE,        328, 3 },
        { xi.item.BRASS_AXE,        1622, 2 },
        { xi.item.BUTTERFLY_AXE,     698, 2 },
        { xi.item.MAPLE_WAND,         51, 3 },
        { xi.item.ASH_STAFF,          64, 3 },
    }

    player:showText(npc, zones[xi.zone.BASTOK_MARKETS].text.CIQALA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end

return entity
