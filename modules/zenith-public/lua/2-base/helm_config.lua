-----------------------------------
-- HELM Zone Configuration Module
--
-- This module allows customizing HELM (Harvesting, Excavation, Logging, Mining)
-- item pools and success/break rates on a per-zone basis.
--
-- The configuration is written into xi.helm.dataTable at server start; the base
-- xi.helm.onTrade keeps running unchanged. xi.helm.result is wrapped only to tell
-- the player when a tool breaks while their inventory is full. Do NOT reintroduce an onTrade override:
-- base owns the minLevel gate, the Mount Zhayolm daily cap, the shared depletion
-- pools, the camp penalty ([HELM]PositionIndex), the per-type relocateRate /
-- respawnTime and the ENABLE_HELM_WAIT delay, and a replacement silently drops
-- all of them.
--
-- Configuration options per zone:
--   rate           - Override the retail obtainRate (percent, floats allowed)
--   breakChance    - Override the retail breakRate (percent, floats allowed)
--   drops          - Replace the entire drop table for this zone
--   additionalDrops - Add items to the existing drop pool
--   additionalDrops<EXPANSION> - Add items to the pool only when the matching
--                     ENABLE_<EXPANSION> server setting is active (e.g.
--                     additionalDropsABYSSEA gates on xi.settings.main.ENABLE_ABYSSEA).
--                     This mirrors the stock<EXPANSION> convention in vendorOverrides.lua
--                     and is intentionally keyed off ENABLE_<X> (not xi.pre), so post-era
--                     items auto-disable until their expansion is enabled without
--                     hand-editing this module.
--
-- Anything a zone does not set keeps the retail-captured base value, so omitting
-- rate/breakChance is the accurate choice unless a deliberate server tweak is wanted.
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
            },
            additionalDropsROTZ =
            {
                {  10, xi.item.SPRIG_OF_FRESH_MUGWORT          },
            },
            additionalDropsCOP =
            {
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
            },
            additionalDropsROTZ =
            {
                {  10, xi.item.SPRIG_OF_FRESH_MUGWORT          },
            },
            additionalDropsCOP =
            {
                { 150, xi.item.CLUMP_OF_RED_MOKO_GRASS         },
            },
            -- WOTG: Dyer's Woad (added Sep 2008)
            additionalDropsWOTG =
            {
                {  10, xi.item.SPRIG_OF_DYERS_WOAD             },
            },
        },
        -- TODO Audit Yuhtunga Jungle Harvesting (Only appears during rain)
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
        -- TODO Audit Yhoator Jungle Harvesting (Only appears during rain)
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
                {  10, xi.item.WAMOURA_COCOON               },
            },
            -- WOTG: Eastern Ginger Root (added Jun 2008)
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
            -- WOTG: Eastern Ginger Root (added Jun 2008)
            additionalDropsWOTG =
            {
                {  50, xi.item.EASTERN_GINGER_ROOT          },
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
        -- TODO Audit Abyssea Grauberg
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
                {  10, xi.item.HANDFUL_OF_WYVERN_SCALES    },
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
                {  50, xi.item.LUGWORM                },
                { 100, xi.item.SHELL_BUG              },
                {  10, xi.item.CORAL_FRAGMENT         },
                {  50, xi.item.TURTLE_SHELL           },
                {  50, xi.item.HELMET_MOLE            },
                {  10, xi.item.BEETLE_JAW             },
                {  50, xi.item.SHALL_SHELL            },
                { 100, xi.item.VIAL_OF_SLIME_OIL      },
                {  10, xi.item.VIAL_OF_BEASTMAN_BLOOD },
            },
            additionalDropsCOP =
            {
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
                { 240, xi.item.PIECE_OF_RATTAN_LUMBER },
                { 100, xi.item.LAUAN_LOG              },
                {  50, xi.item.REVIVAL_TREE_ROOT      },
                {  50, xi.item.BEEHIVE_CHIP           },
                {  50, xi.item.BAG_OF_TREE_CUTTINGS   },
                {  10, xi.item.EBONY_LOG              },
                {  50, xi.item.HOLLY_LOG              },
                {  50, xi.item.ROSEWOOD_LOG           },
                {  10, xi.item.KITRON                 },
                {  50, xi.item.STICK_OF_CINNAMON      },
                {  10, xi.item.STICK_OF_VANILLA       },
            },
            -- Abyssea-era logging items gated behind ENABLE_ABYSSEA
            additionalDropsABYSSEA =
            {
                {  50, xi.item.AQUILARIA_LOG          },
                { 100, xi.item.BUTTERPEAR             },
                {  50, xi.item.KAPOR_LOG              },
            },
        },

        [xi.zone.YHOATOR_JUNGLE] =
        {
            breakChance = 20,
            drops =
            {
                {  50, xi.item.ARROWWOOD_LOG          },
                { 240, xi.item.PIECE_OF_RATTAN_LUMBER },
                { 100, xi.item.LAUAN_LOG              },
                {  50, xi.item.REVIVAL_TREE_ROOT      },
                { 100, xi.item.BEEHIVE_CHIP           },
                {  10, xi.item.BAG_OF_TREE_CUTTINGS   },
                {  10, xi.item.EBONY_LOG              },
                {  50, xi.item.DRYAD_ROOT             },
                {  50, xi.item.MAHOGANY_LOG           },
                {  50, xi.item.MALBORO_VINE           },
                {  10, xi.item.BLACK_CHOCOBO_FEATHER  },
                {   5, xi.item.LACQUER_TREE_LOG       },
            },
            -- Abyssea-era logging items gated behind ENABLE_ABYSSEA
            additionalDropsABYSSEA =
            {
                {  50, xi.item.AQUILARIA_LOG          },
                { 100, xi.item.BUTTERPEAR             },
                { 100, xi.item.KAPOR_LOG              },
            },
        },

        [xi.zone.LUFAISE_MEADOWS] =
        {
            breakChance = 20,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG      },
                { 240, xi.item.ASH_LOG            },
                { 150, xi.item.MAPLE_LOG          },
                { 100, xi.item.FAERIE_APPLE       },
                { 100, xi.item.WALNUT_LOG         },
                { 100, xi.item.ACORN              },
                {  50, xi.item.ELM_LOG            },
                {  10, xi.item.OAK_LOG            },
                {  50, xi.item.SPRIG_OF_MISTLETOE },
                {  50, xi.item.HOLLY_LOG          },
            },
        },

        [xi.zone.MISAREAUX_COAST] =
        {
            breakChance = 20,
            drops =
            {
                { 150, xi.item.ARROWWOOD_LOG      },
                { 240, xi.item.ASH_LOG            },
                { 150, xi.item.MAPLE_LOG          },
                { 100, xi.item.FAERIE_APPLE       },
                { 100, xi.item.WALNUT_LOG         },
                {  50, xi.item.ACORN              },
                { 100, xi.item.ELM_LOG            },
                {  50, xi.item.OAK_LOG            },
                {  50, xi.item.GIANT_BIRD_FEATHER },
                {  10, xi.item.GIANT_BIRD_PLUME   },
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

        [xi.zone.FORT_KARUGO_NARUGO_S] =
        {
            breakChance = 10,
            drops =
            {
                {  50, xi.item.FLASK_OF_HOLY_WATER },
                { 150, xi.item.PAIR_OF_NOPALES     },
                { 150, xi.item.DRAGON_FRUIT        },
                { 100, xi.item.BIRD_FEATHER        },
                { 100, xi.item.BIRD_EGG            },
                {  10, xi.item.BAG_OF_CACTUS_STEMS },
                {  50, xi.item.DRYAD_ROOT          },
                {  50, xi.item.BEEHIVE_CHIP        },
                { 100, xi.item.GNAT_WING           },
                {  50, xi.item.WILD_ONION          },
                {  10, xi.item.RAFFLESIA_VINE      },
            },
        },
    },

    -- MINING (Pickaxe) ------------------------------------------------------
    [xi.helmType.MINING] =
    {
        [xi.zone.YUGHOTT_GROTTO] =
        {
            breakChance = 55,
            drops =
            {
                { 100, xi.item.CHUNK_OF_COPPER_ORE    },
                { 240, xi.item.CHUNK_OF_IRON_ORE      },
                { 150, xi.item.CHUNK_OF_TIN_ORE       },
                { 150, xi.item.PEBBLE                 },
                { 150, xi.item.CHUNK_OF_ZINC_ORE      },
                { 100, xi.item.FLINT_STONE            },
                {  50, xi.item.CHUNK_OF_SILVER_ORE    },
                {  10, xi.item.RED_ROCK               },
                {  10, xi.item.CHUNK_OF_DARKSTEEL_ORE },
                {   5, xi.item.CHUNK_OF_GOLD_ORE      },
            },
        },

        [xi.zone.GUSGEN_MINES] =
        {
            breakChance = 55,
            drops =
            {
                { 150, xi.item.CHUNK_OF_COPPER_ORE    },
                { 150, xi.item.CHUNK_OF_IRON_ORE      },
                { 150, xi.item.CHUNK_OF_TIN_ORE       },
                {  50, xi.item.PEBBLE                 },
                { 150, xi.item.CHUNK_OF_ZINC_ORE      },
                { 100, xi.item.CHUNK_OF_SILVER_ORE    },
                {  50, xi.item.RED_ROCK               },
                {  50, xi.item.CHUNK_OF_DARKSTEEL_ORE },
                {  10, xi.item.CHUNK_OF_GOLD_ORE      },
            },
        },

        [xi.zone.PALBOROUGH_MINES] =
        {
            breakChance = 50,
            drops =
            {
                { 150, xi.item.CHUNK_OF_ZINC_ORE     },
                { 150, xi.item.CHUNK_OF_IRON_ORE     },
                { 150, xi.item.PEBBLE                },
                { 150, xi.item.CHUNK_OF_TIN_ORE      },
                { 100, xi.item.CHUNK_OF_MYTHRIL_ORE  },
                { 100, xi.item.CHUNK_OF_SILVER_ORE   },
                { 100, xi.item.CHUNK_OF_COPPER_ORE   },
                {  10, xi.item.CHUNK_OF_PLATINUM_ORE },
            },
        },

        [xi.zone.ZERUHN_MINES] =
        {
            breakChance = 45,
            drops =
            {
                { 150, xi.item.CHUNK_OF_IRON_ORE      },
                { 150, xi.item.PEBBLE                 },
                { 240, xi.item.CHUNK_OF_COPPER_ORE    },
                { 100, xi.item.CHUNK_OF_ZINC_ORE      },
                { 100, xi.item.CHUNK_OF_TIN_ORE       },
                { 150, xi.item.SNAPPING_MOLE          },
                {  10, xi.item.CHUNK_OF_SILVER_ORE    },
                {   5, xi.item.CHUNK_OF_DARKSTEEL_ORE },
                {   5, xi.item.CHUNK_OF_GOLD_ORE      },
            },
        },

        [xi.zone.IFRITS_CAULDRON] =
        {
            breakChance = 55, -- ~60-65% in retail
            drops =
            {
                { 100, xi.item.FLINT_STONE             },
                { 150, xi.item.CHUNK_OF_IRON_ORE       },
                { 100, xi.item.PINCH_OF_SULFUR         },
                {  10, xi.item.BOMB_ARM                },
                { 150, xi.item.PINCH_OF_BOMB_ASH       },
                { 150, xi.item.HANDFUL_OF_IRON_SAND    },
                {  10, xi.item.CHUNK_OF_ADAMAN_ORE     },
                {  10, xi.item.CHUNK_OF_DARKSTEEL_ORE  },
                {  50, xi.item.CHUNK_OF_ORPIMENT       },
                {   5, xi.item.CHUNK_OF_ORICHALCUM_ORE },
                {  10, xi.item.RED_ROCK                },
                { 100, xi.item.CHUNK_OF_SILVER_ORE     },
                {  10, xi.item.CHUNK_OF_GOLD_ORE       },
                {  10, xi.item.DEMON_HORN              },
            },
        },

        -- TODO: Audit Oldton Movalpolos
        [xi.zone.OLDTON_MOVALPOLOS] =
        {
            drops =
            {
                { 1150, xi.item.IGNEOUS_ROCK           },
                { 1130, xi.item.CHUNK_OF_ZINC_ORE      },
                { 1100, xi.item.CHUNK_OF_COPPER_ORE    },
                { 1080, xi.item.CHUNK_OF_TIN_ORE       },
                { 1050, xi.item.CHUNK_OF_SILVER_ORE    },
                {  970, xi.item.CHUNK_OF_IRON_ORE      },
                {  680, xi.item.SUIT_OF_MOBLIN_MAIL    },
                {  630, xi.item.MOBLIN_HELM            },
                {  600, xi.item.MOBLIN_MASK            },
                {  570, xi.item.GOBLIN_DIE             },
                {  570, xi.item.SUIT_OF_MOBLIN_ARMOR   },
                {   80, xi.item.CHUNK_OF_DARKSTEEL_ORE },
                {   80, xi.item.CHUNK_OF_MYTHRIL_ORE   },
                {   70, xi.item.CHUNK_OF_GOLD_ORE      },
                {   70, xi.item.CHUNK_OF_PLATINUM_ORE  },
            },
        },
        -- TODO: Audit Newton Movalpolos
        [xi.zone.NEWTON_MOVALPOLOS] =
        {
            drops =
            {
                { 1660, xi.item.CHUNK_OF_COPPER_ORE    },
                { 1100, xi.item.CHUNK_OF_TIN_ORE       },
                { 1450, xi.item.CHUNK_OF_ZINC_ORE      },
                { 1790, xi.item.IGNEOUS_ROCK           },
                { 1450, xi.item.CHUNK_OF_SILVER_ORE    },
                {  140, xi.item.CHUNK_OF_ALUMINUM_ORE  },
                { 1720, xi.item.CHUNK_OF_IRON_ORE      },
                {   70, xi.item.CHUNK_OF_DARKSTEEL_ORE },
                {  210, xi.item.CHUNK_OF_MYTHRIL_ORE   },
                {  140, xi.item.CHUNK_OF_GOLD_ORE      },
                {  340, xi.item.CHUNK_OF_PLATINUM_ORE  },
                {   70, xi.item.RED_ROCK               },
            },
        },

        [xi.zone.MOUNT_ZHAYOLM] =
        {
            breakChance = 55,
            drops =
            {
                { 150, xi.item.PINCH_OF_SULFUR      },
                { 150, xi.item.CHUNK_OF_IRON_ORE    },
                { 150, xi.item.HANDFUL_OF_IRON_SAND },
                { 100, xi.item.FLINT_STONE          },
                { 100, xi.item.PINCH_OF_BOMB_ASH    },
                {  50, xi.item.SUIT_OF_MOBLIN_MAIL  },
                {  50, xi.item.MOBLIN_HELM          },
                {  50, xi.item.TROLL_PAULDRON       },
                {  50, xi.item.TROLL_VAMBRACE       },
                {  10, xi.item.MOBLIN_MASK          },
                {  50, xi.item.DEMON_HORN           },
                {  10, xi.item.CHUNK_OF_ADAMAN_ORE  },
                {   1, xi.item.CHUNK_OF_KHROMA_ORE  },
                {  10, xi.item.SLAB_OF_PLUMBAGO     },
            },
        },

        [xi.zone.HALVUNG] =
        {
            breakChance = 55,
            drops =
            {
                { 100, xi.item.PINCH_OF_SULFUR           },
                {  10, xi.item.CHUNK_OF_LUMINIUM_ORE     },
                { 100, xi.item.HANDFUL_OF_IRON_SAND      },
                { 100, xi.item.FLINT_STONE               },
                { 100, xi.item.PINCH_OF_BOMB_ASH         },
                {  50, xi.item.SUIT_OF_MOBLIN_MAIL       },
                {  50, xi.item.MOBLIN_HELM               },
                {  50, xi.item.SUIT_OF_MOBLIN_ARMOR      },
                {  50, xi.item.TROLL_PAULDRON            },
                {  50, xi.item.TROLL_VAMBRACE            },
                {  50, xi.item.MOBLIN_MASK               },
                { 150, xi.item.CHUNK_OF_AHT_URHGAN_BRASS },
                {  10, xi.item.CHUNK_OF_GOLD_ORE         },
                {   5, xi.item.CHUNK_OF_ORICHALCUM_ORE   },
                {  10, xi.item.SLAB_OF_PLUMBAGO          },
                {  50, xi.item.CHUNK_OF_DARKSTEEL_ORE    },
            },
        },
        -- TODO: Audit North Gustaberg (S)
        [xi.zone.NORTH_GUSTABERG_S] =
        {
            drops =
            {
                { 1870, xi.item.CHUNK_OF_COPPER_ORE   },
                { 1930, xi.item.CHUNK_OF_ZINC_ORE     },
                { 1500, xi.item.CHUNK_OF_TIN_ORE      },
                { 1340, xi.item.PEBBLE                },
                {  860, xi.item.CHUNK_OF_SILVER_ORE   },
                { 1180, xi.item.CHUNK_OF_IRON_ORE     },
                {  750, xi.item.CHUNK_OF_MYTHRIL_ORE  },
                {  210, xi.item.MOBLIN_MASK           },
                {  110, xi.item.MOBLIN_HELM           },
                {  110, xi.item.SUIT_OF_MOBLIN_MAIL   },
                {   50, xi.item.SUIT_OF_MOBLIN_ARMOR  },
                {  160, xi.item.CHUNK_OF_PLATINUM_ORE },
            },
        },
    },
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

-- Build the effective drop table for a zone from the untouched base table
local function getEffectiveDrops(baseDrops, zoneConfig)
    local drops = zoneConfig.drops or baseDrops

    if zoneConfig.additionalDrops then
        drops = mergeDrops(drops, zoneConfig.additionalDrops)
    end

    return applyExpansionDrops(drops, zoneConfig)
end

-----------------------------------
-- CONFIGURATION APPLICATION
-----------------------------------

-- Pristine base drop tables, captured before the first merge so re-applying a zone
-- through the utility API below never stacks additionalDrops on top of itself.
local baseDropTables = {}

local function getBaseDrops(zoneData, helmType, zoneId)
    if not baseDropTables[helmType] then
        baseDropTables[helmType] = {}
    end

    if not baseDropTables[helmType][zoneId] then
        baseDropTables[helmType][zoneId] = zoneData.drops
    end

    return baseDropTables[helmType][zoneId]
end

-- Write one zone's configuration into xi.helm.dataTable.
-- Returns false when the base has no data for that helm type / zone pair.
local function applyZoneConfig(helmType, zoneId)
    local info       = xi.helm.dataTable and xi.helm.dataTable[helmType]
    local zoneData   = info and info.zone[zoneId]
    local zoneConfig = getZoneConfig(helmType, zoneId)

    if not zoneData or not zoneConfig then
        return false
    end

    zoneData.drops = getEffectiveDrops(getBaseDrops(zoneData, helmType, zoneId), zoneConfig)

    -- obtainRate and breakRate are retail-captured floats; only replace them when
    -- the zone config carries a deliberate server-side value.
    if zoneConfig.rate then
        zoneData.obtainRate = zoneConfig.rate
    end

    if zoneConfig.breakChance then
        zoneData.breakRate = zoneConfig.breakChance
    end

    return true
end

-----------------------------------
-- OVERRIDES
-----------------------------------

-- Applied at server start, once scripts/globals/hobbies/helm/data.lua has built
-- xi.helm.dataTable. Nothing here replaces base behaviour: only the per-zone drop
-- table, obtain rate and break rate are rewritten.
m:addOverride('xi.server.onServerStart', function()
    super()

    local zoneCount = 0

    for helmType, zoneConfigs in pairs(config) do
        for zoneId in pairs(zoneConfigs) do
            if applyZoneConfig(helmType, zoneId) then
                zoneCount = zoneCount + 1
            else
                printf('[helm_config] Warning: no base HELM data for type %d zone %d, skipping zone override.', helmType, zoneId)
            end
        end
    end

    if zoneCount > 0 then
        printf('[helm_config] Applied %d HELM zone override(s).', zoneCount)
    end
end)

-- With a full inventory the HELM cutscene only says "Your inventory is full", even
-- when base onTrade broke and removed the tool. Base zeroes itemID when the
-- inventory is full and adds nothing, so broke + no item + no free slot is exactly
-- that case; tell the player the tool broke.
local toolNames =
{
    [xi.helmType.HARVESTING] = 'sickle',
    [xi.helmType.EXCAVATION] = 'pickaxe',
    [xi.helmType.LOGGING]    = 'hatchet',
    [xi.helmType.MINING]     = 'pickaxe',
}

m:addOverride('xi.helm.result', function(player, helmType, broke, itemID)
    super(player, helmType, broke, itemID)

    if
        broke == 1 and
        itemID == 0 and
        player:getFreeSlotsCount() == 0
    then
        player:printToPlayer(string.format('Your %s breaks.', toolNames[helmType]), xi.msg.channel.SYSTEM_3)
    end
end)

-----------------------------------
-- UTILITY API
--
-- The setters re-apply the zone immediately, so a runtime change lands in
-- xi.helm.dataTable instead of waiting for the next server start. They return
-- false when the base has no data for that helm type / zone pair.
-----------------------------------

xi.helmConfig = xi.helmConfig or {}
xi.helmConfig.config = config

xi.helmConfig.getConfig = function()
    return config
end

xi.helmConfig.getZoneConfig = function(helmType, zoneId)
    return getZoneConfig(helmType, zoneId)
end

-- Make sure config[helmType][zoneId] exists so a setter can write into it
local function ensureZoneConfig(helmType, zoneId)
    if not config[helmType] then
        config[helmType] = {}
    end

    if not config[helmType][zoneId] then
        config[helmType][zoneId] = {}
    end

    return config[helmType][zoneId]
end

xi.helmConfig.setZoneConfig = function(helmType, zoneId, zoneConfig)
    if not config[helmType] then
        config[helmType] = {}
    end

    config[helmType][zoneId] = zoneConfig

    return applyZoneConfig(helmType, zoneId)
end

xi.helmConfig.setZoneRate = function(helmType, zoneId, rate)
    ensureZoneConfig(helmType, zoneId).rate = rate

    return applyZoneConfig(helmType, zoneId)
end

xi.helmConfig.setZoneBreakChance = function(helmType, zoneId, breakChance)
    ensureZoneConfig(helmType, zoneId).breakChance = breakChance

    return applyZoneConfig(helmType, zoneId)
end

xi.helmConfig.addZoneDrop = function(helmType, zoneId, weight, itemId)
    local zoneConfig = ensureZoneConfig(helmType, zoneId)

    if not zoneConfig.additionalDrops then
        zoneConfig.additionalDrops = {}
    end

    table.insert(zoneConfig.additionalDrops, { weight, itemId })

    return applyZoneConfig(helmType, zoneId)
end

xi.helmConfig.setZoneDrops = function(helmType, zoneId, drops)
    ensureZoneConfig(helmType, zoneId).drops = drops

    return applyZoneConfig(helmType, zoneId)
end

return m
