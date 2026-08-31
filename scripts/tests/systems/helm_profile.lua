describe('July HELM profile', function()
    local function assertDrops(zoneId, expected)
        local actual = xi.helm.dataTable[xi.helmType.LOGGING].zone[zoneId].drops

        assert(#actual == #expected, string.format('expected %u drops, got %u', #expected, #actual))

        for index, expectedDrop in ipairs(expected) do
            local actualDrop = actual[index]

            assert(actualDrop[1] == expectedDrop[1], string.format('drop %u weight mismatch', index))
            assert(actualDrop[2] == expectedDrop[2], string.format('drop %u item mismatch', index))
        end
    end

    it('pins the Yuhtunga Jungle logging table', function()
        assertDrops(xi.zone.YUHTUNGA_JUNGLE,
        {
            { 1840, xi.item.PIECE_OF_RATTAN_LUMBER },
            { 1750, xi.item.ARROWWOOD_LOG          },
            { 1160, xi.item.LAUAN_LOG              },
            {  870, xi.item.BEEHIVE_CHIP           },
            {  600, xi.item.REVIVAL_TREE_ROOT      },
            {  590, xi.item.HOLLY_LOG              },
            {  240, xi.item.ROSEWOOD_LOG           },
            {  140, xi.item.EBONY_LOG              },
            {  130, xi.item.BAG_OF_TREE_CUTTINGS   },
        })
    end)

    it('pins the Yhoator Jungle logging table', function()
        assertDrops(xi.zone.YHOATOR_JUNGLE,
        {
            { 1810, xi.item.ARROWWOOD_LOG          },
            { 1770, xi.item.PIECE_OF_RATTAN_LUMBER },
            { 1190, xi.item.LAUAN_LOG              },
            {  860, xi.item.BEEHIVE_CHIP           },
            {  650, xi.item.REVIVAL_TREE_ROOT      },
            {  600, xi.item.DRYAD_ROOT             },
            {  250, xi.item.MAHOGANY_LOG           },
            {  130, xi.item.EBONY_LOG              },
            {  120, xi.item.BAG_OF_TREE_CUTTINGS   },
        })
    end)
end)
