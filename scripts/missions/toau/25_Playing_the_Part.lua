-----------------------------------
-- Playing the Part
-- Aht Uhrgan Mission 25
-----------------------------------
-- !addmission 4 24
-- The original JST-midnight wait was shortened in August 2016.
-- Source: https://forum.square-enix.com/ffxi/threads/51154-Aug.-3-2016-%28JST%29-Version-Update
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.PLAYING_THE_PART)

mission.reward =
{
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SEAL_OF_THE_SERPENT },
}

mission.sections =
{
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    if
                        not mission:getMustZone(player) and
                        mission:getVar(player, 'Timer') == 0
                    then
                        return mission:progressEvent(3110)
                    else
                        local dialog = mission:getVar(player, 'Option') + 1 -- Captured values 1 and 2
                        if dialog == 1 then
                            mission:setVar(player, 'Option', 1)
                        else
                            mission:setVar(player, 'Option', 0)
                        end

                        return mission:event(3098, xi.besieged.getMercenaryRank(player), 1, 0, 0, 0, 0, 0, dialog, 0)
                    end
                end,
            },

            onEventFinish =
            {
                [3110] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
