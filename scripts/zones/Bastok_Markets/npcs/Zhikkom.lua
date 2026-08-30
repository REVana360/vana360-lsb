-----------------------------------
-- Area: Bastok Markets
--  NPC: Zhikkom
-- !pos -288.669 -10.319 -135.064 235
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.BRONZE_SWORD,    268, 3 },
        { xi.item.IRON_SWORD,     7920, 2 },
        { xi.item.MYTHRIL_SWORD, 34073, 1 },
        { xi.item.BROADSWORD,    23185, 1 },
        { xi.item.DEGEN,         10224, 3 },
        { xi.item.TUCK,          12754, 1 },
        { xi.item.SAPARA,          776, 3 },
        { xi.item.SCIMITAR,       4525, 2 },
        { xi.item.FALCHION,      67353, 1 },
        { xi.item.BRONZE_KNIFE,    164, 3 },
        { xi.item.KNIFE,          2425, 2 },
        { xi.item.KUKRI,          6151, 1 },
        { xi.item.CAT_BAGHNAKHS,   116, 3 },
    }

    player:showText(npc, zones[xi.zone.BASTOK_MARKETS].text.ZHIKKOM_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end

return entity
