-----------------------------------
-- Area: Upper Jeuno
--  NPC: Coumuna
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.MYTHRIL_CLAWS,    29760 },
        { xi.item.KATARS,           15488 },
        { xi.item.MYTHRIL_KNIFE,    14560 },
        { xi.item.KRIS,             12096 },
        { xi.item.MYTHRIL_DEGEN,    31000 },
        { xi.item.KNIGHTS_SWORD,    85250 },
        { xi.item.TWO_HANDED_SWORD, 13926 },
        { xi.item.GREATAXE,          4550 },
    }

    player:showText(npc, zones[xi.zone.UPPER_JEUNO].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
