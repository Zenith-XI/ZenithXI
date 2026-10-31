-----------------------------------
-- Era chocobo digging loot (ZENITHDEV-273)
-- Swaps the items of the regular digging pools to match the historical pools in Phoenix's pxi_digging_data.lua.
-- Items in both keep LSB's chance and rank, and all digging mechanics and other layers stay LSB's.
-- Each item added is { item, chance, rank }: the rank is Phoenix's, the chance is Phoenix's full rank weight / 12.5.
-----------------------------------
require('scripts/globals/hobbies/chocobo_digging/data')
-----------------------------------
local eraChanges =
{
    [xi.zone.BATALLIA_DOWNS] =
    {
        add =
        {
            { xi.item.PURPLE_ROCK, 16, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.BUBURIMU_PENINSULA] =
    {
        remove =
        {
            xi.item.CORAL_FRAGMENT,
        },
        add =
        {
            { xi.item.TURTLE_SHELL, 7, xi.craftRank.VETERAN },
        },
    },

    [xi.zone.EAST_RONFAURE] =
    {
        remove =
        {
            xi.item.KING_TRUFFLE,
        },
    },

    [xi.zone.EAST_SARUTABARUTA] =
    {
        remove =
        {
            xi.item.EBONY_LOG,
        },
        add =
        {
            { xi.item.GREEN_ROCK, 19, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.JUGNER_FOREST] =
    {
        add =
        {
            { xi.item.ARROWWOOD_LOG, 60, xi.craftRank.AMATEUR },
        },
    },

    [xi.zone.KONSCHTAT_HIGHLANDS] =
    {
        add =
        {
            { xi.item.PHOENIX_FEATHER, 8, xi.craftRank.EXPERT },
        },
    },

    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        add =
        {
            { xi.item.INSECT_WING, 51, xi.craftRank.AMATEUR },
            { xi.item.YELLOW_ROCK, 14, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.NORTH_GUSTABERG] =
    {
        remove =
        {
            xi.item.BAG_OF_CACTUS_STEMS,
            xi.item.CHUNK_OF_MYTHRIL_ORE,
        },
        add =
        {
            { xi.item.FLINT_STONE, 10, xi.craftRank.AMATEUR },
        },
    },

    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        remove =
        {
            xi.item.PETRIFIED_LOG,
        },
        add =
        {
            { xi.item.BLACK_ROCK, 13, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.ROLANBERRY_FIELDS] =
    {
        add =
        {
            { xi.item.CORAL_FUNGUS, 12, xi.craftRank.CRAFTSMAN },
        },
    },

    [xi.zone.SOUTH_GUSTABERG] =
    {
        remove =
        {
            xi.item.CHUNK_OF_MYTHRIL_ORE,
        },
    },

    [xi.zone.TAHRONGI_CANYON] =
    {
        remove =
        {
            xi.item.GOLD_BEASTCOIN,
        },
        add =
        {
            { xi.item.RED_ROCK, 18, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.WEST_SARUTABARUTA] =
    {
        remove =
        {
            xi.item.ROSEWOOD_LOG,
        },
        add =
        {
            { xi.item.BAG_OF_TREE_CUTTINGS, 14, xi.craftRank.CRAFTSMAN },
        },
    },

    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        remove =
        {
            xi.item.FLINT_STONE,
        },
    },

    [xi.zone.THE_SANCTUARY_OF_ZITAH] =
    {
        remove =
        {
            xi.item.PETRIFIED_LOG,
        },
        add =
        {
            { xi.item.TRANSLUCENT_ROCK, 14, xi.craftRank.JOURNEYMAN },
        },
    },

    [xi.zone.YHOATOR_JUNGLE] =
    {
        add =
        {
            { xi.item.PETRIFIED_LOG, 7, xi.craftRank.ARTISAN },
        },
    },

    [xi.zone.BIBIKI_BAY] =
    {
        remove =
        {
            xi.item.CHUNK_OF_PLATINUM_ORE,
            xi.item.CORAL_FRAGMENT,
        },
        add =
        {
            { xi.item.TURTLE_SHELL, 8, xi.craftRank.VETERAN },
        },
    },

    [xi.zone.CARPENTERS_LANDING] =
    {
        add =
        {
            { xi.item.OAK_LOG, 15, xi.craftRank.JOURNEYMAN },
            { xi.item.KING_TRUFFLE, 4, xi.craftRank.EXPERT },
        },
    },

    [xi.zone.BHAFLAU_THICKETS] =
    {
        remove =
        {
            xi.item.FLINT_STONE,
        },
        add =
        {
            { xi.item.BLUE_ROCK, 20, xi.craftRank.ARTISAN },
        },
    },

    [xi.zone.WAJAOM_WOODLANDS] =
    {
        add =
        {
            { xi.item.BLUE_ROCK, 16, xi.craftRank.JOURNEYMAN },
        },
    },
}

for zoneId, changes in pairs(eraChanges) do
    local rows    = xi.chocoboDig.digInfo[zoneId][xi.chocoboDig.layer.REGULAR]
    local present = {}

    for index = #rows, 1, -1 do
        if utils.contains(rows[index][1], changes.remove or {}) then
            table.remove(rows, index)
        else
            present[rows[index][1]] = true
        end
    end

    for _, row in ipairs(changes.add or {}) do
        -- The filewatcher can run this file again
        if not present[row[1]] then
            table.insert(rows, row)
        end
    end
end
