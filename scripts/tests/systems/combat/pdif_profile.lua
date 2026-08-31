describe('July pDIF profile', function()
    -- March 2013 equalized one- and two-handed caps and delayed level correction.
    -- Source: https://forum.square-enix.com/ffxi/threads/31310

    local function makeActor(level)
        return
        {
            getMainLvl = function()
                return level
            end,

            getMod = function()
                return 0
            end,

            getStat = function(_, stat)
                if stat == xi.mod.ATT or stat == xi.mod.RATT then
                    return 1000
                end

                return 0
            end,

            getStatusEffect = function()
                return nil
            end,

            isAutomaton = function()
                return false
            end,

            isMob = function()
                return false
            end,

            isPC = function()
                return true
            end,
        }
    end

    local function makeTarget(level)
        return
        {
            getMainLvl = function()
                return level
            end,

            getMod = function()
                return 0
            end,

            getStat = function(_, stat)
                return stat == xi.mod.DEF and 100 or 0
            end,
        }
    end

    local function meleePDif(actor, target, weaponType, isCritical)
        return xi.combat.physical.calculateMeleePDIF(
            actor,
            target,
            weaponType,
            1,
            isCritical or false,
            true,
            false,
            0,
            false,
            xi.slot.MAIN,
            false)
    end

    local function rangedPDif(actor, target, isCritical)
        return xi.combat.physical.calculateRangedPDIF(
            actor,
            target,
            xi.skill.ARCHERY,
            1,
            isCritical or false,
            true,
            false,
            0,
            false,
            0)
    end

    local function assertClose(actual, expected)
        assert(math.abs(actual - expected) < 0.000001)
    end

    local function upperRoll(bound)
        return math.floor(bound * 1000) / 1000 * 1.05
    end

    local function chooseUpperBounds()
        stub('math.randomInt', function(_, high)
            return math.floor(high)
        end)
    end

    local function chooseLowerBounds()
        stub('math.randomInt', function(low, _)
            return math.ceil(low)
        end)
    end

    it('uses the pre-Adoulin profile in every zone', function()
        assert(not xi.settings.main.USE_ADOULIN_WEAPON_SKILL_CHANGES)
        assert(xi.data.levelCorrection.isLevelCorrectedZone(
        {
            getZoneID = function()
                return xi.zone.GM_HOME
            end,
        }))
    end)

    it('uses the July one-handed pDIF range', function()
        local actor  = makeActor(75)
        local target = makeTarget(75)

        chooseLowerBounds()
        assertClose(meleePDif(actor, target, xi.skill.SWORD), 1.556)
    end)

    it('uses the July one-handed upper cap', function()
        local actor  = makeActor(75)
        local target = makeTarget(75)

        chooseUpperBounds()
        assertClose(meleePDif(actor, target, xi.skill.SWORD), upperRoll(1 + 10 / 9 * 1.25))
    end)

    it('uses the July two-handed upper cap', function()
        local actor  = makeActor(75)
        local target = makeTarget(75)

        chooseUpperBounds()
        assertClose(meleePDif(actor, target, xi.skill.GREAT_SWORD), 2.52)
    end)

    it('retains the July melee critical cap', function()
        local actor  = makeActor(75)
        local target = makeTarget(75)

        chooseUpperBounds()
        assertClose(meleePDif(actor, target, xi.skill.SWORD, true), 3.15)
    end)

    it('applies level correction at a one-level disadvantage', function()
        local actor  = makeActor(74)
        local target = makeTarget(75)

        chooseUpperBounds()
        local cRatio   = 2 - 3 / 64
        local expected = upperRoll(1 + 10 / 9 * (cRatio - 0.75))
        assertClose(meleePDif(actor, target, xi.skill.SWORD), expected)
    end)

    it('retains the two-handed level-correction buffer', function()
        local actor  = makeActor(70)
        local target = makeTarget(75)

        chooseUpperBounds()
        assertClose(meleePDif(actor, target, xi.skill.GREAT_SWORD), 2.52)
    end)

    it('uses the July ranged and ranged-critical caps', function()
        local actor  = makeActor(75)
        local target = makeTarget(75)

        stub('xi.combat.ranged.attackDistancePenalty', 0)
        chooseUpperBounds()
        assertClose(rangedPDif(actor, target), 3)
        assertClose(rangedPDif(actor, target, true), 3.75)
    end)
end)
