-----------------------------------
-- Guild Vendor Shop Overrides
--
-- Opens the era guild shop for the NPCs that do not own one in their base
-- script: the craft guilds' "General Vendors" -- which otherwise open the
-- static, infinite-stock shop built from xi.shop.generalGuildStock in
-- scripts/globals/shop.lua -- and the two Tenshodo merchants that retail
-- converted into plain shops.
--
-- The stock pools themselves come from c_eraGuildShops, which registers each
-- of these NPCs as a cfg.sharedStock alias of its partner merchant (or, for the
-- Tenshodo pair, as a guild shop of its own). Base canonicalShop in
-- scripts/globals/guild_shops.lua resolves the alias, so triggering one of
-- these NPCs opens and depletes the partner's shared inventory and price pool.
--
-- Public module for ZenithXI
-----------------------------------
local m = Module:new('c_guildVendorShops')

-- Each entry overrides one NPC's onTrigger to open its era guild shop.
--   path    : override target (the NPC's onTrigger)
--   zone    : xi.zone the NPC lives in (used to resolve its dialog)
--   dialog  : original showText key on zones[zone].text, or nil for no dialog
--   keyItem : key item required to shop here, or nil for no requirement
local sharedGuildVendors =
{
    -- General Vendors, aliased onto their partner merchant's guild shop
    {
        path   = 'xi.zones.Bastok_Markets.npcs.Teerth.onTrigger',
        zone   = xi.zone.BASTOK_MARKETS,
        dialog = 'TEERTH_SHOP_DIALOG', -- shares Visala (Goldsmithing)
    },
    {
        path   = 'xi.zones.Bastok_Mines.npcs.Odoba.onTrigger',
        zone   = xi.zone.BASTOK_MINES,
        dialog = 'ODOBA_SHOP_DIALOG', -- shares Maymunah (Alchemy)
    },
    {
        path   = 'xi.zones.Metalworks.npcs.Vicious_Eye.onTrigger',
        zone   = xi.zone.METALWORKS,
        dialog = 'VICIOUS_EYE_SHOP_DIALOG', -- shares Amulya (Smithing)
    },
    {
        path   = 'xi.zones.Mhaura.npcs.Celestina.onTrigger',
        zone   = xi.zone.MHAURA,
        dialog = nil, -- shares Yabby Tanmikey (Goldsmithing); Celestina shows no shop dialog
    },
    {
        path   = 'xi.zones.Mhaura.npcs.Mololo.onTrigger',
        zone   = xi.zone.MHAURA,
        dialog = 'SMITHING_GUILD', -- shares Kamilah (Smithing)
    },
    {
        path   = 'xi.zones.Northern_San_dOria.npcs.Cauzeriste.onTrigger',
        zone   = xi.zone.NORTHERN_SAN_DORIA,
        dialog = 'CAUZERISTE_SHOP_DIALOG', -- shares Chaupire (Woodworking)
    },
    {
        path   = 'xi.zones.Northern_San_dOria.npcs.Lucretia.onTrigger',
        zone   = xi.zone.NORTHERN_SAN_DORIA,
        dialog = 'LUCRETIA_SHOP_DIALOG', -- shares Doggomehr (Smithing)
    },
    {
        path   = 'xi.zones.Selbina.npcs.Gibol.onTrigger',
        zone   = xi.zone.SELBINA,
        dialog = 'CLOTHCRAFT_SHOP_DIALOG', -- shares Tilala (Clothcraft)
    },
    {
        path   = 'xi.zones.Southern_San_dOria.npcs.Cletae.onTrigger',
        zone   = xi.zone.SOUTHERN_SAN_DORIA,
        dialog = 'CLETAE_DIALOG', -- shares Kueh Igunahmori (Leathercraft)
    },
    {
        path   = 'xi.zones.Windurst_Waters.npcs.Chomo_Jinjahl.onTrigger',
        zone   = xi.zone.WINDURST_WATERS,
        dialog = 'CHOMOJINJAHL_SHOP_DIALOG', -- shares Kopopo (Cooking)
    },
    {
        path   = 'xi.zones.Windurst_Woods.npcs.Meriri.onTrigger',
        zone   = xi.zone.WINDURST_WOODS,
        dialog = 'MERIRI_DIALOG', -- shares Kuzah Hpirohpon (Clothcraft)
    },
    {
        path   = 'xi.zones.Windurst_Woods.npcs.Retto-Marutto.onTrigger',
        zone   = xi.zone.WINDURST_WOODS,
        dialog = 'RETTO_MARUTTO_DIALOG', -- shares Shih Tayuun (Bonecraft)
    },

    -- Tenshodo merchants, restored to guild shops of their own by c_eraGuildShops.
    -- Their base scripts gate on the members card; that check is kept here.
    {
        path    = 'xi.zones.Lower_Jeuno.npcs.Akamafula.onTrigger',
        zone    = xi.zone.LOWER_JEUNO,
        dialog  = 'AKAMAFULA_SHOP_DIALOG',
        keyItem = xi.ki.TENSHODO_MEMBERS_CARD,
    },
    {
        path    = 'xi.zones.Lower_Jeuno.npcs.Amalasanda.onTrigger',
        zone    = xi.zone.LOWER_JEUNO,
        dialog  = 'AMALASANDA_SHOP_DIALOG',
        keyItem = xi.ki.TENSHODO_MEMBERS_CARD,
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

-- Open this NPC's era guild shop, honouring any key item requirement.
-- @param player CBaseEntity
-- @param npc CBaseEntity: the triggered vendor
-- @param entry table: a sharedGuildVendors row
local function openEraGuildShop(player, npc, entry)
    if entry.keyItem ~= nil and not player:hasKeyItem(entry.keyItem) then
        return -- Anti-Cheat.
    end

    if xi.guildShops.onTrigger(player, npc) then
        local dialog = dialogText(entry)
        if dialog ~= nil then
            player:showText(npc, dialog)
        end
    end
end

for _, entry in ipairs(sharedGuildVendors) do
    m:addOverride(entry.path, function(player, npc)
        openEraGuildShop(player, npc, entry)
    end)
end

return m
