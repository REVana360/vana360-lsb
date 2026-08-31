describe('July combat stat multipliers', function()
    -- One-handed, hand-to-hand, and ranged ratios changed after the July cutoff.
    -- Source: https://forum.square-enix.com/ffxi/threads/35228
    -- The player and allied VIT defense contribution changed in 2016.
    -- Source: https://forum.square-enix.com/ffxi/threads/51154

    local function normalizeStat(player, stat)
        player:addMod(stat, 100 - player:getStat(stat))
        assert(player:getStat(stat) == 100)
    end

    local function assertContribution(player, stat, measure, expected, message)
        local before = measure()
        player:addMod(stat, 20)
        assert(measure() - before == expected, message)
    end

    it('selects the complete July ratio matrix', function()
        local expectedSettings =
        {
            TWO_HANDED_STR_ATTACK_MULTIPLIER         = 0.75,
            HAND_TO_HAND_STR_ATTACK_MULTIPLIER       = 0.5,
            ONE_HAND_MAIN_HAND_STR_ATTACK_MULTIPLIER = 0.5,
            ONE_HAND_OFF_HAND_STR_ATTACK_MULTIPLIER  = 0.5,
            RANGED_STR_ATTACK_MULTIPLIER             = 0.5,
            TWO_HANDED_DEX_ACCURACY_MULTIPLIER         = 0.75,
            HAND_TO_HAND_DEX_ACCURACY_MULTIPLIER       = 0.5,
            ONE_HAND_MAIN_HAND_DEX_ACCURACY_MULTIPLIER = 0.5,
            ONE_HAND_OFF_HAND_DEX_ACCURACY_MULTIPLIER  = 0.5,
            RANGED_AGI_ACCURACY_MULTIPLIER             = 0.5,
            PLAYER_ALLIES_VIT_DEF_MULTIPLIER            = 0.5,
        }

        for setting, expected in pairs(expectedSettings) do
            assert(xi.settings.main[setting] == expected, string.format('%s is not set for July 2009', setting))
        end
    end)

    it('applies two-handed STR and DEX contributions', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
        player:addItem(xi.item.GREATSWORD)
        player:equipItem(xi.item.GREATSWORD, nil, xi.slot.MAIN)
        normalizeStat(player, xi.mod.STR)
        normalizeStat(player, xi.mod.DEX)

        assertContribution(player, xi.mod.STR, function()
            return player:getStat(xi.mod.ATT, xi.slot.MAIN)
        end, 15, 'two-handed STR contribution is not 0.75')
        assertContribution(player, xi.mod.DEX, function()
            return player:getACC()
        end, 15, 'two-handed DEX contribution is not 0.75')
    end)

    it('applies hand-to-hand STR and DEX contributions', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.MNK, level = 75 })
        player:addItem(xi.item.CESTI)
        player:equipItem(xi.item.CESTI, nil, xi.slot.MAIN)
        normalizeStat(player, xi.mod.STR)
        normalizeStat(player, xi.mod.DEX)

        assertContribution(player, xi.mod.STR, function()
            return player:getStat(xi.mod.ATT, xi.slot.MAIN)
        end, 10, 'hand-to-hand STR contribution is not 0.5')
        assertContribution(player, xi.mod.DEX, function()
            return player:getACC()
        end, 10, 'hand-to-hand DEX contribution is not 0.5')
    end)

    it('applies one-handed main and off-hand contributions', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.NIN, level = 75 })
        player:addItem(xi.item.KUNAI)
        player:addItem(xi.item.BRONZE_KNIFE)
        player:equipItem(xi.item.KUNAI, nil, xi.slot.MAIN)
        player:equipItem(xi.item.BRONZE_KNIFE, nil, xi.slot.SUB)
        normalizeStat(player, xi.mod.STR)
        normalizeStat(player, xi.mod.DEX)

        local mainAttack = player:getStat(xi.mod.ATT, xi.slot.MAIN)
        local offAttack  = player:getStat(xi.mod.ATT, xi.slot.SUB)
        player:addMod(xi.mod.STR, 20)
        assert(player:getStat(xi.mod.ATT, xi.slot.MAIN) - mainAttack == 10, 'main-hand STR contribution is not 0.5')
        assert(player:getStat(xi.mod.ATT, xi.slot.SUB) - offAttack == 10, 'off-hand STR contribution is not 0.5')

        local mainAccuracy = player:getACC()
        local offAccuracy  = player:getACC(1)
        player:addMod(xi.mod.DEX, 20)
        assert(player:getACC() - mainAccuracy == 10, 'main-hand DEX contribution is not 0.5')
        assert(player:getACC(1) - offAccuracy == 10, 'off-hand DEX contribution is not 0.5')
    end)

    it('applies ranged STR and AGI contributions', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.RNG, level = 75 })
        player:addItem(xi.item.POWER_BOW)
        player:addItem(xi.item.WOODEN_ARROW)
        player:equipItem(xi.item.POWER_BOW)
        player:equipItem(xi.item.WOODEN_ARROW)
        normalizeStat(player, xi.mod.STR)
        normalizeStat(player, xi.mod.AGI)

        assertContribution(player, xi.mod.STR, function()
            return player:getRATT()
        end, 10, 'ranged STR contribution is not 0.5')
        assertContribution(player, xi.mod.AGI, function()
            return player:getRACC()
        end, 10, 'ranged AGI contribution is not 0.5')
    end)

    it('applies the July VIT defense contribution', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 75 })
        normalizeStat(player, xi.mod.VIT)

        assertContribution(player, xi.mod.VIT, function()
            return player:getStat(xi.mod.DEF)
        end, 10, 'VIT defense contribution is not 0.5')
    end)
end)
