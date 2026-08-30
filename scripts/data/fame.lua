-----------------------------------
-- Rank thresholds for fame calculations
-- Fame is stored at 10x the retail 0-250 scale to account for decimal precision (2500 cap)
-- https://wiki.ffo.jp/html/2683.html
-- https://forum.square-enix.com/ffxi/threads/40059
-----------------------------------
xi = xi or {}
xi.data = xi.data or {}
xi.data.fame = xi.data.fame or {}
-----------------------------------

-- Points required for each fame rank
-- These thresholds predate the February 18th 2014 reduction.
xi.data.fame.rankPoints =
{
    [1] = 0,
    [2] = 200,
    [3] = 500,
    [4] = 900,
    [5] = 1300,
    [6] = 1700,
    [7] = 1950,
    [8] = 2200,
    [9] = 2450,
}

-- Fame rank (1-9) for a raw fame point value
-- Called by CLuaBaseEntity::getFameLevel
xi.data.fame.getRankFromPoints = function(famePoints)
    local rank = 1

    for level, points in ipairs(xi.data.fame.rankPoints) do
        if famePoints >= points then
            rank = level
        end
    end

    return rank
end
