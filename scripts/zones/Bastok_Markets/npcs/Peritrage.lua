-----------------------------------
-- Area: Bastok Markets
--  NPC: Peritrage
-- !pos -286.985 -10.319 -142.586 235
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.LIGHT_CROSSBOW,   179, 3 },
        { xi.item.CROSSBOW,        2449, 2 },
        { xi.item.ZAMBURAK,       15243, 1 },
        { xi.item.TATHLUM,          320, 1 },
        { xi.item.CROSSBOW_BOLT,      6, 3 },
        { xi.item.MYTHRIL_BOLT,      24, 2 },
    }

    player:showText(npc, zones[xi.zone.BASTOK_MARKETS].text.PERITRAGE_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end

return entity
