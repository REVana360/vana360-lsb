describe('July 2009 training regimes', function()
    local player
    local originalRegimeWait

    before_each(function()
        originalRegimeWait = xi.settings.main.REGIME_WAIT
        xi.settings.main.REGIME_WAIT = 1
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    after_each(function()
        xi.settings.main.REGIME_WAIT = originalRegimeWait
    end)

    it('uses July East Ronfaure field manual text', function()
        local text = zones[xi.zone.EAST_RONFAURE].text

        assert(text.REGIME_REGISTERED == 1812, 'registration message does not match the July DAT')
        assert(text.NOT_ENOUGH_TABS == 2076, 'tabs message does not match the July DAT')
    end)

    it("allows only one undertaking per Vana'diel day", function()
        local vanadielDay = VanadielUniqueDay()

        xi.regime.bookOnEventFinish(player, 18, xi.regime.type.FIELDS)
        assert(player:getCharVar('[regime]id') == 1, 'first regime was not registered')
        assert(player:getCharVar('[regime]lastStart') == vanadielDay, 'undertaking day was not recorded')

        xi.regime.bookOnEventFinish(player, 3, xi.regime.type.FIELDS)
        assert(player:getCharVar('[regime]id') == 0, 'regime was not canceled')
        assert(player:getCharVar('[regime]lastStart') == vanadielDay, 'canceling cleared the undertaking day')

        xi.regime.bookOnEventFinish(player, 34, xi.regime.type.FIELDS)
        assert(player:getCharVar('[regime]id') == 0, 'second same-day regime was registered')

        xi.test.world:skipVanaDays(1)
        assert(VanadielUniqueDay() > vanadielDay, "Vana'diel day did not advance")
        xi.regime.bookOnEventFinish(player, 34, xi.regime.type.FIELDS)
        assert(player:getCharVar('[regime]id') == 2, 'next-day regime was not registered')
    end)

    it('disables automatic repeat', function()
        xi.regime.bookOnEventFinish(player, 0x80000012, xi.regime.type.FIELDS)

        assert(player:getCharVar('[regime]id') == 1, 'regime was not registered')
        assert(player:getCharVar('[regime]repeat') == 0, 'automatic repeat was enabled')
    end)

    it('preserves the reward day during cleanup', function()
        local vanadielDay = VanadielUniqueDay()
        player:setCharVar('[regime]lastReward', vanadielDay)

        xi.regime.clearRegimeVars(player)

        assert(player:getCharVar('[regime]lastReward') == vanadielDay, 'cleanup cleared the reward day')

        xi.regime.bookOnEventFinish(player, 18, xi.regime.type.FIELDS)
        assert(player:getCharVar('[regime]id') == 0, 'same-day reward allowed another regime')
    end)

    it('retains repeat behavior when the wait is disabled', function()
        xi.settings.main.REGIME_WAIT = 0

        xi.regime.bookOnEventFinish(player, 0x80000012, xi.regime.type.FIELDS)

        assert(player:getCharVar('[regime]id') == 1, 'regime was not registered')
        assert(player:getCharVar('[regime]repeat') == 1, 'automatic repeat was not enabled')
    end)
end)
