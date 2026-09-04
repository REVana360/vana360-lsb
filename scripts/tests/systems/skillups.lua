describe('July 2009 skill-ups', function()
    it('keeps neutral configured multipliers', function()
        assert(xi.settings.map.SKILLUP_CHANCE_MULTIPLIER == 1.0, 'skill-up chance multiplier was not neutral')
        assert(xi.settings.map.SKILLUP_AMOUNT_MULTIPLIER == 1, 'skill-up amount multiplier was not neutral')
    end)

    it('requires an even-match target to reach the current skill cap', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 4 })
        local lowerTargetCap = player:getMaxSkillLevel(3, xi.job.WAR, xi.skill.SWORD) * 10

        player:setSkillLevel(xi.skill.SWORD, lowerTargetCap)
        player:trySkillUp(xi.skill.SWORD, 3, true)
        assert(player:getCharSkillLevel(xi.skill.SWORD) == lowerTargetCap, 'lower-level target raised skill past its cap')

        player:trySkillUp(xi.skill.SWORD, 4, true)
        assert(player:getCharSkillLevel(xi.skill.SWORD) > lowerTargetCap, 'even-match target did not permit a skill-up')
    end)
end)
