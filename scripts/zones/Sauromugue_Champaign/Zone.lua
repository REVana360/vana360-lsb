-----------------------------------
-- Zone: Sauromugue_Champaign (120)
-----------------------------------
local ID = zones[xi.zone.SAUROMUGUE_CHAMPAIGN]
-----------------------------------
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

-----------------------------------
---@type TZone
local zoneObject = {}

zoneObject.onInitialize = function(zone)
    -- A Chocobo Riding Game finish line
    zone:registerCylindricalTriggerArea(1, -489.11, 349.14, 20)

    GetNPCByID(ID.npc.QM2 + math.randomInt(0, 5)):setLocalVar('Quest[2][70]Option', 1) -- Determine which QM is active today for THF AF2
    xi.voidwalker.zoneOnInit(zone)

    initializeTimedNM(zone, 'Roc', 75600, 86400)
end

zoneObject.onZoneIn = function(player, prevZone)
    local cs = -1

    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        player:setPos(-574.647, 2.3231, 399.974, 7)
    end

    return cs
end

zoneObject.afterZoneIn = function(player)
    xi.chocoboGame.handleMessage(player)
end

zoneObject.onConquestUpdate = function(zone, updatetype, influence, owner, ranking, isConquestAlliance)
    xi.conquest.onConquestUpdate(zone, updatetype, influence, owner, ranking, isConquestAlliance)
end

zoneObject.onTriggerAreaEnter = function(player, triggerArea)
    local triggerAreaID = triggerArea:getTriggerAreaID()

    if triggerAreaID == 1 and player:hasStatusEffect(xi.effect.MOUNTED) then
        xi.chocoboGame.onTriggerAreaEnter(player)
    end
end

zoneObject.onGameDay = function()
    for i = ID.npc.QM2, ID.npc.QM2 + 5 do
        GetNPCByID(i):resetLocalVars()
    end

    GetNPCByID(ID.npc.QM2 + math.randomInt(0, 5)):setLocalVar('Quest[2][70]Option', 1) -- Determine which QM is active today for THF AF2
end

zoneObject.onEventUpdate = function(player, csid, option, npc)
end

zoneObject.onEventFinish = function(player, csid, option, npc)
    xi.chocoboGame.onEventFinish(player, csid)
end

return zoneObject
