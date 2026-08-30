-----------------------------------
-- Area: Lower Jeuno
--  NPC: Creepstix
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_GOBLIN_GAVOTTE,   8160 },
        { xi.item.SCROLL_OF_PROTECTRA_II  ,   7074 },
        { xi.item.SCROLL_OF_SHELLRA,          1760 },
    }

    player:showText(npc, zones[xi.zone.LOWER_JEUNO].text.JUNK_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
