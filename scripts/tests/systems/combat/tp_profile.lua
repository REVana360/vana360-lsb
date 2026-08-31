describe('July physical TP profile', function()
    local function makeEntity(options)
        options = options or {}

        return
        {
            getBaseDelay = function()
                return options.delay or 180
            end,

            getMerit = function(_, merit)
                if merit == xi.merit.STORE_TP_EFFECT then
                    return options.storeTPMerit or 0
                elseif merit == xi.merit.SUBTLE_BLOW_EFFECT then
                    return options.subtleBlowMerit or 0
                end

                return 0
            end,

            getMod = function(_, modifier)
                if modifier == xi.mod.AGI then
                    return options.agi or 0
                elseif modifier == xi.mod.DUAL_WIELD then
                    return options.dualWield or 0
                elseif modifier == xi.mod.INHIBIT_TP then
                    return options.inhibitTP or 0
                elseif modifier == xi.mod.STORETP then
                    return options.storeTP or 0
                elseif modifier == xi.mod.SUBTLE_BLOW then
                    return options.subtleBlow or 0
                elseif modifier == xi.mod.SUBTLE_BLOW_II then
                    return options.subtleBlowII or 0
                end

                return 0
            end,

            getObjType = function()
                return options.objType or xi.objType.PC
            end,

            getStat = function(_, modifier)
                if modifier == xi.mod.AGI then
                    return options.agi or 0
                end

                return 0
            end,

            hasStatusEffect = function()
                return false
            end,

            isDualWielding = function()
                return options.isDualWielding or false
            end,

            isTandemActive = function()
                return false
            end,

            isUsingH2H = function()
                return false
            end,
        }
    end

    it('preserves each pre-2014 delay boundary', function()
        local cases =
        {
            { delay = 180, expected = 50 },
            { delay = 181, expected = 50 },
            { delay = 450, expected = 115 },
            { delay = 451, expected = 115 },
            { delay = 480, expected = 130 },
            { delay = 481, expected = 130 },
            { delay = 530, expected = 145 },
            { delay = 531, expected = 145 },
            { delay = 1000, expected = 180 },
        }

        for _, testCase in ipairs(cases) do
            assert(xi.combat.tp.calculateTPReturn(nil, testCase.delay) == testCase.expected)
        end
    end)

    it('uses aggregate delay per dual-wield swing', function()
        local actor = makeEntity({ delay = 500, dualWield = 20, isDualWielding = true, storeTP = 17 })

        assert(xi.combat.tp.getSingleMeleeHitTPReturn(actor) == 63)
    end)

    it('includes ammunition delay in ranged TP', function()
        local player = xi.test.world:spawnPlayer({ job = xi.job.RNG, level = 75 })
        player:addItem(xi.item.SHORTBOW)
        player:addItem(xi.item.WOODEN_ARROW)
        player:equipItem(xi.item.SHORTBOW)
        player:equipItem(xi.item.WOODEN_ARROW)

        assert(player:getBaseRangedDelay() == 480)
        assert(xi.combat.tp.getSingleRangedHitTPReturn(player) == 130)
    end)

    it('applies dAGI and both Subtle Blow tiers', function()
        local target = makeEntity({ objType = xi.objType.MOB, inhibitTP = 75 })
        local neutralActor = makeEntity({ agi = -30 })
        local cappedActor  = makeEntity({ agi = 70, subtleBlow = 50, subtleBlowII = 25 })

        assert(xi.combat.tp.calculateTPGainOnPhysicalDamage(neutralActor, target, 1, 180) == 80)
        assert(xi.combat.tp.calculateTPGainOnPhysicalDamage(cappedActor, target, 1, 180) == 10)
        assert(xi.combat.tp.calculateTPGainOnMagicalDamage(neutralActor, target, 1) == 100)
        assert(xi.combat.tp.calculateTPGainOnMagicalDamage(cappedActor, target, 1) == 12)
    end)

    it('applies Inhibit TP once in the native TP owner', function()
        local player = xi.test.world:spawnPlayer()
        player:setMod(xi.mod.INHIBIT_TP, 25)
        player:addTP(100)

        assert(player:getTP() == 75)
    end)
end)
