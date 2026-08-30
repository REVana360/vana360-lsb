-----------------------------------
-- Area: Port Windurst
--  NPC: Taniko-Maniko
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.CAT_BAGHNAKHS,       116, 2 },
        { xi.item.CESTI,               144, 2 },
        { xi.item.BONE_AXE,           4665, 3 },
        { xi.item.BONE_PICK,          6516, 2 },
        { xi.item.BRONZE_ZAGHNAL,      344, 3 },
        { xi.item.BRASS_ZAGHNAL,      2825, 1 },
        { xi.item.HARPOON,             108, 3 },
        { xi.item.WRAPPED_BOW,        7920, 1 },
        { xi.item.ICE_ARROW,           140, 1 },
        { xi.item.LIGHTNING_ARROW,     140, 1 },
        { xi.item.SELF_BOW,            536, 2 },
        { xi.item.WOODEN_ARROW,          4, 2 },
        { xi.item.HAWKEYE,              61, 2 },
        { xi.item.BOOMERANG,          1750, 2 },
        { xi.item.SHORTBOW,             43, 3 },
        { xi.item.BONE_ARROW,            5, 3 },
    }

    player:showText(npc, zones[xi.zone.PORT_WINDURST].text.TANIKOMANIKO_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end

return entity
