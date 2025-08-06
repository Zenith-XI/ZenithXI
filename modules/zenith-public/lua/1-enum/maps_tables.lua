-- -----------------------------------
-- Maps Tables Module
--
-- This module overrides the maps table for vendors and maps.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('maps_tables')

-- Override the maps table
xi = xi or {}
xi.maps = xi.maps or {}

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

-- Maps information by area, cost and region(s) sold
xi.maps.mapInfo = {
    [0] = {
        xi.ki.MAP_OF_THE_SAN_DORIA_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
        },
    },
    [1] = {
        xi.ki.MAP_OF_THE_BASTOK_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
        },
    },
    [2] = {
        xi.ki.MAP_OF_THE_WINDURST_AREA,
        200,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
        },
    },
    [3] = {
        xi.ki.MAP_OF_THE_JEUNO_AREA,
        600,
        {
            xi.region.SANDORIA,
            xi.region.BASTOK,
            xi.region.WINDURST,
            xi.region.KOLSHUSHU,
            xi.region.ZULKHEIM,
            xi.region.JEUNO,
        },
    },
    [4] = {
        xi.ki.MAP_OF_ORDELLES_CAVES,
        600,
        {
            xi.region.SANDORIA,
        },
    },
    [5] = {
        xi.ki.MAP_OF_GHELSBA,
        600,
        {
            xi.region.SANDORIA,
        },
    },
    [6] = {
        xi.ki.MAP_OF_DAVOI,
        3000,
        {
            xi.region.SANDORIA,
        },
    },
    -- Chains of Promathia
    [7] = {
        xi.ki.MAP_OF_CARPENTERS_LANDING,
        xi.settings.main.ENABLE_COP == 1 and 3000 or -1,
        {
            xi.region.SANDORIA,
        },
    },
    [8] = {
        xi.ki.MAP_OF_THE_ZERUHN_MINES,
        200,
        {
            xi.region.BASTOK,
        },
    },
    [9] = {
        xi.ki.MAP_OF_THE_PALBOROUGH_MINES,
        600,
        {
            xi.region.BASTOK,
        },
    },
    [10] = {
        xi.ki.MAP_OF_BEADEAUX,
        600,
        {
            xi.region.BASTOK,
        },
    },
    [11] = {
        xi.ki.MAP_OF_GIDDEUS,
        600,
        {
            xi.region.WINDURST,
        },
    },
    [12] = {
        xi.ki.MAP_OF_CASTLE_OZTROJA,
        3000,
        {
            xi.region.WINDURST,
        },
    },
    [13] = {
        xi.ki.MAP_OF_THE_MAZE_OF_SHAKHRAMI,
        600,
        {
            xi.region.WINDURST,
        },
    },
    -- Rise of the Zilart
    [14] = {
        xi.ki.MAP_OF_THE_LITELOR_REGION,
        xi.settings.main.ENABLE_ROZ == 1 and 3000 or -1,
        {
            xi.region.KOLSHUSHU,
        },
    },
    -- Chains of Promathia
    [15] = {
        xi.ki.MAP_OF_BIBIKI_BAY,
        xi.settings.main.ENABLE_COP == 1 and 3000 or -1,
        {
            xi.region.KOLSHUSHU,
        },
    },
    [16] = {
        xi.ki.MAP_OF_QUFIM_ISLAND,
        3000,
        {
            xi.region.JEUNO,
        },
    },
    [17] = {
        xi.ki.MAP_OF_THE_ELDIEME_NECROPOLIS,
        3000,
        {
            xi.region.JEUNO,
        },
    },
    [18] = {
        xi.ki.MAP_OF_THE_GARLAIGE_CITADEL,
        3000,
        {
            xi.region.JEUNO,
        },
    },
    -- Rise of the Zilart
    [19] = {
        xi.ki.MAP_OF_THE_ELSHIMO_REGIONS,
        xi.settings.main.ENABLE_ROZ == 1 and 3000 or -1,
        {
            xi.region.JEUNO,
        },
    },
    [20] = {
        xi.ki.MAP_OF_THE_NORTHLANDS_AREA,
        -1,
    },
    [21] = {
        xi.ki.MAP_OF_KING_RANPERRES_TOMB,
        -1,
    },
    [22] = {
        xi.ki.MAP_OF_THE_DANGRUF_WADI,
        -1,
    },
    [23] = {
        xi.ki.MAP_OF_THE_HORUTOTO_RUINS,
        -1,
    },
    [24] = {
        xi.ki.MAP_OF_BOSTAUNIEUX_OUBLIETTE,
        -1,
    },
    [25] = {
        xi.ki.MAP_OF_THE_TORAIMARAI_CANAL,
        -1,
    },
    [26] = {
        xi.ki.MAP_OF_THE_GUSGEN_MINES,
        -1,
    },
    [27] = {
        xi.ki.MAP_OF_THE_CRAWLERS_NEST,
        -1,
    },
    [28] = {
        xi.ki.MAP_OF_THE_RANGUEMONT_PASS,
        -1,
    },
    [29] = {
        xi.ki.MAP_OF_DELKFUTTS_TOWER,
        -1,
    },
    [30] = {
        xi.ki.MAP_OF_FEIYIN,
        -1,
    },
    [31] = {
        xi.ki.MAP_OF_CASTLE_ZVAHL,
        -1,
    },
    -- Rise of the Zilart
    [32] = {
        xi.ki.MAP_OF_THE_KUZOTZ_REGION,
        xi.settings.main.ENABLE_ROZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
    },
    [33] = {
        xi.ki.MAP_OF_THE_RUAUN_GARDENS,
        -1,
    },
    [34] = {
        xi.ki.MAP_OF_NORG,
        -1,
    },
    [35] = {
        xi.ki.MAP_OF_TEMPLE_OF_UGGALEPIH,
        -1,
    },
    [36] = {
        xi.ki.MAP_OF_THE_DEN_OF_RANCOR,
        -1,
    },
    -- Rise of the Zilart
    [37] = {
        xi.ki.MAP_OF_THE_KORROLOKA_TUNNEL,
        xi.settings.main.ENABLE_ROZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
    },
    [38] = {
        xi.ki.MAP_OF_THE_KUFTAL_TUNNEL,
        -1,
    },
    [39] = {
        xi.ki.MAP_OF_THE_BOYAHDA_TREE,
        -1,
    },
    [40] = {
        xi.ki.MAP_OF_VELUGANNON_PALACE,
        -1,
    },
    [41] = {
        xi.ki.MAP_OF_IFRITS_CAULDRON,
        -1,
    },
    [42] = {
        xi.ki.MAP_OF_THE_QUICKSAND_CAVES,
        -1,
    },
    [43] = {
        xi.ki.MAP_OF_SEA_SERPENT_GROTTO,
        -1,
    },
    -- Rise of the Zilart
    [44] = {
        xi.ki.MAP_OF_THE_VOLLBOW_REGION,
        xi.settings.main.ENABLE_ROZ == 1 and 3000 or -1,
        {
            xi.region.KUZOTZ,
        },
    },
    [45] = {
        xi.ki.MAP_OF_LABYRINTH_OF_ONZOZO,
        -1,
    },
    [46] = {
        xi.ki.MAP_OF_THE_ULEGUERAND_RANGE,
        -1,
    },
    [47] = {
        xi.ki.MAP_OF_THE_ATTOHWA_CHASM,
        -1,
    },
    [48] = {
        xi.ki.MAP_OF_PSOXJA,
        -1,
    },
    [49] = {
        xi.ki.MAP_OF_OLDTON_MOVALPOLOS,
        -1,
    },
    [50] = {
        xi.ki.MAP_OF_NEWTON_MOVALPOLOS,
        -1,
    },
    [51] = {
        xi.ki.MAP_OF_TAVNAZIA,
        -1,
    },
    [52] = {
        xi.ki.MAP_OF_THE_AQUEDUCTS,
        -1,
    },
    [53] = {
        xi.ki.MAP_OF_THE_SACRARIUM,
        -1,
    },
    [54] = {
        xi.ki.MAP_OF_CAPE_RIVERNE,
        -1,
    },
    [55] = {
        xi.ki.MAP_OF_ALTAIEU,
        -1,
    },
    [56] = {
        xi.ki.MAP_OF_HUXZOI,
        -1,
    },
    [57] = {
        xi.ki.MAP_OF_RUHMET,
        -1,
    },
    -- Treasures of Aht Urhgan
    [58] = {
        xi.ki.MAP_OF_AL_ZAHBI,
        xi.settings.main.ENABLE_TOAU == 1 and 600 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
    },
    -- Treasures of Aht Urhgan
    [59] = {
        xi.ki.MAP_OF_NASHMAU,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
    },
    -- Treasures of Aht Urhgan
    [60] = {
        xi.ki.MAP_OF_WAJAOM_WOODLANDS,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
    },
    [61] = {
        xi.ki.MAP_OF_CAEDARVA_MIRE,
        -1,
    },
    [62] = {
        xi.ki.MAP_OF_MOUNT_ZHAYOLM,
        -1,
    },
    [63] = {
        xi.ki.MAP_OF_AYDEEWA_SUBTERRANE,
        -1,
    },
    [64] = {
        xi.ki.MAP_OF_MAMOOK,
        -1,
    },
    [65] = {
        xi.ki.MAP_OF_HALVUNG,
        -1,
    },
    [66] = {
        xi.ki.MAP_OF_ARRAPAGO_REEF,
        -1,
    },
    [67] = {
        xi.ki.MAP_OF_ALZADAAL_RUINS,
        -1,
    },
    -- Treasures of Aht Urhgan
    [68] = {
        xi.ki.MAP_OF_BHAFLAU_THICKETS,
        xi.settings.main.ENABLE_TOAU == 1 and 3000 or -1,
        {
            xi.region.WEST_AHT_URHGAN,
        },
    },
    [69] = {
        xi.ki.MAP_OF_VUNKERL_INLET,
        -1,
    },
    [70] = {
        xi.ki.MAP_OF_GRAUBERG,
        -1,
    },
    [71] = {
        xi.ki.MAP_OF_FORT_KARUGO_NARUGO,
        -1,
    },
}

return m
