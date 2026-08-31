describe('July home point profile', function()
    local function settle()
        for _ = 1, 8 do
            xi.test.world:skipTime(1)
        end
    end

    it('uses the native set-only event without registering travel', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        assert(not player:hasTeleport(xi.teleport.type.HOMEPOINT, 0, 0))
        player.entities:gotoAndTrigger('HomePoint#1', { eventId = 8700, finishOption = 1 })
        assert(not player:hasTeleport(xi.teleport.type.HOMEPOINT, 0, 0))

        player:setPos(0, 0, 0, 0, xi.zone.WEST_RONFAURE)
        settle()
        player:warp()
        settle()

        assert(player:getZoneID() == xi.zone.SOUTHERN_SAN_DORIA)
    end)
end)
