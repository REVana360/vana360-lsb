-----------------------------------
-- Zone: RoMaeve (122)
-----------------------------------
local ID = zones[xi.zone.ROMAEVE]
-----------------------------------
---@type TZone
local zoneObject = {}

-- The Moongate opens only during a clear full moon from 00:00 through 02:59.
-- Source: https://forum.square-enix.com/ffxi/threads/50760-Jun.-7-2016-%28JST%29-Version-Update
-- The wider 18:00-06:00 window was added on July 13, 2011.
local function handleFullMoon(zone)
    local validMoon    = getVanadielMoonCycle() == xi.moonCycle.FULL_MOON
    local validHour    = VanadielHour() >= 0 and VanadielHour() < 3
    local validWeather = zone:getWeather() == xi.weather.NONE or zone:getWeather() == xi.weather.SUNSHINE

    local shouldDoorsOpen        = validMoon and validHour
    local shouldFountainActivate = validMoon and validHour and validWeather

    -- Set targetable status.
    local moongate1 = GetNPCByID(ID.npc.MOONGATE_OFFSET)
    if moongate1 then
        moongate1:setUntargetable(shouldDoorsOpen)
    end

    local moongate2 = GetNPCByID(ID.npc.MOONGATE_OFFSET + 1)
    if moongate2 then
        moongate2:setUntargetable(shouldDoorsOpen)
    end

    -- Determine what the animation/status of the NPCs should be.
    local doorStatus     = shouldDoorsOpen and xi.animation.OPEN_DOOR or xi.animation.CLOSE_DOOR
    local fountainStatus = shouldFountainActivate and xi.animation.OPEN_DOOR or xi.animation.CLOSE_DOOR

    -- Loop over the affected NPCs: Moongates, bridges and fountain
    for i = ID.npc.MOONGATE_OFFSET, ID.npc.MOONGATE_OFFSET + 7 do
        local npc = GetNPCByID(i)
        if i == ID.npc.MOONGATE_OFFSET + 6 then
            if npc and npc:getAnimation() ~= fountainStatus then
                npc:setAnimation(fountainStatus)
            end
        elseif npc and npc:getAnimation() ~= doorStatus then
            npc:setAnimation(doorStatus)
        end
    end
end

local function handleBastokQM(onInitialize)
    local bastokMissionQM = GetNPCByID(ID.npc.BASTOK_7_1_QM)
    if not bastokMissionQM then
        return
    end

    local newPosition = npcUtil.pickNewPosition(ID.npc.BASTOK_7_1_QM, ID.npc.BASTOK_7_1_QM_POS, onInitialize)
    if onInitialize then
        bastokMissionQM:setPos(newPosition.x, newPosition.y, newPosition.z)
        return
    end

    local vanadielHour = VanadielHour()
    if
        vanadielHour == 0 or
        vanadielHour == 6 or
        vanadielHour == 12 or
        vanadielHour == 18
    then
        npcUtil.queueMove(bastokMissionQM, newPosition)
    end
end

zoneObject.onInitialize = function(zone)
    handleFullMoon(zone)
    handleBastokQM(true)
end

zoneObject.onConquestUpdate = function(zone, updatetype, influence, owner, ranking, isConquestAlliance)
    xi.conquest.onConquestUpdate(zone, updatetype, influence, owner, ranking, isConquestAlliance)
end

zoneObject.onZoneIn = function(player, prevZone)
    local cs = -1

    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(-0.008, -33.595, 123.478, 62)
    end

    return cs
end

zoneObject.onTriggerAreaEnter = function(player, triggerArea)
end

zoneObject.onGameHour = function(zone)
    handleFullMoon(zone)
    handleBastokQM(false)
end

zoneObject.onEventUpdate = function(player, csid, option, npc)
end

zoneObject.onEventFinish = function(player, csid, option, npc)
end

return zoneObject
