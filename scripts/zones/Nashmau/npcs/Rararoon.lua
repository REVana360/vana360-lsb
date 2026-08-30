-----------------------------------
-- Area: Nashmau
--  NPC: Rararoon
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local ID = zones[xi.zone.NASHMAU]

    -- Must have PUP30+ to get access to the shop
    if player:getJobLevel(xi.job.PUP) < 30 then
        player:showText(npc, ID.text.RARAROON_SHOP_CLOSED)
        return
    end

    local stock =
    {
        { xi.item.REACTIVE_SHIELD,     222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.TENSION_SPRING_IV,   112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.HEAT_CAPACITOR_II,   112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.TRANQUILIZER,        222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.TRANQUILIZER_II,     100776, { job = xi.job.PUP, level = 99 } },
        { xi.item.LOUDSPEAKER_IV,      112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.TRANQUILIZER_III,    112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.AMPLIFIER_II,        112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.TURBO_CHARGER,       222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.ACCELERATOR_IV,      112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.SCOPE_III,           112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.SCHURZEN,            222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.SHOCK_ABSORBER_II,   100776, { job = xi.job.PUP, level = 90 } },
        { xi.item.ARMOR_PLATE_IV,      112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.SHOCK_ABSORBER_III,  112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.DYNAMO,              222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.COILER,              185250, { job = xi.job.PUP, level = 80 } },
        { xi.item.COILER_II,           100776, { job = xi.job.PUP, level = 99 } },
        { xi.item.DYNAMO_II,           100776, { job = xi.job.PUP, level = 90 } },
        { xi.item.STABILIZER_IV,       112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.DYNAMO_III,          112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.CONDENSER,           222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.STEAM_JACKET,        185250, { job = xi.job.PUP, level = 80 } },
        { xi.item.RESISTER_II,          88920, { job = xi.job.PUP, level = 80 } },
        { xi.item.MANA_JAMMER_IV,      112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.OPTIC_FIBER,         222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.AUTO_REPAIR_KIT_III,  88920, { job = xi.job.PUP, level = 80 } },
        { xi.item.AUTO_REPAIR_KIT_IV,  112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.ARCANIC_CELL_II,      88920, { job = xi.job.PUP, level = 80 } },
        { xi.item.ECONOMIZER,          222300, { job = xi.job.PUP, level = 80 } },
        { xi.item.MANA_TANK_III,        88920, { job = xi.job.PUP, level = 80 } },
        { xi.item.REGULATOR,           112632, { job = xi.job.PUP, level = 99 } },
        { xi.item.MANA_TANK_IV,        112632, { job = xi.job.PUP, level = 99 } },
    }

    player:showText(npc, ID.text.RARAROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end

return entity
