describe('July physical hit-rate profile', function()
    -- Distance-based ranged damage and accuracy predate the selected client.
    -- Sources: https://www.playonline.com/pcd/update/ff11us/20050715Pm01B1/detail.html
    -- https://www.playonline.com/pcd/update/ff11us/20061017UJ0a71/detail.html

    local function makeActor(level, acc, rangedAcc, distance, options)
        options = options or {}

        return
        {
            checkDistance = function()
                return distance or 10
            end,

            getACC = function()
                return acc
            end,

            getMainLvl = function()
                return level
            end,

            getMerit = function()
                return 0
            end,

            getRACC = function()
                return rangedAcc or acc
            end,

            getStatusEffect = function(_, effect)
                if options.statusEffectId == effect then
                    return options.statusEffect
                end
            end,

            getJobPointLevel = function()
                return 0
            end,

            hasStatusEffect = function(_, effect)
                return options.statusEffectId == effect
            end,

            hasTrait = function()
                return false
            end,

            isAvatar = function()
                return options.isAvatar or false
            end,

            isBehind = function()
                return options.isBehind or false
            end,

            isFacing = function()
                return options.isFacing or false
            end,

            isPC = function()
                return options.isPC ~= false
            end,

            isUsingH2H = function()
                return false
            end,

            isWeaponTwoHanded = function()
                return false
            end,
        }
    end

    local function makeTarget(level, evasion, options)
        options = options or {}

        return
        {
            getEVA = function()
                return evasion
            end,

            getMainLvl = function()
                return level
            end,

            getJobPointLevel = function()
                return 0
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

            isPC = function()
                return false
            end,
        }
    end

    local function assertClose(actual, expected)
        assert(math.abs(actual - expected) < 0.000001)
    end

    it('caps every melee attack state at 95 percent', function()
        local actor = makeActor(75, 1000)

        for _, animation in pairs(xi.attackAnimation) do
            assertClose(xi.combat.physicalHitRate.getPhysicalHitRateCap(actor, animation), 0.95)
        end
    end)

    it('uses the July melee base, slope, and bounds', function()
        local target = makeTarget(75, 400)

        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(makeActor(75, 400), target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.75)
        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(makeActor(75, 401), target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.75)
        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(makeActor(75, 399), target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.74)
        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(makeActor(75, 200), target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.20)
        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(makeActor(75, 1000), target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.95)
    end)

    it('applies the July accuracy correction at one level', function()
        local actor  = makeActor(74, 400)
        local target = makeTarget(75, 400)

        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(actor, target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.73)
    end)

    it('limits positive level correction to avatars', function()
        local target = makeTarget(75, 400)
        local mob    = makeActor(80, 400, nil, nil, { isPC = false })
        local avatar = makeActor(76, 400, nil, nil, { isPC = false, isAvatar = true })

        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(mob, target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.75)
        assertClose(xi.combat.physicalHitRate.getPhysicalHitRate(avatar, target, 0, xi.attackAnimation.RIGHT_ATTACK, false), 0.77)
    end)

    it('applies Innin and Yonin from the correct entity', function()
        local statusEffect =
        {
            getPower = function()
                return 30
            end,
        }

        local target = makeTarget(75, 400, { statusEffectId = xi.effect.YONIN, statusEffect = statusEffect, isFacing = true })
        local inninActor = makeActor(75, 400, nil, nil, { statusEffectId = xi.effect.INNIN, statusEffect = statusEffect, isBehind = true })
        local yoninActor = makeActor(75, 400, nil, nil, { statusEffectId = xi.effect.YONIN, statusEffect = statusEffect, isFacing = true })

        local inninAcc, inninEva = xi.combat.physicalHitRate.getHitRateModifiers(inninActor, makeTarget(75, 400), false, false)
        local yoninAcc, yoninEva = xi.combat.physicalHitRate.getHitRateModifiers(yoninActor, makeTarget(75, 400), false, false)
        local targetAcc, targetEva = xi.combat.physicalHitRate.getHitRateModifiers(makeActor(75, 400), target, false, false)

        assert(inninAcc == 30 and inninEva == 0)
        assert(yoninAcc == 0 and yoninEva == 0)
        assert(targetAcc == 0 and targetEva == 30)
    end)

    it('preserves the ranged base, slope, and bounds', function()
        local target = makeTarget(75, 400)

        stub('xi.combat.ranged.accuracyDistancePenalty', 0)
        assertClose(xi.combat.physicalHitRate.getRangedHitRate(makeActor(75, 400), target, 0, false), 0.75)
        assertClose(xi.combat.physicalHitRate.getRangedHitRate(makeActor(75, 200), target, 0, false), 0.05)
        assertClose(xi.combat.physicalHitRate.getRangedHitRate(makeActor(75, 1000), target, 0, false), 0.95)
    end)

    it('rejects ranged attacks beyond 25 yalms', function()
        local actor  = makeActor(75, 1000, 1000, 26)
        local target = makeTarget(75, 0)

        assertClose(xi.combat.physicalHitRate.getRangedHitRate(actor, target, 0, false), 0)
    end)
end)
