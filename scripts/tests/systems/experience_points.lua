describe('July 2009 experience points', function()
    it('uses the pre-February 2011 base table', function()
        local baseTable = xi.data.experiencePoints.baseTable
        local caps = xi.experiencePoints.perMonsterCaps

        assert(baseTable[0][1] == 100, 'level 1-5 even match EXP was not 100')
        assert(baseTable[1][1] == 120, 'level 1-5 level-difference 1 EXP was not 120')
        assert(baseTable[-1][1] == 72, 'level 1-5 level-difference -1 EXP was not 72')
        assert(baseTable[0][15] == 100, 'level 71-75 even match EXP was not 100')
        assert(baseTable[-7][15] == 50, 'level 71-75 level-difference -7 EXP was not 50')
        assert(caps[1].maxLevel == 50 and caps[1].cap == 200, 'level 1-50 cap was not 200')
        assert(caps[2].maxLevel == 60 and caps[2].cap == 250, 'level 51-60 cap was not 250')
        assert(caps[3].cap == 300, 'level 61+ cap was not 300')
    end)

    it('uses the matching July Check curve', function()
        local player = xi.test.world:spawnPlayer({ level = 4, zone = xi.zone.WEST_RONFAURE })
        local mob = player.entities:moveTo('Wild_Rabbit')

        mob:setMobLevel(4)
        assert(player:checkDifficulty(mob) == xi.mobDifficulty.EVEN_MATCH, 'same-level mob was not even match')

        mob:setMobLevel(5)
        assert(player:checkDifficulty(mob) == xi.mobDifficulty.TOUGH, 'level-difference 1 mob was not tough')

        mob:setMobLevel(3)
        assert(player:checkDifficulty(mob) == xi.mobDifficulty.DECENT_CHALLENGE, 'level-difference -1 mob was not decent challenge')

        mob:setMobLevel(1)
        assert(player:checkDifficulty(mob) == xi.mobDifficulty.EASY_PREY, 'level-difference -3 mob was not easy prey')
    end)
end)
