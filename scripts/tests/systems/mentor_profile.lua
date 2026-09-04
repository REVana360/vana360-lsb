describe('Mentor enrollment', function()
    it('preserves enrollment across zone changes', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTHERN_SAN_DORIA })

        assert(not player:getMentor(), 'new character already had mentor enrollment')
        player:setMentor(true)
        assert(player:getMentor(), 'mentor enrollment was not applied')

        player:gotoZone(xi.zone.WEST_RONFAURE)
        assert(player:getMentor(), 'mentor enrollment was lost on zone change')

        player:setMentor(false)
        player:gotoZone(xi.zone.SOUTHERN_SAN_DORIA)
        assert(not player:getMentor(), 'mentor enrollment returned after revocation')
    end)
end)
