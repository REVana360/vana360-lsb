describe('Mog Bonanza reward pages', function()
    it('keeps rank two and three prizes contiguous', function()
        local _ = mock('xi.events.mogBonanza.enabledCheck', true)
        local parameters = {}
        local player =
        {
            getZoneID = function()
                return xi.zone.PORT_BASTOK
            end,

            updateEvent = function(self, ...)
                parameters = { ... }
            end,
        }

        xi.events.mogBonanza.onBonanzaMoogleEventUpdate(player, 467, 0x100, nil)
        assert(bit.band(parameters[2], 0xFFFF) == xi.item.MOG_KUPON_A_OMII)
        assert(bit.rshift(parameters[2], 16) == xi.item.MOG_KUPON_I_AF119)
        assert(bit.rshift(parameters[8], 16) == xi.item.RIMILALA_STRIPESHELL)

        xi.events.mogBonanza.onBonanzaMoogleEventUpdate(player, 467, 0x101, nil)
        assert(bit.band(parameters[1], 0xFFFF) == xi.item.BAYLD_CRYSTAL)
        assert(bit.band(parameters[3], 0xFFFF) == xi.item.LU_SHANGS_FISHING_ROD)

        xi.events.mogBonanza.onBonanzaMoogleEventUpdate(player, 467, 0x200, nil)
        assert(bit.band(parameters[2], 0xFFFF) == xi.item.MOG_KUPON_AW_COS)
        assert(bit.rshift(parameters[2], 16) == xi.item.AUCUBA_CROWN)
        assert(bit.rshift(parameters[8], 16) == xi.item.MARS_ORB)
    end)
end)
