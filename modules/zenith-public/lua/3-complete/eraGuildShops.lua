-----------------------------------
-- Era Guild Shops
--
-- Restores the pre-June-2014 guild shops: the craft guilds' "General Vendors"
-- share one inventory and price pool with their partner merchant, and the
-- guild stock lists get their era quantities, restock rates and price curves
-- back. Sharing rides on the base cfg.sharedStock alias resolved by
-- canonicalShop in scripts/globals/guild_shops.lua -- no engine override.
--
-- Original work by Phoenix (montijin), PR "Era accurate guild shops":
--   https://github.com/phoenixffxi/Phoenix/pull/98
-- Their sources: 2009 Guild Masters Guide Ver.101207, FFXI Lightning Brigade
-- Ver.070613 and various archived https://wiki.ffo.jp/ pages.
-- ZenithXI has made changes to that work.
--
-- The dialogue side (which NPC opens which shared shop) lives in the companion
-- module c_guildVendorShops.
--
-- Public module for ZenithXI
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_eraGuildShops')

-- Data-only module: dummy override so the loader does not report
-- "No overrides found in module" (src/map/utils/moduleutils.cpp).
m:addOverride('xi.dummyFunc', function()
end)

-- The filewatcher can re-execute this file mid-session and the table.insert
-- calls below are not idempotent. The sentinel lives on xi.data.guildShops
-- itself so reloading scripts/data/guild_shops.lua clears it too. Nothing
-- iterates that table with pairs(), so an extra key is harmless.
if xi.data.guildShops.eraStockApplied then
    return m
end

xi.data.guildShops.eraStockApplied = true

-----------------------------------
-- Helpers
--
-- A missing shop or item means the base data drifted (upstream sync, item
-- rename). Warn and skip that one edit rather than aborting the file, which
-- would silently drop every patch below it.
-----------------------------------

local function getShop(shopName)
    local shop = xi.data.guildShops[shopName]
    if shop == nil or shop.stock == nil then
        printf('[warning] missing guild shop %s in c_eraGuildShops', shopName)
        return nil
    end

    return shop
end

local function findStock(shopName, itemId)
    local shop = getShop(shopName)
    if shop == nil then
        return nil, nil
    end

    for index, cfg in ipairs(shop.stock) do
        if cfg.id == itemId then
            return cfg, index
        end
    end

    printf('[warning] missing item %i in guild shop %s in c_eraGuildShops', itemId, shopName)

    return nil, nil
end

local function patchStock(shopName, itemId, patch)
    local cfg = findStock(shopName, itemId)
    if cfg == nil then
        return
    end

    for key, value in pairs(patch) do
        cfg[key] = value
    end
end

local function removeStock(shopName, itemId)
    local _, index = findStock(shopName, itemId)
    if index == nil then
        return
    end

    table.remove(xi.data.guildShops[shopName].stock, index)
end

-- Point an NPC with no stock list of its own at a partner merchant's shop.
local function shareStock(npcName, shopName)
    xi.data.guildShops[npcName] = { sharedStock = shopName }
end

-----------------------------------
-- Smithing
-----------------------------------
-- Amulya & Vicious Eye
shareStock('Vicious_Eye', 'Amulya')
table.insert(xi.data.guildShops['Amulya'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,   restockRate = 40 })
patchStock('Amulya', xi.item.CHUNK_OF_TIN_ORE,  { initial = 120 })
patchStock('Amulya', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 })
patchStock('Amulya', xi.item.BRONZE_INGOT,      { initial =  12 })
patchStock('Amulya', xi.item.IRON_INGOT,        { initial =  12 })
patchStock('Amulya', xi.item.BRONZE_SHEET,      { initial =  12 })
patchStock('Amulya', xi.item.IRON_SHEET,        { initial =  12 })
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Amulya'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Doggomehr & Lucretia
shareStock('Lucretia', 'Doggomehr')
table.insert(xi.data.guildShops['Doggomehr'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,   restockRate = 60 })
patchStock('Doggomehr', xi.item.CHUNK_OF_TIN_ORE,  { initial = 120 })
patchStock('Doggomehr', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 })
patchStock('Doggomehr', xi.item.BRONZE_INGOT,      { initial =  12, buyMax = 370, priceFloor = 230 })
patchStock('Doggomehr', xi.item.IRON_INGOT,        { initial =  12 })
patchStock('Doggomehr', xi.item.BRONZE_SHEET,      { initial =  12 })
patchStock('Doggomehr', xi.item.IRON_SHEET,        { initial =  12 })
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Doggomehr'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Kamilah & Mololo
shareStock('Mololo', 'Kamilah')
table.insert(xi.data.guildShops['Kamilah'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 110,  buyMax = 60,  restockRate = 20 })
patchStock('Kamilah', xi.item.CHUNK_OF_TIN_ORE,  { initial = 120 })
patchStock('Kamilah', xi.item.CHUNK_OF_IRON_ORE, { initial = 120 })

-- Ndego
patchStock('Ndego', xi.item.CHUNK_OF_COPPER_ORE, { initial = 120 })
patchStock('Ndego', xi.item.CHUNK_OF_TIN_ORE,    { initial = 120 })
patchStock('Ndego', xi.item.CHUNK_OF_IRON_ORE,   { initial = 120 })
patchStock('Ndego', xi.item.BRONZE_INGOT,        { initial =  12 })
patchStock('Ndego', xi.item.IRON_INGOT,          { initial =  12 })
patchStock('Ndego', xi.item.BRONZE_SHEET,        { initial =  12 })
patchStock('Ndego', xi.item.IRON_SHEET,          { initial =  12 })
patchStock('Ndego', xi.item.MANDREL,             { initial = 120 })
patchStock('Ndego', xi.item.WORKSHOP_ANVIL,      { initial = 120 })

-----------------------------------
-- Goldsmithing
-----------------------------------
-- Bornahn
patchStock('Bornahn', xi.item.CHUNK_OF_COPPER_ORE,     { initial = 120 })
patchStock('Bornahn', xi.item.CHUNK_OF_SILVER_ORE,     { initial = 120 })
patchStock('Bornahn', xi.item.CHUNK_OF_MYTHRIL_ORE,    { initial = 0 })
patchStock('Bornahn', xi.item.HANDFUL_OF_BRASS_SCALES, { initial = 1, restockRate = 1 })
patchStock('Bornahn', xi.item.MYTHRIL_CHAIN,           { initial = 1, restockRate = 1 })
patchStock('Bornahn', xi.item.RED_ROCK,                { initial = 2 })
patchStock('Bornahn', xi.item.BLUE_ROCK,               { initial = 2 })
patchStock('Bornahn', xi.item.YELLOW_ROCK,             { initial = 2 })
patchStock('Bornahn', xi.item.GREEN_ROCK,              { initial = 2 })
patchStock('Bornahn', xi.item.TRANSLUCENT_ROCK,        { initial = 2 })
patchStock('Bornahn', xi.item.PURPLE_ROCK,             { initial = 2 })
patchStock('Bornahn', xi.item.BLACK_ROCK,              { initial = 2 })
patchStock('Bornahn', xi.item.WHITE_ROCK,              { initial = 2 })
patchStock('Bornahn', xi.item.LAPIS_LAZULI,            { initial = 6 })
patchStock('Bornahn', xi.item.LIGHT_OPAL,              { initial = 6 })
patchStock('Bornahn', xi.item.ONYX,                    { initial = 6 })
patchStock('Bornahn', xi.item.AMETHYST,                { initial = 6 })
patchStock('Bornahn', xi.item.TOURMALINE,              { initial = 6 })
patchStock('Bornahn', xi.item.SARDONYX,                { initial = 6 })
patchStock('Bornahn', xi.item.CLEAR_TOPAZ,             { initial = 6 })
patchStock('Bornahn', xi.item.AMBER_STONE,             { initial = 6 })
patchStock('Bornahn', xi.item.WORKSHOP_ANVIL,          { initial = 0, restockRate = 0 })

-- Visala & Teerth
shareStock('Teerth', 'Visala')
table.insert(xi.data.guildShops['Visala'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,  restockRate = 60 })
patchStock('Visala', xi.item.CHUNK_OF_SILVER_ORE,     { initial = 120 })
patchStock('Visala', xi.item.CHUNK_OF_MYTHRIL_ORE,    { initial = 0 })
patchStock('Visala', xi.item.HANDFUL_OF_BRASS_SCALES, { initial = 1, restockRate = 1 })
patchStock('Visala', xi.item.MYTHRIL_CHAIN,           { initial = 1 })
patchStock('Visala', xi.item.RED_ROCK,                { initial = 2 })
patchStock('Visala', xi.item.BLUE_ROCK,               { initial = 2 })
patchStock('Visala', xi.item.YELLOW_ROCK,             { initial = 2 })
patchStock('Visala', xi.item.GREEN_ROCK,              { initial = 2 })
patchStock('Visala', xi.item.TRANSLUCENT_ROCK,        { initial = 2 })
patchStock('Visala', xi.item.PURPLE_ROCK,             { initial = 2 })
patchStock('Visala', xi.item.BLACK_ROCK,              { initial = 2 })
patchStock('Visala', xi.item.WHITE_ROCK,              { initial = 2 })
patchStock('Visala', xi.item.LAPIS_LAZULI,            { initial = 6 })
patchStock('Visala', xi.item.LIGHT_OPAL,              { initial = 6 })
patchStock('Visala', xi.item.ONYX,                    { initial = 6 })
patchStock('Visala', xi.item.AMETHYST,                { initial = 6 })
patchStock('Visala', xi.item.TOURMALINE,              { initial = 6 })
patchStock('Visala', xi.item.SARDONYX,                { initial = 6 })
patchStock('Visala', xi.item.CLEAR_TOPAZ,             { initial = 6 })
patchStock('Visala', xi.item.AMBER_STONE,             { initial = 6 })
patchStock('Visala', xi.item.SLAB_OF_TUFA,            { initial = 120 })

-- Yabby Tanmikey & Celestina
shareStock('Celestina', 'Yabby_Tanmikey')
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, 1, { id = xi.item.CHUNK_OF_COPPER_ORE,  initial = 90,   maxStock = 240,  targetStock = 180,  buyMax = 134,  restockRate = 15 }) -- buyMax Mhaura-specific (20g vs 9g at Bastok/Al Zahbi)
patchStock('Yabby_Tanmikey', xi.item.CHUNK_OF_SILVER_ORE, { initial = 70 })
patchStock('Yabby_Tanmikey', xi.item.RED_ROCK,            { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.BLUE_ROCK,           { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.YELLOW_ROCK,         { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.GREEN_ROCK,          { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.TRANSLUCENT_ROCK,    { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.PURPLE_ROCK,         { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.BLACK_ROCK,          { initial = 2 })
patchStock('Yabby_Tanmikey', xi.item.WHITE_ROCK,          { initial = 2 })
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.MANDREL,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })
table.insert(xi.data.guildShops['Yabby_Tanmikey'].stock, { id = xi.item.WORKSHOP_ANVIL,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Woodworking
-----------------------------------
-- Chaupire & Cauzeriste
shareStock('Cauzeriste', 'Chaupire')
table.insert(xi.data.guildShops['Chaupire'].stock, 1, { id = xi.item.ARROWWOOD_LOG,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 60 })
table.insert(xi.data.guildShops['Chaupire'].stock, 2, { id = xi.item.LAUAN_LOG,      initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 180,  restockRate = 12 })
table.insert(xi.data.guildShops['Chaupire'].stock, 3, { id = xi.item.MAPLE_LOG,      initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 300,  restockRate = 12 })
patchStock('Chaupire', xi.item.ASH_LOG,                   { initial = 120 })
patchStock('Chaupire', xi.item.WILLOW_LOG,                { initial = 120 })
patchStock('Chaupire', xi.item.HOLLY_LOG,                 { initial = 90 })
patchStock('Chaupire', xi.item.YEW_LOG,                   { initial = 90 })
patchStock('Chaupire', xi.item.ELM_LOG,                   { initial = 60 })
patchStock('Chaupire', xi.item.WALNUT_LOG,                { initial = 60 })
patchStock('Chaupire', xi.item.CHESTNUT_LOG,              { initial = 60 })
patchStock('Chaupire', xi.item.OAK_LOG,                   { initial = 30 })
patchStock('Chaupire', xi.item.ROSEWOOD_LOG,              { initial = 30 })
patchStock('Chaupire', xi.item.MAHOGANY_LOG,              { initial = 10 })
patchStock('Chaupire', xi.item.EBONY_LOG,                 { initial = 10 })
patchStock('Chaupire', xi.item.BAMBOO_STICK,              { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_ARROWWOOD_LUMBER, { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_LAUAN_LUMBER,     { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_MAPLE_LUMBER,     { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_ASH_LUMBER,       { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_WILLOW_LUMBER,    { initial = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_HOLLY_LUMBER,     { initial = 9 })
patchStock('Chaupire', xi.item.PIECE_OF_YEW_LUMBER,       { initial = 9 })
patchStock('Chaupire', xi.item.PIECE_OF_ELM_LUMBER,       { initial = 12, restockRate = 12 })
patchStock('Chaupire', xi.item.PIECE_OF_CHESTNUT_LUMBER,  { initial = 6 })
patchStock('Chaupire', xi.item.PIECE_OF_OAK_LUMBER,       { initial = 6 })

-- Beugungel
xi.data.guildShops['Beugungel'].hours = { 5, 21 } -- close time corrected from base 22
patchStock('Beugungel', xi.item.SPOOL_OF_BUNDLING_TWINE, { initial = 120 })
patchStock('Beugungel', xi.item.HATCHET,                 { initial = 120 })
patchStock('Beugungel', xi.item.ARROWWOOD_LOG,           { initial = 120 })
patchStock('Beugungel', xi.item.ASH_LOG,                 { initial = 120, buyMax = 480, priceFloor = 180 })
patchStock('Beugungel', xi.item.YEW_LOG,                 { initial = 100 })
patchStock('Beugungel', xi.item.WILLOW_LOG,              { initial = 100 })
patchStock('Beugungel', xi.item.WALNUT_LOG,              { initial = 120, restockRate = 50 })

-- Dehbi Moshal
patchStock('Dehbi_Moshal', xi.item.ARROWWOOD_LOG,             { initial = 120 })
patchStock('Dehbi_Moshal', xi.item.LAUAN_LOG,                 { initial = 120 })
patchStock('Dehbi_Moshal', xi.item.MAPLE_LOG,                 { initial = 120 })
patchStock('Dehbi_Moshal', xi.item.ASH_LOG,                   { initial = 100, buyMax = 400, restockRate = 50 })
patchStock('Dehbi_Moshal', xi.item.WILLOW_LOG,                { initial = 120, restockRate = 20 })
patchStock('Dehbi_Moshal', xi.item.HOLLY_LOG,                 { initial = 90 })
patchStock('Dehbi_Moshal', xi.item.YEW_LOG,                   { initial = 120, restockRate = 20 })
patchStock('Dehbi_Moshal', xi.item.ELM_LOG,                   { initial = 60 })
patchStock('Dehbi_Moshal', xi.item.WALNUT_LOG,                { initial = 60 })
patchStock('Dehbi_Moshal', xi.item.CHESTNUT_LOG,              { initial = 60 })
patchStock('Dehbi_Moshal', xi.item.OAK_LOG,                   { initial = 30 })
patchStock('Dehbi_Moshal', xi.item.ROSEWOOD_LOG,              { initial = 30 })
patchStock('Dehbi_Moshal', xi.item.MAHOGANY_LOG,              { initial = 10 })
patchStock('Dehbi_Moshal', xi.item.EBONY_LOG,                 { initial = 10 })
patchStock('Dehbi_Moshal', xi.item.BAMBOO_STICK,              { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ARROWWOOD_LUMBER, { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_LAUAN_LUMBER,     { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_MAPLE_LUMBER,     { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ASH_LUMBER,       { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_WILLOW_LUMBER,    { initial = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_HOLLY_LUMBER,     { initial = 9 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_YEW_LUMBER,       { initial = 9 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_ELM_LUMBER,       { initial = 12, restockRate = 12 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_CHESTNUT_LUMBER,  { initial = 6 })
patchStock('Dehbi_Moshal', xi.item.PIECE_OF_OAK_LUMBER,       { initial = 6 })

-----------------------------------
-- Clothcraft
-----------------------------------
-- Kuzah Hpirohpon & Meriri
shareStock('Meriri', 'Kuzah_Hpirohpon')
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 60 })
patchStock('Kuzah_Hpirohpon', xi.item.BALL_OF_SARUTA_COTTON,   { initial = 0 })
patchStock('Kuzah_Hpirohpon', xi.item.FLAX_FLOWER,             { initial = 120 })
patchStock('Kuzah_Hpirohpon', xi.item.CLUMP_OF_SHEEP_WOOL,     { initial = 120 })
patchStock('Kuzah_Hpirohpon', xi.item.PIECE_OF_CRAWLER_COCOON, { initial = 40, targetStock = 180 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_GRASS_THREAD,   { initial = 120 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_COTTON_THREAD,  { initial = 120, buyMax = 780, priceFloor = 196 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_LINEN_THREAD,   { initial = 90 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_WOOL_THREAD,    { initial = 60 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_SILK_THREAD,    { initial = 6 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_SILVER_THREAD,  { initial = 4 })
patchStock('Kuzah_Hpirohpon', xi.item.SPOOL_OF_GOLD_THREAD,    { initial = 3 })
patchStock('Kuzah_Hpirohpon', xi.item.SQUARE_OF_GRASS_CLOTH,   { initial = 12 })
patchStock('Kuzah_Hpirohpon', xi.item.SQUARE_OF_COTTON_CLOTH,  { initial = 12 })
table.insert(xi.data.guildShops['Kuzah_Hpirohpon'].stock, 78, { id = xi.item.SPINDLE,              initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-- Taten-Bilten
patchStock('Taten-Bilten', xi.item.SPOOL_OF_SILK_THREAD,    { initial = 6, buyMax = 2944, targetStock = 25 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_GRASS_THREAD,   { initial = 120 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_COTTON_THREAD,  { initial = 120 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_LINEN_THREAD,   { initial = 90 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_SILVER_THREAD,  { initial = 4, buyMax = 4480, priceFloor = 22.5 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_GOLD_THREAD,    { initial = 3 })
patchStock('Taten-Bilten', xi.item.SQUARE_OF_GRASS_CLOTH,   { initial = 12 })
patchStock('Taten-Bilten', xi.item.SQUARE_OF_COTTON_CLOTH,  { initial = 12 })
patchStock('Taten-Bilten', xi.item.CLUMP_OF_SHEEP_WOOL,     { initial = 120 })
patchStock('Taten-Bilten', xi.item.CLUMP_OF_MOKO_GRASS,     { initial = 120 })
patchStock('Taten-Bilten', xi.item.BALL_OF_SARUTA_COTTON,   { initial = 0, buyMax = 84 })
patchStock('Taten-Bilten', xi.item.FLAX_FLOWER,             { initial = 120 })
patchStock('Taten-Bilten', xi.item.PIECE_OF_CRAWLER_COCOON, { initial = 40 })
patchStock('Taten-Bilten', xi.item.SPINDLE,                 { initial = 120 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_ZEPHYR_THREAD,  { initial = 120 })
patchStock('Taten-Bilten', xi.item.WAMOURA_COCOON,          { initial = 60 })
patchStock('Taten-Bilten', xi.item.SPOOL_OF_KARAKUL_THREAD, { initial = 60 })
table.insert(xi.data.guildShops['Taten-Bilten'].stock, { id = xi.item.SPOOL_OF_WOOL_THREAD,  initial = 60,  maxStock = 120,  targetStock = 90,  buyMax = 18000,  restockRate = 3 })

-- Tilala & Gibol
shareStock('Gibol', 'Tilala')
table.insert(xi.data.guildShops['Tilala'].stock, 1, { id = xi.item.CLUMP_OF_MOKO_GRASS,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 100,  restockRate = 40 })
patchStock('Tilala', xi.item.FLAX_FLOWER,            { initial = 60 })
patchStock('Tilala', xi.item.CLUMP_OF_SHEEP_WOOL,    { initial = 55 })
patchStock('Tilala', xi.item.SPOOL_OF_GRASS_THREAD,  { initial = 90 })
patchStock('Tilala', xi.item.SPOOL_OF_COTTON_THREAD, { initial = 90, restockRate = 30 })
patchStock('Tilala', xi.item.SPOOL_OF_LINEN_THREAD,  { initial = 90, buyMax = 4873, priceFloor = 150 })
patchStock('Tilala', xi.item.SPOOL_OF_WOOL_THREAD,   { initial = 60 })
patchStock('Tilala', xi.item.SPOOL_OF_SILK_THREAD,   { initial = 12 })
patchStock('Tilala', xi.item.SPOOL_OF_SILVER_THREAD, { initial = 6 })
patchStock('Tilala', xi.item.SPOOL_OF_GOLD_THREAD,   { initial = 3 })

-----------------------------------
-- Leatherworking
-----------------------------------
-- Kueh Igunahmori & Cletae
shareStock('Cletae', 'Kueh_Igunahmori')
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 1, { id = xi.item.RABBIT_HIDE,  initial = 12,   maxStock = 160,  targetStock = 120,  buyMax = 314,  restockRate = 12,  priceFloor = 120 }) -- no retail data, values adjusted to match wiki
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, 2, { id = xi.item.SHEEPSKIN,    initial = 12,   maxStock = 160,  targetStock = 120,  buyMax = 397,  restockRate = 12 }) -- no retail data, values adjusted to match wiki
patchStock('Kueh_Igunahmori', xi.item.RAM_SKIN,                 { initial =   0 })
patchStock('Kueh_Igunahmori', xi.item.RAPTOR_SKIN,              { initial =  30 })
patchStock('Kueh_Igunahmori', xi.item.COCKATRICE_SKIN,          { initial =  30 })
patchStock('Kueh_Igunahmori', xi.item.WILLOW_LOG,               { initial = 120 })
patchStock('Kueh_Igunahmori', xi.item.FLASK_OF_DISTILLED_WATER, { initial = 120 })
table.insert(xi.data.guildShops['Kueh_Igunahmori'].stock, { id = xi.item.TANNING_VAT,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Bonecraft
-----------------------------------
-- Shih Tayuun & Retto-Marutto
shareStock('Retto-Marutto', 'Shih_Tayuun')
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 1, { id = xi.item.BONE_CHIP,               initial = 12,   maxStock = 160,  targetStock = 120,  buyMax = 397,  restockRate = 12,  priceFloor = 120 })
patchStock('Shih_Tayuun', xi.item.SHEEP_TOOTH, { initial =  12 })
patchStock('Shih_Tayuun', xi.item.SEASHELL,    { initial = 120 })
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, 14, { id = xi.item.HANDFUL_OF_FISH_SCALES,  initial = 30,   maxStock = 240,  targetStock = 180,  buyMax = 480,  restockRate = 15 })
patchStock('Shih_Tayuun', xi.item.BONE_ARROW, { initial = 0 })
table.insert(xi.data.guildShops['Shih_Tayuun'].stock, { id = xi.item.SHAGREEN_FILE,           initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,  restockRate = 60 })

-----------------------------------
-- Alchemy
-----------------------------------
-- Maymunah & Odoba
shareStock('Odoba', 'Maymunah')
table.insert(xi.data.guildShops['Maymunah'].stock, 1, { id = xi.item.VIAL_OF_MERCURY,  initial = 8,    maxStock = 60,   targetStock = 45,   buyMax = 7500,  restockRate = 1 })
patchStock('Maymunah', xi.item.WIJNRUIT,                { initial =  60 })
patchStock('Maymunah', xi.item.POT_OF_CRYING_MUSTARD,   { initial =  60 })
patchStock('Maymunah', xi.item.PINCH_OF_DRIED_MARJORAM, { initial =  60 })
patchStock('Maymunah', xi.item.CHAMOMILE,               { initial =  60 })
patchStock('Maymunah', xi.item.COBALT_JELLYFISH,        { initial =  12 })
patchStock('Maymunah', xi.item.LOOP_OF_GLASS_FIBER,     { initial =  30 })
patchStock('Maymunah', xi.item.BATTERY,                 { initial = 120 })
patchStock('Maymunah', xi.item.HYDRO_PUMP,              { initial = 120 })
patchStock('Maymunah', xi.item.WIND_FAN,                { initial = 120 })
table.insert(xi.data.guildShops['Maymunah'].stock, { id = xi.item.TRITURATOR,       initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 500,   restockRate = 60 })

-- Wahraga & Gathweeda
patchStock('Wahraga', xi.item.VIAL_OF_MERCURY,             { initial =   8 })
patchStock('Wahraga', xi.item.MALBORO_VINE,                { initial =   8 })
patchStock('Wahraga', xi.item.PINCH_OF_SULFUR,             { initial =  40 })
patchStock('Wahraga', xi.item.WIJNRUIT,                    { initial =  60 })
patchStock('Wahraga', xi.item.POT_OF_CRYING_MUSTARD,       { initial =  60 })
patchStock('Wahraga', xi.item.PINCH_OF_DRIED_MARJORAM,     { initial =  60 })
patchStock('Wahraga', xi.item.CHAMOMILE,                   { initial =  60 })
patchStock('Wahraga', xi.item.SPRIG_OF_SAGE,               { initial = 120 })
patchStock('Wahraga', xi.item.COBALT_JELLYFISH,            { initial =  12 })
patchStock('Wahraga', xi.item.LOOP_OF_GLASS_FIBER,         { initial =  30 })
patchStock('Wahraga', xi.item.TRITURATOR,                  { initial = 120 })
patchStock('Wahraga', xi.item.BUNDLE_OF_HOMUNCULUS_NERVES, { initial = 120 })
patchStock('Wahraga', xi.item.SHEET_OF_POLYFLAN_PAPER,     { initial = 120 })
patchStock('Wahraga', xi.item.BATTERY,                     { initial = 120 })
patchStock('Wahraga', xi.item.HYDRO_PUMP,                  { initial = 120 })
patchStock('Wahraga', xi.item.WIND_FAN,                    { initial = 120 })
patchStock('Wahraga', xi.item.PINCH_OF_MINIUM,             { initial =  12 })

-----------------------------------
-- Cooking
-----------------------------------
-- Kopopo & Chomo Jinjahl
shareStock('Chomo_Jinjahl', 'Kopopo')
table.insert(xi.data.guildShops['Kopopo'].stock, 1, { id = xi.item.CHUNK_OF_ROCK_SALT,          initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 80,   restockRate = 12 }) -- no retail data, values adjusted to match wiki
table.insert(xi.data.guildShops['Kopopo'].stock, 42, { id = xi.item.SARUTA_ORANGE,               initial = 60,   maxStock = 240,  targetStock = 180,  buyMax = 380,  restockRate = 2 }) -- no retail data, values adjusted to match wiki
table.insert(xi.data.guildShops['Kopopo'].stock, 47, { id = xi.item.BUNCH_OF_SAN_DORIAN_GRAPES,  initial = 12,   maxStock = 240,  targetStock = 180,  buyMax = 387,  restockRate = 2 }) -- no retail data, values adjusted to match wiki
patchStock('Kopopo', xi.item.BAG_OF_SAN_DORIAN_FLOUR, { initial = 120 })
patchStock('Kopopo', xi.item.BUNCH_OF_KAZHAM_PEPPERS, { initial = 120 })
patchStock('Kopopo', xi.item.BULB_OF_MHAURA_GARLIC,   { initial = 120 })
patchStock('Kopopo', xi.item.JUG_OF_SELBINA_MILK,     { initial = 120 })
patchStock('Kopopo', xi.item.PIECE_OF_PIE_DOUGH,      { initial =   6 })
patchStock('Kopopo', xi.item.POD_OF_BLUE_PEAS,        { initial = 120 })
patchStock('Kopopo', xi.item.POPOTO,                  { initial = 120 })
patchStock('Kopopo', xi.item.BOX_OF_TARUTARU_RICE,    { initial = 120 })
patchStock('Kopopo', xi.item.POT_OF_CRYING_MUSTARD,   { initial = 120 })
patchStock('Kopopo', xi.item.PINCH_OF_DRIED_MARJORAM, { initial = 120 })
patchStock('Kopopo', xi.item.BOTTLE_OF_APPLE_VINEGAR, { initial =   0 })
patchStock('Kopopo', xi.item.STICK_OF_CINNAMON,       { initial = 120 })
patchStock('Kopopo', xi.item.EAR_OF_MILLIONCORN,      { initial = 120 })
patchStock('Kopopo', xi.item.BIRD_EGG,                { initial =  60 })
patchStock('Kopopo', xi.item.FAERIE_APPLE,            { initial =  60 })
patchStock('Kopopo', xi.item.LA_THEINE_CABBAGE,       { initial =  60 })
patchStock('Kopopo', xi.item.CLUMP_OF_BEAUGREENS,     { initial =  60 })
patchStock('Kopopo', xi.item.CLUMP_OF_BATAGREENS,     { initial =   0 })
patchStock('Kopopo', xi.item.SMOKED_SALMON,           { initial =   0 })
patchStock('Kopopo', xi.item.SAN_DORIAN_CARROT,       { initial =  60, targetStock = 120 })
patchStock('Kopopo', xi.item.MITHRAN_TOMATO,          { initial =  60, targetStock = 120 })
patchStock('Kopopo', xi.item.THUNDERMELON,            { initial =  12, priceFloor = 242 })
patchStock('Kopopo', xi.item.KAZHAM_PINEAPPLE,        { initial =  12 })
patchStock('Kopopo', xi.item.WATERMELON,              { initial =  12 })
patchStock('Kopopo', xi.item.ONZ_OF_TURMERIC,         { initial =  30 })
patchStock('Kopopo', xi.item.ONZ_OF_CORIANDER,        { initial =  30 })
patchStock('Kopopo', xi.item.SPRIG_OF_HOLY_BASIL,     { initial =  15 })
patchStock('Kopopo', xi.item.BAG_OF_SEMOLINA,         { initial =  60 })
patchStock('Kopopo', xi.item.JAR_OF_FISH_STOCK,       { initial =  50 })
patchStock('Kopopo', xi.item.SAUCER_OF_SOY_STOCK,     { initial =  50 })
patchStock('Kopopo', xi.item.YAGUDO_CHERRY,           { targetStock = 110 })

-----------------------------------
-- Fishing
-----------------------------------
-- Babubu
patchStock('Babubu', xi.item.LITTLE_WORM,             { initial = 120 })
patchStock('Babubu', xi.item.LUGWORM,                 { initial = 120 })
patchStock('Babubu', xi.item.BALL_OF_SARDINE_PASTE,   { initial = 120 })
patchStock('Babubu', xi.item.BALL_OF_CRAYFISH_PASTE,  { initial = 120 })
patchStock('Babubu', xi.item.BALL_OF_INSECT_PASTE,    { initial = 120 })
patchStock('Babubu', xi.item.BALL_OF_TROUT_PASTE,     { initial = 120 })
patchStock('Babubu', xi.item.MEATBALL,                { initial = 120 })
patchStock('Babubu', xi.item.SLICE_OF_SARDINE,        { initial = 120 })
patchStock('Babubu', xi.item.SLICE_OF_COD,            { initial = 120 })
patchStock('Babubu', xi.item.PEELED_LOBSTER,          { initial = 120 })
patchStock('Babubu', xi.item.SLICE_OF_BLUETAIL,       { initial = 120 })
patchStock('Babubu', xi.item.PEELED_CRAYFISH,         { initial = 120 })
patchStock('Babubu', xi.item.SLICE_OF_MOAT_CARP,      { initial = 120 })
patchStock('Babubu', xi.item.FLY_LURE,                { initial = 120 })
patchStock('Babubu', xi.item.MINNOW,                  { initial = 120 })
patchStock('Babubu', xi.item.WORM_LURE,               { initial = 120 })
patchStock('Babubu', xi.item.SABIKI_RIG,              { initial = 120 })
patchStock('Babubu', xi.item.WILLOW_FISHING_ROD,      { initial =  90 })
patchStock('Babubu', xi.item.YEW_FISHING_ROD,         { initial =  90 })
patchStock('Babubu', xi.item.BAMBOO_FISHING_ROD,      { initial =  90 })
patchStock('Babubu', xi.item.FASTWATER_FISHING_ROD,   { initial =  60 })
patchStock('Babubu', xi.item.TARUTARU_FISHING_ROD,    { initial =  30 })
patchStock('Babubu', xi.item.MITHRAN_FISHING_ROD,     { initial =  30 })
patchStock('Babubu', xi.item.SINGLE_HOOK_FISHING_ROD, { initial =  30 })

-- Cehn Teyohngo
patchStock('Cehn_Teyohngo', xi.item.SABIKI_RIG,           { initial =  10 })
patchStock('Cehn_Teyohngo', xi.item.MINNOW,               { initial =  10 })
patchStock('Cehn_Teyohngo', xi.item.TARUTARU_FISHING_ROD, { initial = 120 })

-- Graegham & Mendoline
table.insert(xi.data.guildShops['Graegham'].stock, 1, { id = xi.item.LITTLE_WORM,             initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 20,      restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 2, { id = xi.item.LUGWORM,                 initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 60,      restockRate = 60 })
table.insert(xi.data.guildShops['Graegham'].stock, 3, { id = xi.item.BALL_OF_SARDINE_PASTE,   initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 350,     restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 4, { id = xi.item.BALL_OF_CRAYFISH_PASTE,  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 350,     restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 5, { id = xi.item.SLICE_OF_COD,            initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 1425,    restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 6, { id = xi.item.FLY_LURE,                initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 3600,    restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 7, { id = xi.item.MINNOW,                  initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 2025,    restockRate = 12 })
patchStock('Graegham', xi.item.SABIKI_RIG, { initial = 120, restockRate = 12 })
table.insert(xi.data.guildShops['Graegham'].stock, 9, { id = xi.item.WILLOW_FISHING_ROD,      initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 360,     restockRate = 9 })
table.insert(xi.data.guildShops['Graegham'].stock, 10, { id = xi.item.YEW_FISHING_ROD,         initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 1180,    restockRate = 9 })
table.insert(xi.data.guildShops['Graegham'].stock, 11, { id = xi.item.BAMBOO_FISHING_ROD,      initial = 90,   maxStock = 180,  targetStock = 160,  buyMax = 2700,    restockRate = 9 })
patchStock('Graegham', xi.item.TARUTARU_FISHING_ROD, { initial = 30, restockRate = 15 })
table.insert(xi.data.guildShops['Graegham'].stock, 13, { id = xi.item.MITHRAN_FISHING_ROD,     initial = 30,   maxStock = 60,   targetStock = 45,   buyMax = 171600,  restockRate = 5 })
patchStock('Graegham', xi.item.CLOTHESPOLE,             { initial = 30, restockRate = 15 })
patchStock('Graegham', xi.item.FASTWATER_FISHING_ROD,   { initial = 30, restockRate = 15 })
patchStock('Graegham', xi.item.SINGLE_HOOK_FISHING_ROD, { initial = 30, restockRate = 3 })

-- Jidwahn
patchStock('Jidwahn', xi.item.SABIKI_RIG,   { initial =  10 })
patchStock('Jidwahn', xi.item.MINNOW,       { initial =  10 })
patchStock('Jidwahn', xi.item.ICE_CARD,     { initial = 120 })
patchStock('Jidwahn', xi.item.THUNDER_CARD, { initial = 120 })
patchStock('Jidwahn', xi.item.LIGHT_CARD,   { initial = 120 })
patchStock('Jidwahn', xi.item.DARK_CARD,    { initial = 120 })

-- Lokhong
patchStock('Lokhong', xi.item.SABIKI_RIG,           { initial =  10 })
patchStock('Lokhong', xi.item.MINNOW,               { initial =  10 })
patchStock('Lokhong', xi.item.TARUTARU_FISHING_ROD, { initial = 120 })

-- Mep Nhapopoluko
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 1, { id = xi.item.SABIKI_RIG,            initial = 120,  maxStock = 240,  targetStock = 180,  buyMax = 15960,  restockRate = 12 })
patchStock('Mep_Nhapopoluko', xi.item.FASTWATER_FISHING_ROD, { initial = 80 })
table.insert(xi.data.guildShops['Mep_Nhapopoluko'].stock, 3, { id = xi.item.TARUTARU_FISHING_ROD,  initial = 30,   maxStock = 60,   targetStock = 45,   buyMax = 27180,  restockRate = 3 })
patchStock('Mep_Nhapopoluko', xi.item.SINGLE_HOOK_FISHING_ROD, { initial =  80 })
patchStock('Mep_Nhapopoluko', xi.item.BLUETAIL_1,              { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.NOBLE_LADY,              { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.TRILOBITE,               { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.SHALL_SHELL,             { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.ZAFMLUG_BASS,            { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.MOORISH_IDOL,            { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.BIBIKIBO,                { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.BIBIKI_URCHIN,           { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.CLUMP_OF_PAMTAM_KELP,    { initial = 100 })
patchStock('Mep_Nhapopoluko', xi.item.COBALT_JELLYFISH,        { initial = 100 })

-- Pashi Maccaleh
patchStock('Pashi_Maccaleh', xi.item.SABIKI_RIG,           { initial =  10 })
patchStock('Pashi_Maccaleh', xi.item.MINNOW,               { initial =  10 })
patchStock('Pashi_Maccaleh', xi.item.TARUTARU_FISHING_ROD, { initial = 120 })

-- Rajmonda
patchStock('Rajmonda', xi.item.SABIKI_RIG,           { initial =  10 })
patchStock('Rajmonda', xi.item.MINNOW,               { initial =  10 })
patchStock('Rajmonda', xi.item.TARUTARU_FISHING_ROD, { initial = 120 })

-- Wahnid
patchStock('Wahnid', xi.item.LITTLE_WORM,            { initial = 120 })
patchStock('Wahnid', xi.item.LUGWORM,                { initial = 120 })
patchStock('Wahnid', xi.item.BALL_OF_SARDINE_PASTE,  { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.BALL_OF_CRAYFISH_PASTE, { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.BALL_OF_INSECT_PASTE,   { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.BALL_OF_TROUT_PASTE,    { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.MEATBALL,               { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.SLICE_OF_SARDINE,       { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.SLICE_OF_COD,           { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.PEELED_LOBSTER,         { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.SLICE_OF_BLUETAIL,      { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.PEELED_CRAYFISH,        { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.SLICE_OF_MOAT_CARP,     { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.FLY_LURE,               { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.MINNOW,                 { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.SABIKI_RIG,             { initial = 120, restockRate = 12 })
patchStock('Wahnid', xi.item.YEW_FISHING_ROD,        { initial = 0, restockRate = 0 })
patchStock('Wahnid', xi.item.BAMBOO_FISHING_ROD,     { initial = 90 })
patchStock('Wahnid', xi.item.FASTWATER_FISHING_ROD,  { initial = 60, restockRate = 6 })
patchStock('Wahnid', xi.item.TARUTARU_FISHING_ROD,   { initial = 30, restockRate = 3 })

-- Yahliq
patchStock('Yahliq', xi.item.SABIKI_RIG,   { initial =  10 })
patchStock('Yahliq', xi.item.MINNOW,       { initial =  10 })
patchStock('Yahliq', xi.item.ICE_CARD,     { initial = 120 })
patchStock('Yahliq', xi.item.THUNDER_CARD, { initial = 120 })
patchStock('Yahliq', xi.item.LIGHT_CARD,   { initial = 120 })
patchStock('Yahliq', xi.item.DARK_CARD,    { initial = 120 })

-----------------------------------
-- Tenshodo
-----------------------------------
-- Jabbar
patchStock('Jabbar', xi.item.BAMBOO_STICK,           { initial = 30 })
patchStock('Jabbar', xi.item.SCROLL_OF_KATON_ICHI,   { initial = 10 })
patchStock('Jabbar', xi.item.SCROLL_OF_HUTON_ICHI,   { initial = 10 })
patchStock('Jabbar', xi.item.SCROLL_OF_DOTON_ICHI,   { initial = 10 })
patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_MND,   { initial = 12 })
patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_CHR,   { initial = 12 })
patchStock('Jabbar', xi.item.ONZ_OF_TURMERIC,        { initial = 30 })
patchStock('Jabbar', xi.item.ONZ_OF_CORIANDER,       { initial = 30 })
patchStock('Jabbar', xi.item.SPRIG_OF_HOLY_BASIL,    { initial = 30 })
patchStock('Jabbar', xi.item.ONZ_OF_CURRY_POWDER,    { initial = 15 })
patchStock('Jabbar', xi.item.JAR_OF_GROUND_WASABI,   { initial = 50 })
patchStock('Jabbar', xi.item.BOTTLE_OF_RICE_VINEGAR, { initial = 50 })
patchStock('Jabbar', xi.item.CLUMP_OF_SHUNGIKU,      { initial = 50 })

-- Silver Owl
patchStock('Silver_Owl', xi.item.KUNAI,            { initial = 15 })
patchStock('Silver_Owl', xi.item.SHINOBI_GATANA,   { initial = 15 })
patchStock('Silver_Owl', xi.item.KANESADA,         { initial = 5 })
patchStock('Silver_Owl', xi.item.TACHI,            { initial = 15 })
patchStock('Silver_Owl', xi.item.KOTETSU,          { initial = 5 })
patchStock('Silver_Owl', xi.item.HACHIMAKI,        { initial = 10 })
patchStock('Silver_Owl', xi.item.COTTON_HACHIMAKI, { initial = 10 })
patchStock('Silver_Owl', xi.item.KENPOGI,          { initial = 10 })
patchStock('Silver_Owl', xi.item.COTTON_DOGI,      { initial = 10 })
patchStock('Silver_Owl', xi.item.TEKKO,            { initial = 10 })
patchStock('Silver_Owl', xi.item.COTTON_TEKKO,     { initial = 10 })
patchStock('Silver_Owl', xi.item.SOIL_TEKKO,       { initial = 10, restockRate = 5 })
patchStock('Silver_Owl', xi.item.SITABAKI,         { initial = 10 })
patchStock('Silver_Owl', xi.item.COTTON_SITABAKI,  { initial = 10 })
patchStock('Silver_Owl', xi.item.SOIL_SITABAKI,    { initial = 10, restockRate = 5 })
patchStock('Silver_Owl', xi.item.KYAHAN,           { initial = 10 })
patchStock('Silver_Owl', xi.item.COTTON_KYAHAN,    { initial = 10 })
removeStock('Silver_Owl', xi.item.JUJI_SHURIKEN)

-- Jirokichi
patchStock('Jirokichi', xi.item.KUNAI,          { initial = 30 })
patchStock('Jirokichi', xi.item.SUZUME,         { initial = 30 })
patchStock('Jirokichi', xi.item.WAKIZASHI,      { initial = 30 })
patchStock('Jirokichi', xi.item.SHINOBI_GATANA, { initial = 30 })
patchStock('Jirokichi', xi.item.UCHIGATANA,     { initial = 30 })
patchStock('Jirokichi', xi.item.KANESADA,       { initial = 10 })
patchStock('Jirokichi', xi.item.TACHI,          { initial = 30 })
patchStock('Jirokichi', xi.item.NODACHI,        { initial = 10 })
patchStock('Jirokichi', xi.item.OKANEHIRA,      { initial = 5 })
patchStock('Jirokichi', xi.item.SHURIKEN,       { initial = 30 })
patchStock('Jirokichi', xi.item.JUJI_SHURIKEN,  { initial = 20, buyMax = 347, priceFloor = 0 })

-- Achika
patchStock('Achika', xi.item.HACHIMAKI,     { initial = 30 })
patchStock('Achika', xi.item.TEKKO,         { initial = 30 })
patchStock('Achika', xi.item.COTTON_KYAHAN, { initial = 30 })
patchStock('Achika', xi.item.SOIL_KYAHAN,   { initial = 30 })
patchStock('Achika', xi.item.NODOWA,        { targetStock = 30 })

-- Chiyo
patchStock('Chiyo', xi.item.SCROLL_OF_HYOTON_ICHI, { initial = 20 })
patchStock('Chiyo', xi.item.SCROLL_OF_HUTON_ICHI,  { initial = 20 })
patchStock('Chiyo', xi.item.SCROLL_OF_DOTON_ICHI,  { initial = 20 })
patchStock('Chiyo', xi.item.SCROLL_OF_RAITON_ICHI, { initial = 20 })
patchStock('Chiyo', xi.item.SCROLL_OF_SUITON_ICHI, { initial = 20 })

-- Vuliaie
patchStock('Vuliaie', xi.item.JAR_OF_TOAD_OIL,         { initial =  10 })
patchStock('Vuliaie', xi.item.SHEET_OF_BAST_PARCHMENT, { initial =   6 })
patchStock('Vuliaie', xi.item.HANDFUL_OF_IRON_SAND,    { initial = 180 })
patchStock('Vuliaie', xi.item.UCHITAKE,                { initial =  60 })
patchStock('Vuliaie', xi.item.TSURARA,                 { initial =  60 })
patchStock('Vuliaie', xi.item.KAWAHORI_OGI,            { initial =  60 })
patchStock('Vuliaie', xi.item.MAKIBISHI,               { initial =  60 })
patchStock('Vuliaie', xi.item.HIRAISHIN,               { initial =  60 })
patchStock('Vuliaie', xi.item.MIZU_DEPPO,              { initial =  60 })
patchStock('Vuliaie', xi.item.GARDENIA_SEED,           { initial =  50 })
patchStock('Vuliaie', xi.item.ONZ_OF_TURMERIC,         { initial = 120 })
patchStock('Vuliaie', xi.item.ONZ_OF_CORIANDER,        { initial = 120 })
patchStock('Vuliaie', xi.item.SPRIG_OF_HOLY_BASIL,     { initial = 120 })
patchStock('Vuliaie', xi.item.ONZ_OF_CURRY_POWDER,     { initial =  60 })
patchStock('Vuliaie', xi.item.JAR_OF_GROUND_WASABI,    { initial = 100 })
patchStock('Vuliaie', xi.item.BOTTLE_OF_RICE_VINEGAR,  { initial = 100 })
patchStock('Vuliaie', xi.item.HEAD_OF_NAPA,            { initial = 100 })
table.insert(xi.data.guildShops['Vuliaie'].stock, { id = xi.item.KOMA,  initial = 30,  maxStock = 60,  targetStock = 45,  buyMax = 660,  restockRate = 15 })

-- Tsutsuroon
patchStock('Tsutsuroon', xi.item.KUNAI,                   { initial = 30 })
patchStock('Tsutsuroon', xi.item.SUZUME,                  { initial = 30 })
patchStock('Tsutsuroon', xi.item.WAKIZASHI,               { initial = 30 })
patchStock('Tsutsuroon', xi.item.SHINOBI_GATANA,          { initial = 30 })
patchStock('Tsutsuroon', xi.item.UCHIGATANA,              { initial = 30 })
patchStock('Tsutsuroon', xi.item.KANESADA,                { initial = 10 })
patchStock('Tsutsuroon', xi.item.TACHI,                   { initial = 30 })
patchStock('Tsutsuroon', xi.item.NODACHI,                 { initial = 10 })
patchStock('Tsutsuroon', xi.item.OKANEHIRA,               { initial = 5 })
patchStock('Tsutsuroon', xi.item.KOTETSU,                 { initial = 5 })
patchStock('Tsutsuroon', xi.item.SHURIKEN,                { initial = 30 })
patchStock('Tsutsuroon', xi.item.JUJI_SHURIKEN,           { initial = 20, buyMax = 347, priceFloor = 0 })
patchStock('Tsutsuroon', xi.item.FIRE_ARROW,              { initial = 30 })
patchStock('Tsutsuroon', xi.item.BULLET,                  { initial = 20 })
patchStock('Tsutsuroon', xi.item.FUMA_SHURIKEN,           { buyMax = 78750 })
patchStock('Tsutsuroon', xi.item.SOIL_HACHIMAKI,          { initial = 30 })
patchStock('Tsutsuroon', xi.item.KENPOGI,                 { initial = 30 })
patchStock('Tsutsuroon', xi.item.COTTON_DOGI,             { initial = 30 })
patchStock('Tsutsuroon', xi.item.SOIL_GI,                 { initial = 30 })
patchStock('Tsutsuroon', xi.item.TEKKO,                   { initial = 30 })
patchStock('Tsutsuroon', xi.item.COTTON_TEKKO,            { initial = 30 })
patchStock('Tsutsuroon', xi.item.SITABAKI,                { initial = 30 })
patchStock('Tsutsuroon', xi.item.COTTON_SITABAKI,         { initial = 30 })
patchStock('Tsutsuroon', xi.item.SOIL_SITABAKI,           { initial = 30 })
patchStock('Tsutsuroon', xi.item.KYAHAN,                  { initial = 30 })
patchStock('Tsutsuroon', xi.item.COTTON_KYAHAN,           { initial = 30 })
patchStock('Tsutsuroon', xi.item.SOIL_KYAHAN,             { initial = 30 })
patchStock('Tsutsuroon', xi.item.JAR_OF_TOAD_OIL,         { initial = 10 })
patchStock('Tsutsuroon', xi.item.SHEET_OF_BAST_PARCHMENT, { initial = 6 })
patchStock('Tsutsuroon', xi.item.SQUARE_OF_SILK_CLOTH,    { initial = 10 })
patchStock('Tsutsuroon', xi.item.HANDFUL_OF_IRON_SAND,    { initial = 180, buyMax = 3074 })
patchStock('Tsutsuroon', xi.item.UCHITAKE,                { initial = 60 })
patchStock('Tsutsuroon', xi.item.TSURARA,                 { initial = 60 })
patchStock('Tsutsuroon', xi.item.KAWAHORI_OGI,            { initial = 60 })
patchStock('Tsutsuroon', xi.item.MAKIBISHI,               { initial = 60 })
patchStock('Tsutsuroon', xi.item.HIRAISHIN,               { initial = 60 })
patchStock('Tsutsuroon', xi.item.MIZU_DEPPO,              { initial = 60 })
patchStock('Tsutsuroon', xi.item.GARDENIA_SEED,           { initial = 50 })
patchStock('Tsutsuroon', xi.item.ONZ_OF_TURMERIC,         { initial = 120 })
patchStock('Tsutsuroon', xi.item.ONZ_OF_CORIANDER,        { initial = 120 })
patchStock('Tsutsuroon', xi.item.SPRIG_OF_HOLY_BASIL,     { initial = 120 })
patchStock('Tsutsuroon', xi.item.ONZ_OF_CURRY_POWDER,     { initial = 60 })
patchStock('Tsutsuroon', xi.item.JAR_OF_GROUND_WASABI,    { initial = 100 })
patchStock('Tsutsuroon', xi.item.BOTTLE_OF_RICE_VINEGAR,  { initial = 100 })
patchStock('Tsutsuroon', xi.item.HEAD_OF_NAPA,            { initial = 100 })
table.insert(xi.data.guildShops['Tsutsuroon'].stock, { id = xi.item.KOMA,  initial = 30,  maxStock = 60,  targetStock = 45,  buyMax = 660,  restockRate = 15 })

-----------------------------------
-- Tenshodo (new shops)
--
-- Akamafula and Amalasanda were converted to normal shops on retail; this puts
-- them back on the guild-shop path. c_guildVendorShops keeps the Tenshodo
-- Member's Card check their base scripts had.
-- ZenithXI: no holiday is set for these shops.
-----------------------------------
xi.data.guildShops['Akamafula'] =
{
    hours = { 1, 23 },
    stock =
    {
        { id = xi.item.KUNAI,             initial = 20,  maxStock = 60,  targetStock = 50,  buyMax = 4419,    restockRate = 5 },
        { id = xi.item.WAKIZASHI,         initial = 20,  maxStock = 60,  targetStock = 50,  buyMax = 12000,   restockRate = 5 },
        { id = xi.item.UCHIGATANA,        initial = 20,  maxStock = 60,  targetStock = 50,  buyMax = 26680,   restockRate = 5 },
        { id = xi.item.KANESADA,          initial = 2,   maxStock = 60,  targetStock = 50,  buyMax = 99000,   restockRate = 10 },
        { id = xi.item.TACHI,             initial = 20,  maxStock = 60,  targetStock = 50,  buyMax = 15695,   restockRate = 5 },
        { id = xi.item.NODACHI,           initial = 2,   maxStock = 60,  targetStock = 55,  buyMax = 40620,   restockRate = 0 },
        { id = xi.item.OKANEHIRA,         initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 104730,  restockRate = 7 },
        { id = xi.item.TANEGASHIMA,       initial = 2,   maxStock = 60,  targetStock = 55,  buyMax = 65310,   restockRate = 0 },
        { id = xi.item.SHURIKEN,          initial = 30,  maxStock = 60,  targetStock = 55,  buyMax = 151,     restockRate = 10, priceFloor = 92 },
        { id = xi.item.HACHIMAKI,         initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 4125,    restockRate = 3 },
        { id = xi.item.COTTON_HACHIMAKI,  initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 24420,   restockRate = 3 },
        { id = xi.item.SOIL_HACHIMAKI,    initial = 10,  maxStock = 60,  targetStock = 50,  buyMax = 66960,   restockRate = 5 },
        { id = xi.item.KENPOGI,           initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 6225,    restockRate = 3 },
        { id = xi.item.COTTON_DOGI,       initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 36800,   restockRate = 3 },
        { id = xi.item.SOIL_GI,           initial = 10,  maxStock = 60,  targetStock = 50,  buyMax = 99000,   restockRate = 5 },
        { id = xi.item.TEKKO,             initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 3425,    restockRate = 3 },
        { id = xi.item.COTTON_TEKKO,      initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 20250,   restockRate = 3 },
        { id = xi.item.SOIL_TEKKO,        initial = 10,  maxStock = 60,  targetStock = 50,  buyMax = 55440,   restockRate = 5 },
        { id = xi.item.SITABAKI,          initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 4975,    restockRate = 3 },
        { id = xi.item.COTTON_SITABAKI,   initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 29490,   restockRate = 3 },
        { id = xi.item.SOIL_SITABAKI,     initial = 10,  maxStock = 60,  targetStock = 50,  buyMax = 80640,   restockRate = 5 },
        { id = xi.item.KYAHAN,            initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 3175,    restockRate = 3 },
        { id = xi.item.COTTON_KYAHAN,     initial = 5,   maxStock = 60,  targetStock = 50,  buyMax = 18870,   restockRate = 3 },
        { id = xi.item.SOIL_KYAHAN,       initial = 10,  maxStock = 60,  targetStock = 50,  buyMax = 82620,   restockRate = 5 },
    },
}

xi.data.guildShops['Amalasanda'] =
{
    hours = { 9, 23 },
    stock =
    {
        { id = xi.item.BAMBOO_STICK,            initial =  30, maxStock = 240, targetStock = 180, buyMax =    720, restockRate =  10 },
        { id = xi.item.KOMA,                    initial =  30, maxStock =  60, targetStock =  45, buyMax =   1100, restockRate =  15, priceFloor =  45 },
        { id = xi.item.LUMP_OF_TAMA_HAGANE,     initial =  20, maxStock =  60, targetStock =  45, buyMax =  35000, restockRate =   5 },
        { id = xi.item.POT_OF_URUSHI,           initial =  10, maxStock =  60, targetStock =  45, buyMax = 367650, restockRate =   1 },
        { id = xi.item.BOX_OF_STICKY_RICE,      initial =  50, maxStock = 150, targetStock = 120, buyMax =    316, restockRate = 100, priceFloor =   0 },
        { id = xi.item.BAG_OF_BUCKWHEAT_FLOUR,  initial =  50, maxStock = 150, targetStock = 120, buyMax =   8985, restockRate = 100 },
        { id = xi.item.PINCH_OF_BLACK_PEPPER,   initial =  10, maxStock =  60, targetStock =  45, buyMax =   1111, restockRate =   5, priceFloor =  59 },
        { id = xi.item.ONZ_OF_TURMERIC,         initial =  20, maxStock =  60, targetStock =  50, buyMax =   3225, restockRate =  15 },
        { id = xi.item.ONZ_OF_CORIANDER,        initial =  20, maxStock =  60, targetStock =  50, buyMax =   7925, restockRate =  15 },
        { id = xi.item.SPRIG_OF_HOLY_BASIL,     initial =  20, maxStock =  60, targetStock =  50, buyMax =   4000, restockRate =  15 },
        { id = xi.item.ONZ_OF_CURRY_POWDER,     initial =  10, maxStock =  30, targetStock =  25, buyMax =   1456, restockRate =   7, priceFloor =  55 },
        { id = xi.item.JAR_OF_GROUND_WASABI,    initial = 100, maxStock = 150, targetStock = 110, buyMax =  12974, restockRate = 100 },
        { id = xi.item.BOTTLE_OF_RICE_VINEGAR,  initial = 100, maxStock = 150, targetStock = 120, buyMax =   1000, restockRate = 100, priceFloor = 135 },
        { id = xi.item.BUNDLE_OF_SHIRATAKI,     initial =  50, maxStock = 150, targetStock = 120, buyMax =    369, restockRate = 100, priceFloor =   0 },
        { id = xi.item.SCROLL_OF_KATON_ICHI,    initial =  10, maxStock =  60, targetStock =  45, buyMax =  11655, restockRate =   3 },
        { id = xi.item.SCROLL_OF_HUTON_ICHI,    initial =  10, maxStock =  60, targetStock =  45, buyMax =  11655, restockRate =   3 },
        { id = xi.item.SCROLL_OF_DOTON_ICHI,    initial =  10, maxStock =  60, targetStock =  45, buyMax =  11655, restockRate =   3 },
        { id = xi.item.SCROLL_OF_SUITON_ICHI,   initial =  10, maxStock =  60, targetStock =  45, buyMax =  11655, restockRate =   3 },
        { id = xi.item.UCHITAKE,                initial =  10, maxStock =  60, targetStock =  50, buyMax =    200, restockRate =   0 },
        { id = xi.item.KAWAHORI_OGI,            initial =  10, maxStock =  60, targetStock =  50, buyMax =    200, restockRate =   0 },
        { id = xi.item.MAKIBISHI,               initial =  10, maxStock =  60, targetStock =  50, buyMax =    200, restockRate =   0 },
        { id = xi.item.MIZU_DEPPO,              initial =  10, maxStock =  60, targetStock =  50, buyMax =    200, restockRate =   0 },
    },
}

-----------------------------------
-- Linkshell / Pendant Compass Vendors
-----------------------------------
removeStock('Ilita', xi.item.PENDANT_COMPASS)
removeStock('Khel_Pahlhama', xi.item.PENDANT_COMPASS)
removeStock('Paunelie', xi.item.PENDANT_COMPASS)
patchStock('Ilita', xi.item.NEW_LINKSHELL,         { priceFloor = 200, buyMax = 14493 })
patchStock('Khel_Pahlhama', xi.item.NEW_LINKSHELL, { priceFloor = 200, buyMax = 14493 })
patchStock('Paunelie', xi.item.NEW_LINKSHELL,      { priceFloor = 200, buyMax = 14493 })

-----------------------------------
-- ZenithXI: expansion-locked stock
--
-- Stock belonging to a later expansion is held out of the guild shops while that
-- expansion is disabled in settings/main.lua. initial/restockRate 0 keeps the item
-- off the buy list (offered is locked false when the shop day rolls) and noSell
-- keeps it off the sell list and rejects sell-backs.
--
-- When the expansion is enabled nothing is applied here, so the era values set
-- above -- or the base values in scripts/data/guild_shops.lua -- stand.
--
-- These test == 0 rather than `not`, because 0 is truthy in Lua.
-----------------------------------
if xi.settings.main.ENABLE_ROTZ == 0 then
    patchStock('Akamafula', xi.item.KUNAI,                   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.WAKIZASHI,               { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.UCHIGATANA,              { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.KANESADA,                { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.TACHI,                   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.NODACHI,                 { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.OKANEHIRA,               { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.TANEGASHIMA,             { initial = 0, restockRate = 0, noSell = true })
    patchStock('Akamafula', xi.item.SHURIKEN,                { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.KOMA,                   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.LUMP_OF_TAMA_HAGANE,    { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.POT_OF_URUSHI,          { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.BOX_OF_STICKY_RICE,     { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.ONZ_OF_TURMERIC,        { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.ONZ_OF_CORIANDER,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.SPRIG_OF_HOLY_BASIL,    { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.ONZ_OF_CURRY_POWDER,    { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.JAR_OF_GROUND_WASABI,   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.BOTTLE_OF_RICE_VINEGAR, { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.SCROLL_OF_KATON_ICHI,   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.SCROLL_OF_HUTON_ICHI,   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.SCROLL_OF_DOTON_ICHI,   { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.SCROLL_OF_SUITON_ICHI,  { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.UCHITAKE,               { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.KAWAHORI_OGI,           { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.MAKIBISHI,              { initial = 0, restockRate = 0, noSell = true })
    patchStock('Amalasanda', xi.item.MIZU_DEPPO,             { initial = 0, restockRate = 0, noSell = true })
    patchStock('Babubu', xi.item.MITHRAN_FISHING_ROD,        { initial = 0, restockRate = 0, noSell = true })
    patchStock('Graegham', xi.item.MITHRAN_FISHING_ROD,      { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SCROLL_OF_KATON_ICHI,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SCROLL_OF_HUTON_ICHI,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SCROLL_OF_DOTON_ICHI,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_MND,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SCROLL_OF_ABSORB_CHR,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.ONZ_OF_TURMERIC,            { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.ONZ_OF_CORIANDER,           { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.SPRIG_OF_HOLY_BASIL,        { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.ONZ_OF_CURRY_POWDER,        { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.JAR_OF_GROUND_WASABI,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.BOTTLE_OF_RICE_VINEGAR,     { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.SMOKED_SALMON,              { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.ONZ_OF_TURMERIC,            { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.ONZ_OF_CORIANDER,           { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.SPRIG_OF_HOLY_BASIL,        { initial = 0, restockRate = 0, noSell = true })
    patchStock('Maymunah', xi.item.BATTERY,                  { initial = 0, restockRate = 0, noSell = true })
    patchStock('Maymunah', xi.item.HYDRO_PUMP,               { initial = 0, restockRate = 0, noSell = true })
    patchStock('Maymunah', xi.item.WIND_FAN,                 { initial = 0, restockRate = 0, noSell = true })
    patchStock('Silver_Owl', xi.item.KUNAI,                  { initial = 0, restockRate = 0, noSell = true })
    patchStock('Silver_Owl', xi.item.SHINOBI_GATANA,         { initial = 0, restockRate = 0, noSell = true })
    patchStock('Silver_Owl', xi.item.KANESADA,               { initial = 0, restockRate = 0, noSell = true })
    patchStock('Silver_Owl', xi.item.TACHI,                  { initial = 0, restockRate = 0, noSell = true })
    patchStock('Silver_Owl', xi.item.KOTETSU,                { initial = 0, restockRate = 0, noSell = true })
end

if xi.settings.main.ENABLE_COP == 0 then
    patchStock('Amalasanda', xi.item.BUNDLE_OF_SHIRATAKI, { initial = 0, restockRate = 0, noSell = true })
    patchStock('Jabbar', xi.item.CLUMP_OF_SHUNGIKU,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.BAG_OF_SEMOLINA,         { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.JAR_OF_FISH_STOCK,       { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.SAUCER_OF_SOY_STOCK,     { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.STICK_OF_VANILLA,        { initial = 0, restockRate = 0, noSell = true })
end

if xi.settings.main.ENABLE_WOTG == 0 then
    patchStock('Amalasanda', xi.item.BAG_OF_BUCKWHEAT_FLOUR, { initial = 0, restockRate = 0, noSell = true })
    patchStock('Kopopo', xi.item.WEDGE_OF_CHALAIMBILLE,      { initial = 0, restockRate = 0, noSell = true })
end

if xi.settings.main.ENABLE_SOA == 1 then
    table.insert(xi.data.guildShops['Kopopo'].stock, { id = xi.item.JAR_OF_MISO,  initial = 150,   maxStock = 200,   targetStock = 150,   buyMax = 16667,  restockRate = 12 })
    table.insert(xi.data.guildShops['Kopopo'].stock, { id = xi.item.JAR_OF_SOY_SAUCE,  initial = 150,   maxStock = 200,   targetStock = 150,   buyMax = 16667,  restockRate = 12 })
    table.insert(xi.data.guildShops['Kopopo'].stock, { id = xi.item.HANDFUL_OF_DRIED_BONITO,  initial = 150,   maxStock = 200,   targetStock = 150,   buyMax = 16667,  restockRate = 12 })
    table.insert(xi.data.guildShops['Kopopo'].stock, { id = xi.item.AZUKI_BEAN,  initial = 150,   maxStock = 200,   targetStock = 150,   buyMax = 16667,  restockRate = 12 })
end

return m
