-----------------------------------
-- Zone: Maze of Shakhrami (198)
-- July 2009-era NM respawn behavior restored from pre-November 2013 values.
-- Source: https://forum.square-enix.com/ffxi/threads/38100
-----------------------------------
local ID = zones[xi.zone.MAZE_OF_SHAKHRAMI]
-----------------------------------
local function scheduleLeechPair(nextId, seconds)
    local otherId = nextId == ID.mob.ARGUS and ID.mob.LEECH_KING or ID.mob.ARGUS

    DisallowRespawn(otherId, true)
    DisallowRespawn(nextId, false)
    xi.mob.updateNMSpawnPoint(nextId)
    GetMobByID(nextId):setRespawnTime(seconds)
    SetServerVariable('[Respawn]LeechKingArgus_Mob', nextId)
    SetServerVariable('[Respawn]LeechKingArgus_Time', GetSystemTime() + seconds)
end

-----------------------------------
---@type TZone
local zoneObject = {}

zoneObject.onInitialize = function(zone)
    if math.randomInt(1, 100) <= 50 then
        DisallowRespawn(ID.mob.LEECH_KING, true)
        DisallowRespawn(ID.mob.ARGUS, false)
        xi.mob.updateNMSpawnPoint(ID.mob.ARGUS)
        GetMobByID(ID.mob.ARGUS):setRespawnTime(math.randomInt(900, 7200))
    else
        DisallowRespawn(ID.mob.ARGUS, true)
        DisallowRespawn(ID.mob.LEECH_KING, false)
        xi.mob.updateNMSpawnPoint(ID.mob.LEECH_KING)
        GetMobByID(ID.mob.LEECH_KING):setRespawnTime(math.randomInt(900, 7200))
    end

    xi.treasure.initZone(zone)
    xi.helm.initZone(zone, xi.helmType.EXCAVATION)

    GetMobByID(ID.mob.ARGUS):setRespawnTime(0)
    GetMobByID(ID.mob.LEECH_KING):setRespawnTime(0)

    local nextId = GetServerVariable('[Respawn]LeechKingArgus_Mob')
    local nextTime = GetServerVariable('[Respawn]LeechKingArgus_Time')

    if nextId == 0 then
        scheduleLeechPair(
            math.randomInt(1, 100) <= 50 and ID.mob.ARGUS or ID.mob.LEECH_KING,
            math.randomInt(64800, 108000)) -- 18 to 30 hours
    elseif GetSystemTime() < nextTime then
        scheduleLeechPair(nextId, nextTime - GetSystemTime())
    else
        DisallowRespawn(nextId == ID.mob.ARGUS and ID.mob.LEECH_KING or ID.mob.ARGUS, true)
        xi.mob.updateNMSpawnPoint(nextId)
        SpawnMob(nextId)
    end
end

zoneObject.onZoneIn = function(player, prevZone)
    local cs = -1

    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(-345, -11, -180, 239)
    end

    return cs
end

zoneObject.onConquestUpdate = function(zone, updatetype, influence, owner, ranking, isConquestAlliance)
    xi.conquest.onConquestUpdate(zone, updatetype, influence, owner, ranking, isConquestAlliance)
end

zoneObject.onTriggerAreaEnter = function(player, triggerArea)
end

zoneObject.onEventUpdate = function(player, csid, option, npc)
end

zoneObject.onEventFinish = function(player, csid, option, npc)
end

zoneObject.onGameHour = function(zone)
    local qmRSE = GetNPCByID(ID.npc.QM_RSE)
    if not qmRSE then
        return
    end

    local currentRSELocation = VanadielRSELocation()
    local rseEventActive     = qmRSE:getLocalVar('rseEventActive')

    if currentRSELocation ~= 2 then
        qmRSE:setLocalVar('rseEventActive', 0)
        qmRSE:setStatus(xi.status.DISAPPEAR)
        return
    end

    if rseEventActive == 0 then
        qmRSE:setLocalVar('rseEventActive', 1)
        qmRSE:setStatus(xi.status.NORMAL)
    end
end

zoneObject.onZoneOut = function(player)
    xi.helm.onZoneOut(player)
end

return zoneObject
