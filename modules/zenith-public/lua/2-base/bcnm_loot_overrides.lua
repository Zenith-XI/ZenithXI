-----------------------------------
-- BCNM/KSNM Loot Override Module
--
-- This module allows server administrators to override loot tables for
-- BSNM (Burning Circle Seal Notorious Monster) and KSNM (Kindred Seal
-- Notorious Monster) battlefields without modifying core scripts.
--
-- =========================================================================
-- HOW TO USE THIS MODULE
-- =========================================================================
--
-- 1. Find the battlefield ID you want to modify in scripts/globals/battlefield.lua
--    Example: xi.battlefield.id.CHARMING_TRIO, xi.battlefield.id.DOUBLE_DRAGONIAN
--
-- 2. Add an entry to the lootOverrides table below using the battlefield ID as the key
--
-- 3. Define your loot table using the format described below
--
-- 4. Restart the server for changes to take effect
--
-- =========================================================================
-- LOOT TABLE FORMAT
-- =========================================================================
--
-- Each battlefield's loot is defined as an array of "loot groups".
-- When a player wins and opens the Armoury Crate, ONE item is selected
-- from EACH loot group based on weighted random selection.
--
-- BASIC STRUCTURE:
-- {
--     { group1 },  -- One item selected from this group
--     { group2 },  -- One item selected from this group
--     { group3 },  -- etc.
-- }
--
-- LOOT GROUP OPTIONS:
--
-- 1. Single guaranteed item:
--    { { itemId = xi.item.ITEM_NAME, weight = 1000 } }
--
-- 2. Multiple items with different drop rates (weights are relative):
--    {
--        { itemId = xi.item.COMMON_ITEM, weight = 700 },   -- 70% chance
--        { itemId = xi.item.UNCOMMON_ITEM, weight = 200 }, -- 20% chance
--        { itemId = xi.item.RARE_ITEM, weight = 100 },     -- 10% chance
--    }
--
-- 3. Chance of dropping nothing (use xi.item.NONE):
--    {
--        { itemId = xi.item.NONE, weight = 800 },      -- 80% nothing
--        { itemId = xi.item.RARE_DROP, weight = 200 }, -- 20% rare item
--    }
--
-- 4. Multiple items from same pool (use quantity field):
--    {
--        quantity = 2,  -- Select 2 items from this group
--        { itemId = xi.item.ITEM_A, weight = 100 },
--        { itemId = xi.item.ITEM_B, weight = 100 },
--        { itemId = xi.item.ITEM_C, weight = 100 },
--    }
--
-- 5. Gil reward (use amount field):
--    { { itemId = xi.item.GIL, weight = 1000, amount = 5000 } }
--    Note: Gil is split evenly among all party members.
--
-- WEIGHT SYSTEM:
-- - Higher weight = higher chance to drop
-- - The probability is: item_weight / total_group_weight
-- - Use xi.loot.weight constants for consistency:
--   xi.loot.weight.EXTREMELY_LOW  = 2
--   xi.loot.weight.VERY_LOW       = 10
--   xi.loot.weight.LOW            = 30
--   xi.loot.weight.NORMAL         = 50
--   xi.loot.weight.HIGH           = 70
--   xi.loot.weight.VERY_HIGH      = 100
--   xi.loot.weight.EXTREMELY_HIGH = 140
--
-- =========================================================================
-- EXAMPLE CONFIGURATIONS (Commented Out)
-- =========================================================================
--
-- Example 1: Override Charming Trio (BCNM20) to give guaranteed Mannequin Head
-- [xi.battlefield.id.CHARMING_TRIO] =
-- {
--     -- Group 1: Gil reward
--     {
--         { itemId = xi.item.GIL, weight = 1000, amount = 3000 },
--     },
--
--     -- Group 2: Choose 2 platoon weapons
--     {
--         quantity = 2,
--         { itemId = xi.item.PLATOON_EDGE, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.PLATOON_SPATHA, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.PLATOON_DISC, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.PLATOON_CUTTER, weight = xi.loot.weight.NORMAL },
--     },
--
--     -- Group 3: Guaranteed Mannequin Head (normally 5% chance)
--     {
--         { itemId = xi.item.MANNEQUIN_HEAD, weight = 1000 },
--     },
-- },
--
-- Example 2: Override Double Dragonian (KSNM) with custom drops
-- [xi.battlefield.id.DOUBLE_DRAGONIAN] =
-- {
--     -- Group 1: Gil
--     {
--         { itemId = xi.item.GIL, weight = 1000, amount = 20000 },
--     },
--
--     -- Group 2: Rare weapon pool
--     {
--         { itemId = xi.item.NONE, weight = 500 },                    -- 50% nothing
--         { itemId = xi.item.SPEED_BELT, weight = 100 },              -- 10% Speed Belt
--         { itemId = xi.item.PEACOCK_CHARM, weight = 50 },            -- 5% Peacock Charm
--         { itemId = xi.item.SNIPERS_RING, weight = xi.loot.weight.VERY_HIGH },
--     },
--
--     -- Group 3: Crafting materials
--     {
--         quantity = 3,
--         { itemId = xi.item.WYVERN_SKIN, weight = xi.loot.weight.HIGH },
--         { itemId = xi.item.DRAGON_HEART, weight = xi.loot.weight.LOW },
--         { itemId = xi.item.DRAGON_BLOOD, weight = xi.loot.weight.NORMAL },
--     },
-- },
--
-- Example 3: Override Divine Punishers (BCNM60) with boosted rare drop rates
-- [xi.battlefield.id.DIVINE_PUNISHERS] =
-- {
--     -- Group 1: Gil
--     {
--         { itemId = xi.item.GIL, weight = 1000, amount = 10000 },
--     },
--
--     -- Group 2: Weapon drops with improved rates
--     {
--         { itemId = xi.item.NONE, weight = 200 },
--         { itemId = xi.item.BALANCE_BUCKLER, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.FENCING_DEGEN, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.RAIFU, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.PALMERIN_SHIELD, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.KOSETSUSAMONJI, weight = xi.loot.weight.LOW },
--     },
--
--     -- Group 3: Accessory pool
--     {
--         { itemId = xi.item.NONE, weight = 850 },
--         { itemId = xi.item.ASSAULT_EARRING, weight = xi.loot.weight.NORMAL },
--         { itemId = xi.item.ASSAULT_EARRING, weight = xi.loot.weight.VERY_HIGH },
--     },
-- },
--
-----------------------------------

require('modules/module_utils')

local m = Module:new('b_bcnm_loot_overrides')

-----------------------------------
-- LOOT OVERRIDE CONFIGURATION
-----------------------------------
-- Add your battlefield loot overrides below.
-- Use the battlefield ID as the key and a complete loot table as the value.
-- See examples in the header comments for guidance.
-----------------------------------

local lootOverrides =
{
    -----------------------------------
    -- Under Observation (BCNM40, Horlais Peak)
    -- Reduced Utsusemi: Ni drop rate (originally 5% in group 4, 20% in group 5) - Now 2.5% in group 4, 10% in group 5
    -- Reduced Phalanx and Erase (originally both 20% in group 6) - Now 10%
    -----------------------------------
    [xi.battlefield.id.UNDER_OBSERVATION] =
    {
        -- Group 1: Gil
        {
            { itemId = xi.item.GIL, weight = 1000, amount = 5000 },
        },

        -- Group 2: Peacock Charm (rare)
        {
            { itemId = xi.item.NONE,          weight = 900 },
            { itemId = xi.item.PEACOCK_CHARM, weight = 100 },
        },

        -- Group 3: Weapons and Tilt Belt
        -- REDUCED Tilt Belt (was 300, now 250)
        {
            { itemId = xi.item.BEHOURD_LANCE,     weight =  50 },
            { itemId = xi.item.MUTILATOR,         weight =  50 },
            { itemId = xi.item.RAIFU,             weight =  50 },
            { itemId = xi.item.TILT_BELT,         weight = 250 },
            { itemId = xi.item.TOURNEY_PATAS,     weight =  50 },
            { itemId = xi.item.BLACK_ROCK,        weight =  25 },
            { itemId = xi.item.BLUE_ROCK,         weight =  25 },
            { itemId = xi.item.GREEN_ROCK,        weight =  25 },
            { itemId = xi.item.PURPLE_ROCK,       weight =  25 },
            { itemId = xi.item.RED_ROCK,          weight =  25 },
            { itemId = xi.item.TRANSLUCENT_ROCK,  weight =  25 },
            { itemId = xi.item.WHITE_ROCK,        weight =  25 },
            { itemId = xi.item.YELLOW_ROCK,       weight =  25 },
            { itemId = xi.item.AMETRINE,          weight =  25 },
            { itemId = xi.item.BLACK_PEARL,       weight =  25 },
            { itemId = xi.item.GARNET,            weight =  25 },
            { itemId = xi.item.GOSHENITE,         weight =  25 },
            { itemId = xi.item.PEARL,             weight =  25 },
            { itemId = xi.item.PERIDOT,           weight =  25 },
            { itemId = xi.item.SPHENE,            weight =  25 },
            { itemId = xi.item.TURQUOISE,         weight =  25 },
            { itemId = xi.item.MYTHRIL_BEASTCOIN, weight =  50 },
            { itemId = xi.item.OAK_LOG,           weight =  50 },
            { itemId = xi.item.SCROLL_OF_REFRESH, weight =  50 },
        },

        -- Group 4: Mixed drops
        -- REDUCED Utsusemi: Ni (was 50, now 25)
        -- REDUCED Mantra Belt (was 300, now 250)
        {
            { itemId = xi.item.BUZZARD_TUCK,          weight =  50 },
            { itemId = xi.item.DE_SAINTRES_AXE,       weight =  50 },
            { itemId = xi.item.GRUDGE_SWORD,          weight =  50 },
            { itemId = xi.item.MANTRA_BELT,           weight = 250 },
            { itemId = xi.item.BLACK_ROCK,            weight =  25 },
            { itemId = xi.item.BLUE_ROCK,             weight =  25 },
            { itemId = xi.item.GREEN_ROCK,            weight =  25 },
            { itemId = xi.item.PURPLE_ROCK,           weight =  25 },
            { itemId = xi.item.RED_ROCK,              weight =  25 },
            { itemId = xi.item.TRANSLUCENT_ROCK,      weight =  25 },
            { itemId = xi.item.WHITE_ROCK,            weight =  25 },
            { itemId = xi.item.YELLOW_ROCK,           weight =  25 },
            { itemId = xi.item.AMETRINE,              weight =  25 },
            { itemId = xi.item.BLACK_PEARL,           weight =  25 },
            { itemId = xi.item.GARNET,                weight =  25 },
            { itemId = xi.item.GOSHENITE,             weight =  25 },
            { itemId = xi.item.PEARL,                 weight =  25 },
            { itemId = xi.item.PERIDOT,               weight =  25 },
            { itemId = xi.item.SPHENE,                weight =  25 },
            { itemId = xi.item.TURQUOISE,             weight =  25 },
            { itemId = xi.item.MYTHRIL_BEASTCOIN,     weight =  50 },
            { itemId = xi.item.OAK_LOG,               weight =  50 },
            { itemId = xi.item.RERAISER,              weight =  50 },
            { itemId = xi.item.VILE_ELIXIR,           weight =  25 },
            { itemId = xi.item.SCROLL_OF_UTSUSEMI_NI, weight =  25 },
        },

        -- Group 5: Scrolls
        -- REDUCED Utsusemi: Ni (was 200, now 100)
        {
            { itemId = xi.item.SCROLL_OF_ICE_SPIKES,  weight = 300 },
            { itemId = xi.item.SCROLL_OF_REFRESH,     weight = 200 },
            { itemId = xi.item.SCROLL_OF_UTSUSEMI_NI, weight = 100 },
            { itemId = xi.item.GOLD_BEASTCOIN,        weight = 400 },
        },

        -- Group 6: Scrolls
        -- REDUCED Erase and Phalanx (was 200, now 100)
        {
            { itemId = xi.item.FIRE_SPIRIT_PACT,     weight = 200 },
            { itemId = xi.item.SCROLL_OF_ABSORB_STR, weight = 300 },
            { itemId = xi.item.SCROLL_OF_ERASE,      weight = 100 },
            { itemId = xi.item.SCROLL_OF_PHALANX,    weight = 100 },
            { itemId = xi.item.BLACK_PEARL,          weight = 300 },
        },

        -- Group 7: Guaranteed Hecteyes Eye
        {
            { itemId = xi.item.HECTEYES_EYE, weight = 1000 },
        },

        -- Group 8: Guaranteed Vial of Mercury
        {
            { itemId = xi.item.VIAL_OF_MERCURY, weight = 1000 },
        },
    },
}

-----------------------------------
-- MODULE INITIALIZATION
-----------------------------------

-- Apply loot overrides after server initialization when all battlefields are loaded
m:addOverride('xi.server.onServerStart', function()
    super()

    local overrideCount = 0
    for battlefieldId, lootTable in pairs(lootOverrides) do
        local battlefield = xi.battlefield.contents[battlefieldId]
        if battlefield then
            battlefield.loot = lootTable
            overrideCount = overrideCount + 1
        else
            printf('[bcnm_loot_overrides] Warning: Battlefield ID %d not found, skipping loot override.', battlefieldId)
        end
    end

    if overrideCount > 0 then
        printf('[bcnm_loot_overrides] Applied %d battlefield loot override(s).', overrideCount)
    end
end)

return m
