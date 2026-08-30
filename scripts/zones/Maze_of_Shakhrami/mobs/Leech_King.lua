-----------------------------------
-- Area: Maze of Shakhrami
--   NM: Leech King
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
    { x = 271.844, y = 18.887, z = -203.545 },
    { x = 243.469, y = 19.727, z = -196.274 },
    { x = 262.156, y = 19.973, z = -219.851 },
    { x = 281.575, y = 20.000, z = -241.118 },
    { x = 280.504, y = 21.000, z = -220.683 }
}

entity.onMobDespawn = function(mob)
    scheduleLeechPair(
        math.randomInt(1, 100) <= 50 and ID.mob.ARGUS or ID.mob.LEECH_KING,
        math.randomInt(64800, 108000)) -- 18 to 30 hours
end

return entity
