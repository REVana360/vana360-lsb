describe('July physical critical-rate profile', function()
    local function makeActor(stats, mods, options)
        stats   = stats or {}
        mods    = mods or {}
        options = options or {}

        return
        {
            getGearModFromSlot = function()
                return options.weaponCritBonus or 0
            end,

            getMainLvl = function()
                return 75
            end,

            getMerit = function()
                return 0
            end,

            getMod = function(_, modifier)
                return mods[modifier] or 0
            end,

            getObjType = function()
                return options.isPC and xi.objType.PC or xi.objType.MOB
            end,

            getStat = function(_, stat)
                return stats[stat] or 0
            end,

            getStatusEffect = function(_, effect)
                if options.statusEffectId == effect then
                    return options.statusEffect
                end
            end,

            hasStatusEffect = function(_, effect)
                return options.statusEffectId == effect
            end,

            isBehind = function()
                return options.isBehind or false
            end,

            isPC = function()
                return options.isPC or false
            end,
        }
    end

    local function makeTarget(stats, mods, options)
        stats   = stats or {}
        mods    = mods or {}
        options = options or {}

        return
        {
            getHP = function()
                return 1000
            end,

            getMainLvl = function()
                return 75
            end,

            getMerit = function()
                return 0
            end,

            getMod = function(_, modifier)
                return mods[modifier] or 0
            end,

            getStat = function(_, stat)
                return stats[stat] or 0
            end,

            getStatusEffect = function(_, effect)
                if options.statusEffectId == effect then
                    return options.statusEffect
                end
            end,

            hasStatusEffect = function(_, effect)
                return options.statusEffectId == effect
            end,

            isFacing = function()
                return options.isFacing or false
            end,
        }
    end

    local function assertClose(actual, expected)
        assert(math.abs(actual - expected) < 0.000001)
    end

    it('preserves the selected dDEX tiers', function()
        local target = makeTarget({ [xi.mod.AGI] = 100 })

        local cases =
        {
            { dex = 99,  expected = 0 },
            { dex = 106, expected = 0 },
            { dex = 107, expected = 0.01 },
            { dex = 114, expected = 0.02 },
            { dex = 120, expected = 0.03 },
            { dex = 130, expected = 0.04 },
            { dex = 140, expected = 0.05 },
            { dex = 150, expected = 0.15 },
            { dex = 200, expected = 0.15 },
        }

        for _, testCase in ipairs(cases) do
            local actor = makeActor({ [xi.mod.DEX] = testCase.dex })
            assertClose(xi.combat.physical.criticalRateFromStatDiff(actor, target), testCase.expected)
        end
    end)

    it('scales Innin and Yonin percentage powers', function()
        local effect =
        {
            getPower = function()
                return 30
            end,
        }

        local actor = makeActor(nil, nil, { statusEffectId = xi.effect.INNIN, statusEffect = effect, isBehind = true })
        local target = makeTarget(nil, nil, { statusEffectId = xi.effect.YONIN, statusEffect = effect, isFacing = true })

        assertClose(xi.combat.physical.criticalRateFromInnin(actor, target), 0.30)
        assertClose(xi.combat.physical.criticalRateFromYonin(actor, target), 0.30)
    end)

    it('applies Innin and Yonin to the complete melee rate', function()
        local effect =
        {
            getPower = function()
                return 30
            end,
        }

        local inninActor = makeActor(nil, nil, { statusEffectId = xi.effect.INNIN, statusEffect = effect, isBehind = true })
        local normalTarget = makeTarget()
        local normalActor = makeActor(nil, { [xi.mod.CRITHITRATE] = 50 })
        local yoninTarget = makeTarget(nil, nil, { statusEffectId = xi.effect.YONIN, statusEffect = effect, isFacing = true })

        assertClose(xi.combat.physical.calculateSwingCriticalRate(inninActor, normalTarget, 0, xi.slot.MAIN), 0.35)
        assertClose(xi.combat.physical.calculateSwingCriticalRate(normalActor, yoninTarget, 0, xi.slot.MAIN), 0.25)
        assertClose(xi.combat.physical.calculateSwingCriticalRate(makeActor(), yoninTarget, 0, xi.slot.MAIN), 0)
    end)

    it('uses AGI and excludes melee-only bonuses from ranged rates', function()
        local stats =
        {
            [xi.mod.DEX] = 1000,
            [xi.mod.AGI] = 100,
        }

        local flourishEffect =
        {
            getPower = function()
                return 3
            end,

            getSubPower = function()
                return 0
            end,
        }

        local actor = makeActor(stats, { [xi.mod.FENCER_CRITHITRATE] = 95 },
        {
            isPC                = true,
            statusEffectId      = xi.effect.BUILDING_FLOURISH,
            statusEffect        = flourishEffect,
            weaponCritBonus     = 95,
        })
        local target = makeTarget({ [xi.mod.AGI] = 0 })

        assertClose(xi.combat.physical.calculateRangedCriticalRate(actor, target, 0, xi.slot.RANGED), 0.15)
    end)

    it('does not apply Mighty Strikes to ranged rates', function()
        local actor = makeActor(nil, { [xi.mod.CRITHITRATE] = 100 }, { statusEffectId = xi.effect.MIGHTY_STRIKES })
        local target = makeTarget()

        assertClose(xi.combat.physical.calculateRangedCriticalRate(actor, target, 0, xi.slot.RANGED), 0.05)
    end)

    it('routes ranged weapon skills through the ranged rate', function()
        local actor  = makeActor()
        local target = makeTarget()

        local rangedRate = spy('xi.combat.physical.calculateRangedCriticalRate')
        local meleeRate  = spy('xi.combat.physical.calculateSwingCriticalRate')

        local ok = pcall(xi.weaponskills.calculateRawWSDmg, actor, target, 0, 1000, nil,
        {
            ftpMod     = { 1, 1, 1 },
            critVaries = { 0, 0, 0 },
        },
        {
            attackInfo = { slot = xi.slot.RANGED },
            weaponDamage = { 1 },
            fSTR = 0,
            bonusWSmods = 0,
            bonusfTP = 0,
        })

        assert(not ok)
        rangedRate:called(1)
        meleeRate:called(0)
    end)
end)
