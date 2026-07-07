-----------------------------------
-- Guild Vendor Shop Overrides
--
-- Redirects the legacy "General Vendor" guild merchants -- which open the static,
-- infinite-stock shop built from xi.shop.generalGuildStock in
-- scripts/globals/shop.lua -- to the real, finite guild shop they share inventory
-- with. The General Vendor's own shop is replaced; it now opens the partner shop.
--
-- Two share mechanisms, both giving true shared stock with the partner merchant:
--   * sendGuild  -> retail DB-backed guild shop keyed by guildid
--                   (sql/guild_shops.sql via src/map/utils/guildutils.cpp).
--                   Both NPCs calling sendGuild(<id>, ...) read the same stock.
--   * dynamic   -> ZenithXI dynamic vendor (scripts/data/guild_shops.lua). The
--                  General Vendor is aliased to the partner's shop key by the
--                  c_guildShopSharing module, so xi.guildShops.onTrigger opens
--                  and shares the partner's inventory + prices.
--
-- Public module for ZenithXI
-----------------------------------
local m = Module:new('c_guildVendorShops')

-- Each entry overrides one General Vendor's onTrigger.
--   zone    : xi.zone the NPC lives in (used to resolve its dialog)
--   dialog  : original showText key on zones[zone].text, or nil for no dialog
--   guild   : { guildId, open, close, holiday } -> player:sendGuild(...)  (DB guild shop)
--   (dynamic entries have no guild field; alias in c_guildShopSharing routes them)
-- Exactly one of guild / (no guild) is set per entry.
local sharedGuildVendors =
{
    -- sendGuild merchants (DB-backed guild shops, shared by guildid)
    {
        path   = 'xi.zones.Bastok_Markets.npcs.Teerth.onTrigger',
        zone   = xi.zone.BASTOK_MARKETS,
        dialog = 'TEERTH_SHOP_DIALOG',
        guild  = { 5272, 8, 23, 4 }, -- Visala (Goldsmithing)
    },
    {
        path   = 'xi.zones.Bastok_Mines.npcs.Odoba.onTrigger',
        zone   = xi.zone.BASTOK_MINES,
        dialog = 'ODOBA_SHOP_DIALOG',
        guild  = { 5262, 8, 23, 6 }, -- Maymunah (Alchemy)
    },
    {
        path   = 'xi.zones.Northern_San_dOria.npcs.Cauzeriste.onTrigger',
        zone   = xi.zone.NORTHERN_SAN_DORIA,
        dialog = 'CAUZERISTE_SHOP_DIALOG',
        guild  = { 5132, 6, 21, 0 }, -- Chaupire (Woodworking)
    },
    {
        path   = 'xi.zones.Northern_San_dOria.npcs.Lucretia.onTrigger',
        zone   = xi.zone.NORTHERN_SAN_DORIA,
        dialog = 'LUCRETIA_SHOP_DIALOG',
        guild  = { 531, 8, 23, 2 }, -- Doggomehr (Smithing)
    },
    {
        path   = 'xi.zones.Selbina.npcs.Gibol.onTrigger',
        zone   = xi.zone.SELBINA,
        dialog = 'CLOTHCRAFT_SHOP_DIALOG',
        guild  = { 5152, 6, 21, 0 }, -- Kuzah Hpirohpon (Clothcraft)
    },
    {
        path   = 'xi.zones.Southern_San_dOria.npcs.Cletae.onTrigger',
        zone   = xi.zone.SOUTHERN_SAN_DORIA,
        dialog = 'CLETAE_DIALOG',
        guild  = { 529, 3, 18, 4 }, -- Kueh Igunahmori (Leathercraft)
    },
    {
        path   = 'xi.zones.Windurst_Woods.npcs.Meriri.onTrigger',
        zone   = xi.zone.WINDURST_WOODS,
        dialog = 'MERIRI_DIALOG',
        guild  = { 5152, 6, 21, 0 }, -- Kuzah Hpirohpon (Clothcraft)
    },
    {
        path   = 'xi.zones.Windurst_Woods.npcs.Retto-Marutto.onTrigger',
        zone   = xi.zone.WINDURST_WOODS,
        dialog = 'RETTO_MARUTTO_DIALOG',
        guild  = { 514, 8, 23, 3 }, -- Shih Tayuun (Bonecraft)
    },

    -- Dynamic vendors (ZenithXI Lua guild shops, shared by NPC name)
    {
        path   = 'xi.zones.Metalworks.npcs.Vicious_Eye.onTrigger',
        zone   = xi.zone.METALWORKS,
        dialog = 'VICIOUS_EYE_SHOP_DIALOG',
    },
    {
        path   = 'xi.zones.Mhaura.npcs.Celestina.onTrigger',
        zone   = xi.zone.MHAURA,
        dialog = nil, -- Celestina shows no shop dialog
    },
    {
        path   = 'xi.zones.Mhaura.npcs.Mololo.onTrigger',
        zone   = xi.zone.MHAURA,
        dialog = 'SMITHING_GUILD',
    },
    {
        path   = 'xi.zones.Windurst_Waters.npcs.Chomo_Jinjahl.onTrigger',
        zone   = xi.zone.WINDURST_WATERS,
        dialog = 'CHOMOJINJAHL_SHOP_DIALOG',
    },
}

-- Resolve the NPC's kept dialog text id, or nil if it has none.
-- @param entry table: a sharedGuildVendors row
-- @return integer or nil: the resolved zones[zone].text value
local function dialogText(entry)
    if entry.dialog == nil then
        return nil
    end

    return zones[entry.zone].text[entry.dialog]
end

-- Open the partner's DB-backed guild shop via sendGuild. Stock is shared by guildid.
-- @param player CBaseEntity
-- @param npc CBaseEntity: the triggered General Vendor
-- @param entry table: a sharedGuildVendors row with a guild field
local function openSharedSendGuild(player, npc, entry)
    local guild = entry.guild
    if player:sendGuild(guild[1], guild[2], guild[3], guild[4]) then
        local dialog = dialogText(entry)
        if dialog ~= nil then
            player:showText(npc, dialog)
        end
    end
end

-- Open the shared dynamic vendor shop. The alias registered by c_guildShopSharing
-- (xi.guildShops.alias) maps this General Vendor's name to the partner's shop key,
-- so triggering it directly opens and depletes the shared inventory + price pool.
-- @param player CBaseEntity
-- @param npc CBaseEntity: the triggered General Vendor
-- @param entry table: a sharedGuildVendors row without a guild field
local function openSharedDynamicShop(player, npc, entry)
    if xi.guildShops.onTrigger(player, npc) then
        local dialog = dialogText(entry)
        if dialog ~= nil then
            player:showText(npc, dialog)
        end
    end
end

for _, entry in ipairs(sharedGuildVendors) do
    m:addOverride(entry.path, function(player, npc)
        if entry.guild ~= nil then
            openSharedSendGuild(player, npc, entry)
        else
            openSharedDynamicShop(player, npc, entry)
        end
    end)
end

return m
