-----------------------------------
-- Area: South Gustaberg
--  NPC: qm2 (???)
-- Involved in Quest: Smoke on the Mountain
-- !pos 461.841 -21.515 -580.105 107
-----------------------------------
local ID = zones[xi.zone.SOUTH_GUSTABERG]
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrade = function(player, npc, trade)
    if not npcUtil.tradeMatches(trade, { { xi.item.SLICE_OF_GIANT_SHEEP_MEAT, 1 } }) then
        return
    end

    if player:getCharVar('SouthGustabergCampfire') ~= 0 then
        return player:messageSpecial(ID.text.MEAT_ALREADY_PUT, xi.item.SLICE_OF_GIANT_SHEEP_MEAT)
    end

    player:tradeComplete()

    -- The wait was reduced from one Vana'diel day to one Earth minute in June 2016.
    -- Source: https://forum.square-enix.com/ffxi/threads/50760-Jun.-7-2016-(JST)-Version-Update
    -- Source: https://wiki.ffo.jp/html/8848.html
    player:setCharVar('SouthGustabergCampfire', GetSystemTime() + xi.vanaTime.DAY)

    return player:messageSpecial(ID.text.FIRE_PUT, xi.item.SLICE_OF_GIANT_SHEEP_MEAT)
end

entity.onTrigger = function(player, npc)
    local cookTimer = player:getCharVar('SouthGustabergCampfire')

    -- Retail emits this as speakerless npc text (flag unset, type 6), even while the fire looks out.
    if cookTimer == 0 then
        return player:messageText(npc, ID.text.FIRE_GOOD, false, 6)
    end

    if GetSystemTime() < cookTimer then
        return player:messageSpecial(ID.text.FIRE_LONGER, xi.item.SLICE_OF_GIANT_SHEEP_MEAT)
    end

    if player:getFreeSlotsCount() == 0 then
        return player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, xi.item.GALKAN_SAUSAGE)
    end

    player:setCharVar('SouthGustabergCampfire', 0)
    npcUtil.giveItem(player, xi.item.GALKAN_SAUSAGE, { silent = true })

    return player:messageSpecial(ID.text.FIRE_TAKE, xi.item.GALKAN_SAUSAGE)
end

return entity
