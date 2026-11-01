-----------------------------------
-- Era chocobo digging loot (ZENITHDEV-273)
-- Phoenix's historical digging pools and their weights, from pxi_digging_data.lua and pxi_digging_logic.lua.
-- Phoenix has one weighted pool per zone, so the treasure layer drops nothing and the regular layer rolls that pool.
-- Fatigue, cooldowns, skill-ups and the Burrow and Bore layers stay LSB's.
-- xi.chocoboDig.rollLayer comes from git-patches/118-ChocoboDigLayerHook.patch.
-----------------------------------
require('modules/module_utils')
require('scripts/globals/hobbies/chocobo_digging/logic')
-----------------------------------
local m = Module:new('era_digging_loot')

-----------------------------------
-- Digging accuracy is affected by player's rank only. No moon influence.
-----------------------------------
xi.chocoboDig.accuracy =
{
    [xi.craftRank.AMATEUR    ] = 30,
    [xi.craftRank.RECRUIT    ] = 34,
    [xi.craftRank.INITIATE   ] = 38,
    [xi.craftRank.NOVICE     ] = 42,
    [xi.craftRank.APPRENTICE ] = 46,
    [xi.craftRank.JOURNEYMAN ] = 50,
    [xi.craftRank.CRAFTSMAN  ] = 51,
    [xi.craftRank.ARTISAN    ] = 52,
    [xi.craftRank.ADEPT      ] = 53,
    [xi.craftRank.VETERAN    ] = 54,
    [xi.craftRank.EXPERT     ] = 55,
}

-----------------------------------
-- Areas where Elemental Ores can be dug.
-----------------------------------
xi.chocoboDig.elementalOreZones =
set{
    xi.zone.BATALLIA_DOWNS,
    xi.zone.BUBURIMU_PENINSULA,
    xi.zone.EAST_RONFAURE,
    xi.zone.EAST_SARUTABARUTA,
    xi.zone.JUGNER_FOREST,
    xi.zone.KONSCHTAT_HIGHLANDS,
    xi.zone.LA_THEINE_PLATEAU,
    xi.zone.MERIPHATAUD_MOUNTAINS,
    xi.zone.NORTH_GUSTABERG,
    xi.zone.PASHHOW_MARSHLANDS,
    xi.zone.ROLANBERRY_FIELDS,
    xi.zone.SAUROMUGUE_CHAMPAIGN,
    xi.zone.SOUTH_GUSTABERG,
    xi.zone.TAHRONGI_CANYON,
    xi.zone.VALKURM_DUNES,
    xi.zone.WEST_RONFAURE,
    xi.zone.WEST_SARUTABARUTA,
    xi.zone.BIBIKI_BAY,
    xi.zone.CARPENTERS_LANDING,
    xi.zone.BHAFLAU_THICKETS,
    xi.zone.WAJAOM_WOODLANDS,
    xi.zone.THE_SANCTUARY_OF_ZITAH,
}

-----------------------------------
-- Elemental Ore weight. Full weight set at Expert Rank.
-----------------------------------
xi.chocoboDig.elementalOreWeight =
{
    [xi.craftRank.AMATEUR    ] =  0,
    [xi.craftRank.RECRUIT    ] =  0,
    [xi.craftRank.INITIATE   ] =  0,
    [xi.craftRank.NOVICE     ] =  0,
    [xi.craftRank.APPRENTICE ] =  0,
    [xi.craftRank.JOURNEYMAN ] = 15,
    [xi.craftRank.CRAFTSMAN  ] = 30,
    [xi.craftRank.ARTISAN    ] = 45,
    [xi.craftRank.ADEPT      ] = 55,
    [xi.craftRank.VETERAN    ] = 65,
    [xi.craftRank.EXPERT     ] = 80,
}

-----------------------------------
-- Crystal chance. Full weight set at Novice Rank.
-----------------------------------
xi.chocoboDig.crystalWeight =
{
    [xi.craftRank.AMATEUR    ] =  440,
    [xi.craftRank.RECRUIT    ] =  560,
    [xi.craftRank.INITIATE   ] =  680,
    [xi.craftRank.NOVICE     ] =  800,
    [xi.craftRank.APPRENTICE ] =  800,
    [xi.craftRank.JOURNEYMAN ] =  800,
    [xi.craftRank.CRAFTSMAN  ] =  800,
    [xi.craftRank.ARTISAN    ] =  800,
    [xi.craftRank.ADEPT      ] =  800,
    [xi.craftRank.VETERAN    ] =  800,
    [xi.craftRank.EXPERT     ] =  800,
}

-----------------------------------
-- Cluster chance. Full weight set at Journeyman Rank.
-----------------------------------
xi.chocoboDig.clusterWeight =
{
    [xi.craftRank.AMATEUR    ] =   80,
    [xi.craftRank.RECRUIT    ] =  160,
    [xi.craftRank.INITIATE   ] =  220,
    [xi.craftRank.NOVICE     ] =  280,
    [xi.craftRank.APPRENTICE ] =  340,
    [xi.craftRank.JOURNEYMAN ] =  400,
    [xi.craftRank.CRAFTSMAN  ] =  400,
    [xi.craftRank.ARTISAN    ] =  400,
    [xi.craftRank.ADEPT      ] =  400,
    [xi.craftRank.VETERAN    ] =  400,
    [xi.craftRank.EXPERT     ] =  400,
}

-----------------------------------
-- Elemental Ore awarded based on the day of the week.
-----------------------------------
xi.chocoboDig.elementalOreByDay =
{
    [xi.day.FIRESDAY         ] = xi.item.CHUNK_OF_FIRE_ORE,
    [xi.day.ICEDAY           ] = xi.item.CHUNK_OF_ICE_ORE,
    [xi.day.WINDSDAY         ] = xi.item.CHUNK_OF_WIND_ORE,
    [xi.day.EARTHSDAY        ] = xi.item.CHUNK_OF_EARTH_ORE,
    [xi.day.LIGHTNINGDAY     ] = xi.item.CHUNK_OF_LIGHTNING_ORE,
    [xi.day.WATERSDAY        ] = xi.item.CHUNK_OF_WATER_ORE,
    [xi.day.LIGHTSDAY        ] = xi.item.CHUNK_OF_LIGHT_ORE,
    [xi.day.DARKSDAY         ] = xi.item.CHUNK_OF_DARK_ORE,
}

-----------------------------------
-- Crystals awarded based on the current weather.
-----------------------------------
xi.chocoboDig.crystalByWeather =
{
    [xi.weather.HOT_SPELL    ] = xi.item.FIRE_CRYSTAL,
    [xi.weather.SNOW         ] = xi.item.ICE_CRYSTAL,
    [xi.weather.WIND         ] = xi.item.WIND_CRYSTAL,
    [xi.weather.DUST_STORM   ] = xi.item.EARTH_CRYSTAL,
    [xi.weather.THUNDER      ] = xi.item.LIGHTNING_CRYSTAL,
    [xi.weather.RAIN         ] = xi.item.WATER_CRYSTAL,
    [xi.weather.AURORAS      ] = xi.item.LIGHT_CRYSTAL,
    [xi.weather.GLOOM        ] = xi.item.DARK_CRYSTAL,
}

-----------------------------------
-- Clusters awarded based on the current weather.
-----------------------------------
xi.chocoboDig.clusterByWeather =
{
    [xi.weather.HEAT_WAVE    ] = xi.item.FIRE_CLUSTER,
    [xi.weather.BLIZZARDS    ] = xi.item.ICE_CLUSTER,
    [xi.weather.GALES        ] = xi.item.WIND_CLUSTER,
    [xi.weather.SAND_STORM   ] = xi.item.EARTH_CLUSTER,
    [xi.weather.THUNDERSTORMS] = xi.item.LIGHTNING_CLUSTER,
    [xi.weather.SQUALL       ] = xi.item.WATER_CLUSTER,
    [xi.weather.STELLAR_GLARE] = xi.item.LIGHT_CLUSTER,
    [xi.weather.DARKNESS     ] = xi.item.DARK_CLUSTER,
}

-----------------------------------
-- Seeds can only be dug up at night.
-----------------------------------
xi.chocoboDig.nightOnlyItems =
set{
    xi.item.BAG_OF_FRUIT_SEEDS,
    xi.item.BAG_OF_GRAIN_SEEDS,
    xi.item.BAG_OF_HERB_SEEDS,
    xi.item.BAG_OF_TREE_CUTTINGS,
    xi.item.BAG_OF_VEGETABLE_SEEDS,
}

-----------------------------------
-- { itemId, weights at rank 0-10 }
-----------------------------------
xi.chocoboDig.zoneTable =
{
    [xi.zone.BATALLIA_DOWNS] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.FLINT_STONE,               910,  910,  910,  910,  910,  910,  910,  910,  910,  910,  910 },
        { xi.item.BONE_CHIP,                 810,  810,  810,  810,  810,  810,  810,  810,  810,  810,  810 },
        { xi.item.CHUNK_OF_COPPER_ORE,       370,  450,  530,  530,  530,  530,  530,  530,  530,  530,  530 },
        { xi.item.CHUNK_OF_IRON_ORE,         145,  200,  255,  310,  365,  365,  365,  365,  365,  365,  365 },
        { xi.item.BIRD_FEATHER,              130,  175,  225,  275,  325,  325,  325,  325,  325,  325,  325 },
        { xi.item.RED_JAR,                    50,  100,  135,  175,  215,  250,  250,  250,  250,  250,  250 },
        { xi.item.PURPLE_ROCK,                40,   80,  115,  145,  175,  205,  205,  205,  205,  205,  205 },
        { xi.item.BLACK_CHOCOBO_FEATHER,       1,    2,    5,   10,   20,   30,   35,   45,   50,   50,   50 },
        { xi.item.REISHI_MUSHROOM,             1,    1,    2,    5,    5,   10,   15,   20,   25,   30,   30 },
    },

    [xi.zone.BUBURIMU_PENINSULA] =
    {
        { xi.item.CHUNK_OF_TIN_ORE,         1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.SEASHELL,                  765,  765,  765,  765,  765,  765,  765,  765,  765,  765,  765 },
        { xi.item.LUGWORM,                   420,  510,  600,  600,  600,  600,  600,  600,  600,  600,  600 },
        { xi.item.GIANT_FEMUR,               310,  385,  450,  450,  450,  450,  450,  450,  450,  450,  450 },
        { xi.item.BIRD_FEATHER,              135,  175,  230,  270,  325,  325,  325,  325,  325,  325,  325 },
        { xi.item.SHELL_BUG,                  95,  170,  235,  310,  375,  435,  435,  435,  435,  435,  435 },
        { xi.item.SHALL_SHELL,                60,  120,  180,  220,  280,  320,  320,  320,  320,  320,  320 },
        { xi.item.CHUNK_OF_PLATINUM_ORE,       1,    1,    2,    5,   10,   15,   20,   25,   35,   35,   35 },
        { xi.item.TURTLE_SHELL,                1,    2,    3,    8,   15,   30,   45,   55,   70,   85,   85 },
    },

    [xi.zone.EAST_RONFAURE] =
    {
        { xi.item.ACORN,                    1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LITTLE_WORM,               875,  875,  875,  875,  875,  875,  875,  875,  875,  875,  875 },
        { xi.item.ARROWWOOD_LOG,             780,  780,  780,  780,  780,  780,  780,  780,  780,  780,  780 },
        { xi.item.CHOCOBO_FEATHER,           455,  535,  535,  535,  535,  535,  535,  535,  535,  535,  535 },
        { xi.item.MAPLE_LOG,                 330,  400,  470,  470,  470,  470,  470,  470,  470,  470,  470 },
        { xi.item.RONFAURE_CHESTNUT,         325,  390,  460,  460,  460,  460,  460,  460,  460,  460,  460 },
        { xi.item.ASH_LOG,                   295,  360,  420,  420,  420,  420,  420,  420,  420,  420,  420 },
        { xi.item.CHESTNUT_LOG,              100,  140,  175,  215,  250,  250,  250,  250,  250,  250,  250 },
        { xi.item.BAG_OF_FRUIT_SEEDS,         25,   35,   70,   95,  120,  145,  170,  170,  170,  170,  170 },
        { xi.item.SPRIG_OF_MISTLETOE,          2,    5,   10,   15,   20,   40,   55,   70,   85,  100,  100 },
    },

    [xi.zone.EAST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LAUAN_LOG,                 930,  930,  930,  930,  930,  930,  930,  930,  930,  930,  930 },
        { xi.item.PAPAKA_GRASS,              825,  825,  825,  825,  825,  825,  825,  825,  825,  825,  825 },
        { xi.item.INSECT_WING,               630,  630,  630,  630,  630,  630,  630,  630,  630,  630,  630 },
        { xi.item.YAGUDO_FEATHER,            330,  420,  510,  600,  600,  600,  600,  600,  600,  600,  600 },
        { xi.item.BIRD_FEATHER,              220,  305,  385,  470,  550,  550,  550,  550,  550,  550,  550 },
        { xi.item.ROSEWOOD_LOG,               55,  110,  150,  190,  230,  275,  275,  275,  275,  275,  275 },
        { xi.item.GREEN_ROCK,                 50,   95,  130,  170,  205,  240,  240,  240,  240,  240,  240 },
        { xi.item.BAG_OF_HERB_SEEDS,          25,   35,   70,   95,  120,  145,  170,  170,  170,  170,  170 },
        { xi.item.BALL_OF_SARUTA_COTTON,      20,   30,   60,   85,  110,  135,  155,  155,  155,  155,  155 },
    },

    [xi.zone.JUGNER_FOREST] =
    {
        { xi.item.ACORN,                    1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.ARROWWOOD_LOG,             745,  745,  745,  745,  745,  745,  745,  745,  745,  745,  745 },
        { xi.item.LITTLE_WORM,               730,  730,  730,  730,  730,  730,  730,  730,  730,  730,  730 },
        { xi.item.MAPLE_LOG,                 505,  615,  725,  725,  725,  725,  725,  725,  725,  725,  725 },
        { xi.item.WILLOW_LOG,                350,  425,  500,  500,  500,  500,  500,  500,  500,  500,  500 },
        { xi.item.HOLLY_LOG,                 290,  355,  415,  415,  415,  415,  415,  415,  415,  415,  415 },
        { xi.item.OAK_LOG,                    55,  110,  150,  190,  230,  270,  270,  270,  270,  270,  270 },
        { xi.item.SCREAM_FUNGUS,              15,   25,   30,   60,   85,  105,  130,  150,  150,  150,  150 },
        { xi.item.SPRIG_OF_MISTLETOE,          2,    5,   10,   15,   20,   40,   55,   70,   85,  100,  100 },
    },

    [xi.zone.KONSCHTAT_HIGHLANDS] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.BONE_CHIP,                 820,  820,  820,  820,  820,  820,  820,  820,  820,  820,  820 },
        { xi.item.FLINT_STONE,               550,  550,  550,  550,  550,  550,  550,  550,  550,  550,  550 },
        { xi.item.HANDFUL_OF_FISH_SCALES,    520,  520,  520,  520,  520,  520,  520,  520,  520,  520,  520 },
        { xi.item.CHUNK_OF_ZINC_ORE,         260,  335,  405,  475,  475,  475,  475,  475,  475,  475,  475 },
        { xi.item.ELM_LOG,                   205,  265,  320,  375,  375,  375,  375,  375,  375,  375,  375 },
        { xi.item.BIRD_FEATHER,              115,  160,  205,  250,  290,  290,  290,  290,  290,  290,  290 },
        { xi.item.LIZARD_MOLT,               110,  155,  200,  240,  280,  280,  280,  280,  280,  280,  280 },
        { xi.item.MYTHRIL_BEASTCOIN,          50,   95,  135,  170,  205,  240,  240,  240,  240,  240,  240 },
        { xi.item.PHOENIX_FEATHER,             1,    2,    5,   10,   15,   20,   40,   50,   65,   80,   95 },
    },

    [xi.zone.LA_THEINE_PLATEAU] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.ARROWWOOD_LOG,             905,  905,  905,  905,  905,  905,  905,  905,  905,  905,  905 },
        { xi.item.LITTLE_WORM,               800,  800,  800,  800,  800,  800,  800,  800,  800,  800,  800 },
        { xi.item.CHUNK_OF_TIN_ORE,          700,  700,  700,  700,  700,  700,  700,  700,  700,  700,  700 },
        { xi.item.CHOCOBO_FEATHER,           340,  400,  400,  400,  400,  400,  400,  400,  400,  400,  400 },
        { xi.item.YEW_LOG,                   195,  245,  300,  350,  350,  350,  350,  350,  350,  350,  350 },
        { xi.item.CHUNK_OF_ZINC_ORE,         170,  215,  265,  310,  310,  310,  310,  310,  310,  310,  310 },
        { xi.item.CHESTNUT_LOG,               85,  115,  145,  175,  205,  205,  205,  205,  205,  205,  205 },
        { xi.item.PINCH_OF_DRIED_MARJORAM,    70,   95,  125,  150,  175,  175,  175,  175,  175,  175,  175 },
        { xi.item.MAHOGANY_LOG,               45,   60,   80,  100,  115,  115,  115,  115,  115,  115,  115 },
    },

    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.FLINT_STONE,               810,  810,  810,  810,  810,  810,  810,  810,  810,  810,  810 },
        { xi.item.INSECT_WING,               635,  635,  635,  635,  635,  635,  635,  635,  635,  635,  635 },
        { xi.item.LIZARD_MOLT,               615,  615,  615,  615,  615,  615,  615,  615,  615,  615,  615 },
        { xi.item.CHUNK_OF_COPPER_ORE,       405,  490,  575,  575,  575,  575,  575,  575,  575,  575,  575 },
        { xi.item.GIANT_FEMUR,               170,  205,  240,  240,  240,  240,  240,  240,  240,  240,  240 },
        { xi.item.YELLOW_ROCK,                35,   70,   95,  125,  150,  175,  175,  175,  175,  175,  175 },
        { xi.item.GOLD_BEASTCOIN,             15,   25,   30,   65,   90,  115,  135,  160,  160,  160,  160 },
        { xi.item.BLACK_CHOCOBO_FEATHER,       2,    5,   10,   15,   30,   40,   50,   60,   70,   70,   70 },
        { xi.item.CHUNK_OF_ADAMAN_ORE,         1,    1,    1,    2,    5,   10,   20,   25,   30,   40,   45 },
    },

    [xi.zone.NORTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.INSECT_WING,               785,  785,  785,  785,  785,  785,  785,  785,  785,  785,  785 },
        { xi.item.LITTLE_WORM,               775,  775,  775,  775,  775,  775,  775,  775,  775,  775,  775 },
        { xi.item.BONE_CHIP,                 625,  625,  625,  625,  625,  625,  625,  625,  625,  625,  625 },
        { xi.item.HANDFUL_OF_FISH_SCALES,    520,  520,  520,  520,  520,  520,  520,  520,  520,  520,  520 },
        { xi.item.LIZARD_MOLT,               365,  365,  365,  365,  365,  365,  365,  365,  365,  365,  365 },
        { xi.item.FLINT_STONE,               120,  120,  120,  120,  120,  120,  120,  120,  120,  120,  120 },
        { xi.item.BIRD_FEATHER,               85,  115,  145,  175,  205,  205,  205,  205,  205,  205,  205 },
        { xi.item.MYTHRIL_BEASTCOIN,          45,   90,  125,  160,  195,  230,  230,  230,  230,  230,  230 },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,     10,   15,   25,   30,   60,   85,  110,  130,  155,  155,  155 },
    },

    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        { xi.item.INSECT_WING,              1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PEBBLE,                    700,  700,  700,  700,  700,  700,  700,  700,  700,  700,  700 },
        { xi.item.LIZARD_MOLT,               615,  615,  615,  615,  615,  615,  615,  615,  615,  615,  615 },
        { xi.item.WILLOW_LOG,                210,  255,  300,  300,  300,  300,  300,  300,  300,  300,  300 },
        { xi.item.CHUNK_OF_SILVER_ORE,       150,  195,  235,  275,  275,  275,  275,  275,  275,  275,  275 },
        { xi.item.MYTHRIL_BEASTCOIN,          50,   95,  130,  165,  200,  235,  235,  235,  235,  235,  235 },
        { xi.item.BLACK_ROCK,                 35,   65,   90,  115,  140,  165,  165,  165,  165,  165,  165 },
        { xi.item.PUFFBALL,                   30,   60,   80,  105,  125,  145,  145,  145,  145,  145,  145 },
        { xi.item.TURTLE_SHELL,                1,    1,    1,    2,    5,   10,   15,   20,   25,   30,   30 },
    },

    [xi.zone.ROLANBERRY_FIELDS] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.FLINT_STONE,               890,  890,  890,  890,  890,  890,  890,  890,  890,  890,  890 },
        { xi.item.LITTLE_WORM,               820,  820,  820,  820,  820,  820,  820,  820,  820,  820,  820 },
        { xi.item.INSECT_WING,               630,  630,  630,  630,  630,  630,  630,  630,  630,  630,  630 },
        { xi.item.SPRIG_OF_SAGE,             240,  330,  420,  510,  600,  600,  600,  600,  600,  600,  600 },
        { xi.item.MYTHRIL_BEASTCOIN,          55,  110,  150,  195,  235,  275,  275,  275,  275,  275,  275 },
        { xi.item.RED_JAR,                    50,  100,  140,  175,  215,  250,  250,  250,  250,  250,  250 },
        { xi.item.CORAL_FUNGUS,               20,   30,   60,   80,  105,  125,  150,  150,  150,  150,  150 },
        { xi.item.GOLD_BEASTCOIN,             10,   15,   20,   40,   55,   70,   85,  100,  100,  100,  100 },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,     1,    1,    1,    2,    5,   10,   20,   30,   35,   45,   50 },
    },

    [xi.zone.SAUROMUGUE_CHAMPAIGN] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.BONE_CHIP,                 685,  685,  685,  685,  685,  685,  685,  685,  685,  685,  685 },
        { xi.item.FLINT_STONE,               665,  665,  665,  665,  665,  665,  665,  665,  665,  665,  665 },
        { xi.item.INSECT_WING,               610,  610,  610,  610,  610,  610,  610,  610,  610,  610,  610 },
        { xi.item.LIZARD_MOLT,               335,  335,  335,  335,  335,  335,  335,  335,  335,  335,  335 },
        { xi.item.CHUNK_OF_IRON_ORE,         130,  185,  230,  280,  330,  330,  330,  330,  330,  330,  330 },
        { xi.item.RED_JAR,                    50,  100,  135,  175,  215,  250,  250,  250,  250,  250,  250 },
        { xi.item.GOLD_BEASTCOIN,             25,   40,   50,  100,  135,  175,  210,  245,  245,  245,  245 },
        { xi.item.BLACK_CHOCOBO_FEATHER,       1,    2,    5,   10,   20,   30,   35,   45,   50,   50,   50 },
    },

    [xi.zone.SOUTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LITTLE_WORM,               910,  910,  910,  910,  910,  910,  910,  910,  910,  910,  910 },
        { xi.item.LIZARD_MOLT,               735,  735,  735,  735,  735,  735,  735,  735,  735,  735,  735 },
        { xi.item.BONE_CHIP,                 635,  635,  635,  635,  635,  635,  635,  635,  635,  635,  635 },
        { xi.item.INSECT_WING,               450,  450,  450,  450,  450,  450,  450,  450,  450,  450,  450 },
        { xi.item.CHUNK_OF_ROCK_SALT,        160,  220,  280,  340,  400,  400,  400,  400,  400,  400,  400 },
        { xi.item.BIRD_FEATHER,              150,  205,  265,  320,  375,  375,  375,  375,  375,  375,  375 },
        { xi.item.MYTHRIL_BEASTCOIN,          70,  140,  190,  240,  295,  345,  345,  345,  345,  345,  345 },
        { xi.item.BAG_OF_GRAIN_SEEDS,         25,   35,   70,   95,  120,  145,  170,  170,  170,  170,  170 },
    },

    [xi.zone.TAHRONGI_CANYON] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.BONE_CHIP,                 875,  875,  875,  875,  875,  875,  875,  875,  875,  875,  875 },
        { xi.item.SEASHELL,                  800,  800,  800,  800,  800,  800,  800,  800,  800,  800,  800 },
        { xi.item.CHUNK_OF_TIN_ORE,          550,  550,  550,  550,  550,  550,  550,  550,  550,  550,  550 },
        { xi.item.INSECT_WING,               450,  450,  450,  450,  450,  450,  450,  450,  450,  450,  450 },
        { xi.item.YAGUDO_FEATHER,            220,  280,  340,  400,  400,  400,  400,  400,  400,  400,  400 },
        { xi.item.GIANT_FEMUR,               150,  205,  265,  320,  375,  375,  375,  375,  375,  375,  375 },
        { xi.item.RED_ROCK,                   45,   90,  125,  160,  190,  225,  225,  225,  225,  225,  225 },
        { xi.item.CHUNK_OF_GOLD_ORE,          20,   30,   40,   80,  110,  140,  170,  195,  195,  195,  195 },
    },

    [xi.zone.VALKURM_DUNES] =
    {
        { xi.item.SEASHELL,                 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.BONE_CHIP,                 755,  755,  755,  755,  755,  755,  755,  755,  755,  755,  755 },
        { xi.item.HANDFUL_OF_FISH_SCALES,    470,  470,  470,  470,  470,  470,  470,  470,  470,  470,  470 },
        { xi.item.LIZARD_MOLT,               435,  435,  435,  435,  435,  435,  435,  435,  435,  435,  435 },
        { xi.item.LUGWORM,                   315,  385,  450,  450,  450,  450,  450,  450,  450,  450,  450 },
        { xi.item.GIANT_FEMUR,               175,  215,  250,  250,  250,  250,  250,  250,  250,  250,  250 },
        { xi.item.SHALL_SHELL,                40,   75,  105,  135,  160,  190,  190,  190,  190,  190,  190 },
        { xi.item.SHELL_BUG,                  25,   50,   75,   90,  110,  130,  130,  130,  130,  130,  130 },
        { xi.item.TURTLE_SHELL,                1,    2,    5,   10,   15,   30,   40,   55,   65,   75,   75 },
    },

    [xi.zone.WEST_RONFAURE] =
    {
        { xi.item.LITTLE_WORM,              1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.ACORN,                    1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000 },
        { xi.item.ARROWWOOD_LOG,             900,  900,  900,  900,  900,  900,  900,  900,  900,  900,  900 },
        { xi.item.CLUMP_OF_MOKO_GRASS,       450,  450,  450,  450,  450,  450,  450,  450,  450,  450,  450 },
        { xi.item.CHOCOBO_FEATHER,           425,  500,  500,  500,  500,  500,  500,  500,  500,  500,  500 },
        { xi.item.MAPLE_LOG,                 385,  470,  550,  550,  550,  550,  550,  550,  550,  550,  550 },
        { xi.item.ASH_LOG,                   245,  300,  350,  350,  350,  350,  350,  350,  350,  350,  350 },
        { xi.item.RONFAURE_CHESTNUT,          90,  105,  125,  125,  125,  125,  125,  125,  125,  125,  125 },
        { xi.item.CHESTNUT_LOG,               60,   80,  105,  130,  150,  150,  150,  150,  150,  150,  150 },
        { xi.item.BAG_OF_VEGETABLE_SEEDS,     25,   35,   70,   95,  120,  145,  170,  170,  170,  170,  170 },
        { xi.item.SPRIG_OF_MISTLETOE,          0,    5,   10,   15,   20,   40,   55,   70,   85,  100,  100 },
    },

    [xi.zone.WEST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LITTLE_WORM,               830,  830,  830,  830,  830,  830,  830,  830,  830,  830,  830 },
        { xi.item.LAUAN_LOG,                 740,  740,  740,  740,  740,  740,  740,  740,  740,  740,  740 },
        { xi.item.INSECT_WING,               565,  565,  565,  565,  565,  565,  565,  565,  565,  565,  565 },
        { xi.item.CLUMP_OF_MOKO_GRASS,       435,  435,  435,  435,  435,  435,  435,  435,  435,  435,  435 },
        { xi.item.YAGUDO_FEATHER,            215,  275,  330,  390,  390,  390,  390,  390,  390,  390,  390 },
        { xi.item.BIRD_FEATHER,              105,  145,  180,  220,  260,  260,  260,  260,  260,  260,  260 },
        { xi.item.BALL_OF_SARUTA_COTTON,      35,   50,   95,  130,  170,  205,  240,  240,  240,  240,  240 },
        { xi.item.BAG_OF_TREE_CUTTINGS,       25,   35,   70,   95,  120,  145,  170,  170,  170,  170,  170 },
    },

    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,                1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PEBBLE,                    740,  690,  640,  590,  540,  490,  490,  490,  490,  490,  490 },
        { xi.item.GIANT_FEMUR,               425,  500,  500,  500,  500,  500,  500,  500,  500,  500,  500 },
        { xi.item.CHUNK_OF_ZINC_ORE,         180,  230,  280,  330,  330,  330,  330,  330,  330,  330,  330 },
        { xi.item.CHUNK_OF_SILVER_ORE,       125,  160,  190,  225,  225,  225,  225,  225,  225,  225,  225 },
        { xi.item.HANDFUL_OF_WYVERN_SCALES,   25,   35,   45,   90,  125,  160,  195,  230,  230,  230,  230 },
        { xi.item.CHUNK_OF_MYTHRIL_ORE,       20,   25,   35,   70,   95,  120,  150,  175,  175,  175,  175 },
        { xi.item.CHUNK_OF_PLATINUM_ORE,       5,   10,   15,   20,   40,   60,   75,   90,  105,  105,  105 },
        { xi.item.PHILOSOPHERS_STONE,          1,    1,    2,    5,   10,   15,   20,   30,   35,   40,   40 },
    },

    [xi.zone.THE_SANCTUARY_OF_ZITAH] =
    {
        { xi.item.PEBBLE,                   1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.BONE_CHIP,                 750,  750,  750,  750,  750,  750,  750,  750,  750,  750,  750 },
        { xi.item.CLUMP_OF_MOKO_GRASS,       715,  715,  715,  715,  715,  715,  715,  715,  715,  715,  715 },
        { xi.item.ARROWWOOD_LOG,             570,  570,  570,  570,  570,  570,  570,  570,  570,  570,  570 },
        { xi.item.YEW_LOG,                   195,  250,  300,  355,  355,  355,  355,  355,  355,  355,  355 },
        { xi.item.ELM_LOG,                   165,  210,  255,  300,  300,  300,  300,  300,  300,  300,  300 },
        { xi.item.TRANSLUCENT_ROCK,           35,   70,   95,  120,  150,  175,  175,  175,  175,  175,  175 },
        { xi.item.KING_TRUFFLE,                0,    0,    5,    5,   10,   10,   20,   30,   35,   45,   50 },
    },

    [xi.zone.WESTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,                1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PEBBLE,                    650,  650,  650,  650,  650,  650,  650,  650,  650,  650,  650 },
        { xi.item.GIANT_FEMUR,               445,  525,  525,  525,  525,  525,  525,  525,  525,  525,  525 },
        { xi.item.CHUNK_OF_ZINC_ORE,         215,  275,  330,  390,  390,  390,  390,  390,  390,  390,  390 },
        { xi.item.CHUNK_OF_IRON_ORE,         100,  140,  175,  215,  250,  250,  250,  250,  250,  250,  250 },
        { xi.item.CORAL_FRAGMENT,             30,   45,   90,  125,  135,  190,  225,  225,  225,  225,  225 },
        { xi.item.CHUNK_OF_GOLD_ORE,          20,   30,   40,   80,  110,  140,  170,  195,  195,  195,  195 },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,      2,    5,   10,   15,   30,   45,   55,   65,   80,   80,   80 },
        { xi.item.PHILOSOPHERS_STONE,          1,    1,    2,    5,   10,   20,   30,   35,   45,   50,   50 },
    },

    [xi.zone.YHOATOR_JUNGLE] =
    {
        { xi.item.BONE_CHIP,                1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LAUAN_LOG,                 545,  545,  545,  545,  545,  545,  545,  545,  545,  545,  545 },
        { xi.item.KAZHAM_PINEAPPLE,          540,  540,  540,  540,  540,  540,  540,  540,  540,  540,  540 },
        { xi.item.DRYAD_ROOT,                365,  365,  365,  365,  365,  365,  365,  365,  365,  365,  365 },
        { xi.item.MAHOGANY_LOG,              155,  175,  195,  215,  330,  390,  390,  390,  390,  390,  390 },
        { xi.item.EBONY_LOG,                  55,   85,  115,  150,  210,  270,  270,  270,  270,  270,  270 },
        { xi.item.CORAL_FUNGUS,               20,   25,   55,   75,   95,  115,  135,  135,  135,  135,  135 },
        { xi.item.PETRIFIED_LOG,              10,   15,   20,   35,   50,   65,   75,   90,   90,   90,   90 },
        { xi.item.REISHI_MUSHROOM,             2,    5,   10,   15,   25,   35,   45,   55,   65,   65,   65 },
    },

    [xi.zone.YUHTUNGA_JUNGLE] =
    {
        { xi.item.BONE_CHIP,                1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PIECE_OF_RATTAN_LUMBER,    750,  750,  750,  750,  750,  750,  750,  750,  750,  750,  750 },
        { xi.item.STICK_OF_CINNAMON,         560,  560,  560,  560,  560,  560,  560,  560,  560,  560,  560 },
        { xi.item.DANCESHROOM,               275,  335,  395,  395,  395,  395,  395,  395,  395,  395,  395 },
        { xi.item.ROSEWOOD_LOG,              100,  135,  170,  210,  245,  245,  245,  245,  245,  245,  245 },
        { xi.item.EBONY_LOG,                  35,   70,   95,  120,  145,  170,  170,  170,  170,  170,  170 },
        { xi.item.PETRIFIED_LOG,              15,   25,   30,   60,   85,  110,  130,  155,  155,  155,  155 },
        { xi.item.PUFFBALL,                    2,    5,   10,   15,   20,   40,   55,   70,   85,  100,  100 },
        { xi.item.KING_TRUFFLE,                1,    1,    2,    5,   10,   10,   20,   30,   35,   45,   50 },
    },

    [xi.zone.BIBIKI_BAY] =
    {
        { xi.item.SEASHELL,                 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.CHUNK_OF_TIN_ORE,          875,  875,  875,  875,  875,  875,  875,  875,  875,  875,  875 },
        { xi.item.LUGWORM,                   560,  675,  795,  795,  795,  795,  795,  795,  795,  795,  795 },
        { xi.item.GIANT_FEMUR,               280,  345,  400,  400,  400,  400,  400,  400,  400,  400,  400 },
        { xi.item.BIRD_FEATHER,              320,  445,  560,  675,  795,  795,  795,  795,  795,  795,  795 },
        { xi.item.SHALL_SHELL,                60,  125,  170,  220,  260,  310,  310,  310,  310,  310,  310 },
        { xi.item.SHELL_BUG,                  85,  160,  220,  285,  345,  405,  405,  405,  405,  405,  405 },
        { xi.item.TURTLE_SHELL,                2,    5,   10,   15,   25,   40,   55,   70,   85,  100,  100 },
    },

    [xi.zone.CARPENTERS_LANDING] =
    {
        { xi.item.ACORN,                    1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.LITTLE_WORM,               835,  835,  835,  835,  835,  835,  835,  835,  835,  835,  835 },
        { xi.item.ARROWWOOD_LOG,             610,  610,  610,  610,  610,  610,  610,  610,  610,  610,  610 },
        { xi.item.MAPLE_LOG,                 530,  645,  760,  760,  760,  760,  760,  760,  760,  760,  760 },
        { xi.item.HOLLY_LOG,                 270,  325,  385,  385,  385,  385,  385,  385,  385,  385,  385 },
        { xi.item.WILLOW_LOG,                265,  320,  375,  375,  375,  375,  375,  375,  375,  375,  375 },
        { xi.item.OAK_LOG,                    35,   75,  100,  130,  155,  185,  185,  185,  185,  185,  185 },
        { xi.item.SCREAM_FUNGUS,              15,   20,   25,   50,   70,   90,  110,  130,  130,  130,  130 },
        { xi.item.SPRIG_OF_MISTLETOE,          2,    5,   10,   15,   20,   40,   55,   70,   85,  100,  100 },
        { xi.item.KING_TRUFFLE,                1,    1,    2,    5,   10,   10,   20,   30,   35,   45,   50 },
    },

    [xi.zone.BHAFLAU_THICKETS] =
    {
        { xi.item.PINCH_OF_DRIED_MARJORAM,  1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PEBBLE,                    650,  650,  650,  650,  650,  650,  650,  650,  650,  650,  650 },
        { xi.item.HANDFUL_OF_PINE_NUTS,      470,  550,  550,  550,  550,  550,  550,  550,  550,  550,  550 },
        { xi.item.COLIBRI_FEATHER,            80,  150,  215,  280,  345,  430,  430,  430,  430,  430,  430 },
        { xi.item.PETRIFIED_LOG,              50,   70,  135,  190,  240,  290,  340,  340,  340,  340,  340 },
        { xi.item.BLUE_ROCK,                  15,   25,   45,   90,  125,  160,  200,  250,  250,  250,  250 },
        { xi.item.LESSER_CHIGOE,              10,   15,   20,   30,   60,   80,  100,  125,  145,  145,  145 },
        { xi.item.SPIDER_WEB,                  1,    2,    5,   10,   15,   30,   40,   50,   60,   75,   75 },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,     1,    1,    1,    1,    2,    5,   10,   15,   20,   30,   40 },
    },

    [xi.zone.WAJAOM_WOODLANDS] =
    {
        { xi.item.CLUMP_OF_MOKO_GRASS,      1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250, 1250 },
        { xi.item.PEBBLE,                    900,  900,  900,  900,  900,  900,  900,  900,  900,  900,  900 },
        { xi.item.HANDFUL_OF_PINE_NUTS,      480,  600,  600,  600,  600,  600,  600,  600,  600,  600,  600 },
        { xi.item.BLACK_CHOCOBO_FEATHER,     315,  315,  315,  315,  315,  315,  315,  315,  315,  315,  315 },
        { xi.item.BLUE_ROCK,                  40,   80,  110,  140,  170,  200,  200,  200,  200,  200,  200 },
        { xi.item.EBONY_LOG,                  35,   45,   90,  125,  160,  190,  220,  220,  220,  220,  220 },
        { xi.item.PEPHREDO_HIVE_CHIP,          1,    2,    5,   15,   25,   40,   60,   85,  110,  110,  110 },
        { xi.item.SPIDER_WEB,                  1,    2,    3,    8,   15,   30,   45,   55,   65,   80,   80 },
        { xi.item.CHUNK_OF_ADAMAN_ORE,         1,    1,    2,    5,    5,   10,   15,   20,   25,   30,   40 },
    }
}

local function regularEntries(player, zoneId, rank)
    local entries = {}
    local hour    = VanadielHour()
    local isNight = hour >= 20 or hour < 4

    for _, row in ipairs(xi.chocoboDig.zoneTable[zoneId]) do
        local weight = row[rank + 2]

        if
            weight > 0 and
            (isNight or not xi.chocoboDig.nightOnlyItems[row[1]])
        then
            table.insert(entries, { itemId = row[1], weight = weight })
        end
    end

    local weather         = player:getWeather(true)
    local crystal         = xi.chocoboDig.crystalByWeather[weather]
    local cluster         = xi.chocoboDig.clusterByWeather[weather]
    local isActiveWeather = weather ~= xi.weather.NONE and weather ~= xi.weather.SUNSHINE and weather ~= xi.weather.CLOUDS

    if crystal then
        table.insert(entries, { itemId = crystal, weight = xi.chocoboDig.crystalWeight[rank] })
    end

    if cluster then
        table.insert(entries, { itemId = cluster, weight = xi.chocoboDig.clusterWeight[rank] })
    end

    if
        xi.chocoboDig.elementalOreZones[zoneId] and
        isActiveWeather and
        getVanadielMoonCycle() == xi.moonCycle.LESSER_WAXING_CRESCENT and
        xi.chocoboDig.elementalOreWeight[rank] > 0
    then
        table.insert(entries, { itemId = xi.chocoboDig.elementalOreByDay[VanadielDayOfTheWeek()], weight = xi.chocoboDig.elementalOreWeight[rank] })
    end

    return entries
end

m:addOverride('xi.chocoboDig.rollLayer', function(player, zoneId, currentLayer, chocobo)
    if not xi.chocoboDig.zoneTable[zoneId] then
        return super(player, zoneId, currentLayer, chocobo)
    end

    if currentLayer == xi.chocoboDig.layer.TREASURE then
        return 0
    end

    if currentLayer ~= xi.chocoboDig.layer.REGULAR then
        return super(player, zoneId, currentLayer, chocobo)
    end

    local rank = player:getSkillRank(xi.skill.DIG)

    if math.randomInt(1, 100) > xi.chocoboDig.accuracy[rank] then
        return 0
    end

    return utils.selectFromLootGroups(player, { regularEntries(player, zoneId, rank) })[1].itemId
end)

return m
