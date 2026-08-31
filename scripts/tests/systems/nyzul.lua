describe('July Nyzul Isle profile', function()
    -- Sources:
    -- https://www.playonline.com/pcd/update/ff11us/20070308c2bbd1/detail.html
    -- https://www.playonline.com/pcd/verup/ff11us/detail/3668/detail.html

    ---@type CClientEntityPair
    local player

    local investigationOption = bit.lshift(xi.assault.mission.NYZUL_ISLE_INVESTIGATION, 4) + 1
    local unchartedOption     = bit.lshift(xi.assault.mission.NYZUL_ISLE_UNCHARTED_AREA_SURVEY, 4) + 1
    local nyzulInstance       = require('scripts/zones/Nyzul_Isle/instances/nyzul_isle_investigation')

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE })
        player:addKeyItem(xi.ki.PSC_WILDCAT_BADGE)
        player:addKeyItem(xi.ki.IMPERIAL_ARMY_ID_TAG)
    end)

    after_each(function()
        xi.settings.main.NYZUL_ENABLED = true
    end)

    it('uses the July 2009 defaults', function()
        assert(xi.settings.main.NYZUL_ENABLED, 'Nyzul Isle is disabled by default')
        assert(xi.settings.main.RUNIC_DISK_SAVE, 'party floor progress is disabled by default')
        assert(xi.settings.main.ENABLE_NYZUL_CASKETS, 'Nyzul caskets are disabled by default')
        assert(xi.settings.main.ENABLE_VIGIL_DROPS, 'Vigil weapon drops are disabled by default')
    end)

    it('offers the original Nyzul Isle Investigation', function()
        player.entities:gotoAndTrigger('Sorrowful_Sage', { eventId = 278, finishOption = investigationOption })

        assert(player:getCurrentAssault() == xi.assault.mission.NYZUL_ISLE_INVESTIGATION, 'wrong assault accepted')
        player.assert:hasKI(xi.ki.NYZUL_ISLE_ASSAULT_ORDERS)
        assert(not player:hasKeyItem(xi.ki.IMPERIAL_ARMY_ID_TAG), 'ID tag was not consumed')
    end)

    it('rejects the post-cutoff Uncharted survey', function()
        assert(xi.assault.missionToArea[xi.assault.mission.NYZUL_ISLE_UNCHARTED_AREA_SURVEY] == nil)
        player.entities:gotoAndTrigger('Sorrowful_Sage', { eventId = 278, finishOption = unchartedOption })

        assert(player:getCurrentAssault() == 0, 'Uncharted survey accepted')
        assert(not player:hasKeyItem(xi.ki.NYZUL_ISLE_ASSAULT_ORDERS), 'Uncharted orders granted')
        player.assert:hasKI(xi.ki.IMPERIAL_ARMY_ID_TAG)
    end)

    it('rejects forged Uncharted instance entry', function()
        player:addAssault(xi.assault.mission.NYZUL_ISLE_UNCHARTED_AREA_SURVEY)
        player:addKeyItem(xi.ki.NYZUL_ISLE_ASSAULT_ORDERS)

        assert(not nyzulInstance.registryRequirements(player), 'Uncharted registrant accepted')
        assert(not nyzulInstance.entryRequirements(player), 'Uncharted member accepted')
    end)

    it('retains the disabled fallback', function()
        xi.settings.main.NYZUL_ENABLED = false
        player.entities:gotoAndTrigger('Sorrowful_Sage', { eventId = 284 })
    end)
end)
