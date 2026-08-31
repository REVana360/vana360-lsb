describe('July cure formula', function()
    -- The Healing Magic skill formula was changed after the Vana360 cutoff.
    -- Source: https://forum.square-enix.com/ffxi/threads/22099

    ---@type CClientEntityPair
    local player

    local julySpells =
    {
        { xi.magic.spell.CURE,     30 },
        { xi.magic.spell.CURE_II,  90 },
        { xi.magic.spell.CURE_III, 165 },
        { xi.magic.spell.CURE_IV,  315 },
        { xi.magic.spell.CURE_V,   480 },
        { xi.magic.spell.CURA,     30 },
    }

    before_each(function()
        player = xi.test.world:spawnPlayer(
        {
            zone  = xi.zone.GM_HOME,
            job   = xi.job.WHM,
            level = 75,
        })

        for _, spell in ipairs(julySpells) do
            player:addSpell(spell[1])
        end

        player:setSkillLevel(xi.skill.HEALING_MAGIC, 276)
        player:setMod(xi.mod.REGEN, 0)
        player:setHP(1)
        player:setMP(player:getMaxMP())
        player:setWeather(xi.weather.NONE)
        xi.test.world:setVanaDay(xi.day.FIRESDAY)
    end)

    after_each(function()
        xi.settings.main.USE_OLD_CURE_FORMULA = true
    end)

    local function cast(spellId)
        player.actions:useSpell(player, spellId)
        xi.test.world:skipTime(10)
    end

    for _, testCase in ipairs(julySpells) do
        it('uses the old formula for spell ' .. testCase[1], function()
            assert(xi.settings.main.USE_OLD_CURE_FORMULA, 'old cure formula is disabled by default')
            mock('getCurePowerOld', 200)

            local startingHP = player:getHP()
            cast(testCase[1])

            local expectedHP = startingHP + testCase[2]
            local actualHP = player:getHP()
            assert(actualHP == expectedHP, string.format('expected %u HP, got %u', expectedHP, actualHP))
        end)
    end

    it('retains the modern formula option', function()
        xi.settings.main.USE_OLD_CURE_FORMULA = false
        mock('getCurePower', 200)

        local startingHP = player:getHP()
        cast(xi.magic.spell.CURE_IV)

        local actualHP = player:getHP()
        local expectedHP = startingHP + 400
        assert(actualHP == expectedHP, string.format('expected %u HP, got %u', expectedHP, actualHP))
    end)
end)
