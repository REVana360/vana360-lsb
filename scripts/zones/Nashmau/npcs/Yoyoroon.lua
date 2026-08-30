-----------------------------------
-- Area: Nashmau
--  NPC: Yoyoroon
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.TENSION_SPRING,       4940 },
        { xi.item.LOUDSPEAKER,          4940 },
        { xi.item.ACCELERATOR,          4940 },
        { xi.item.ARMOR_PLATE,          4940 },
        { xi.item.STABILIZER,           4940 },
        { xi.item.MANA_JAMMER,          4940 },
        { xi.item.AUTO_REPAIR_KIT,      4940 },
        { xi.item.MANA_TANK,            4940 },
        { xi.item.INHIBITOR,            9925 },
        { xi.item.MANA_BOOSTER,         9925 },
        { xi.item.SCOPE,                9925 },
        { xi.item.SHOCK_ABSORBER,       9925 },
        { xi.item.VOLT_GUN,             9925 },
        { xi.item.STEALTH_SCREEN,       9925 },
        { xi.item.DAMAGE_GAUGE,         9925 },
        { xi.item.MANA_CONSERVER,       9925 },
    }

    player:showText(npc, zones[xi.zone.NASHMAU].text.YOYOROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
