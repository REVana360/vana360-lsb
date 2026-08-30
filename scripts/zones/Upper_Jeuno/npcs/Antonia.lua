-----------------------------------
-- Area: Upper Jeuno
--  NPC: Antonia
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.MYTHRIL_ROD,   6256 },
        { xi.item.OAK_CUDGEL,   11232 },
        { xi.item.MYTHRIL_MACE, 18048 },
        { xi.item.WARHAMMER,     6558 },
        { xi.item.OAK_POLE,     37440 },
        { xi.item.HALBERD,      44550 },
        { xi.item.SCYTHE,       10596 },
        { xi.item.IRON_ARROW,      10 },
    }

    player:showText(npc, zones[xi.zone.UPPER_JEUNO].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
