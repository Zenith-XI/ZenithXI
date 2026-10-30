-----------------------------------
-- Era chocobo digging loot (ZENITHDEV-273)
-- The regular digging pools of 26 zones go back to the historical items in Phoenix's pxi_digging_data.lua. Zones
-- Phoenix has no data for keep their LSB pool. Only the pools change: LSB still decides success, skill-ups, fatigue
-- and the treasure, burrow and bore layers. Seeds can only be dug up at night, as in the Phoenix data.
--
-- Phoenix draws one item by weights that grow with the digging rank, LSB gives each item its own roll out of
-- 1000 and a minimum rank. So each row is { item, LSB chance, Phoenix item rank }, with the chance being the
-- Phoenix weight at full rank divided by 12.5: the most common items are 100 out of 1000, like LSB's own.
-----------------------------------
require('modules/module_utils')
require('scripts/globals/hobbies/chocobo_digging/data')
-----------------------------------
local m = Module:new('c_eraDiggingLoot')

local nightOnlyItems =
{
    [xi.item.BAG_OF_FRUIT_SEEDS    ] = true,
    [xi.item.BAG_OF_GRAIN_SEEDS    ] = true,
    [xi.item.BAG_OF_HERB_SEEDS     ] = true,
    [xi.item.BAG_OF_TREE_CUTTINGS  ] = true,
    [xi.item.BAG_OF_VEGETABLE_SEEDS] = true,
}

local eraPools =
{
    [xi.zone.BATALLIA_DOWNS] =
    {
        { xi.item.PEBBLE,                100, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,            73, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,              65, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_COPPER_ORE,    42, xi.craftRank.INITIATE },
        { xi.item.CHUNK_OF_IRON_ORE,      29, xi.craftRank.APPRENTICE },
        { xi.item.BIRD_FEATHER,           26, xi.craftRank.APPRENTICE },
        { xi.item.RED_JAR,                20, xi.craftRank.JOURNEYMAN },
        { xi.item.PURPLE_ROCK,            16, xi.craftRank.JOURNEYMAN },
        { xi.item.BLACK_CHOCOBO_FEATHER,   4, xi.craftRank.ADEPT },
        { xi.item.REISHI_MUSHROOM,         2, xi.craftRank.VETERAN },
    },

    [xi.zone.BUBURIMU_PENINSULA] =
    {
        { xi.item.CHUNK_OF_TIN_ORE,      100, xi.craftRank.AMATEUR },
        { xi.item.SEASHELL,               61, xi.craftRank.AMATEUR },
        { xi.item.LUGWORM,                48, xi.craftRank.INITIATE },
        { xi.item.GIANT_FEMUR,            36, xi.craftRank.INITIATE },
        { xi.item.BIRD_FEATHER,           26, xi.craftRank.APPRENTICE },
        { xi.item.SHELL_BUG,              35, xi.craftRank.JOURNEYMAN },
        { xi.item.SHALL_SHELL,            26, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_PLATINUM_ORE,   3, xi.craftRank.ADEPT },
        { xi.item.TURTLE_SHELL,            7, xi.craftRank.VETERAN },
    },

    [xi.zone.EAST_RONFAURE] =
    {
        { xi.item.ACORN,              100, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,         70, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,       62, xi.craftRank.AMATEUR },
        { xi.item.CHOCOBO_FEATHER,     43, xi.craftRank.RECRUIT },
        { xi.item.MAPLE_LOG,           38, xi.craftRank.INITIATE },
        { xi.item.RONFAURE_CHESTNUT,   37, xi.craftRank.INITIATE },
        { xi.item.ASH_LOG,             34, xi.craftRank.INITIATE },
        { xi.item.CHESTNUT_LOG,        20, xi.craftRank.APPRENTICE },
        { xi.item.BAG_OF_FRUIT_SEEDS,  14, xi.craftRank.CRAFTSMAN },
        { xi.item.SPRIG_OF_MISTLETOE,   8, xi.craftRank.VETERAN },
    },

    [xi.zone.EAST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                100, xi.craftRank.AMATEUR },
        { xi.item.LAUAN_LOG,              74, xi.craftRank.AMATEUR },
        { xi.item.PAPAKA_GRASS,           66, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,            50, xi.craftRank.AMATEUR },
        { xi.item.YAGUDO_FEATHER,         48, xi.craftRank.NOVICE },
        { xi.item.BIRD_FEATHER,           44, xi.craftRank.APPRENTICE },
        { xi.item.ROSEWOOD_LOG,           22, xi.craftRank.APPRENTICE },
        { xi.item.GREEN_ROCK,             19, xi.craftRank.JOURNEYMAN },
        { xi.item.BAG_OF_HERB_SEEDS,      14, xi.craftRank.CRAFTSMAN },
        { xi.item.BALL_OF_SARUTA_COTTON,  12, xi.craftRank.CRAFTSMAN },
    },

    [xi.zone.JUGNER_FOREST] =
    {
        { xi.item.ACORN,              100, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,       60, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,         58, xi.craftRank.AMATEUR },
        { xi.item.MAPLE_LOG,           58, xi.craftRank.INITIATE },
        { xi.item.WILLOW_LOG,          40, xi.craftRank.INITIATE },
        { xi.item.HOLLY_LOG,           33, xi.craftRank.INITIATE },
        { xi.item.OAK_LOG,             22, xi.craftRank.JOURNEYMAN },
        { xi.item.SCREAM_FUNGUS,       12, xi.craftRank.ARTISAN },
        { xi.item.SPRIG_OF_MISTLETOE,   8, xi.craftRank.VETERAN },
    },

    [xi.zone.KONSCHTAT_HIGHLANDS] =
    {
        { xi.item.PEBBLE,                 100, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,               66, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,             44, xi.craftRank.AMATEUR },
        { xi.item.HANDFUL_OF_FISH_SCALES,  42, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_ZINC_ORE,       38, xi.craftRank.NOVICE },
        { xi.item.ELM_LOG,                 30, xi.craftRank.NOVICE },
        { xi.item.BIRD_FEATHER,            23, xi.craftRank.APPRENTICE },
        { xi.item.LIZARD_MOLT,             22, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,       19, xi.craftRank.JOURNEYMAN },
        { xi.item.PHOENIX_FEATHER,          8, xi.craftRank.EXPERT },
    },

    [xi.zone.LA_THEINE_PLATEAU] =
    {
        { xi.item.PEBBLE,                  100, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,            72, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,              64, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_TIN_ORE,         56, xi.craftRank.AMATEUR },
        { xi.item.CHOCOBO_FEATHER,          32, xi.craftRank.RECRUIT },
        { xi.item.YEW_LOG,                  28, xi.craftRank.NOVICE },
        { xi.item.CHUNK_OF_ZINC_ORE,        25, xi.craftRank.NOVICE },
        { xi.item.CHESTNUT_LOG,             16, xi.craftRank.APPRENTICE },
        { xi.item.PINCH_OF_DRIED_MARJORAM,  14, xi.craftRank.APPRENTICE },
        { xi.item.MAHOGANY_LOG,              9, xi.craftRank.APPRENTICE },
    },

    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        { xi.item.PEBBLE,                100, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,            65, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,            51, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,            49, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_COPPER_ORE,    46, xi.craftRank.INITIATE },
        { xi.item.GIANT_FEMUR,            19, xi.craftRank.INITIATE },
        { xi.item.YELLOW_ROCK,            14, xi.craftRank.JOURNEYMAN },
        { xi.item.GOLD_BEASTCOIN,         13, xi.craftRank.ARTISAN },
        { xi.item.BLACK_CHOCOBO_FEATHER,   6, xi.craftRank.ADEPT },
        { xi.item.CHUNK_OF_ADAMAN_ORE,     4, xi.craftRank.EXPERT },
    },

    [xi.zone.NORTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,                 100, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,             63, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,             62, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,               50, xi.craftRank.AMATEUR },
        { xi.item.HANDFUL_OF_FISH_SCALES,  42, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,             29, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,             10, xi.craftRank.AMATEUR },
        { xi.item.BIRD_FEATHER,            16, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,       18, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,  12, xi.craftRank.ADEPT },
    },

    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        { xi.item.INSECT_WING,         100, xi.craftRank.AMATEUR },
        { xi.item.PEBBLE,               56, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,          49, xi.craftRank.AMATEUR },
        { xi.item.WILLOW_LOG,           24, xi.craftRank.INITIATE },
        { xi.item.CHUNK_OF_SILVER_ORE,  22, xi.craftRank.NOVICE },
        { xi.item.MYTHRIL_BEASTCOIN,    19, xi.craftRank.JOURNEYMAN },
        { xi.item.BLACK_ROCK,           13, xi.craftRank.JOURNEYMAN },
        { xi.item.PUFFBALL,             12, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,          2, xi.craftRank.VETERAN },
    },

    [xi.zone.ROLANBERRY_FIELDS] =
    {
        { xi.item.PEBBLE,                  100, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,              71, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,              66, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,              50, xi.craftRank.AMATEUR },
        { xi.item.SPRIG_OF_SAGE,            48, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,        22, xi.craftRank.JOURNEYMAN },
        { xi.item.RED_JAR,                  20, xi.craftRank.JOURNEYMAN },
        { xi.item.CORAL_FUNGUS,             12, xi.craftRank.CRAFTSMAN },
        { xi.item.GOLD_BEASTCOIN,            8, xi.craftRank.ARTISAN },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,   4, xi.craftRank.EXPERT },
    },

    [xi.zone.SAUROMUGUE_CHAMPAIGN] =
    {
        { xi.item.PEBBLE,                100, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,              55, xi.craftRank.AMATEUR },
        { xi.item.FLINT_STONE,            53, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,            49, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,            27, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_IRON_ORE,      26, xi.craftRank.APPRENTICE },
        { xi.item.RED_JAR,                20, xi.craftRank.JOURNEYMAN },
        { xi.item.GOLD_BEASTCOIN,         20, xi.craftRank.ARTISAN },
        { xi.item.BLACK_CHOCOBO_FEATHER,   4, xi.craftRank.ADEPT },
    },

    [xi.zone.SOUTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,             100, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,         73, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,         59, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,           51, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,         36, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_ROCK_SALT,  32, xi.craftRank.APPRENTICE },
        { xi.item.BIRD_FEATHER,        30, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,   28, xi.craftRank.JOURNEYMAN },
        { xi.item.BAG_OF_GRAIN_SEEDS,  14, xi.craftRank.CRAFTSMAN },
    },

    [xi.zone.TAHRONGI_CANYON] =
    {
        { xi.item.PEBBLE,            100, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,          70, xi.craftRank.AMATEUR },
        { xi.item.SEASHELL,           64, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_TIN_ORE,   44, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,        36, xi.craftRank.AMATEUR },
        { xi.item.YAGUDO_FEATHER,     32, xi.craftRank.NOVICE },
        { xi.item.GIANT_FEMUR,        30, xi.craftRank.APPRENTICE },
        { xi.item.RED_ROCK,           18, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_GOLD_ORE,  16, xi.craftRank.ARTISAN },
    },

    [xi.zone.VALKURM_DUNES] =
    {
        { xi.item.SEASHELL,               100, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,               60, xi.craftRank.AMATEUR },
        { xi.item.HANDFUL_OF_FISH_SCALES,  38, xi.craftRank.AMATEUR },
        { xi.item.LIZARD_MOLT,             35, xi.craftRank.AMATEUR },
        { xi.item.LUGWORM,                 36, xi.craftRank.INITIATE },
        { xi.item.GIANT_FEMUR,             20, xi.craftRank.INITIATE },
        { xi.item.SHALL_SHELL,             15, xi.craftRank.JOURNEYMAN },
        { xi.item.SHELL_BUG,               10, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,             6, xi.craftRank.VETERAN },
    },

    [xi.zone.WEST_RONFAURE] =
    {
        { xi.item.LITTLE_WORM,            100, xi.craftRank.AMATEUR },
        { xi.item.ACORN,                   80, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,           72, xi.craftRank.AMATEUR },
        { xi.item.CLUMP_OF_MOKO_GRASS,     36, xi.craftRank.AMATEUR },
        { xi.item.CHOCOBO_FEATHER,         40, xi.craftRank.RECRUIT },
        { xi.item.MAPLE_LOG,               44, xi.craftRank.INITIATE },
        { xi.item.ASH_LOG,                 28, xi.craftRank.INITIATE },
        { xi.item.RONFAURE_CHESTNUT,       10, xi.craftRank.INITIATE },
        { xi.item.CHESTNUT_LOG,            12, xi.craftRank.APPRENTICE },
        { xi.item.BAG_OF_VEGETABLE_SEEDS,  14, xi.craftRank.CRAFTSMAN },
        { xi.item.SPRIG_OF_MISTLETOE,       8, xi.craftRank.VETERAN },
    },

    [xi.zone.WEST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                100, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,            66, xi.craftRank.AMATEUR },
        { xi.item.LAUAN_LOG,              59, xi.craftRank.AMATEUR },
        { xi.item.INSECT_WING,            45, xi.craftRank.AMATEUR },
        { xi.item.CLUMP_OF_MOKO_GRASS,    35, xi.craftRank.AMATEUR },
        { xi.item.YAGUDO_FEATHER,         31, xi.craftRank.NOVICE },
        { xi.item.BIRD_FEATHER,           21, xi.craftRank.APPRENTICE },
        { xi.item.BALL_OF_SARUTA_COTTON,  19, xi.craftRank.CRAFTSMAN },
        { xi.item.BAG_OF_TREE_CUTTINGS,   14, xi.craftRank.CRAFTSMAN },
    },

    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,                100, xi.craftRank.AMATEUR },
        { xi.item.PEBBLE,                    39, xi.craftRank.AMATEUR },
        { xi.item.GIANT_FEMUR,               40, xi.craftRank.RECRUIT },
        { xi.item.CHUNK_OF_ZINC_ORE,         26, xi.craftRank.NOVICE },
        { xi.item.CHUNK_OF_SILVER_ORE,       18, xi.craftRank.NOVICE },
        { xi.item.HANDFUL_OF_WYVERN_SCALES,  18, xi.craftRank.ARTISAN },
        { xi.item.CHUNK_OF_MYTHRIL_ORE,      14, xi.craftRank.ARTISAN },
        { xi.item.CHUNK_OF_PLATINUM_ORE,      8, xi.craftRank.ADEPT },
        { xi.item.PHILOSOPHERS_STONE,         3, xi.craftRank.VETERAN },
    },

    [xi.zone.THE_SANCTUARY_OF_ZITAH] =
    {
        { xi.item.PEBBLE,              100, xi.craftRank.AMATEUR },
        { xi.item.BONE_CHIP,            60, xi.craftRank.AMATEUR },
        { xi.item.CLUMP_OF_MOKO_GRASS,  57, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,        46, xi.craftRank.AMATEUR },
        { xi.item.YEW_LOG,              28, xi.craftRank.NOVICE },
        { xi.item.ELM_LOG,              24, xi.craftRank.NOVICE },
        { xi.item.TRANSLUCENT_ROCK,     14, xi.craftRank.JOURNEYMAN },
        { xi.item.KING_TRUFFLE,          4, xi.craftRank.EXPERT },
    },

    [xi.zone.WESTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,              100, xi.craftRank.AMATEUR },
        { xi.item.PEBBLE,                  52, xi.craftRank.AMATEUR },
        { xi.item.GIANT_FEMUR,             42, xi.craftRank.RECRUIT },
        { xi.item.CHUNK_OF_ZINC_ORE,       31, xi.craftRank.NOVICE },
        { xi.item.CHUNK_OF_IRON_ORE,       20, xi.craftRank.APPRENTICE },
        { xi.item.CORAL_FRAGMENT,          18, xi.craftRank.CRAFTSMAN },
        { xi.item.CHUNK_OF_GOLD_ORE,       16, xi.craftRank.ARTISAN },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,   6, xi.craftRank.ADEPT },
        { xi.item.PHILOSOPHERS_STONE,       4, xi.craftRank.VETERAN },
    },

    [xi.zone.YHOATOR_JUNGLE] =
    {
        { xi.item.BONE_CHIP,        100, xi.craftRank.AMATEUR },
        { xi.item.LAUAN_LOG,         44, xi.craftRank.AMATEUR },
        { xi.item.KAZHAM_PINEAPPLE,  43, xi.craftRank.AMATEUR },
        { xi.item.DRYAD_ROOT,        29, xi.craftRank.AMATEUR },
        { xi.item.MAHOGANY_LOG,      31, xi.craftRank.JOURNEYMAN },
        { xi.item.EBONY_LOG,         22, xi.craftRank.JOURNEYMAN },
        { xi.item.CORAL_FUNGUS,      11, xi.craftRank.CRAFTSMAN },
        { xi.item.PETRIFIED_LOG,      7, xi.craftRank.ARTISAN },
        { xi.item.REISHI_MUSHROOM,    5, xi.craftRank.ADEPT },
    },

    [xi.zone.YUHTUNGA_JUNGLE] =
    {
        { xi.item.BONE_CHIP,              100, xi.craftRank.AMATEUR },
        { xi.item.PIECE_OF_RATTAN_LUMBER,  60, xi.craftRank.AMATEUR },
        { xi.item.STICK_OF_CINNAMON,       45, xi.craftRank.AMATEUR },
        { xi.item.DANCESHROOM,             32, xi.craftRank.INITIATE },
        { xi.item.ROSEWOOD_LOG,            20, xi.craftRank.APPRENTICE },
        { xi.item.EBONY_LOG,               14, xi.craftRank.JOURNEYMAN },
        { xi.item.PETRIFIED_LOG,           12, xi.craftRank.ARTISAN },
        { xi.item.PUFFBALL,                 8, xi.craftRank.VETERAN },
        { xi.item.KING_TRUFFLE,             4, xi.craftRank.EXPERT },
    },

    [xi.zone.BIBIKI_BAY] =
    {
        { xi.item.SEASHELL,         100, xi.craftRank.AMATEUR },
        { xi.item.CHUNK_OF_TIN_ORE,  70, xi.craftRank.AMATEUR },
        { xi.item.LUGWORM,           64, xi.craftRank.INITIATE },
        { xi.item.GIANT_FEMUR,       32, xi.craftRank.INITIATE },
        { xi.item.BIRD_FEATHER,      64, xi.craftRank.APPRENTICE },
        { xi.item.SHALL_SHELL,       25, xi.craftRank.JOURNEYMAN },
        { xi.item.SHELL_BUG,         32, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,       8, xi.craftRank.VETERAN },
    },

    [xi.zone.CARPENTERS_LANDING] =
    {
        { xi.item.ACORN,              100, xi.craftRank.AMATEUR },
        { xi.item.LITTLE_WORM,         67, xi.craftRank.AMATEUR },
        { xi.item.ARROWWOOD_LOG,       49, xi.craftRank.AMATEUR },
        { xi.item.MAPLE_LOG,           61, xi.craftRank.INITIATE },
        { xi.item.HOLLY_LOG,           31, xi.craftRank.INITIATE },
        { xi.item.WILLOW_LOG,          30, xi.craftRank.INITIATE },
        { xi.item.OAK_LOG,             15, xi.craftRank.JOURNEYMAN },
        { xi.item.SCREAM_FUNGUS,       10, xi.craftRank.ARTISAN },
        { xi.item.SPRIG_OF_MISTLETOE,   8, xi.craftRank.VETERAN },
        { xi.item.KING_TRUFFLE,         4, xi.craftRank.EXPERT },
    },

    [xi.zone.BHAFLAU_THICKETS] =
    {
        { xi.item.PINCH_OF_DRIED_MARJORAM, 100, xi.craftRank.AMATEUR },
        { xi.item.PEBBLE,                   52, xi.craftRank.AMATEUR },
        { xi.item.HANDFUL_OF_PINE_NUTS,     44, xi.craftRank.RECRUIT },
        { xi.item.COLIBRI_FEATHER,          34, xi.craftRank.JOURNEYMAN },
        { xi.item.PETRIFIED_LOG,            27, xi.craftRank.CRAFTSMAN },
        { xi.item.BLUE_ROCK,                20, xi.craftRank.ARTISAN },
        { xi.item.LESSER_CHIGOE,            12, xi.craftRank.ADEPT },
        { xi.item.SPIDER_WEB,                6, xi.craftRank.VETERAN },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,   3, xi.craftRank.EXPERT },
    },

    [xi.zone.WAJAOM_WOODLANDS] =
    {
        { xi.item.CLUMP_OF_MOKO_GRASS,   100, xi.craftRank.AMATEUR },
        { xi.item.PEBBLE,                 72, xi.craftRank.AMATEUR },
        { xi.item.HANDFUL_OF_PINE_NUTS,   48, xi.craftRank.RECRUIT },
        { xi.item.BLACK_CHOCOBO_FEATHER,  25, xi.craftRank.RECRUIT },
        { xi.item.BLUE_ROCK,              16, xi.craftRank.JOURNEYMAN },
        { xi.item.EBONY_LOG,              18, xi.craftRank.CRAFTSMAN },
        { xi.item.PEPHREDO_HIVE_CHIP,      9, xi.craftRank.ADEPT },
        { xi.item.SPIDER_WEB,              6, xi.craftRank.VETERAN },
        { xi.item.CHUNK_OF_ADAMAN_ORE,     3, xi.craftRank.EXPERT },
    },
}

local function isNight()
    local hour = VanadielHour()

    return hour >= 20 or hour < 4
end

for zoneId, rows in pairs(eraPools) do
    xi.chocoboDig.digInfo[zoneId][xi.chocoboDig.layer.REGULAR] = rows
end

-- A chance of 0 never hits, so by day the seeds are out of the pool
m:addOverride('xi.chocoboDig.start', function(player)
    local rows  = eraPools[player:getZoneID()]
    local night = isNight()

    for _, row in ipairs(rows or {}) do
        if nightOnlyItems[row[1]] then
            row.nightChance = row.nightChance or row[2]
            row[2]          = night and row.nightChance or 0
        end
    end

    return super(player)
end)

return m
