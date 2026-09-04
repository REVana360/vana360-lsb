-----------------------------------
-- Area: Southern San d'Oria
--  NPC: Cletae
-- Guild Merchant NPC: Leathercrafting Guild
-- !pos -189.142 -8.800 14.449 230
-----------------------------------
local ID = zones[xi.zone.SOUTHERN_SAN_DORIA]
-----------------------------------
---@type TNpcEntity
local entity = {}

local july2009Stock =
{
    { xi.item.TANNING_VAT,        75, xi.craftRank.AMATEUR    },
    { xi.item.SHEEPSKIN,         100, xi.craftRank.AMATEUR    },
    { xi.item.RABBIT_HIDE,        80, xi.craftRank.AMATEUR    },
    { xi.item.LIZARD_SKIN,       600, xi.craftRank.RECRUIT    },
    { xi.item.KARAKUL_SKIN,      600, xi.craftRank.RECRUIT    },
    { xi.item.WOLF_HIDE,         600, xi.craftRank.RECRUIT    },
    { xi.item.DHALMEL_HIDE,     2400, xi.craftRank.INITIATE   },
    { xi.item.BUGARD_SKIN,      2500, xi.craftRank.INITIATE   },
    { xi.item.RAM_SKIN,         1500, xi.craftRank.NOVICE     },
    { xi.item.BUFFALO_HIDE,    16000, xi.craftRank.APPRENTICE },
    { xi.item.RAPTOR_SKIN,      3000, xi.craftRank.JOURNEYMAN },
    { xi.item.CATOBLEPAS_HIDE,  2500, xi.craftRank.JOURNEYMAN },
    { xi.item.SMILODON_HIDE,    3000, xi.craftRank.CRAFTSMAN  },
    { xi.item.COCKATRICE_SKIN,  3000, xi.craftRank.CRAFTSMAN  },
}

entity.onTrade = function(player, npc, trade)
    -- Flyers_For_Regine needs to be reviewed.
    local flyerForRegine = player:getQuestStatus(xi.questLog.SANDORIA, xi.quest.id.sandoria.FLYERS_FOR_REGINE)

    if flyerForRegine == 1 then
        if npcUtil.tradeHasExactly(trade, xi.item.MAGICMART_FLYER) then
            player:messageSpecial(ID.text.FLYER_REFUSED)
        end
    end
end

entity.onTrigger = function(player, npc)
    local guildSkillId = xi.skill.LEATHERCRAFT
    xi.shop.generalGuild(player, july2009Stock, guildSkillId)
    player:showText(npc, ID.text.CLETAE_DIALOG)
end

return entity
