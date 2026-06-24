-----------------------------------
-- HELM Zone Configuration Module
--
-- This module allows customizing HELM (Harvesting, Excavation, Logging, Mining)
-- item pools and success/break rates on a per-zone basis.
--
-- Configuration options per zone:
--   rate           - Override success rate (1-100%)
--   breakChance    - Override tool break chance (1-100%)
--   drops          - Replace the entire drop table for this zone
--   additionalDrops - Add items to the existing drop pool
--   additionalDrops<EXPANSION> - Add items to the pool only when the matching
--                     ENABLE_<EXPANSION> server setting is active (e.g.
--                     additionalDropsABYSSEA gates on xi.settings.main.ENABLE_ABYSSEA).
--                     This mirrors the stock<EXPANSION> convention in vendorOverrides.lua
--                     and is intentionally keyed off ENABLE_<X> (not isContentEnabled),
--                     so post-era items auto-disable until their expansion is enabled
--                     without hand-editing this module.
--
-- Example configuration:
--   [xi.helmType.MINING] =
--   {
--       [xi.zone.ZERUHN_MINES] =
--       {
--           rate = 75,
--           breakChance = 20,
--           additionalDrops =
--           {
--               { 500, xi.item.CHUNK_OF_GOLD_ORE },
--           },
--       },
--   },
-----------------------------------

require('modules/module_utils')

local m = Module:new('b_helm_config')

-----------------------------------
-- CONFIGURATION
-- Modify these values to customize HELM per zone
-----------------------------------
local config =
{
    -- HARVESTING (Sickle) ---------------------------------------------------
    [xi.helmType.HARVESTING] =
    {
        [xi.zone.WEST_SARUTABARUTA] =
        {
            breakChance = 10,
            drops =
            {
                {  50, xi.item.PIECE_OF_CRAWLER_COCOON         },
                { 100, xi.item.FLAX_FLOWER                     },
                { 150, xi.item.SPRIG_OF_FRESH_MARJORAM         },
                {  10, xi.item.BAG_OF_GRAIN_SEEDS              },
                {  50, xi.item.BUNCH_OF_GYSAHL_GREENS          },
                {  10, xi.item.BAG_OF_HERB_SEEDS               },
                { 150, xi.item.CLUMP_OF_MOKO_GRASS             },
                {  10, xi.item.BAG_OF_VEGETABLE_SEEDS          },
                { 150, xi.item.BALL_OF_SARUTA_COTTON           },
                {  50, xi.item.SKULL_LOCUST                    },
                {  50, xi.item.WIJNRUIT                        },
                {  50, xi.item.CLUMP_OF_WINDURSTIAN_TEA_LEAVES },
                {  10, xi.item.CLUMP_OF_SHEEP_WOOL             },
                {  10, xi.item.SPRIG_OF_FRESH_MUGWORT          },
                { 100, xi.item.CLUMP_OF_RED_MOKO_GRASS         },
            },
            -- WOTG: Dyer's Woad (added Sep 2008) gated behind ENABLE_WOTG
            additionalDropsWOTG =
            {
                {  50, xi.item.SPRIG_OF_DYERS_WOAD             },
            },
        },

        [xi.zone.GIDDEUS] =
        {
            breakChance = 10,
            drops =
            {
                {  10, xi.item.PIECE_OF_CRAWLER_COCOON         },
                { 100, xi.item.FLAX_FLOWER                     },
                { 100, xi.item.SPRIG_OF_FRESH_MARJORAM         },
                {  10, xi.item.BAG_OF_GRAIN_SEEDS              },
                {  50, xi.item.BUNCH_OF_GYSAHL_GREENS          },
                {  10, xi.item.BAG_OF_HERB_SEEDS               },
                { 100, xi.item.CLUMP_OF_MOKO_GRASS             },
                {  10, xi.item.BAG_OF_VEGETABLE_SEEDS          },
                { 150, xi.item.BALL_OF_SARUTA_COTTON           },
                {  50, xi.item.KING_LOCUST                     },
                {  50, xi.item.WIJNRUIT                        },
                {  50, xi.item.CLUMP_OF_WINDURSTIAN_TEA_LEAVES },
                {  50, xi.item.BEEHIVE_CHIP                    },
                {  50, xi.item.YAGUDO_FEATHER                  },
                {  10, xi.item.SPRIG_OF_FRESH_MUGWORT          },
                { 150, xi.item.CLUMP_OF_RED_MOKO_GRASS         },
            },
            -- WOTG: Dyer's Woad (added Sep 2008) gated behind ENABLE_WOTG
            additionalDropsWOTG =
            {
                {  10, xi.item.SPRIG_OF_DYERS_WOAD             },
            },
        },
        -- TODO: Audit Grauberg (S)
        [xi.zone.GRAUBERG_S] =
        {
            drops =
            {
                { 1830, xi.item.CLUMP_OF_MOKO_GRASS     },
                { 1850, xi.item.CLUMP_OF_RED_MOKO_GRASS },
                { 1250, xi.item.BAG_OF_VEGETABLE_SEEDS  },
                { 1560, xi.item.BURDOCK_ROOT            },
                { 1060, xi.item.BAG_OF_GRAIN_SEEDS      },
                { 1200, xi.item.BAG_OF_HERB_SEEDS       },
                { 1270, xi.item.LESSER_CHIGOE           },
                { 1160, xi.item.WINTERFLOWER            },
            },
        },
        -- TODO: Audit West Sarutabaruta (S)
        [xi.zone.WEST_SARUTABARUTA_S] =
        {
            drops =
            {
                {  890, xi.item.BURDOCK_ROOT            },
                {  830, xi.item.CLUMP_OF_RED_MOKO_GRASS },
                {  910, xi.item.FLAX_FLOWER             },
                {  540, xi.item.BAG_OF_VEGETABLE_SEEDS  },
                { 1630, xi.item.SPRIG_OF_FRESH_MARJORAM },
                { 1580, xi.item.CLUMP_OF_MOKO_GRASS     },
                { 1680, xi.item.BALL_OF_SARUTA_COTTON   },
                {  550, xi.item.SKULL_LOCUST            },
                {  390, xi.item.SPRIG_OF_FRESH_MUGWORT  },
                {  350, xi.item.KING_LOCUST             },
                {  280, xi.item.BAG_OF_HERB_SEEDS       },
                {  370, xi.item.BAG_OF_GRAIN_SEEDS      },
            },
        },

        [xi.zone.WAJAOM_WOODLANDS] =
        {
            breakChance = 10,
            drops =
            {
                { 100, xi.item.SPRIG_OF_FRESH_MARJORAM      },
                { 100, xi.item.BAG_OF_SIMSIM                },
                { 100, xi.item.CLUMP_OF_MOHBWA_GRASS        },
                { 150, xi.item.PEPHREDO_HIVE_CHIP           },
                {  50, xi.item.EGGPLANT                     },
                { 100, xi.item.BAG_OF_COFFEE_CHERRIES       },
                { 100, xi.item.CLUMP_OF_IMPERIAL_TEA_LEAVES },
                {  50, xi.item.CLUMP_OF_RED_MOKO_GRASS      },
                {  50, xi.item.SPRIG_OF_FRESH_MUGWORT       },
                {  50, xi.item.PUK_WING                     },
            },
            -- WOTG: Eastern Ginger Root (added Jun 2008) gated behind ENABLE_WOTG
            additionalDropsWOTG =
            {
                {  50, xi.item.EASTERN_GINGER_ROOT          },
            },
        },

        [xi.zone.BHAFLAU_THICKETS] =
        {
            breakChance = 10,
            drops =
            {
                { 150, xi.item.SPRIG_OF_FRESH_MARJORAM      },
                { 100, xi.item.BAG_OF_SIMSIM                },
                { 100, xi.item.CLUMP_OF_MOHBWA_GRASS        },
                { 100, xi.item.PEPHREDO_HIVE_CHIP           },
                {  50, xi.item.EGGPLANT                     },
                { 150, xi.item.BAG_OF_COFFEE_CHERRIES       },
                { 100, xi.item.CLUMP_OF_IMPERIAL_TEA_LEAVES },
                {  50, xi.item.CLUMP_OF_RED_MOKO_GRASS      },
                {  50, xi.item.SPRIG_OF_FRESH_MUGWORT       },
                {  10, xi.item.WIJNRUIT                     },
                {  50, xi.item.PIECE_OF_CRAWLER_COCOON      },
                {  10, xi.item.SPIDER_WEB                   },
            },
            -- WOTG: Eastern Ginger Root (added Jun 2008) gated behind ENABLE_WOTG
            additionalDropsWOTG =
            {
                {  50, xi.item.EASTERN_GINGER_ROOT          },
            },
        },
        -- TODO audit Yuhtunga Jungle Harvesting
        [xi.zone.YUHTUNGA_JUNGLE] =
        {
            drops =
            {
                    { 4000, xi.item.WOOZYSHROOM     },
                    { 2000, xi.item.DANCESHROOM     },
                    { 2000, xi.item.SLEEPSHROOM     },
                    {  700, xi.item.SCREAM_FUNGUS   },
                    {  700, xi.item.PUFFBALL        },
                    {  300, xi.item.KING_TRUFFLE    },
                    {  300, xi.item.MUSHROOM_LOCUST },
            },
        },
        -- TODO audit Yhoator Jungle Harvesting
        [xi.zone.YHOATOR_JUNGLE] =
        {
            drops =
            {
                    { 4000, xi.item.WOOZYSHROOM     },
                    { 2000, xi.item.DANCESHROOM     },
                    { 2000, xi.item.SLEEPSHROOM     },
                    {  700, xi.item.SCREAM_FUNGUS   },
                    {  700, xi.item.CORAL_FUNGUS    },
                    {  300, xi.item.REISHI_MUSHROOM },
                    {  300, xi.item.MUSHROOM_LOCUST },
            },
        },
        -- TODO audit Abyssea Grauberg
        [xi.zone.ABYSSEA_GRAUBERG] =
        {
            drops =
            {
                    {  970, xi.item.BAG_OF_HERB_SEEDS        },
                    { 1330, xi.item.CLUMP_OF_MOKO_GRASS      },
                    {  880, xi.item.LESSER_CHIGOE            },
                    {  880, xi.item.BAG_OF_GRAIN_SEEDS       },
                    { 1180, xi.item.CLUMP_OF_RED_MOKO_GRASS  },
                    { 1000, xi.item.BURDOCK_ROOT             },
                    {  790, xi.item.BAG_OF_VEGETABLE_SEEDS   },
                    {  940, xi.item.BUNCH_OF_GRAUBERG_GREENS },
            },
        },
    },

    -- EXCAVATION (Pickaxe) --------------------------------------------------
    [xi.helmType.EXCAVATION] =
    {
        [xi.zone.TAHRONGI_CANYON] =
        {
            breakChance = 40,
            drops =
            {
                { 240, xi.item.BONE_CHIP        },
                { 240, xi.item.CHICKEN_BONE     },
                { 150, xi.item.BAT_FANG         },
                { 150, xi.item.GIANT_FEMUR      },
                { 100, xi.item.LITTLE_WORM      },
                {  10, xi.item.SCORPION_CLAW    },
                {  10, xi.item.SCORPION_SHELL   },
                {  10, xi.item.TURTLE_SHELL     },
                {  10, xi.item.SACK_OF_SILICA   },
                {  10, xi.item.BLACK_TIGER_FANG },
                {  50, xi.item.RAM_HORN         },
            },
        },

        [xi.zone.ATTOHWA_CHASM] =
        {
            breakChance = 60,
            drops =
            {
                { 240, xi.item.BONE_CHIP                   },
                { 150, xi.item.CHICKEN_BONE                },
                { 100, xi.item.BAT_FANG                    },
                {  50, xi.item.LITTLE_WORM                 },
                { 150, xi.item.SCORPION_CLAW               },
                { 100, xi.item.SCORPION_SHELL              },
                { 100, xi.item.ANTLION_JAW                 },
                {  10, xi.item.BAG_OF_CACTUS_STEMS         },
                {  10, xi.item.HIGH_QUALITY_SCORPION_SHELL },
                {  10, xi.item.RED_ROCK                    },
                {   5, xi.item.SCARLET_STONE               },
                {   5, xi.item.WYVERN_SKULL                },
                {  50, xi.item.COEURL_WHISKER              },
            },
        },

        [xi.zone.KORROLOKA_TUNNEL] =
        {
            breakChance = 55,
            drops =
            {
                {  50, xi.item.CHUNK_OF_ROCK_SALT     },
                { 150, xi.item.SEASHELL               },
                { 100, xi.item.CRAB_SHELL             },
                { 150, xi.item.HANDFUL_OF_FISH_SCALES },
                { 100, xi.item.LUGWORM                },
                { 100, xi.item.SHELL_BUG              },
                {  10, xi.item.CORAL_FRAGMENT         },
                {  50, xi.item.TURTLE_SHELL           },
                {  50, xi.item.HELMET_MOLE            },
                {  50, xi.item.RAM_HORN               },
                {  50, xi.item.SHALL_SHELL            },
                {  10, xi.item.VIAL_OF_BEASTMAN_BLOOD },
                {  10, xi.item.URAGNITE_SHELL         },
            },
        },

        [xi.zone.MAZE_OF_SHAKHRAMI] =
        {
            breakChance = 55,
            drops =
            {
                { 240, xi.item.BONE_CHIP      },
                { 150, xi.item.BAT_FANG       },
                { 100, xi.item.LITTLE_WORM    },
                { 150, xi.item.GIANT_FEMUR    },
                {  50, xi.item.SCORPION_CLAW  },
                { 100, xi.item.SCORPION_SHELL },
                {  10, xi.item.PETRIFIED_LOG  },
                {  10, xi.item.RED_ROCK       },
                {  10, xi.item.SACK_OF_SILICA },
                { 100, xi.item.BEETLE_SHELL   },
                {  50, xi.item.BEETLE_JAW     },
                {  10, xi.item.DEMON_HORN     },
            },
        },
    },

    -- LOGGING (Hatchet) -----------------------------------------------------
    [xi.helmType.LOGGING] =
    {
        [xi.zone.EAST_RONFAURE] =
        {
            breakChance = 10,
            drops =
            {
                { 240, xi.item.ARROWWOOD_LOG      },
                { 240, xi.item.ASH_LOG            },
                { 240, xi.item.MAPLE_LOG          },
                { 100, xi.item.CHESTNUT_LOG       },
                {  50, xi.item.BAG_OF_FRUIT_SEEDS },
                {  50, xi.item.YEW_LOG            },
                {  50, xi.item.RONFAURE_CHESTNUT  },
                {  10, xi.item.ELM_LOG            },
            },
        },

        [xi.zone.GHELSBA_OUTPOST] =
        {
            breakChance = 10,
            drops =
            {
                { 240, xi.item.ARROWWOOD_LOG     },
                { 240, xi.item.ASH_LOG           },
                { 240, xi.item.MAPLE_LOG         },
                { 100, xi.item.WILLOW_LOG        },
                {  50, xi.item.ELM_LOG           },
                {  50, xi.item.HOLLY_LOG         },
                {  10, xi.item.BAG_OF_FRUIT_SEEDS },
                {  50, xi.item.LAUAN_LOG         },
            },
        },

        [xi.zone.BUBURIMU_PENINSULA] =
        {
            breakChance = 15,
            drops =
            {
                { 150, xi.item.LAUAN_LOG                },
                { 100, xi.item.ARROWWOOD_LOG            },
                { 150, xi.item.YAGUDO_CHERRY            },
                { 150, xi.item.BUNCH_OF_BUBURIMU_GRAPES },
                {  50, xi.item.DRYAD_ROOT               },
                {  10, xi.item.BAG_OF_FRUIT_SEEDS       },
                {  50, xi.item.HOLLY_LOG                },
                {  10, xi.item.EBONY_LOG                },
                {  10, xi.item.MAHOGANY_LOG             },
                {  10, xi.item.ROSEWOOD_LOG             },
                {  50, xi.item.MAPLE_LOG                },
                {  50, xi.item.BEEHIVE_CHIP             },
            },
        },

        [xi.zone.JUGNER_FOREST] =
        {
            breakChance = 15,
            drops =
            {
                { 150, xi.item.WALNUT_LOG    },
                { 150, xi.item.WILLOW_LOG    },
                { 240, xi.item.YEW_LOG       },
                { 150, xi.item.ARROWWOOD_LOG },
                { 100, xi.item.ASH_LOG       },
                {  50, xi.item.DRYAD_ROOT    },
                { 100, xi.item.ACORN         },
                {  50, xi.item.OAK_LOG       },
                {  10, xi.item.MAHOGANY_LOG  },
            },
        },

        [xi.zone.CARPENTERS_LANDING] =
        {
            breakChance = 15,
            drops =
            {
                { 240, xi.item.WALNUT_LOG    },
                { 150, xi.item.WILLOW_LOG    },
                { 150, xi.item.YEW_LOG       },
                { 150, xi.item.ARROWWOOD_LOG },
                { 100, xi.item.ASH_LOG       },
                {  50, xi.item.DRYAD_ROOT    },
                {  50, xi.item.ACORN         },
                {  10, xi.item.OAK_LOG       },
                {  50, xi.item.CHESTNUT_LOG  },
                {  10, xi.item.ELM_LOG       },
            },
        },

        [xi.zone.YUHTUNGA_JUNGLE] =
        {
            breakChance = 20,
            drops =
            {
                { 100, xi.item.ARROWWOOD_LOG          },
                { 150, xi.item.PIECE_OF_RATTAN_LUMBER },
                { 100, xi.item.LAUAN_LOG              },
                {  50, xi.item.REVIVAL_TREE_ROOT      },
                {  50, xi.item.BEEHIVE_CHIP           },
                {  50, xi.item.BAG_OF_TREE_CUTTINGS   },
                {  10, xi.item.EBONY_LOG              },
                {  50, xi.item.HOLLY_LOG              },
                {  50, xi.item.ROSEWOOD_LOG           },
                {  10, xi.item.KITRON                 },
                {  50, xi.item.STICK_OF_CINNAMON      },
            },
            -- Abyssea-era logging items gated behind ENABLE_ABYSSEA
            additionalDropsABYSSEA =
            {
                {  50, xi.item.KAPOR_LOG              },
                { 100, xi.item.AQUILARIA_LOG          },
                { 100, xi.item.BUTTERPEAR             },
            },
        },

        [xi.zone.YHOATOR_JUNGLE] =
        {
            breakChance = 20,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG          },
                { 150, xi.item.PIECE_OF_RATTAN_LUMBER },
                { 100, xi.item.LAUAN_LOG              },
                {  50, xi.item.REVIVAL_TREE_ROOT      },
                { 100, xi.item.BEEHIVE_CHIP           },
                {  10, xi.item.BAG_OF_TREE_CUTTINGS   },
                {  10, xi.item.EBONY_LOG              },
                {  50, xi.item.DRYAD_ROOT             },
                {  50, xi.item.MAHOGANY_LOG           },
                {   5, xi.item.LACQUER_TREE_LOG       },
            },
            -- Abyssea-era logging items gated behind ENABLE_ABYSSEA
            additionalDropsABYSSEA =
            {
                { 100, xi.item.KAPOR_LOG              },
                { 100, xi.item.AQUILARIA_LOG          },
                { 100, xi.item.BUTTERPEAR             },
            },
        },

        [xi.zone.LUFAISE_MEADOWS] =
        {
            breakChance = 20,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG },
                { 240, xi.item.ASH_LOG       },
                { 150, xi.item.MAPLE_LOG     },
                { 100, xi.item.FAERIE_APPLE  },
                { 100, xi.item.WALNUT_LOG    },
                { 100, xi.item.ACORN         },
                {  50, xi.item.ELM_LOG       },
                {  10, xi.item.OAK_LOG       },
                {  50, xi.item.HOLLY_LOG     },
            },
        },

        [xi.zone.MISAREAUX_COAST] =
        {
            breakChance = 20,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG },
                { 240, xi.item.ASH_LOG       },
                { 150, xi.item.MAPLE_LOG     },
                { 100, xi.item.FAERIE_APPLE  },
                { 100, xi.item.WALNUT_LOG    },
                {  50, xi.item.ACORN         },
                { 100, xi.item.ELM_LOG       },
                {  50, xi.item.OAK_LOG       },
                {  50, xi.item.LAUAN_LOG     },
            },
        },

        [xi.zone.CAEDARVA_MIRE] =
        {
            breakChance = 10,
            drops =
            {
                { 100, xi.item.ARROWWOOD_LOG        },
                { 240, xi.item.DOGWOOD_LOG          },
                { 100, xi.item.HANDFUL_OF_PINE_NUTS },
                { 100, xi.item.HANDFUL_OF_ALMONDS   },
                {  50, xi.item.CHESTNUT_LOG         },
                {  50, xi.item.DATE                 },
                {  50, xi.item.EBONY_LOG            },
                {  50, xi.item.LAUAN_LOG            },
                {  50, xi.item.ROSEWOOD_LOG         },
                {  10, xi.item.BLOODWOOD_LOG        },
                {  10, xi.item.PETRIFIED_LOG        },
                { 100, xi.item.WALNUT_LOG           },
            },
        },

        [xi.zone.MAMOOK] =
        {
            breakChance = 10,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG        },
                { 240, xi.item.DOGWOOD_LOG          },
                {  50, xi.item.HANDFUL_OF_PINE_NUTS },
                { 150, xi.item.HANDFUL_OF_ALMONDS   },
                {  10, xi.item.CHESTNUT_LOG         },
                { 100, xi.item.DATE                 },
                {  50, xi.item.EBONY_LOG            },
                {  50, xi.item.LAUAN_LOG            },
                {  50, xi.item.ROSEWOOD_LOG         },
                {  10, xi.item.BLOODWOOD_LOG        },
                {  10, xi.item.LACQUER_TREE_LOG     },
                {  50, xi.item.OAK_LOG              },
            },
        },

        [xi.zone.EAST_RONFAURE_S] =
        {
            breakChance = 10,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG      },
                { 150, xi.item.ASH_LOG            },
                { 150, xi.item.MAPLE_LOG          },
                { 150, xi.item.WALNUT             },
                { 100, xi.item.CHESTNUT_LOG       },
                { 100, xi.item.RONFAURE_CHESTNUT  },
                {  50, xi.item.WALNUT_LOG         },
                {  50, xi.item.BAG_OF_FRUIT_SEEDS },
                {   1, xi.item.JACARANDA_LOG      },
                {  50, xi.item.OAK_LOG            },
                {  50, xi.item.TEAK_LOG           },
            },
        },

        [xi.zone.JUGNER_FOREST_S] =
        {
            breakChance = 15,
            drops =
            {
                { 100, xi.item.ARROWWOOD_LOG },
                { 150, xi.item.ASH_LOG       },
                { 150, xi.item.WALNUT        },
                { 150, xi.item.WILLOW_LOG    },
                { 150, xi.item.WALNUT_LOG    },
                {  50, xi.item.ACORN         },
                {  10, xi.item.JACARANDA_LOG },
                { 100, xi.item.OAK_LOG       },
                {  50, xi.item.TEAK_LOG      },
                {  10, xi.item.MAHOGANY_LOG  },
            },
        },

    },

    -- MINING (Pickaxe) ------------------------------------------------------
    -- [xi.helmType.MINING] =
    -- {
    --     [xi.zone.ZERUHN_MINES] =
    --     {
    --         rate = 75,
    --         breakChance = 20,
    --         additionalDrops =
    --         {
    --             { 500, xi.item.CHUNK_OF_GOLD_ORE },
    --         },
    --     },
    -- },
}

-----------------------------------
-- COLORED ROCKS ARRAY
-- (replicated from base logic.lua for RED_ROCK handling)
-----------------------------------
local rocks =
{
    [xi.element.FIRE   ] = xi.item.RED_ROCK,
    [xi.element.ICE    ] = xi.item.TRANSLUCENT_ROCK,
    [xi.element.WIND   ] = xi.item.GREEN_ROCK,
    [xi.element.EARTH  ] = xi.item.YELLOW_ROCK,
    [xi.element.THUNDER] = xi.item.PURPLE_ROCK,
    [xi.element.WATER  ] = xi.item.BLUE_ROCK,
    [xi.element.LIGHT  ] = xi.item.WHITE_ROCK,
    [xi.element.DARK   ] = xi.item.BLACK_ROCK,
}

-----------------------------------
-- HELPER FUNCTIONS
-----------------------------------

-- Get zone-specific configuration if it exists
local function getZoneConfig(helmType, zoneId)
    if config[helmType] and config[helmType][zoneId] then
        return config[helmType][zoneId]
    end

    return nil
end

-- Merge additional drops with base drops
local function mergeDrops(baseDrops, additionalDrops)
    local merged = {}

    for i = 1, #baseDrops do
        table.insert(merged, baseDrops[i])
    end

    for i = 1, #additionalDrops do
        table.insert(merged, additionalDrops[i])
    end

    return merged
end

-- Merge expansion-gated drops (additionalDrops<EXPANSION>) into the working drop
-- table when the matching ENABLE_<EXPANSION> server setting is active. Mirrors the
-- stock<EXPANSION> convention used by vendorOverrides.lua. Only the zone config's own
-- keys are scanned, so settings with no matching table are never touched. mergeDrops
-- returns a new table, so the config tables are never mutated.
local function applyExpansionDrops(drops, zoneConfig)
    local prefix = 'additionalDrops'

    for key, expansionDrops in pairs(zoneConfig) do
        if
            type(key) == 'string' and
            #key > #prefix and
            string.sub(key, 1, #prefix) == prefix
        then
            local suffix = string.sub(key, #prefix + 1)
            local setting = xi.settings.main['ENABLE_' .. suffix]

            if
                (type(setting) == 'number' and setting == 1) or
                (type(setting) == 'boolean' and setting)
            then
                drops = mergeDrops(drops, expansionDrops)
            end
        end
    end

    return drops
end

-- Get the effective drop table for a zone
local function getEffectiveDrops(info, zoneId, zoneConfig)
    local drops = zoneConfig.drops or info.zone[zoneId].drops

    if zoneConfig.additionalDrops then
        drops = mergeDrops(drops, zoneConfig.additionalDrops)
    end

    drops = applyExpansionDrops(drops, zoneConfig)

    return drops
end

-- Custom tool break check with zone-specific chance
local function doesToolBreakCustom(player, info, zoneConfig)
    local roll = math.random(1, 100)
    local mod = info.mod

    if mod then
        roll = roll + (player:getMod(mod) / 10)
    end

    local breakChance = zoneConfig.breakChance or info.settingBreak

    if roll <= breakChance then
        player:tradeComplete()
        return true
    end

    return false
end

-- Custom item picker with zone-specific drops and rate
local function pickItemCustom(player, info, zoneId, zoneConfig)
    local rate = zoneConfig.rate or info.settingRate

    if math.random(1, 100) > rate then
        return 0
    end

    local drops = getEffectiveDrops(info, zoneId, zoneConfig)

    local sum = 0
    for i = 1, #drops do
        sum = sum + drops[i][1]
    end

    local item = 0
    local pick = math.random(1, sum)
    sum = 0

    for i = 1, #drops do
        sum = sum + drops[i][1]
        if sum >= pick then
            item = drops[i][2]
            break
        end
    end

    if item == xi.item.RED_ROCK then
        item = rocks[VanadielDayElement()]
    end

    return item
end

-- Move point helper (replicated from base logic.lua)
local function doMove(npc, x, y, z)
    return function(entity)
        entity:setPos(x, y, z, 0)
    end
end

local function movePoint(player, npc, zoneId, info)
    local points = info.zone[zoneId].points
    local point = points[math.random(1, #points)]

    npc:hideNPC(120)
    npc:queue(3000, doMove(npc, unpack(point)))
end

-----------------------------------
-- OVERRIDES
-----------------------------------

m:addOverride('xi.helm.onTrade', function(player, npc, trade, helmType, csid, func)
    local info = xi.helm.dataTable[helmType]
    local zoneId = player:getZoneID()
    local zoneConfig = getZoneConfig(helmType, zoneId)

    if not zoneConfig then
        super(player, npc, trade, helmType, csid, func)
        return
    end

    player:delStatusEffect(xi.effect.INVISIBLE)

    if trade:hasItemQty(info.tool, 1) and trade:getItemCount() == 1 then
        local itemID = pickItemCustom(player, info, zoneId, zoneConfig)
        local broke = doesToolBreakCustom(player, info, zoneConfig) and 1 or 0
        local full = (player:getFreeSlotsCount() == 0) and 1 or 0

        -- Cutscene plays the emote in all zones but Adoulin.
        -- Adoulin uses emote packets.
        if csid then
            player:sendEmote(npc, info.animation, xi.emoteMode.MOTION, true)
            player:startEvent(csid, itemID, broke, full)
        else
            player:sendEmote(npc, info.animation, xi.emoteMode.MOTION, false)
        end

        if xi.wotg.helpers.helmTrade(player, helmType, broke) then
            return
        end

        if full == 1 then
            itemID = 0
        end

        if itemID ~= 0 then
            player:addItem(itemID)

            local uses = (npc:getLocalVar('uses') - 1) % 4
            npc:setLocalVar('uses', uses)

            if uses == 0 then
                movePoint(player, npc, zoneId, info)
            end
        end

        xi.helm.result(player, helmType, broke, itemID)

        if type(func) == 'function' then
            func(player)
        end
    else
        player:messageSpecial(zones[zoneId].text[info.message], info.tool)
    end
end)

-----------------------------------
-- UTILITY API
-----------------------------------

xi.helmConfig = xi.helmConfig or {}
xi.helmConfig.config = config

xi.helmConfig.getConfig = function()
    return config
end

xi.helmConfig.getZoneConfig = function(helmType, zoneId)
    return getZoneConfig(helmType, zoneId)
end

xi.helmConfig.setZoneConfig = function(helmType, zoneId, zoneConfig)
    if not config[helmType] then
        config[helmType] = {}
    end

    config[helmType][zoneId] = zoneConfig
    return true
end

xi.helmConfig.setZoneRate = function(helmType, zoneId, rate)
    if not config[helmType] then
        config[helmType] = {}
    end

    if not config[helmType][zoneId] then
        config[helmType][zoneId] = {}
    end

    config[helmType][zoneId].rate = rate
    return true
end

xi.helmConfig.setZoneBreakChance = function(helmType, zoneId, breakChance)
    if not config[helmType] then
        config[helmType] = {}
    end

    if not config[helmType][zoneId] then
        config[helmType][zoneId] = {}
    end

    config[helmType][zoneId].breakChance = breakChance
    return true
end

xi.helmConfig.addZoneDrop = function(helmType, zoneId, weight, itemId)
    if not config[helmType] then
        config[helmType] = {}
    end

    if not config[helmType][zoneId] then
        config[helmType][zoneId] = {}
    end

    if not config[helmType][zoneId].additionalDrops then
        config[helmType][zoneId].additionalDrops = {}
    end

    table.insert(config[helmType][zoneId].additionalDrops, { weight, itemId })
    return true
end

xi.helmConfig.setZoneDrops = function(helmType, zoneId, drops)
    if not config[helmType] then
        config[helmType] = {}
    end

    if not config[helmType][zoneId] then
        config[helmType][zoneId] = {}
    end

    config[helmType][zoneId].drops = drops
    return true
end

return m
