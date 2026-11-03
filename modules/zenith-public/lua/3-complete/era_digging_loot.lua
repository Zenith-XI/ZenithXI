-----------------------------------
-- Era chocobo digging loot (ZENITHDEV-273)
-- Phoenix's historical regular digging pools (pxi_digging_data.lua), translated into LSB's digInfo rows.
-- LSB still does all the digging: per-item rolls, moon, Receptivity, weather crystals, day rocks, elemental ore,
-- Burrow, Bore, Treasure Finder, fatigue and skill-ups. In these zones the treasure layer finds nothing.
--
-- Translation, one row per Phoenix row in Phoenix's order:
-- - min rank: Phoenix's item rank, the rank at which its weight reaches full
-- - rate: Phoenix's full weight times one scale per zone. The scale makes the zone's regular find chance at Expert
--   (moon multiplier 1, no crystal, rock or ore) equal stock LSB's, so within a zone the rates keep Phoenix's
--   proportions and LSB's success level stays as it was.
--
-- Requires git patch: 118-ChocoboDigLayerHook.patch, which lowers the elemental ore roll from 100 to 15.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_era_digging_loot')

-----------------------------------
-- { itemId, rate (out of 1000), min rank }
-----------------------------------
local regularRows =
{
    [xi.zone.BATALLIA_DOWNS] =
    {
        { xi.item.PEBBLE,                     94, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                69, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  61, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_COPPER_ORE,        40, xi.craftRank.INITIATE   },
        { xi.item.CHUNK_OF_IRON_ORE,          28, xi.craftRank.APPRENTICE },
        { xi.item.BIRD_FEATHER,               25, xi.craftRank.APPRENTICE },
        { xi.item.RED_JAR,                    19, xi.craftRank.JOURNEYMAN },
        { xi.item.PURPLE_ROCK,                15, xi.craftRank.JOURNEYMAN },
        { xi.item.BLACK_CHOCOBO_FEATHER,       4, xi.craftRank.ADEPT      },
        { xi.item.REISHI_MUSHROOM,             2, xi.craftRank.VETERAN    },
    },

    [xi.zone.BUBURIMU_PENINSULA] =
    {
        { xi.item.CHUNK_OF_TIN_ORE,          126, xi.craftRank.AMATEUR    },
        { xi.item.SEASHELL,                   77, xi.craftRank.AMATEUR    },
        { xi.item.LUGWORM,                    61, xi.craftRank.INITIATE   },
        { xi.item.GIANT_FEMUR,                45, xi.craftRank.INITIATE   },
        { xi.item.BIRD_FEATHER,               33, xi.craftRank.APPRENTICE },
        { xi.item.SHELL_BUG,                  44, xi.craftRank.JOURNEYMAN },
        { xi.item.SHALL_SHELL,                32, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_PLATINUM_ORE,       4, xi.craftRank.ADEPT      },
        { xi.item.TURTLE_SHELL,                9, xi.craftRank.VETERAN    },
    },

    [xi.zone.EAST_RONFAURE] =
    {
        { xi.item.ACORN,                      82, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                58, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              51, xi.craftRank.AMATEUR    },
        { xi.item.CHOCOBO_FEATHER,            35, xi.craftRank.RECRUIT    },
        { xi.item.MAPLE_LOG,                  31, xi.craftRank.INITIATE   },
        { xi.item.RONFAURE_CHESTNUT,          30, xi.craftRank.INITIATE   },
        { xi.item.ASH_LOG,                    28, xi.craftRank.INITIATE   },
        { xi.item.CHESTNUT_LOG,               16, xi.craftRank.APPRENTICE },
        { xi.item.BAG_OF_FRUIT_SEEDS,         11, xi.craftRank.CRAFTSMAN  },
        { xi.item.SPRIG_OF_MISTLETOE,          7, xi.craftRank.VETERAN    },
    },

    [xi.zone.EAST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                     84, xi.craftRank.AMATEUR    },
        { xi.item.LAUAN_LOG,                  62, xi.craftRank.AMATEUR    },
        { xi.item.PAPAKA_GRASS,               55, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                42, xi.craftRank.AMATEUR    },
        { xi.item.YAGUDO_FEATHER,             40, xi.craftRank.NOVICE     },
        { xi.item.BIRD_FEATHER,               37, xi.craftRank.APPRENTICE },
        { xi.item.ROSEWOOD_LOG,               18, xi.craftRank.APPRENTICE },
        { xi.item.GREEN_ROCK,                 16, xi.craftRank.JOURNEYMAN },
        { xi.item.BAG_OF_HERB_SEEDS,          11, xi.craftRank.CRAFTSMAN  },
        { xi.item.BALL_OF_SARUTA_COTTON,      10, xi.craftRank.CRAFTSMAN  },
    },

    [xi.zone.JUGNER_FOREST] =
    {
        { xi.item.ACORN,                      81, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              48, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                47, xi.craftRank.AMATEUR    },
        { xi.item.MAPLE_LOG,                  47, xi.craftRank.INITIATE   },
        { xi.item.WILLOW_LOG,                 32, xi.craftRank.INITIATE   },
        { xi.item.HOLLY_LOG,                  27, xi.craftRank.INITIATE   },
        { xi.item.OAK_LOG,                    17, xi.craftRank.JOURNEYMAN },
        { xi.item.SCREAM_FUNGUS,              10, xi.craftRank.ARTISAN    },
        { xi.item.SPRIG_OF_MISTLETOE,          6, xi.craftRank.VETERAN    },
    },

    [xi.zone.KONSCHTAT_HIGHLANDS] =
    {
        { xi.item.PEBBLE,                     82, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  54, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                36, xi.craftRank.AMATEUR    },
        { xi.item.HANDFUL_OF_FISH_SCALES,     34, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_ZINC_ORE,          31, xi.craftRank.NOVICE     },
        { xi.item.ELM_LOG,                    24, xi.craftRank.NOVICE     },
        { xi.item.BIRD_FEATHER,               19, xi.craftRank.APPRENTICE },
        { xi.item.LIZARD_MOLT,                18, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,          16, xi.craftRank.JOURNEYMAN },
        { xi.item.PHOENIX_FEATHER,             6, xi.craftRank.EXPERT     },
    },

    [xi.zone.LA_THEINE_PLATEAU] =
    {
        { xi.item.PEBBLE,                     91, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              66, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                58, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_TIN_ORE,           51, xi.craftRank.AMATEUR    },
        { xi.item.CHOCOBO_FEATHER,            29, xi.craftRank.RECRUIT    },
        { xi.item.YEW_LOG,                    25, xi.craftRank.NOVICE     },
        { xi.item.CHUNK_OF_ZINC_ORE,          23, xi.craftRank.NOVICE     },
        { xi.item.CHESTNUT_LOG,               15, xi.craftRank.APPRENTICE },
        { xi.item.PINCH_OF_DRIED_MARJORAM,    13, xi.craftRank.APPRENTICE },
        { xi.item.MAHOGANY_LOG,                8, xi.craftRank.APPRENTICE },
    },

    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        { xi.item.PEBBLE,                    146, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                94, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                74, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                72, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_COPPER_ORE,        67, xi.craftRank.INITIATE   },
        { xi.item.GIANT_FEMUR,                28, xi.craftRank.INITIATE   },
        { xi.item.YELLOW_ROCK,                20, xi.craftRank.JOURNEYMAN },
        { xi.item.GOLD_BEASTCOIN,             19, xi.craftRank.ARTISAN    },
        { xi.item.BLACK_CHOCOBO_FEATHER,       8, xi.craftRank.ADEPT      },
        { xi.item.CHUNK_OF_ADAMAN_ORE,         5, xi.craftRank.EXPERT     },
    },

    [xi.zone.NORTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,                     96, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                61, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                60, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  48, xi.craftRank.AMATEUR    },
        { xi.item.HANDFUL_OF_FISH_SCALES,     40, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                28, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                 9, xi.craftRank.AMATEUR    },
        { xi.item.BIRD_FEATHER,               16, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,          18, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,     12, xi.craftRank.ADEPT      },
    },

    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        { xi.item.INSECT_WING,                81, xi.craftRank.AMATEUR    },
        { xi.item.PEBBLE,                     45, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                40, xi.craftRank.AMATEUR    },
        { xi.item.WILLOW_LOG,                 19, xi.craftRank.INITIATE   },
        { xi.item.CHUNK_OF_SILVER_ORE,        18, xi.craftRank.NOVICE     },
        { xi.item.MYTHRIL_BEASTCOIN,          15, xi.craftRank.JOURNEYMAN },
        { xi.item.BLACK_ROCK,                 11, xi.craftRank.JOURNEYMAN },
        { xi.item.PUFFBALL,                    9, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,                2, xi.craftRank.VETERAN    },
    },

    [xi.zone.ROLANBERRY_FIELDS] =
    {
        { xi.item.PEBBLE,                     98, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                70, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                64, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                50, xi.craftRank.AMATEUR    },
        { xi.item.SPRIG_OF_SAGE,              47, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,          22, xi.craftRank.JOURNEYMAN },
        { xi.item.RED_JAR,                    20, xi.craftRank.JOURNEYMAN },
        { xi.item.CORAL_FUNGUS,               12, xi.craftRank.CRAFTSMAN  },
        { xi.item.GOLD_BEASTCOIN,              8, xi.craftRank.ARTISAN    },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,     4, xi.craftRank.EXPERT     },
    },

    [xi.zone.SAUROMUGUE_CHAMPAIGN] =
    {
        { xi.item.PEBBLE,                    178, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  97, xi.craftRank.AMATEUR    },
        { xi.item.FLINT_STONE,                94, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                87, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                48, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_IRON_ORE,          47, xi.craftRank.APPRENTICE },
        { xi.item.RED_JAR,                    36, xi.craftRank.JOURNEYMAN },
        { xi.item.GOLD_BEASTCOIN,             35, xi.craftRank.ARTISAN    },
        { xi.item.BLACK_CHOCOBO_FEATHER,       7, xi.craftRank.ADEPT      },
    },

    [xi.zone.SOUTH_GUSTABERG] =
    {
        { xi.item.PEBBLE,                    108, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                78, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                63, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  55, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                39, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_ROCK_SALT,         35, xi.craftRank.APPRENTICE },
        { xi.item.BIRD_FEATHER,               32, xi.craftRank.APPRENTICE },
        { xi.item.MYTHRIL_BEASTCOIN,          30, xi.craftRank.JOURNEYMAN },
        { xi.item.BAG_OF_GRAIN_SEEDS,         15, xi.craftRank.CRAFTSMAN  },
    },

    [xi.zone.TAHRONGI_CANYON] =
    {
        { xi.item.PEBBLE,                     90, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  63, xi.craftRank.AMATEUR    },
        { xi.item.SEASHELL,                   57, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_TIN_ORE,           40, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                32, xi.craftRank.AMATEUR    },
        { xi.item.YAGUDO_FEATHER,             29, xi.craftRank.NOVICE     },
        { xi.item.GIANT_FEMUR,                27, xi.craftRank.APPRENTICE },
        { xi.item.RED_ROCK,                   16, xi.craftRank.JOURNEYMAN },
        { xi.item.CHUNK_OF_GOLD_ORE,          14, xi.craftRank.ARTISAN    },
    },

    [xi.zone.VALKURM_DUNES] =
    {
        { xi.item.SEASHELL,                  185, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                 112, xi.craftRank.AMATEUR    },
        { xi.item.HANDFUL_OF_FISH_SCALES,     69, xi.craftRank.AMATEUR    },
        { xi.item.LIZARD_MOLT,                64, xi.craftRank.AMATEUR    },
        { xi.item.LUGWORM,                    67, xi.craftRank.INITIATE   },
        { xi.item.GIANT_FEMUR,                37, xi.craftRank.INITIATE   },
        { xi.item.SHALL_SHELL,                28, xi.craftRank.JOURNEYMAN },
        { xi.item.SHELL_BUG,                  19, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,               11, xi.craftRank.VETERAN    },
    },

    [xi.zone.WEST_RONFAURE] =
    {
        { xi.item.LITTLE_WORM,                88, xi.craftRank.AMATEUR    },
        { xi.item.ACORN,                      70, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              63, xi.craftRank.AMATEUR    },
        { xi.item.CLUMP_OF_MOKO_GRASS,        32, xi.craftRank.AMATEUR    },
        { xi.item.CHOCOBO_FEATHER,            35, xi.craftRank.RECRUIT    },
        { xi.item.MAPLE_LOG,                  39, xi.craftRank.INITIATE   },
        { xi.item.ASH_LOG,                    25, xi.craftRank.INITIATE   },
        { xi.item.RONFAURE_CHESTNUT,           9, xi.craftRank.INITIATE   },
        { xi.item.CHESTNUT_LOG,               11, xi.craftRank.APPRENTICE },
        { xi.item.BAG_OF_VEGETABLE_SEEDS,     12, xi.craftRank.CRAFTSMAN  },
        { xi.item.SPRIG_OF_MISTLETOE,          7, xi.craftRank.VETERAN    },
    },

    [xi.zone.WEST_SARUTABARUTA] =
    {
        { xi.item.PEBBLE,                     84, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                55, xi.craftRank.AMATEUR    },
        { xi.item.LAUAN_LOG,                  49, xi.craftRank.AMATEUR    },
        { xi.item.INSECT_WING,                38, xi.craftRank.AMATEUR    },
        { xi.item.CLUMP_OF_MOKO_GRASS,        29, xi.craftRank.AMATEUR    },
        { xi.item.YAGUDO_FEATHER,             26, xi.craftRank.NOVICE     },
        { xi.item.BIRD_FEATHER,               17, xi.craftRank.APPRENTICE },
        { xi.item.BALL_OF_SARUTA_COTTON,      16, xi.craftRank.CRAFTSMAN  },
        { xi.item.BAG_OF_TREE_CUTTINGS,       11, xi.craftRank.CRAFTSMAN  },
    },

    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,                 231, xi.craftRank.AMATEUR    },
        { xi.item.PEBBLE,                     90, xi.craftRank.AMATEUR    },
        { xi.item.GIANT_FEMUR,                92, xi.craftRank.RECRUIT    },
        { xi.item.CHUNK_OF_ZINC_ORE,          61, xi.craftRank.NOVICE     },
        { xi.item.CHUNK_OF_SILVER_ORE,        42, xi.craftRank.NOVICE     },
        { xi.item.HANDFUL_OF_WYVERN_SCALES,   42, xi.craftRank.ARTISAN    },
        { xi.item.CHUNK_OF_MYTHRIL_ORE,       32, xi.craftRank.ARTISAN    },
        { xi.item.CHUNK_OF_PLATINUM_ORE,      19, xi.craftRank.ADEPT      },
        { xi.item.PHILOSOPHERS_STONE,          7, xi.craftRank.VETERAN    },
    },

    [xi.zone.THE_SANCTUARY_OF_ZITAH] =
    {
        { xi.item.PEBBLE,                    138, xi.craftRank.AMATEUR    },
        { xi.item.BONE_CHIP,                  83, xi.craftRank.AMATEUR    },
        { xi.item.CLUMP_OF_MOKO_GRASS,        79, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              63, xi.craftRank.AMATEUR    },
        { xi.item.YEW_LOG,                    39, xi.craftRank.NOVICE     },
        { xi.item.ELM_LOG,                    33, xi.craftRank.NOVICE     },
        { xi.item.TRANSLUCENT_ROCK,           19, xi.craftRank.JOURNEYMAN },
        { xi.item.KING_TRUFFLE,                6, xi.craftRank.EXPERT     },
    },

    [xi.zone.WESTERN_ALTEPA_DESERT] =
    {
        { xi.item.BONE_CHIP,                 234, xi.craftRank.AMATEUR    },
        { xi.item.PEBBLE,                    122, xi.craftRank.AMATEUR    },
        { xi.item.GIANT_FEMUR,                98, xi.craftRank.RECRUIT    },
        { xi.item.CHUNK_OF_ZINC_ORE,          73, xi.craftRank.NOVICE     },
        { xi.item.CHUNK_OF_IRON_ORE,          47, xi.craftRank.APPRENTICE },
        { xi.item.CORAL_FRAGMENT,             42, xi.craftRank.CRAFTSMAN  },
        { xi.item.CHUNK_OF_GOLD_ORE,          37, xi.craftRank.ARTISAN    },
        { xi.item.CHUNK_OF_DARKSTEEL_ORE,     15, xi.craftRank.ADEPT      },
        { xi.item.PHILOSOPHERS_STONE,          9, xi.craftRank.VETERAN    },
    },

    [xi.zone.YHOATOR_JUNGLE] =
    {
        { xi.item.BONE_CHIP,                 111, xi.craftRank.AMATEUR    },
        { xi.item.LAUAN_LOG,                  48, xi.craftRank.AMATEUR    },
        { xi.item.KAZHAM_PINEAPPLE,           48, xi.craftRank.AMATEUR    },
        { xi.item.DRYAD_ROOT,                 32, xi.craftRank.AMATEUR    },
        { xi.item.MAHOGANY_LOG,               35, xi.craftRank.JOURNEYMAN },
        { xi.item.EBONY_LOG,                  24, xi.craftRank.JOURNEYMAN },
        { xi.item.CORAL_FUNGUS,               12, xi.craftRank.CRAFTSMAN  },
        { xi.item.PETRIFIED_LOG,               8, xi.craftRank.ARTISAN    },
        { xi.item.REISHI_MUSHROOM,             6, xi.craftRank.ADEPT      },
    },

    [xi.zone.YUHTUNGA_JUNGLE] =
    {
        { xi.item.BONE_CHIP,                 143, xi.craftRank.AMATEUR    },
        { xi.item.PIECE_OF_RATTAN_LUMBER,     86, xi.craftRank.AMATEUR    },
        { xi.item.STICK_OF_CINNAMON,          64, xi.craftRank.AMATEUR    },
        { xi.item.DANCESHROOM,                45, xi.craftRank.INITIATE   },
        { xi.item.ROSEWOOD_LOG,               28, xi.craftRank.APPRENTICE },
        { xi.item.EBONY_LOG,                  20, xi.craftRank.JOURNEYMAN },
        { xi.item.PETRIFIED_LOG,              18, xi.craftRank.ARTISAN    },
        { xi.item.PUFFBALL,                   11, xi.craftRank.VETERAN    },
        { xi.item.KING_TRUFFLE,                6, xi.craftRank.EXPERT     },
    },

    [xi.zone.BIBIKI_BAY] =
    {
        { xi.item.SEASHELL,                   94, xi.craftRank.AMATEUR    },
        { xi.item.CHUNK_OF_TIN_ORE,           65, xi.craftRank.AMATEUR    },
        { xi.item.LUGWORM,                    60, xi.craftRank.INITIATE   },
        { xi.item.GIANT_FEMUR,                30, xi.craftRank.INITIATE   },
        { xi.item.BIRD_FEATHER,               60, xi.craftRank.APPRENTICE },
        { xi.item.SHALL_SHELL,                23, xi.craftRank.JOURNEYMAN },
        { xi.item.SHELL_BUG,                  30, xi.craftRank.JOURNEYMAN },
        { xi.item.TURTLE_SHELL,                7, xi.craftRank.VETERAN    },
    },

    [xi.zone.CARPENTERS_LANDING] =
    {
        { xi.item.ACORN,                     112, xi.craftRank.AMATEUR    },
        { xi.item.LITTLE_WORM,                75, xi.craftRank.AMATEUR    },
        { xi.item.ARROWWOOD_LOG,              55, xi.craftRank.AMATEUR    },
        { xi.item.MAPLE_LOG,                  68, xi.craftRank.INITIATE   },
        { xi.item.HOLLY_LOG,                  34, xi.craftRank.INITIATE   },
        { xi.item.WILLOW_LOG,                 34, xi.craftRank.INITIATE   },
        { xi.item.OAK_LOG,                    17, xi.craftRank.JOURNEYMAN },
        { xi.item.SCREAM_FUNGUS,              12, xi.craftRank.ARTISAN    },
        { xi.item.SPRIG_OF_MISTLETOE,          9, xi.craftRank.VETERAN    },
        { xi.item.KING_TRUFFLE,                4, xi.craftRank.EXPERT     },
    },

    [xi.zone.BHAFLAU_THICKETS] =
    {
        { xi.item.PINCH_OF_DRIED_MARJORAM,   142, xi.craftRank.AMATEUR    },
        { xi.item.PEBBLE,                     74, xi.craftRank.AMATEUR    },
        { xi.item.HANDFUL_OF_PINE_NUTS,       62, xi.craftRank.RECRUIT    },
        { xi.item.COLIBRI_FEATHER,            49, xi.craftRank.JOURNEYMAN },
        { xi.item.PETRIFIED_LOG,              39, xi.craftRank.CRAFTSMAN  },
        { xi.item.BLUE_ROCK,                  28, xi.craftRank.ARTISAN    },
        { xi.item.LESSER_CHIGOE,              16, xi.craftRank.ADEPT      },
        { xi.item.SPIDER_WEB,                  8, xi.craftRank.VETERAN    },
        { xi.item.CHUNK_OF_ORICHALCUM_ORE,     5, xi.craftRank.EXPERT     },
    },

    [xi.zone.WAJAOM_WOODLANDS] =
    {
        { xi.item.CLUMP_OF_MOKO_GRASS,       128, xi.craftRank.AMATEUR    },
        { xi.item.PEBBLE,                     92, xi.craftRank.AMATEUR    },
        { xi.item.HANDFUL_OF_PINE_NUTS,       61, xi.craftRank.RECRUIT    },
        { xi.item.BLACK_CHOCOBO_FEATHER,      32, xi.craftRank.RECRUIT    },
        { xi.item.BLUE_ROCK,                  20, xi.craftRank.JOURNEYMAN },
        { xi.item.EBONY_LOG,                  23, xi.craftRank.CRAFTSMAN  },
        { xi.item.PEPHREDO_HIVE_CHIP,         11, xi.craftRank.ADEPT      },
        { xi.item.SPIDER_WEB,                  8, xi.craftRank.VETERAN    },
        { xi.item.CHUNK_OF_ADAMAN_ORE,         4, xi.craftRank.EXPERT     },
    }
}

m:addOverride('xi.server.onServerStart', function()
    super()

    for zoneId, rows in pairs(regularRows) do
        local zoneTable = xi.chocoboDig.digInfo[zoneId]

        zoneTable[xi.chocoboDig.layer.TREASURE] = {}
        zoneTable[xi.chocoboDig.layer.REGULAR]  = rows
    end
end)
