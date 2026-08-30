-----------------------------------
-- In the Blood
-- Aht Uhrgan Mission 32
-----------------------------------
-- !addmission 4 31
-- The original JST-midnight wait was shortened in August 2016.
-- Source: https://forum.square-enix.com/ffxi/threads/51154-Aug.-3-2016-%28JST%29-Version-Update
-- Naja Salaheem : !pos 22.700 -8.804 -45.591 50
-----------------------------------

local mission = Mission:new(xi.mission.log_id.TOAU, xi.mission.id.toau.IN_THE_BLOOD)

mission.reward =
{
    item        = xi.item.IMPERIAL_GOLD_PIECE,
    nextMission = { xi.mission.log_id.TOAU, xi.mission.id.toau.SENTINELS_HONOR },
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
                    return mission:progressEvent(3113, xi.besieged.getMercenaryRank(player), 1, 0, 0, 0, 0, 0, 0, 0)
                end,
            },

            onEventFinish =
            {
                [3113] = function(player, csid, option, npc)
                    if mission:complete(player) then
                        player:setCharVar('Mission[4][32]Timer', 1, JstMidnight())
                        player:setLocalVar('Mission[4][32]mustZone', 1)
                    end
                end,
            },
        },
    },
}

return mission
