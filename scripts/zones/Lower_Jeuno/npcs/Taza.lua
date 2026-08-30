-----------------------------------
-- Area: Lower Jeuno
--  NPC: Taza
--  Basic lua script is kept for utilization in the lower_jeuno_vendors module
-----------------------------------
local ID = zones[xi.zone.LOWER_JEUNO]
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_SLEEPGA,       10304 },
        { xi.item.SCROLL_OF_SHELL_III,     26244 },
        { xi.item.SCROLL_OF_PROTECTRA_III, 19200 },
        { xi.item.SCROLL_OF_SHELLRA_II,    14080 },
        { xi.item.SCROLL_OF_SHELLRA_III,   26244 },
        { xi.item.SCROLL_OF_BARPETRIFY,    15120 },
        { xi.item.SCROLL_OF_BARVIRUS,       9600 },
        { xi.item.SCROLL_OF_BARPETRA,      15120 },
        { xi.item.SCROLL_OF_BARVIRA,        9600 },
        { xi.item.SCROLL_OF_SLEEP_II,      18720 },
        { xi.item.SCROLL_OF_STONE_III,     19932 },
        { xi.item.SCROLL_OF_WATER_III,     22682 },
        { xi.item.SCROLL_OF_AERO_III,      27744 },
        { xi.item.SCROLL_OF_FIRE_III,      33306 },
        { xi.item.SCROLL_OF_BLIZZARD_III,  39368 },
        { xi.item.SCROLL_OF_THUNDER_III,   45930 },
    }

    player:showText(npc, ID.text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
