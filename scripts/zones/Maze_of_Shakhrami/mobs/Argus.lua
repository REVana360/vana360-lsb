-----------------------------------
-- Area: Maze of Shakhrami
--   NM: Argus
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
---@type TMobEntity
local entity = {}

entity.spawnPoints =
{
    { x = 220.112, y = 18.762, z =  -63.954 },
    { x = 241.938, y = 20.000, z =  -74.946 },
    { x = 228.487, y = 19.971, z =  -92.704 },
    { x = 221.185, y = 20.000, z = -112.845 },
    { x = 246.046, y = 19.971, z =  -83.494 }
}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
end

entity.onMobDespawn = function(mob)
    scheduleLeechPair(
        math.randomInt(1, 100) <= 50 and ID.mob.ARGUS or ID.mob.LEECH_KING,
        math.randomInt(64800, 108000)) -- 18 to 30 hours
end

return entity
