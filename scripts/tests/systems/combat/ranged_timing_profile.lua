describe('July ranged timing and trait profile', function()
    it('uses the pre-July-2012 free-phase delay', function()
        assert(xi.settings.main.RANGED_ATTACK_FREE_PHASE_DELAY == 1200)
    end)

    it('keeps the July Ranger Rapid Shot tier', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.RNG, level = 99 })

        assert(player:hasTrait(xi.trait.RAPID_SHOT))
        assert(player:getMod(xi.mod.RAPID_SHOT) == 25)
        assert(not player:hasTrait(xi.trait.SNAPSHOT))
        assert(not player:hasTrait(xi.trait.RECYCLE))
        assert(not player:hasTrait(xi.trait.TRUE_SHOT))
    end)

    it('keeps the July Corsair Rapid Shot tier', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.COR, level = 99 })

        assert(player:hasTrait(xi.trait.RAPID_SHOT))
        assert(player:getMod(xi.mod.RAPID_SHOT) == 25)
        assert(not player:hasTrait(xi.trait.SNAPSHOT))
        assert(not player:hasTrait(xi.trait.RECYCLE))
        assert(not player:hasTrait(xi.trait.TRUE_SHOT))
    end)

    it('requires the Recycle trait before applying merits', function()
        local hasRecycleTrait = false
        local attacker =
        {
            getJobPointLevel = function()
                return 0
            end,

            getMerit = function()
                return 100
            end,

            getMod = function()
                return 0
            end,

            hasStatusEffect = function()
                return false
            end,

            hasTrait = function(_, trait)
                return trait == xi.trait.RECYCLE and hasRecycleTrait
            end,

            isPC = function()
                return true
            end,
        }

        stub('math.randomInt', 1)

        assert(xi.combat.ranged.shouldUseAmmo(attacker))
        hasRecycleTrait = true
        assert(not xi.combat.ranged.shouldUseAmmo(attacker))
    end)
end)
