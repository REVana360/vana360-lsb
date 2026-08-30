-----------------------------------
-- Zone: Temple_of_Uggalepih (159)
-----------------------------------
---@type TZone
local zoneObject = {}

local function initializeTimedNM(zone, mobName, respawnMin, respawnMax)
    local varName = '[Respawn]' .. mobName
    local mob = zone:queryEntitiesByName(mobName)[1]
    if not mob then
        return
    end

    local respawn = GetServerVariable(varName)
    if respawn == 0 and not mob:isSpawned() then
        respawn = GetSystemTime() + math.randomInt(respawnMin, respawnMax)
        SetServerVariable(varName, respawn)
    end

    if GetSystemTime() < respawn then
        xi.mob.updateNMSpawnPoint(mob)
        mob:setRespawnTime(respawn - GetSystemTime())

        if mob:isSpawned() then
            mob:setLocalVar('[Respawn]bootSync', 1)
            DespawnMob(mob:getID())
        end
    elseif not mob:isSpawned() then
        mob:setRespawnTime(0)
        SpawnMob(mob:getID())
    end
end

zoneObject.onInitialize = function(zone)
    xi.treasure.initZone(zone)

    initializeTimedNM(zone, 'Manipulator', 7200, 7200)
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
        player:setPos(432.013, 5.353, 216.472, 153)
    end

    return cs
end

zoneObject.onTriggerAreaEnter = function(player, triggerArea)
end

zoneObject.onEventUpdate = function(player, csid, option, npc)
end

zoneObject.onEventFinish = function(player, csid, option, npc)
end

return zoneObject
