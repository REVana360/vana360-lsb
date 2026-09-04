-----------------------------------
-- EXP to difficulty curve for /check
-- as well as Incredibly Easy Prey stuff
-- July 2009 values; use with scripts/data/experience_table.lua.
-- https://www.playonline.com/pcd2/topics/ff11eu/detail/6178/detail.html
-----------------------------------
xi = xi or {}
xi.expDifficultyCurve = xi.expDifficultyCurve or {}

xi.expDifficultyCurve.loadExpDifficultyCurve = function()
    local incrediblyEasyPreyLevel  = 255
    local incrediblyEasyPreyMinExp = 65535

    -- exp value >= returns X difficulty
    -- [exp] = xi.mobDifficulty
    local expToDifficultyTable =
    {
        [400] = xi.mobDifficulty.INCREDIBLY_TOUGH,
        [200] = xi.mobDifficulty.VERY_TOUGH,
        [120] = xi.mobDifficulty.TOUGH,
        [100] = xi.mobDifficulty.EVEN_MATCH,
        [50]  = xi.mobDifficulty.DECENT_CHALLENGE,
        [15]  = xi.mobDifficulty.EASY_PREY,
        -- Nothing below 15 so that is too weak
    }

    -- Load into C++
    LoadExpDifficultyCurves(expToDifficultyTable, incrediblyEasyPreyLevel, incrediblyEasyPreyMinExp)
end
