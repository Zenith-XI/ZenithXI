-- -----------------------------------
-- Maps Tables Module
--
-- This module adjusts the maps table for vendors and maps to adjust costs/availability.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('e-x_maps')
m:addOverride('xi.dummyFunc', function()
end)

-- Map vendors by region
xi.maps.mapVendors = {
    ['Ashu_Bolkhomo']   = 1006,
    ['Elesca']          = 567,
    ['Karine']          = 210,
    ['Lombaria']        = 500,
    ['Ludwig']          = 500,
    ['Mhoji_Roccoruh']  = 10000,
    ['Pehki_Machumaht'] = 10000,
    ['Promurouve']      = 10000,
    ['Rex']             = 115,
    ['Riyadahf']        = 563,
    ['Rusese']          = 10000,
    ['Violitte']        = 595,
}

-- Maps by menu index: { key item, cost, regions that sell it, name = menu label }
-- The index is the bit the client's vanilla map menu uses for that map. A cost of -1 means not for sale.
-- The vendor menu (3-complete/map_vendor.lua) shows the name and this cost, because the client's
-- own menu prints prices from its DATs that the server cannot change.
xi.maps.mapInfo = {
    [0] = {
        xi.keyItem.MAP_OF_THE_SAN_DORIA_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
            xi.region.JEUNO,
        },
        name = 'San d\'Oria Area',
    },
    [1] = {
        xi.keyItem.MAP_OF_THE_BASTOK_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
            xi.region.JEUNO,
        },
        name = 'Bastok Area',
    },
    [2] = {
        xi.keyItem.MAP_OF_THE_WINDURST_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
            xi.region.JEUNO,
        },
        name = 'Windurst Area',
    },
    [3] = {
        xi.keyItem.MAP_OF_THE_JEUNO_AREA,
        600,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
            xi.region.JEUNO,
        },
        name = 'Jeuno Area',
    },
    [4] = {
        xi.keyItem.MAP_OF_ORDELLES_CAVES,
        600,
        {
            xi.region.SANDORIA,
        },
        name = 'Ordelle\'s Caves',
    },
    [5] = {
        xi.keyItem.MAP_OF_GHELSBA,
        600,
        {
            xi.region.SANDORIA,
        },
        name = 'Ghelsba',
    },
    [6] = {
        xi.keyItem.MAP_OF_DAVOI,
        3000,
        {
            xi.region.SANDORIA,
        },
        name = 'Davoi',
    },
    -- Chains of Promathia
    [7] = {
        xi.keyItem.MAP_OF_CARPENTERS_LANDING,
        xi.settings.main.ENABLE_COP == 1 and 3000 or -1,
        {
            xi.region.SANDORIA,
        },
        name = 'Carpenters\' Landing',
    },
    [8] = {
        xi.keyItem.MAP_OF_THE_ZERUHN_MINES,
        200,
        {
            xi.region.BASTOK,
        },
        name = 'Zeruhn Mines',
    },
    [9] = {
        xi.keyItem.MAP_OF_THE_PALBOROUGH_MINES,
        600,
        {
            xi.region.BASTOK,
        },
        name = 'Palborough Mines',
    },
    [10] = {
        xi.keyItem.MAP_OF_BEADEAUX,
        3000, -- era price, as in LSB's modules/era/lua/globals/maps.lua (base has 600)
        {
            xi.region.BASTOK,
        },
        name = 'Beadeaux',
    },
    [11] = {
        xi.keyItem.MAP_OF_GIDDEUS,
        600,
        {
            xi.region.WINDURST,
        },
        name = 'Giddeus',
    },
    [12] = {
        xi.keyItem.MAP_OF_CASTLE_OZTROJA,
        3000,
        {
            xi.region.WINDURST,
        },
        name = 'Castle Oztroja',
    },
    [13] = {
        xi.keyItem.MAP_OF_THE_MAZE_OF_SHAKHRAMI,
        600,
        {
            xi.region.WINDURST,
        },
        name = 'Maze of Shakhrami',
    },
    -- Rise of the Zilart
    [14] = {
        xi.keyItem.MAP_OF_THE_LITELOR_REGION,
        xi.settings.main.ENABLE_ROTZ == 1 and 3000 or -1,
        {
            xi.region.KOLSHUSHU,
        },
        name = 'Li\'Telor Region',
    },
    -- Chains of Promathia
    [15] = {
        xi.keyItem.MAP_OF_BIBIKI_BAY,
        xi.settings.main.ENABLE_COP == 1 and 3000 or -1,
        {
            xi.region.KOLSHUSHU,
        },
        name = 'Bibiki Bay',
    },
    [16] = {
        xi.keyItem.MAP_OF_QUFIM_ISLAND,
        3000,
        {
            xi.region.JEUNO,
        },
        name = 'Qufim Island',
    },
    [17] = {
        xi.keyItem.MAP_OF_THE_ELDIEME_NECROPOLIS,
        3000,
        {
            xi.region.JEUNO,
        },
        name = 'Eldieme Necropolis',
    },
    [18] = {
        xi.keyItem.MAP_OF_THE_GARLAIGE_CITADEL,
        3000,
        {
            xi.region.JEUNO,
        },
        name = 'Garlaige Citadel',
    },
    -- Rise of the Zilart
    [19] = {
        xi.keyItem.MAP_OF_THE_ELSHIMO_REGIONS,
        xi.settings.main.ENABLE_ROTZ == 1 and 3000 or -1,
        {
            xi.region.JEUNO,
        },
        name = 'Elshimo Regions',
    },
    [20] = {
        xi.keyItem.MAP_OF_THE_NORTHLANDS_AREA,
        -1,
        name = 'Northlands Area',
    },
    [21] = {
        xi.keyItem.MAP_OF_KING_RANPERRES_TOMB,
        -1,
        name = 'King Ranperre\'s Tomb',
    },
    [22] = {
        xi.keyItem.MAP_OF_THE_DANGRUF_WADI,
        -1,
        name = 'Dangruf Wadi',
    },
    [23] = {
        xi.keyItem.MAP_OF_THE_HORUTOTO_RUINS,
        -1,
        name = 'Horutoto Ruins',
    },
    [24] = {
        xi.keyItem.MAP_OF_BOSTAUNIEUX_OUBLIETTE,
        -1,
        name = 'Bostaunieux Oubliette',
    },
    [25] = {
        xi.keyItem.MAP_OF_THE_TORAIMARAI_CANAL,
        -1,
        name = 'Toraimarai Canal',
    },
    [26] = {
        xi.keyItem.MAP_OF_THE_GUSGEN_MINES,
        -1,
        name = 'Gusgen Mines',
    },
    [27] = {
        xi.keyItem.MAP_OF_THE_CRAWLERS_NEST,
        -1,
        name = 'Crawlers\' Nest',
    },
    [28] = {
        xi.keyItem.MAP_OF_THE_RANGUEMONT_PASS,
        -1,
        name = 'Ranguemont Pass',
    },
    [29] = {
        xi.keyItem.MAP_OF_DELKFUTTS_TOWER,
        -1,
        name = 'Delkfutt\'s Tower',
    },
    [30] = {
        xi.keyItem.MAP_OF_FEIYIN,
        -1,
        name = 'Feiyin',
    },
    [31] = {
        xi.keyItem.MAP_OF_CASTLE_ZVAHL,
        -1,
        name = 'Castle Zvahl',
    },
    -- Rise of the Zilart
    [32] = {
        xi.keyItem.MAP_OF_THE_KUZOTZ_REGION,
        xi.settings.main.ENABLE_ROTZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
        name = 'Kuzotz Region',
    },
    [33] = {
        xi.keyItem.MAP_OF_THE_RUAUN_GARDENS,
        -1,
        name = 'Ru\'Aun Gardens',
    },
    [34] = {
        xi.keyItem.MAP_OF_NORG,
        -1,
        name = 'Norg',
    },
    [35] = {
        xi.keyItem.MAP_OF_TEMPLE_OF_UGGALEPIH,
        -1,
        name = 'Temple of Uggalepih',
    },
    [36] = {
        xi.keyItem.MAP_OF_THE_DEN_OF_RANCOR,
        -1,
        name = 'Den of Rancor',
    },
    -- Rise of the Zilart
    [37] = {
        xi.keyItem.MAP_OF_THE_KORROLOKA_TUNNEL,
        xi.settings.main.ENABLE_ROTZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
        name = 'Korroloka Tunnel',
    },
    [38] = {
        xi.keyItem.MAP_OF_THE_KUFTAL_TUNNEL,
        -1,
        name = 'Kuftal Tunnel',
    },
    [39] = {
        xi.keyItem.MAP_OF_THE_BOYAHDA_TREE,
        -1,
        name = 'Boyahda Tree',
    },
    [40] = {
        xi.keyItem.MAP_OF_VELUGANNON_PALACE,
        -1,
        name = 'Ve\'Lugannon Palace',
    },
    [41] = {
        xi.keyItem.MAP_OF_IFRITS_CAULDRON,
        -1,
        name = 'Ifrit\'s Cauldron',
    },
    [42] = {
        xi.keyItem.MAP_OF_THE_QUICKSAND_CAVES,
        -1,
        name = 'Quicksand Caves',
    },
    [43] = {
        xi.keyItem.MAP_OF_SEA_SERPENT_GROTTO,
        -1,
        name = 'Sea Serpent Grotto',
    },
    -- Rise of the Zilart
    [44] = {
        xi.keyItem.MAP_OF_THE_VOLLBOW_REGION,
        xi.settings.main.ENABLE_ROTZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
        name = 'Vollbow Region',
    },
    [45] = {
        xi.keyItem.MAP_OF_LABYRINTH_OF_ONZOZO,
        -1,
        name = 'Labyrinth of Onzozo',
    },
    [46] = {
        xi.keyItem.MAP_OF_THE_ULEGUERAND_RANGE,
        -1,
        name = 'Uleguerand Range',
    },
    [47] = {
        xi.keyItem.MAP_OF_THE_ATTOHWA_CHASM,
        -1,
        name = 'Attohwa Chasm',
    },
    [48] = {
        xi.keyItem.MAP_OF_PSOXJA,
        -1,
        name = 'Pso\'Xja',
    },
    [49] = {
        xi.keyItem.MAP_OF_OLDTON_MOVALPOLOS,
        -1,
        name = 'Oldton Movalpolos',
    },
    [50] = {
        xi.keyItem.MAP_OF_NEWTON_MOVALPOLOS,
        -1,
        name = 'Newton Movalpolos',
    },
    [51] = {
        xi.keyItem.MAP_OF_TAVNAZIA,
        -1,
        name = 'Tavnazia',
    },
    [52] = {
        xi.keyItem.MAP_OF_THE_AQUEDUCTS,
        -1,
        name = 'Aqueducts',
    },
    [53] = {
        xi.keyItem.MAP_OF_THE_SACRARIUM,
        -1,
        name = 'Sacrarium',
    },
    [54] = {
        xi.keyItem.MAP_OF_CAPE_RIVERNE,
        -1,
        name = 'Cape Riverne',
    },
    [55] = {
        xi.keyItem.MAP_OF_ALTAIEU,
        -1,
        name = 'Al\'Taieu',
    },
    [56] = {
        xi.keyItem.MAP_OF_HUXZOI,
        -1,
        name = 'Hu\'Xzoi',
    },
    [57] = {
        xi.keyItem.MAP_OF_RUHMET,
        -1,
        name = 'Ru\'Hmet',
    },
    -- Treasures of Aht Urhgan
    [58] = {
        xi.keyItem.MAP_OF_AL_ZAHBI,
        xi.settings.main.ENABLE_TOAU == 1 and 600 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
        name = 'Al Zahbi',
    },
    -- Treasures of Aht Urhgan
    [59] = {
        xi.keyItem.MAP_OF_NASHMAU,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
        name = 'Nashmau',
    },
    -- Treasures of Aht Urhgan
    [60] = {
        xi.keyItem.MAP_OF_WAJAOM_WOODLANDS,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
        name = 'Wajaom Woodlands',
    },
    [61] = {
        xi.keyItem.MAP_OF_CAEDARVA_MIRE,
        -1,
        name = 'Caedarva Mire',
    },
    [62] = {
        xi.keyItem.MAP_OF_MOUNT_ZHAYOLM,
        -1,
        name = 'Mount Zhayolm',
    },
    [63] = {
        xi.keyItem.MAP_OF_AYDEEWA_SUBTERRANE,
        -1,
        name = 'Aydeewa Subterrane',
    },
    [64] = {
        xi.keyItem.MAP_OF_MAMOOK,
        -1,
        name = 'Mamook',
    },
    [65] = {
        xi.keyItem.MAP_OF_HALVUNG,
        -1,
        name = 'Halvung',
    },
    [66] = {
        xi.keyItem.MAP_OF_ARRAPAGO_REEF,
        -1,
        name = 'Arrapago Reef',
    },
    [67] = {
        xi.keyItem.MAP_OF_ALZADAAL_RUINS,
        -1,
        name = 'Alzadaal Ruins',
    },
    -- Treasures of Aht Urhgan
    [68] = {
        xi.keyItem.MAP_OF_BHAFLAU_THICKETS,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
        name = 'Bhaflau Thickets',
    },
    [69] = {
        xi.keyItem.MAP_OF_VUNKERL_INLET,
        -1,
        name = 'Vunkerl Inlet',
    },
    [70] = {
        xi.keyItem.MAP_OF_GRAUBERG,
        -1,
        name = 'Grauberg',
    },
    [71] = {
        xi.keyItem.MAP_OF_FORT_KARUGO_NARUGO,
        -1,
        name = 'Fort Karugo-Narugo',
    },
}

return m
