-----------------------------------
-- Area: Windurst Waters
--  NPC: Churano-Shurano
-- !pos -60.8 -11.2 98.9 238
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    -- Magicked Astrolabe access was introduced in February 2014.
    -- Source: https://forum.square-enix.com/ffxi/threads/40059
    player:startEvent(280)
end

entity.onEventUpdate = function(player, csid, option, npc)
end

entity.onEventFinish = function(player, csid, option, npc)
end

return entity
