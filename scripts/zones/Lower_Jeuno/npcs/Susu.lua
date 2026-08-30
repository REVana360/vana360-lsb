-----------------------------------
-- Area: Lower Jeuno
--  NPC: Susu
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_BANISHGA_II,  20000 },
        { xi.item.SCROLL_OF_BARBLIND,      2030 },
        { xi.item.SCROLL_OF_BARBLINDRA,    2030 },
        { xi.item.SCROLL_OF_BARPARALYZE,    780 },
        { xi.item.SCROLL_OF_BARPALARYZRA,   780 },
        { xi.item.SCROLL_OF_BARPOISON,      400 },
        { xi.item.SCROLL_OF_BARPOISONRA,    400 },
        { xi.item.SCROLL_OF_BARSILENCE,    4608 },
        { xi.item.SCROLL_OF_BARSILENCERA,  4608 },
        { xi.item.SCROLL_OF_BARSLEEP,       244 },
        { xi.item.SCROLL_OF_BARSLEEPRA,     244 },
        { xi.item.SCROLL_OF_CURSNA,        8586 },
        { xi.item.SCROLL_OF_HOLY,         35000 },
        { xi.item.SCROLL_OF_SILENA,        2330 },
        { xi.item.SCROLL_OF_STONA,        19200 },
        { xi.item.SCROLL_OF_VIRUNA,       13300 },
    }

    player:showText(npc, zones[xi.zone.LOWER_JEUNO].text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
