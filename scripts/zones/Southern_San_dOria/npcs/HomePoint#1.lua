-----------------------------------
-- Area: Southern San dOria
--  NPC: HomePoint#1
-- !pos -85.468 1.000 -66.454 230
-----------------------------------
local ID = zones[xi.zone.SOUTHERN_SAN_DORIA]
-----------------------------------
---@type TNpcEntity
local entity = {}

local hpEvent = 596
local hpIndex = 0

entity.onTrigger = function(player, npc)
    xi.homepoint.onTrigger(player, hpEvent, hpIndex)
end

entity.onEventUpdate = function(player, csid, option, npc)
    xi.homepoint.onEventUpdate(player, csid, option, npc)
end

entity.onEventFinish = function(player, csid, option, npc)
    -- The July 2009 set-only menu returns 0 for Yes and 1 for No.  The
    -- current global home point menu uses 1 for Set Home Point.
    if csid == hpEvent and bit.band(option, 0xFF) == 0 then
        player:setHomePoint()
        player:messageSpecial(ID.text.HOMEPOINT_SET)
    end
end

return entity
