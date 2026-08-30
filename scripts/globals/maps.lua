-----------------------------------
-- Functions for Map Vendor NPCs
-----------------------------------
xi = xi or {}
xi.maps = xi.maps or {}

-- July 2009 vendor lists and prices predate the later map-list merges.
-- Sources:
-- https://forum.square-enix.com/ffxi/threads/38100
-- https://wiki.ffo.jp/html/29812.html
-- https://forum.square-enix.com/ffxi/threads/45365-Dec-10-2014-(JST)-Version-Update
-- https://wiki.ffo.jp/html/23621.html

local mapInfo =
{
--   ID      Key Item                                  Cost
    [ 0] = { xi.ki.MAP_OF_THE_SAN_DORIA_AREA,           200 },
    [ 1] = { xi.ki.MAP_OF_THE_BASTOK_AREA,              200 },
    [ 2] = { xi.ki.MAP_OF_THE_WINDURST_AREA,            200 },
    [ 3] = { xi.ki.MAP_OF_THE_JEUNO_AREA,               600 },
    [ 4] = { xi.ki.MAP_OF_ORDELLES_CAVES,               600 },
    [ 5] = { xi.ki.MAP_OF_GHELSBA,                      600 },
    [ 6] = { xi.ki.MAP_OF_DAVOI,                       3000 },
    [ 7] = { xi.ki.MAP_OF_CARPENTERS_LANDING,          3000 },
    [ 8] = { xi.ki.MAP_OF_THE_ZERUHN_MINES,             200 },
    [ 9] = { xi.ki.MAP_OF_THE_PALBOROUGH_MINES,         600 },
    [10] = { xi.ki.MAP_OF_BEADEAUX,                    3000 },
    [11] = { xi.ki.MAP_OF_GIDDEUS,                      600 },
    [12] = { xi.ki.MAP_OF_CASTLE_OZTROJA,              3000 },
    [13] = { xi.ki.MAP_OF_THE_MAZE_OF_SHAKHRAMI,        600 },
    [14] = { xi.ki.MAP_OF_THE_LITELOR_REGION,          3000 },
    [15] = { xi.ki.MAP_OF_BIBIKI_BAY,                  3000 },
    [16] = { xi.ki.MAP_OF_QUFIM_ISLAND,                3000 },
    [17] = { xi.ki.MAP_OF_THE_ELDIEME_NECROPOLIS,      3000 },
    [18] = { xi.ki.MAP_OF_THE_GARLAIGE_CITADEL,        3000 },
    [19] = { xi.ki.MAP_OF_THE_ELSHIMO_REGIONS,         3000 },
    [20] = { xi.ki.MAP_OF_THE_NORTHLANDS_AREA,         3000 },
    [21] = { xi.ki.MAP_OF_KING_RANPERRES_TOMB,          600 },
    [22] = { xi.ki.MAP_OF_THE_DANGRUF_WADI,             600 },
    [23] = { xi.ki.MAP_OF_THE_HORUTOTO_RUINS,           600 },
    [24] = { xi.ki.MAP_OF_BOSTAUNIEUX_OUBLIETTE,       3000 },
    [25] = { xi.ki.MAP_OF_THE_TORAIMARAI_CANAL,        3000 },
    [26] = { xi.ki.MAP_OF_THE_GUSGEN_MINES,             600 },
    [27] = { xi.ki.MAP_OF_THE_CRAWLERS_NEST,           3000 },
    [28] = { xi.ki.MAP_OF_THE_RANGUEMONT_PASS,         3000 },
    [29] = { xi.ki.MAP_OF_DELKFUTTS_TOWER,             3000 },
    [30] = { xi.ki.MAP_OF_FEIYIN,                      3000 },
    [31] = { xi.ki.MAP_OF_CASTLE_ZVAHL,                3000 },
    [32] = { xi.ki.MAP_OF_THE_KUZOTZ_REGION,           3000 },
    [33] = { xi.ki.MAP_OF_THE_RUAUN_GARDENS,           3000 },
    [34] = { xi.ki.MAP_OF_NORG,                        3000 },
    [35] = { xi.ki.MAP_OF_TEMPLE_OF_UGGALEPIH,         3000 },
    [36] = { xi.ki.MAP_OF_THE_DEN_OF_RANCOR,           3000 },
    [37] = { xi.ki.MAP_OF_THE_KORROLOKA_TUNNEL,        3000 },
    [38] = { xi.ki.MAP_OF_THE_KUFTAL_TUNNEL,           3000 },
    [39] = { xi.ki.MAP_OF_THE_BOYAHDA_TREE,            3000 },
    [40] = { xi.ki.MAP_OF_VELUGANNON_PALACE,           3000 },
    [41] = { xi.ki.MAP_OF_IFRITS_CAULDRON,             3000 },
    [42] = { xi.ki.MAP_OF_THE_QUICKSAND_CAVES,         3000 },
    [43] = { xi.ki.MAP_OF_SEA_SERPENT_GROTTO,          3000 },
    [44] = { xi.ki.MAP_OF_THE_VOLLBOW_REGION,          3000 },
    [45] = { xi.ki.MAP_OF_LABYRINTH_OF_ONZOZO,         3000 },
    [46] = { xi.ki.MAP_OF_THE_ULEGUERAND_RANGE,        3000 },
    [47] = { xi.ki.MAP_OF_THE_ATTOHWA_CHASM,           3000 },
    [48] = { xi.ki.MAP_OF_PSOXJA,                      3000 },
    [49] = { xi.ki.MAP_OF_OLDTON_MOVALPOLOS,           3000 },
    [50] = { xi.ki.MAP_OF_NEWTON_MOVALPOLOS,           3000 },
    [51] = { xi.ki.MAP_OF_TAVNAZIA,                    3000 },
    [52] = { xi.ki.MAP_OF_THE_AQUEDUCTS,               3000 },
    [53] = { xi.ki.MAP_OF_THE_SACRARIUM,               3000 },
    [54] = { xi.ki.MAP_OF_CAPE_RIVERNE,                3000 },
    [55] = { xi.ki.MAP_OF_ALTAIEU,                     3000 },
    [56] = { xi.ki.MAP_OF_HUXZOI,                      3000 },
    [57] = { xi.ki.MAP_OF_RUHMET,                      3000 },
    [58] = { xi.ki.MAP_OF_AL_ZAHBI,                     600 },
    [59] = { xi.ki.MAP_OF_NASHMAU,                     3000 },
    [60] = { xi.ki.MAP_OF_WAJAOM_WOODLANDS,            3000 },
    [61] = { xi.ki.MAP_OF_CAEDARVA_MIRE,               3000 },
    [62] = { xi.ki.MAP_OF_MOUNT_ZHAYOLM,               3000 },
    [63] = { xi.ki.MAP_OF_AYDEEWA_SUBTERRANE,          3000 },
    [64] = { xi.ki.MAP_OF_MAMOOK,                      3000 },
    [65] = { xi.ki.MAP_OF_HALVUNG,                     3000 },
    [66] = { xi.ki.MAP_OF_ARRAPAGO_REEF,               3000 },
    [67] = { xi.ki.MAP_OF_ALZADAAL_RUINS,              3000 },
    [68] = { xi.ki.MAP_OF_BHAFLAU_THICKETS,            3000 },
    [69] = { xi.ki.MAP_OF_VUNKERL_INLET,              30000 },
    [70] = { xi.ki.MAP_OF_GRAUBERG,                   30000 },
    [71] = { xi.ki.MAP_OF_FORT_KARUGO_NARUGO,         30000 },
}

local sandoriaStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
    xi.ki.MAP_OF_ORDELLES_CAVES,
    xi.ki.MAP_OF_GHELSBA,
    xi.ki.MAP_OF_DAVOI,
    xi.ki.MAP_OF_CARPENTERS_LANDING,
}

local bastokStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
    xi.ki.MAP_OF_THE_ZERUHN_MINES,
    xi.ki.MAP_OF_THE_PALBOROUGH_MINES,
    xi.ki.MAP_OF_BEADEAUX,
}

local windurstStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
    xi.ki.MAP_OF_GIDDEUS,
    xi.ki.MAP_OF_CASTLE_OZTROJA,
    xi.ki.MAP_OF_THE_MAZE_OF_SHAKHRAMI,
}

local selbinaStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
}

local mhauraStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
    xi.ki.MAP_OF_THE_LITELOR_REGION,
    xi.ki.MAP_OF_BIBIKI_BAY,
}

local jeunoStock =
{
    xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
    xi.ki.MAP_OF_THE_BASTOK_AREA,
    xi.ki.MAP_OF_THE_WINDURST_AREA,
    xi.ki.MAP_OF_THE_JEUNO_AREA,
    xi.ki.MAP_OF_QUFIM_ISLAND,
    xi.ki.MAP_OF_THE_ELDIEME_NECROPOLIS,
    xi.ki.MAP_OF_THE_GARLAIGE_CITADEL,
    xi.ki.MAP_OF_THE_ELSHIMO_REGIONS,
}

local rabaoStock =
{
    xi.ki.MAP_OF_THE_KUZOTZ_REGION,
    xi.ki.MAP_OF_THE_KORROLOKA_TUNNEL,
    xi.ki.MAP_OF_THE_VOLLBOW_REGION,
}

local whitegateStock =
{
    xi.ki.MAP_OF_AL_ZAHBI,
    xi.ki.MAP_OF_NASHMAU,
    xi.ki.MAP_OF_WAJAOM_WOODLANDS,
    xi.ki.MAP_OF_BHAFLAU_THICKETS,
}

local mapVendors =
{
    ['Ashu_Bolkhomo']   = { event =  1006, stock = rabaoStock     },
    ['Elesca']          = { event =   567, stock = sandoriaStock  },
    ['Karine']          = { event =   210, stock = bastokStock    },
    ['Lombaria']        = { event =   500, stock = selbinaStock   },
    ['Ludwig']          = { event =   500, stock = mhauraStock    },
    ['Mhoji_Roccoruh']  = { event = 10000, stock = windurstStock  },
    ['Pehki_Machumaht'] = { event = 10000, stock = windurstStock  },
    ['Promurouve']      = { event = 10000, stock = jeunoStock     },
    ['Rex']             = { event =   115, stock = bastokStock    },
    ['Riyadahf']        = { event =   563, stock = whitegateStock },
    ['Rusese']          = { event = 10000, stock = jeunoStock     },
    ['Violitte']        = { event =   595, stock = sandoriaStock  },
}

local function getMapEventParams(player, vendor)
    local paramTable = { 0, 0, 0 }

    for mapId = 0, 71 do
        local map = mapInfo[mapId]

        if
            not map or
            not utils.contains(map[1], vendor.stock) or
            player:hasKeyItem(map[1])
        then
            local paramPos = math.floor(mapId / 32) + 1

            paramTable[paramPos] = bit.bor(paramTable[paramPos], bit.lshift(1, mapId))
        end
    end

    return paramTable
end

xi.maps.onTrigger = function(player, npc)
    local vendor = mapVendors[npc:getName()]

    if not vendor then
        return
    end

    local eventParams = getMapEventParams(player, vendor)

    player:startEvent(vendor.event, eventParams[1], eventParams[2], eventParams[3])
end

xi.maps.onEventUpdate = function(player, csid, option, npc)
    local vendor = mapVendors[npc:getName()]
    local mapId = bit.rshift(option, 16)

    if
        not vendor or
        csid ~= vendor.event
    then
        return
    end

    if bit.band(option, 0xF) == 1 then
        local map = mapInfo[mapId]

        if
            not map or
            not utils.contains(map[1], vendor.stock)
        then
            player:printToPlayer('You cannot purchase that item on this server.', xi.msg.channel.SYSTEM_3)
        elseif map[2] <= player:getGil() then
            player:delGil(map[2])
            npcUtil.giveKeyItem(player, map[1])
        else
            player:messageSpecial(zones[player:getZoneID()].text.NOT_HAVE_ENOUGH_GIL)
        end
    end

    player:updateEvent(unpack(getMapEventParams(player, vendor)))
end
