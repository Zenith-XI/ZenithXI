-----------------------------------
-- Clamming Data
-----------------------------------
xi = xi or {}
xi.clamming = xi.clamming or {}
-----------------------------------

-- Table with "Clamming Point" associated event ID.
xi.clamming.npcEvent =
{
    ['Clamming_Point_1'] = 20,
    ['Clamming_Point_2'] = 21,
    ['Clamming_Point_3'] = 22,
    ['Clamming_Point_4'] = 23,
    ['Clamming_Point_5'] = 24,
    ['Clamming_Point_6'] = 25,
    ['Clamming_Point_7'] = 26,
    ['Clamming_Point_8'] = 27,
}

-- Table with item weight and local var name.
xi.clamming.itemData =
{
    [xi.item.BIBIKI_SLUG              ] = {  3, '[Clam]BibikiSlug'   },
    [xi.item.JACKNIFE                 ] = { 11, '[Clam]Jacknife'     },
    [xi.item.PEBBLE                   ] = {  7, '[Clam]Peeble'       },
    [xi.item.IGNEOUS_ROCK             ] = { 35, '[Clam]IgneousRock'  },
    [xi.item.CLUMP_OF_PAMTAM_KELP     ] = {  6, '[Clam]PamtamKelp'   },
    [xi.item.SHALL_SHELL              ] = {  6, '[Clam]ShallShell'   },
    [xi.item.HANDFUL_OF_FISH_SCALES   ] = {  6, '[Clam]FishScales'   },
    [xi.item.NEBIMONITE               ] = {  6, '[Clam]Nebimonite'   },
    [xi.item.CHUNK_OF_ROCK_SALT       ] = {  6, '[Clam]RockSalt'     },
    [xi.item.HOBGOBLIN_PIE            ] = {  6, '[Clam]HobPie'       },
    [xi.item.CRAB_SHELL               ] = {  6, '[Clam]CrabShell'    },
    [xi.item.GOBLIN_MAIL              ] = {  6, '[Clam]GoblinMail'   },
    [xi.item.ELSHIMO_COCONUT          ] = {  6, '[Clam]Coconut'      },
    [xi.item.GOBLIN_ARMOR             ] = {  6, '[Clam]GoblinArmor'  },
    [xi.item.BROKEN_WILLOW_FISHING_ROD] = {  6, '[Clam]WillowRod'    },
    [xi.item.HIGH_QUALITY_PUGIL_SCALE ] = {  6, '[Clam]HQPugilScale' },
    [xi.item.LOAF_OF_HOBGOBLIN_BREAD  ] = {  6, '[Clam]HobBread'     },
    [xi.item.SEASHELL                 ] = {  6, '[Clam]Seashell'     },
    [xi.item.BUNCH_OF_PAMAMAS         ] = {  6, '[Clam]Pamamas'      },
    [xi.item.MAPLE_LOG                ] = {  6, '[Clam]MapleLog'     },
    [xi.item.PETRIFIED_LOG            ] = {  6, '[Clam]PetrifiedLog' },
    [xi.item.CORAL_FRAGMENT           ] = {  6, '[Clam]CoralFrag'    },
    [xi.item.ELM_LOG                  ] = {  6, '[Clam]ElmLog'       },
    [xi.item.TROPICAL_CLAM            ] = { 20, '[Clam]TropicalClam' },
    [xi.item.TITANICTUS_SHELL         ] = {  6, '[Clam]TitanShell'   },
    [xi.item.BIBIKI_URCHIN            ] = {  6, '[Clam]BibikiUrchin' },
    [xi.item.LACQUER_TREE_LOG         ] = {  6, '[Clam]LacquerLog'   },
    [xi.item.HIGH_QUALITY_CRAB_SHELL  ] = {  6, '[Clam]HQCrabShell'  },
    [xi.item.TURTLE_SHELL             ] = {  6, '[Clam]TurtleShell'  },
    [xi.item.PIECE_OF_OXBLOOD         ] = {  6, '[Clam]Oxblood'      },
}

-- Possible loot by npc. Item, weight and requirements. TODO: Add requirements.
xi.clamming.lootTable =
{
    ['Clamming_Point_1'] = -- North
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_2'] = -- East
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_3'] = -- East
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_4'] = -- South
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_5'] = -- South
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_6'] = -- South
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_7'] = -- West
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },

    ['Clamming_Point_8'] = -- West
    {
        [1] = { xi.item.BIBIKI_SLUG, 10000, 10000 },
    },
}
