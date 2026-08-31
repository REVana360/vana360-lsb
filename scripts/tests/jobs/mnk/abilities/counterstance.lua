describe('Counterstance', function()
    -- Counterstance's defense penalty was not reduced until the March 27, 2013 update.
    -- Source: https://forum.square-enix.com/ffxi/threads/31310

    local player

    before_each(function()
        player = xi.test.world:spawnPlayer(
        {
            job   = xi.job.MNK,
            level = 75,
        })

        player:addMod(xi.mod.VIT, 100 - player:getStat(xi.mod.VIT))
        player:addMod(xi.mod.DEF, 200)
        assert(player:getStat(xi.mod.VIT) == 100)
    end)

    local function useCounterstance()
        player.actions:useAbility(player, xi.jobAbility.COUNTERSTANCE)
        xi.test.world:tick()
        player.assert:hasEffect(xi.effect.COUNTERSTANCE)
    end

    it('uses the July defense formula', function()
        assert(xi.settings.main.USE_OLD_COUNTERSTANCE, 'old Counterstance formula is disabled by default')

        useCounterstance()

        assert(player:getStat(xi.mod.DEF) == 51, 'Counterstance did not ignore flat defense')
    end)

    it('adds Minne to the July formula', function()
        player:addStatusEffect(xi.effect.MINNE, { power = 30, duration = 60, origin = player })

        useCounterstance()

        assert(player:getStat(xi.mod.DEF) == 81, 'Counterstance did not include Minne')
    end)
end)
