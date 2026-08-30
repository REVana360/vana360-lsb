-----------------------------------
-- Area: Caedarva Mire
--  NPC: qm8
-- Gives Lamian Fang Key
-----------------------------------
local ID = zones[xi.zone.CAEDARVA_MIRE]
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    -- The key changed from conquest-tally to Vana'diel-day timing in March 2012.
    -- Source: https://www.bg-wiki.com/ffxi/Version_Update_(03/26/2012)
    if player:getCharVar('[TIMER]Lamian_Fang_Key') == 0 then
        if npcUtil.giveItem(player, xi.item.LAMIAN_FANG_KEY) then
            player:setCharVar('[TIMER]Lamian_Fang_Key', 1, NextConquestTally())
        end
    else
        player:messageSpecial(ID.text.NOTHING_OUT_OF_ORDINARY)
    end
end

return entity
