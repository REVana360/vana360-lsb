-- CoP area and mission restrictions were removed after the Vana360 cutoff.
-- Source: https://www.playonline.com/pcd/verup/ff11us/detail/5571/detail.html
describe('Chains of Promathia level restrictions', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer(
            {
                job   = xi.job.WAR,
                level = 75,
                zone  = xi.zone.SOUTHERN_SAN_DORIA,
            })
    end)

    it('enables the July area and mission defaults', function()
        assert(xi.settings.main.ENABLE_COP_ZONE_CAP == 1, 'CoP area caps must be enabled')
        assert(xi.settings.map.LV_CAP_MISSION_BCNM, 'mission battlefield caps must be enabled')
    end)

    it('applies every fixed area cap from zone data', function()
        local areas =
        {
            { xi.zone.PROMYVION_HOLLA,    30 },
            { xi.zone.PROMYVION_DEM,      30 },
            { xi.zone.PROMYVION_MEA,      30 },
            { xi.zone.PROMYVION_VAHZL,    50 },
            { xi.zone.PHOMIUNA_AQUEDUCTS, 40 },
            { xi.zone.SACRARIUM,           50 },
            { xi.zone.RIVERNE_SITE_B01,    50 },
            { xi.zone.RIVERNE_SITE_A01,    40 },
        }

        for _, area in ipairs(areas) do
            player:gotoZone(area[1])

            local restriction = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
            assert(restriction ~= nil, string.format('zone %u did not apply a level restriction', area[1]))
            assert(restriction:getPower() == area[2],
                string.format('zone %u applied level %u instead of %u', area[1], restriction:getPower(), area[2]))
        end
    end)

    it("applies Pso'Xja's entrance-dependent cap", function()
        player:setCharVar('PSOXJA_RESTRICTION_LVL', 40)
        player:gotoZone(xi.zone.PSOXJA)

        local restriction = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
        assert(restriction ~= nil, "Pso'Xja did not apply its entrance cap")
        assert(restriction:getPower() == 40,
            string.format("Pso'Xja applied level %u instead of 40", restriction:getPower()))
    end)
end)
