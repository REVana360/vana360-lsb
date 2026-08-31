describe('July elemental magic damage formula', function()
    -- The player elemental-magic damage curves changed after the Vana360 cutoff.
    -- Source: https://forum.square-enix.com/ffxi/threads/35228

    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local rabbit

    local julySpells =
    {
        { name = 'Stone',    id = xi.magic.spell.STONE,     damage = 42  },
        { name = 'Thunder',  id = xi.magic.spell.THUNDER,   damage = 149 },
        { name = 'Stone III', id = xi.magic.spell.STONE_III, damage = 360 },
        { name = 'Stone IV', id = xi.magic.spell.STONE_IV,  damage = 581 },
    }

    before_each(function()
        player = xi.test.world:spawnPlayer(
        {
            zone  = xi.zone.WEST_RONFAURE,
            job   = xi.job.BLM,
            level = 75,
        })

        rabbit = player.entities:moveTo('Forest_Hare')
        rabbit:spawn()

        local statDifference = player:getStat(xi.mod.INT) - rabbit:getStat(xi.mod.INT)
        player:addMod(xi.mod.INT, 100 - statDifference)
        assert(player:getStat(xi.mod.INT) - rabbit:getStat(xi.mod.INT) == 100)
    end)

    after_each(function()
        xi.settings.main.USE_OLD_MAGIC_DAMAGE = true
        rabbit:respawn()
    end)

    local function calculate(spellId)
        return xi.spells.damage.calculateBaseDamage(
            player,
            rabbit,
            spellId,
            xi.magic.spellGroup.BLACK,
            xi.skill.ELEMENTAL_MAGIC,
            xi.mod.INT)
    end

    for _, testCase in ipairs(julySpells) do
        it('uses the old formula for ' .. testCase.name, function()
            assert(xi.settings.main.USE_OLD_MAGIC_DAMAGE, 'old magic damage formula is disabled by default')
            assert(calculate(testCase.id) == testCase.damage, 'unexpected old-formula damage')
        end)
    end

    it('retains the modern formula option', function()
        xi.settings.main.USE_OLD_MAGIC_DAMAGE = false

        assert(calculate(xi.magic.spell.STONE_IV) == 850, 'unexpected modern-formula damage')
    end)
end)
