-----------------------------------
-- Area: Southern San d'Oria
--  NPC: Nokkhi Jinjahl
-- Type: Travelling Merchant NPC / NPC Quiver Maker / San d'Oria 1st Place
-- !pos 23 2 -13 230
-----------------------------------
local ID = zones[xi.zone.SOUTHERN_SAN_DORIA]
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrade = function(player, npc, trade)
    local bundleList =
    {
        { xi.item.BEETLE_ARROW,        xi.item.BEETLE_QUIVER             },
        { xi.item.DEMON_ARROW,         xi.item.DEMON_QUIVER              },
        { xi.item.HORN_ARROW,          xi.item.HORN_QUIVER               },
        { xi.item.IRON_ARROW,          xi.item.IRON_QUIVER               },
        { xi.item.KABURA_ARROW,        xi.item.KABURA_QUIVER             },
        { xi.item.SCORPION_ARROW,      xi.item.SCORPION_QUIVER           },
        { xi.item.SILVER_ARROW,        xi.item.SILVER_QUIVER             },
        { xi.item.SLEEP_ARROW,         xi.item.SLEEP_QUIVER              },
        { xi.item.STONE_ARROW,         xi.item.STONE_QUIVER              },

        { xi.item.ACID_BOLT,           xi.item.ACID_BOLT_QUIVER          },
        { xi.item.BLIND_BOLT,          xi.item.BLIND_BOLT_QUIVER         },
        { xi.item.BLOODY_BOLT,         xi.item.BLOODY_BOLT_QUIVER        },
        { xi.item.DARKSTEEL_BOLT,      xi.item.DARKSTEEL_BOLT_QUIVER     },
        { xi.item.HOLY_BOLT,           xi.item.HOLY_BOLT_QUIVER          },
        { xi.item.MYTHRIL_BOLT,        xi.item.MYTHRIL_BOLT_QUIVER       },
        { xi.item.SLEEP_BOLT,          xi.item.SLEEP_BOLT_QUIVER         },
        { xi.item.VENOM_BOLT,          xi.item.VENOM_BOLT_QUIVER         },

        { xi.item.BULLET,              xi.item.BULLET_POUCH              },
        { xi.item.BRONZE_BULLET,       xi.item.BRONZE_BULLET_POUCH       },
        { xi.item.IRON_BULLET,         xi.item.IRON_BULLET_POUCH         },
        { xi.item.SILVER_BULLET,       xi.item.SILVER_BULLET_POUCH       },
        { xi.item.STEEL_BULLET,        xi.item.STEEL_BULLET_POUCH        },
        { xi.item.SPARTAN_BULLET,      xi.item.SPARTAN_BULLET_POUCH      },

        { xi.item.FIRE_CARD,           xi.item.FIRE_CARD_CASE            },
        { xi.item.ICE_CARD,            xi.item.ICE_CARD_CASE             },
        { xi.item.WIND_CARD,           xi.item.WIND_CARD_CASE            },
        { xi.item.EARTH_CARD,          xi.item.EARTH_CARD_CASE           },
        { xi.item.THUNDER_CARD,        xi.item.THUNDER_CARD_CASE         },
        { xi.item.WATER_CARD,          xi.item.WATER_CARD_CASE           },
        { xi.item.LIGHT_CARD,          xi.item.LIGHT_CARD_CASE           },
        { xi.item.DARK_CARD,           xi.item.DARK_CARD_CASE            },
    }

    local carnationsNeeded = 0
    local giveToPlayer = {}

    -- check for invalid items
    for i = 0, 8, 1 do
        local itemId = trade:getItemId(i)
        if itemId > 0 and itemId ~= 948 then
            local validSlot = false
            for k, v in pairs(bundleList) do
                if v[1] == itemId then
                    local itemQty = trade:getSlotQty(i)
                    if itemQty % 99 ~= 0 then
                        player:messageSpecial(ID.text.NOKKHI_BAD_COUNT)
                        return
                    end

                    local stacks = itemQty / 99
                    carnationsNeeded = carnationsNeeded + stacks
                    giveToPlayer[#giveToPlayer + 1] = { v[2], stacks }
                    validSlot = true
                    break
                end
            end

            if not validSlot then
                player:messageSpecial(ID.text.NOKKHI_BAD_ITEM)
                return
            end
        end
    end

    -- check for correct number of carnations
    if
        carnationsNeeded == 0 or
        trade:getItemQty(xi.item.CARNATION) ~= carnationsNeeded
    then
        player:messageSpecial(ID.text.NOKKHI_BAD_COUNT)
        return
    end

    -- check for enough inventory space
    if player:getFreeSlotsCount() < carnationsNeeded then
        player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, giveToPlayer[1][1])
        return
    end

    -- make the trade
    player:messageSpecial(ID.text.NOKKHI_GOOD_TRADE)
    for k, v in pairs(giveToPlayer) do
        player:addItem(v[1], v[2])
        player:messageSpecial(ID.text.ITEM_OBTAINED, v[1])
    end

    player:tradeComplete()
end

entity.onTrigger = function(player, npc)
    player:startEvent(683, npc:getID())
end

return entity
