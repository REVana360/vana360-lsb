-----------------------------------
-- Stirrings of War
-- Aht Uhrgan Mission 38
-----------------------------------
-- !addmission 4 37
-- The original JST-midnight wait was shortened in August 2016.
-- Source: https://forum.square-enix.com/ffxi/threads/51154-Aug.-3-2016-%28JST%29-Version-Update
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.STIRRINGS_OF_WAR)

mission.reward =
{
    keyItem     = xi.ki.ALLIED_COUNCIL_SUMMONS,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.ALLIED_RUMBLINGS },
}

mission.sections =
{
    {
        check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId and
                not mission:getMustZone(player) and
                mission:getVar(player, 'Timer') == 0
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Naja_Salaheem'] =
            {
                onTrigger = function(player, npc)
                    return mission:event(3134, xi.besieged.getMercenaryRank(player), 1, 0, 0, 0, 0, 0, 0, 0)
                end,
            },

            onTriggerAreaEnter =
            {
                [5] = function(player, triggerArea)
                    return mission:progressEvent(3136, { text_table = 0 })
                end,
            },

            onEventFinish =
            {
                [3136] = function(player, csid, option, npc)
                    mission:complete(player)
                end,
            },
        },
    },
}

return mission
