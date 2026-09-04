describe('July home point profile', function()
    local function settle()
        for _ = 1, 8 do
            xi.test.world:skipTime(1)
        end
    end

    it('leaves the current home point unchanged when No is selected', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setHomePoint()

        player:setPos(0, 0, 0, 0, xi.zone.SOUTHERN_SAN_DORIA)
        settle()
        player.entities:gotoAndTrigger('HomePoint#1', { eventId = 596, finishOption = 1 })
        player:warp()
        settle()

        assert(player:getZoneID() == xi.zone.WEST_RONFAURE)
    end)

    it('uses the native set-only event without registering travel', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        assert(not player:hasTeleport(xi.teleport.type.HOMEPOINT, 0, 0))
        player.entities:gotoAndTrigger('HomePoint#1', { eventId = 596, finishOption = 0 })
        assert(not player:hasTeleport(xi.teleport.type.HOMEPOINT, 0, 0))

        player:setPos(0, 0, 0, 0, xi.zone.WEST_RONFAURE)
        settle()
        player:warp()
        settle()

        assert(player:getZoneID() == xi.zone.SOUTHERN_SAN_DORIA)
    end)
end)
