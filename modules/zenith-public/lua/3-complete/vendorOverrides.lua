-----------------------------------
-- Out of Era vendors and other shop overrides
-- Does not restore Era functionality but customizes offerings
-- Public module for ZenitXI
-- Items with an * have had their default prices changed
-----------------------------------
local m = Module:new('ooe_vendors')

-- TODO: Dibstix is not yet implemented.

-- TODO: Lollyspox is not yet implemented.

-- stock tables are generally tables of rows of the form { itemid, minimum price }
-- nation shops will have an extra column to further define the place that nation needs to be in
local npcOverrides =
{
    [xi.zone.LOWER_JEUNO] =
    {
        ['Taza'] =
        {
            removeDefault = true, -- remove default action from IF to avoid flip-flopping trigger action
            shopDialog = 'WAAG_DEEG_SHOP_DIALOG',
            stock =
            {
                { xi.item.SCROLL_OF_SLEEP_II,      18720 },
                { xi.item.SCROLL_OF_SLEEPGA,       11200 },
            },
            stock55 =
            {
                { xi.item.SCROLL_OF_STONE_III,     19932 },
                { xi.item.SCROLL_OF_WATER_III,     22682 },
            },
            stock60 =
            {
                { xi.item.SCROLL_OF_AERO_III,      27744 },
            },
            stock65 =
            {
                { xi.item.SCROLL_OF_FIRE_III,      33306 },
                { xi.item.SCROLL_OF_BLIZZARD_III,  39368 },
            },
            stock70 =
            {
                { xi.item.SCROLL_OF_THUNDER_III,   45930 },
            },
            stock75 =
            {
                { xi.item.SCROLL_OF_PROTECTRA_V,  119240 },
                { xi.item.SCROLL_OF_SHELLRA_V,    124540 },
                { xi.item.SCROLL_OF_DIA_III,      139135 },
                { xi.item.SCROLL_OF_SLOW_II,      139135 },
                { xi.item.SCROLL_OF_PARALYZE_II,  139135 },
                { xi.item.SCROLL_OF_PHALANX_II,   139135 },
                { xi.item.SCROLL_OF_QUAKE_II,     119180 },
                { xi.item.SCROLL_OF_FLOOD_II,     119180 },
                { xi.item.SCROLL_OF_TORNADO_II,   119180 },
                { xi.item.SCROLL_OF_FLARE_II,     119180 },
                { xi.item.SCROLL_OF_FREEZE_II,    119180 },
                { xi.item.SCROLL_OF_BURST_II,     119180 },
                { xi.item.SCROLL_OF_BIO_III,      139125 },
                { xi.item.SCROLL_OF_BLIND_II,     139125 },
            },
        },
    },
    [xi.zone.BASTOK_MARKETS] =
    {
        ['Hortense'] =
        {
            nationShop = xi.nation.BASTOK,
            shopDialog = 'HORTENSE_SHOP_DIALOG',
            stock =
            {
                { xi.item.SCROLL_OF_FOE_REQUIEM,         74, },
                { xi.item.SCROLL_OF_FOE_REQUIEM_II,     509, },
                { xi.item.SCROLL_OF_FOE_REQUIEM_III,   4576, },
                { xi.item.SCROLL_OF_FOE_REQUIEM_IV,    7987, },
                { xi.item.SCROLL_OF_ARMYS_PAEON,         43, },
                { xi.item.SCROLL_OF_ARMYS_PAEON_II,     371, },
                { xi.item.SCROLL_OF_ARMYS_PAEON_III,   3744, },
                { xi.item.SCROLL_OF_ARMYS_PAEON_IV,    6864, },
                { xi.item.SCROLL_OF_VALOR_MINUET,        24, },
                { xi.item.SCROLL_OF_VALOR_MINUET_II,   1272, },
                { xi.item.SCROLL_OF_VALOR_MINUET_III,  6406, },
            },
        },
    },
}

-----------------------------------
-- Scroll Vendor Overrides
-- iterates through the table above, inserting conditional items as needed, then showing the appropriate shop
-----------------------------------

local addStockToTable = function(stock, newStock)
    if not type(newStock) == 'table' then
        return
    end

    if type(newStock[1]) ~= 'table' then
        -- single item
        table.insert(stock, newStock)
    else
        -- newStock is table of items
        for _, newStockItem in ipairs(newStock) do
            table.insert(stock, newStockItem)
        end
    end
end

for zoneId, npcs in pairs(npcOverrides) do
    local zoneName = zxi.zoneName[zoneId]

    for npcName, npcData in pairs(npcs) do
        local npcMsgID   = zones[zoneId].text[shopDialog]
        local nationShop = npcData.nationShop
        local fameArea   = npcData.fameArea
        local npcLuaPath = fmt('xi.zones.{}.npcs.{}', zoneName, npcName)

        xi.module.ensureTable(npcLuaPath)
        if npcData.removeDefault then
            zxi.npcHelpers.removeDefaultHandler(zoneId, npcName)
        end

        -- add all relevant stock to table (deep copy instead of direct assignment)
        local stock = {}
        addStockToTable(stock, npcData.stock)

        -- add any level-cap restricted items
        for _, lvlCap in pairs({55, 60, 65, 70, 75}) do
            if xi.settings.main.MAX_LEVEL >= lvlCap then
                local capStock = npcData[fmt('stock{}', lvlCap)]
                if capStock then
                    addStockToTable(stock, capStock)
                end
            end
        end

        m:addOverride(fmt('{}.onTrigger', npcLuaPath), function(player, npc)
            if #stock == 0 then
                player:printToPlayer(fmt('Apologies, {} I have no stock at this time', player:getName()), xi.msg.channel.SYSTEM_3, npc:getName())
            else
                if npcMsgID then
                    player:showText(npc, npcMsgID)
                end

                if nationShop ~= nil then
                    xi.shop.nation(player, stock, nationShop)
                else
                    xi.shop.general(player, stock, fameArea)
                end
            end
        end)
    end
end

m:addOverride('xi.zones.Port_Jeuno.npcs.Gekko.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,                1294 }, -- *
        { xi.item.ANTIDOTE,                           316 },
        { xi.item.FLASK_OF_ECHO_DROPS,                800 },
        { xi.item.POTION,                             910 },
        { xi.item.ETHER,                             1575 }, -- *
        { xi.item.ROLANBERRY,                         120 },
        { xi.item.COPY_OF_AUTUMNS_END_IN_GUSTABERG, 36000 },
        { xi.item.COPY_OF_ACOLYTES_GRIEF,           31224 },
    }

    player:showText(npc, zones[player:getZoneID()].text.DUTY_FREE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Susu.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_BARSLEEP,       244 },
        { xi.item.SCROLL_OF_BARPOISON,      400 },
        { xi.item.SCROLL_OF_BARPARALYZE,    780 },
        { xi.item.SCROLL_OF_BARBLIND,      2030 },
        { xi.item.SCROLL_OF_BARSILENCE,    4608 },
        { xi.item.SCROLL_OF_BARVIRUS,      9600 },
        { xi.item.SCROLL_OF_BARPETRIFY,   15120 },
        { xi.item.SCROLL_OF_BARSLEEPRA,     244 },
        { xi.item.SCROLL_OF_BARPOISONRA,    400 },
        { xi.item.SCROLL_OF_BARPALARYZRA,   780 },
        { xi.item.SCROLL_OF_BARBLINDRA,    2030 },
        { xi.item.SCROLL_OF_BARSILENCERA,  4608 },
        { xi.item.SCROLL_OF_BARVIRA,       9600 },
        { xi.item.SCROLL_OF_BARPETRA,     15120 },
        { xi.item.SCROLL_OF_SILENA,        2330 },
        { xi.item.SCROLL_OF_CURSNA,        8586 },
        { xi.item.SCROLL_OF_VIRUNA,       13300 },
        { xi.item.SCROLL_OF_STONA,        19200 },
        { xi.item.SCROLL_OF_BANISHGA_II,  20000 },
        { xi.item.SCROLL_OF_HOLY,         35000 },
    }

    player:showText(npc, zones[player:getZoneID()].text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Hasim.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_BARSTONE,         156 },
        { xi.item.SCROLL_OF_BARWATER,         360 },
        { xi.item.SCROLL_OF_BARAERO,          930 },
        { xi.item.SCROLL_OF_BARFIRE,         1760 },
        { xi.item.SCROLL_OF_BARBLIZZARD,     3624 },
        { xi.item.SCROLL_OF_BARTHUNDER,      5754 },
        { xi.item.SCROLL_OF_BARSTONRA,        156 },
        { xi.item.SCROLL_OF_BARWATERA,        360 },
        { xi.item.SCROLL_OF_BARAERA,          930 },
        { xi.item.SCROLL_OF_BARFIRA,         1760 },
        { xi.item.SCROLL_OF_BARBLIZZARA,     3624 },
        { xi.item.SCROLL_OF_BARTHUNDRA,      5754 },
        { xi.item.SCROLL_OF_CURE_IV,        23400 },
        { xi.item.SCROLL_OF_CURAGA_II,      11200 },
-- { xi.item.SCROLL_OF_CURAGA_III,     19932 }, -- 55 Cap
        { xi.item.SCROLL_OF_PROTECT_III,    32000 },
        { xi.item.SCROLL_OF_PROTECTRA_II,    7074 },
        { xi.item.SCROLL_OF_PROTECTRA_III,  19200 },
-- { xi.item.SCROLL_OF_SHELL_III,      26244 }, -- 60 Cap
        { xi.item.SCROLL_OF_SHELLRA,         1760 },
        { xi.item.SCROLL_OF_SHELLRA_II,     14080 },
-- { xi.item.SCROLL_OF_SHELLRA_III,    26244 }, -- 60 Cap
-- { xi.item.SCROLL_OF_INUNDATION,     73500 }, (Disabled)
-- { xi.item.SCROLL_OF_ADDLE,         130378 }, -- (Adoulin)
    }

    player:showText(npc, zones[player:getZoneID()].text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Creepstix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_GOBLIN_GAVOTTE,   8160 },
        { xi.item.SCROLL_OF_PROTECTRA_II  ,   7074 },
        { xi.item.SCROLL_OF_SHELLRA,          1760 },
    }

    player:showText(npc, zones[player:getZoneID()].text.JUNK_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Yoskolo.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_DISTILLED_WATER,       12 },
        { xi.item.BOTTLE_OF_ORANGE_JUICE,        200 },
        { xi.item.BOTTLE_OF_APPLE_JUICE,         430 }, -- *
        { xi.item.BOTTLE_OF_MELON_JUICE,        1200 }, -- *
        { xi.item.BOTTLE_OF_GRAPE_JUICE,         967 },
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,     624 }, -- *
        { xi.item.SERVING_OF_ICECAP_ROLANBERRY, 4712 }, -- *
        { xi.item.SCROLL_OF_FIRE_CAROL,         6380 },
        { xi.item.SCROLL_OF_ICE_CAROL,          7440 },
        { xi.item.SCROLL_OF_WIND_CAROL,         5940 },
        { xi.item.SCROLL_OF_EARTH_CAROL,        4600 },
        { xi.item.SCROLL_OF_LIGHTNING_CAROL,    7920 },
        { xi.item.SCROLL_OF_WATER_CAROL,        5000 },
        { xi.item.SCROLL_OF_LIGHT_CAROL,        4200 },
        { xi.item.SCROLL_OF_DARK_CAROL,         8400 },
-- { xi.item.SCROLL_OF_SENTINELS_SCHERZO, 60000 },
    }

    player:showText(npc, zones[player:getZoneID()].text.YOSKOLO_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Amalasanda.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BAMBOO_STICK,             151 },
        { xi.item.PINCH_OF_BLACK_PEPPER,    267 },
        { xi.item.SQUARE_OF_SILK_CLOTH,   35070 }, -- *
        { xi.item.KOMA,                     231 },
        { xi.item.LUMP_OF_TAMA_HAGANE,    12000 }, -- *
        { xi.item.POT_OF_URUSHI,          77206 },
-- { xi.item.BOX_OF_STICKY_RICE,       331 }, (COP)
        { xi.item.ONZ_OF_CURRY_POWDER,     1039 },
        { xi.item.JAR_OF_GROUND_WASABI,    2724 },
        { xi.item.BOTTLE_OF_RICE_VINEGAR,   210 },
-- { xi.item.BUNDLE_OF_SHIRATAKI,      516 }, (COP)
-- { xi.item.BAG_OF_BUCKWHEAT_FLOUR,  2250 }, -- * (WOTG)
        { xi.item.SCROLL_OF_KATON_ICHI,    2447 },
        { xi.item.SCROLL_OF_HYOTON_ICHI,   2447 },
        { xi.item.SCROLL_OF_HUTON_ICHI,    2447 },
        { xi.item.SCROLL_OF_DOTON_ICHI,    2447 },
        { xi.item.SCROLL_OF_RAITON_ICHI,   2447 },
        { xi.item.SCROLL_OF_SUITON_ICHI,   2447 },
    }

    player:showText(npc, zones[player:getZoneID()].text.AMALASANDA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Selbina.npcs.Quelpia.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_CURE_II,      676 },
        { xi.item.SCROLL_OF_CURE_III,    3768 },
        { xi.item.SCROLL_OF_CURAGA_II,  11648 },
        { xi.item.SCROLL_OF_RAISE,       5984 },
        { xi.item.SCROLL_OF_HOLY,       36400 },
        { xi.item.SCROLL_OF_DIA_II,     11648 },
        { xi.item.SCROLL_OF_BANISH_II,   9360 },
        { xi.item.SCROLL_OF_PROTECT_II,  7356 },
        { xi.item.SCROLL_OF_SHELL_II,   18304 },
        { xi.item.SCROLL_OF_HASTE,      20800 },
        { xi.item.SCROLL_OF_ENFIRE,      5366 },
        { xi.item.SCROLL_OF_ENBLIZZARD,  4261 },
        { xi.item.SCROLL_OF_ENAERO,      2600 },
        { xi.item.SCROLL_OF_ENSTONE,     2111 },
        { xi.item.SCROLL_OF_ENTHUNDER,   1575 },
        { xi.item.SCROLL_OF_ENWATER,     7356 },
-- { xi.item.SCROLL_OF_FLURRY,     34320 }, (Adoulin)
    }

    player:showText(npc, zones[player:getZoneID()].text.QUELPIA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Selbina.npcs.Dohdjuma.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BAG_OF_RYE_FLOUR,            41 },
        { xi.item.SCROLL_OF_SHEEPFOE_MAMBO,   269 },
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_DISTILLED_WATER,    12 },
        { xi.item.POTION,                     955 },
        { xi.item.LUGWORM,                     12 },
        { xi.item.JUG_OF_SELBINA_MILK,         62 },
        { xi.item.PICKLED_HERRING,           1497 }, -- *
        { xi.item.SERVING_OF_HERB_QUUS,      5183 },
-- { xi.item.SELBINA_WAYSTONE,         10500 }, (Synergy)
    }

    player:showText(npc, zones[player:getZoneID()].text.DOHDJUMA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Mhaura.npcs.Tya_Padolih.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_SLEEPGA,    11648 },
-- { xi.item.SCROLL_OF_DISTRACT,   71344 }, -- *(Adoulin)
-- { xi.item.SCROLL_OF_FRAZZLE,    84912 }, -- *(Adoulin)
    }

    player:showText(npc, zones[player:getZoneID()].text.TYAPADOLIH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Kazham.npcs.Toji_Mumosulah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.YELLOW_JAR,                  520 },
        { xi.item.BLOOD_STONE,                 109 },
        { xi.item.FANG_NECKLACE,              4006 },
        { xi.item.BONE_EARRING,               1902 },
        { xi.item.SCROLL_OF_MONOMI_ICHI,     10069 },
        { xi.item.GEMSHORN,                   5418 },
        { xi.item.PEELED_CRAYFISH,              73 },
        { xi.item.BALL_OF_INSECT_PASTE,         42 },
        { xi.item.JUG_OF_FISH_BROTH,            94 },
        { xi.item.JUG_OF_WORMY_BROTH,          100 }, -- *
        { xi.item.JUG_OF_SEEDBED_SOIL,         499 },
        { xi.item.HATCHET,                     525 },
        { xi.item.SCROLL_OF_ARMYS_PAEON_III,  3780 },
    }

    player:showText(npc, zones[player:getZoneID()].text.TOJIMUMOSULAH_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Norg.npcs.Solby-Maholby.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LUGWORM,                     12 },
        { xi.item.EARTH_SPIRIT_PACT,          500 },
-- { xi.item.NORG_WAYSTONE,            10500 }, (Synergy)
-- { xi.item.SCROLL_OF_KATON_SAN,     125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_HYOTON_SAN,    125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_HUTON_SAN,     125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_DOTON_SAN,     125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_RAITON_SAN,    125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_SUITON_SAN,    125212 }, -- 75 Cap
-- { xi.item.SCROLL_OF_GEKKA_ICHI,    163705 }, -- 75 Cap (Remember flower)
-- { xi.item.SCROLL_OF_YAIN_ICHI,     163705 }, -- 75 Cap (Remember flower)
    }

    player:showText(npc, zones[player:getZoneID()].text.SOLBYMAHOLBY_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Rabao.npcs.Brave_Ox.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_PROTECT_IV,    88400 },
        { xi.item.SCROLL_OF_PROTECTRA_IV,  84240 },
        { xi.item.SCROLL_OF_DISPEL,        72800 },
        { xi.item.SCROLL_OF_STUN,          36400 },
        { xi.item.SCROLL_OF_FLASH,         36400 },
-- { xi.item.SCROLL_OF_RERAISE_III,  624000 }, -- 70 Cap
        { xi.item.SCROLL_OF_BANISH_III,    89440 },
        { xi.item.SCROLL_OF_CURA,          22713 },
        { xi.item.SCROLL_OF_SACRIFICE,     70304 },
        { xi.item.SCROLL_OF_ESUNA,         73008 },
        { xi.item.SCROLL_OF_AUSPICE,       35006 },
-- { xi.item.SCROLL_OF_CRUSADE,      163705 }, -- 75 Cap
    }

    player:showText(npc, zones[player:getZoneID()].text.BRAVEOX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Nilerouche.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LUFAISE_FLY,         108, },
        { xi.item.CLOTHESPOLE,        2640, },
        { xi.item.ARROWWOOD_LOG,        20, },
        { xi.item.ELM_LOG,            7800, },
-- { xi.item.SAFEHOLD_WAYSTONE, 10000, }, (Synergy)
    }

-- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 2, { xi.item.LITTLE_WORM,                 4 }) -- *
        table.insert(stock, 4, { xi.item.SINGLE_HOOK_FISHING_ROD, 12800 }) -- *
        table.insert(stock, 7, { xi.item.HATCHET,                   500 }) -- *
    end

    -- Bonus wares for COP completion
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN then
        table.insert(stock, 8, { xi.item.ACORN,                          100 }) -- *
        table.insert(stock, 9, { xi.item.CLUMP_OF_WINDURSTIAN_TEA_LEAVES, 26 }) -- *
        table.insert(stock, 10, { xi.item.PINCH_OF_CLUSTER_ASH,         1015 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.NILEROUCHE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Mazuro-Oozuro.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_CURE_II,    676, }, -- *
        { xi.item.SCROLL_OF_BANISH_II, 9360, }, -- *
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 3, { xi.item.SCROLL_OF_BANISH_III, 66000 })
        table.insert(stock, 4, { xi.item.SCROLL_OF_HOLY,       32200 }) -- *
    end

    -- Bonus wares for COP completion
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN then
        table.insert(stock, 5, { xi.item.SCROLL_OF_PROTECTRA_IV, 77500 }) -- *
        table.insert(stock, 6, { xi.item.SCROLL_OF_SHELLRA_IV,   82172 }) -- *
        table.insert(stock, 7, { xi.item.SCROLL_OF_INVISIBLE,     5984 }) -- *
        table.insert(stock, 8, { xi.item.SCROLL_OF_SNEAK,         2600 }) -- *
        table.insert(stock, 9, { xi.item.SCROLL_OF_DEODORIZE,     1346 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.MAZUROOOZURO_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Komalata.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.STRIP_OF_MEAT_JERKY,     120, },
        { xi.item.CHUNK_OF_ROCK_SALT,       16, },
        { xi.item.BAG_OF_RYE_FLOUR,         40, },
        { xi.item.FLASK_OF_DISTILLED_WATER, 12, },
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        stock =
        {
            { xi.item.BOTTLE_OF_APPLE_VINEGAR,  88, },
            { xi.item.LOAF_OF_BLACK_BREAD,     120, },
            { xi.item.STRIP_OF_MEAT_JERKY,     120, },
            { xi.item.CHUNK_OF_ROCK_SALT,       16, },
            { xi.item.BAG_OF_RYE_FLOUR,         40, },
            { xi.item.BAG_OF_SAN_DORIAN_FLOUR,  60, },
            { xi.item.SAN_DORIAN_CARROT,        32, },
            { xi.item.EAR_OF_MILLIONCORN,       48, },
            { xi.item.SPRIG_OF_APPLE_MINT,     316, },
            { xi.item.FLASK_OF_DISTILLED_WATER, 12, },
        }
    end

    -- Bonus wares for COP completion
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN then
        stock =
        {
            { xi.item.BOTTLE_OF_APPLE_VINEGAR,         88, },
            { xi.item.FLASK_OF_OLIVE_OIL,              16, },
            { xi.item.POT_OF_MAPLE_SUGAR,              41, },
            { xi.item.LOAF_OF_BLACK_BREAD,            120, },
            { xi.item.STRIP_OF_MEAT_JERKY,            120, },
            { xi.item.SMOKED_SALMON,                  248, },
            { xi.item.CHUNK_OF_ROCK_SALT,              16, },
            { xi.item.BAG_OF_RYE_FLOUR,                40, },
            { xi.item.BAG_OF_SAN_DORIAN_FLOUR,         60, },
            { xi.item.SAN_DORIAN_CARROT,               32, },
            { xi.item.BUNCH_OF_SAN_DORIAN_GRAPES,      80, },
            { xi.item.EAR_OF_MILLIONCORN,              48, },
            { xi.item.LA_THEINE_CABBAGE,               24, },
            { xi.item.SPRIG_OF_APPLE_MINT,            316, },
            { xi.item.SPRIG_OF_MISAREAUX_PARSLEY,     265, },
            { xi.item.FLASK_OF_DISTILLED_WATER,        12, },
            { xi.item.JUG_OF_SELBINA_MILK,             63, },
        }
    end

    player:showText(npc, zones[player:getZoneID()].text.KOMALATA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Migran.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.TUNIC,         1456, }, -- *
        { xi.item.HOLLY_CLOGS,   1625, },
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 3, { xi.item.BLACK_TUNIC,    10356 }) -- *
        table.insert(stock, 4, { xi.item.CHESTNUT_SABOTS, 9180 }) -- *
    end

    -- Bonus wares for COP completion
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN then
        table.insert(stock, 5, { xi.item.VIR_SUBLIGAR,    8000000 })
        table.insert(stock, 6, { xi.item.FEMINA_SUBLIGAR, 8000000 })
    end

    player:showText(npc, zones[player:getZoneID()].text.MIGRAN_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Misseulieu.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BRASS_HARNESS,  2485, },
        { xi.item.BRASS_LEGGINGS, 1289, }, -- *
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 3, { xi.item.PADDED_ARMOR, 32747 }) -- *
        table.insert(stock, 4, { xi.item.LEGGINGS,     16373 }) -- *
    end

    -- Bonus wares for COP completion
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.DAWN then
        table.insert(stock, 5, { xi.item.BARONE_COSCIALES, 284217 }) -- *
        table.insert(stock, 6, { xi.item.BARONE_GAMBIERAS, 295431 }) -- *
        table.insert(stock, 7, { xi.item.BARONE_MANOPOLAS, 341071 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.MISSEULIEU_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Caiphimonride.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.DAGGER,    2030, },
        { xi.item.CRUDE_ARROW,  4, }, -- *
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 3, { xi.item.IRON_ARROW, 8 }) -- *
        table.insert(stock, 4, { xi.item.BULLET,   104 }) -- *
        table.insert(stock, 5, { xi.item.VOULGE, 20762 })
    end

    player:showText(npc, zones[player:getZoneID()].text.CAIPHIMONRIDE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Melleupaux.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LONGSWORD, 9216, },
        { xi.item.RUSTY_BOLT,   4, },
    }

    -- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 3, { xi.item.MYTHRIL_BOLT, 27 }) -- *
        table.insert(stock, 3, { xi.item.DART,         10 }) -- *
        table.insert(stock, 4, { xi.item.FALX,      37296 })
    end

    player:showText(npc, zones[player:getZoneID()].text.MELLEUPAUX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Mazween.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_SLEEPGA,      11200 },
        { xi.item.SCROLL_OF_SLEEP_II,     18720 },
        { xi.item.SCROLL_OF_POISON_II,    25200 },
        { xi.item.SCROLL_OF_BIO_II,       14000 },
        { xi.item.SCROLL_OF_POISONGA,      5160 },
        { xi.item.SCROLL_OF_STONE_III,    19932 },
        { xi.item.SCROLL_OF_WATER_III,    22682 },
        { xi.item.SCROLL_OF_AERO_III,     27744 },
        { xi.item.SCROLL_OF_FIRE_III,     33306 },
        { xi.item.SCROLL_OF_BLIZZARD_III, 39368 },
        { xi.item.SCROLL_OF_THUNDER_III,  45930 },
        { xi.item.SCROLL_OF_ABSORB_TP,    27000 },
        { xi.item.SCROLL_OF_DRAIN_II,     30780 },
        { xi.item.SCROLL_OF_DREAD_SPIKES, 70560 },
-- { xi.item.SCROLL_OF_ASPIR_II,    79800, },
    }

    player:showText(npc, zones[player:getZoneID()].text.MAZWEEN_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Mamaroon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_STUN,        27000 },
        { xi.item.SCROLL_OF_ENFIRE,       5160 },
        { xi.item.SCROLL_OF_ENBLIZZARD,   4098 },
        { xi.item.SCROLL_OF_ENAERO,       2500 },
        { xi.item.SCROLL_OF_ENSTONE,      2030 },
        { xi.item.SCROLL_OF_ENTHUNDER,    1515 },
        { xi.item.SCROLL_OF_ENWATER,      7074 },
        { xi.item.SCROLL_OF_SHOCK_SPIKES, 9360 },
        { xi.item.WHITE_PUPPET_TURBAN,   39950 }, -- *
        { xi.item.BLACK_PUPPET_TURBAN,   39950 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.MAMAROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-----------------------------------
-- Other Vendor Overrides
-----------------------------------

m:addOverride('xi.zones.Northern_San_dOria.npcs.Pirvidiauce.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.CERAMIC_FLOWERPOT,    1050, 3, },
        { xi.item.PILE_OF_RED_GRAVEL,   2293, 3, },
        { xi.item.ASH_CLOGS,             130, 3, },
        { xi.item.HOLLY_CLOGS,          1706, 2, },
        { xi.item.CHESTNUT_SABOTS,      9547, 1, },
        { xi.item.WOODEN_ARROW,            4, 3, },
        { xi.item.CROSSBOW_BOLT,           6, 2, },
        { xi.item.FLASK_OF_EYE_DROPS,   1362, 3, }, -- *
        { xi.item.ANTIDOTE,              331, 3, },
        { xi.item.FLASK_OF_ECHO_DROPS,   840, 2, },
        { xi.item.POTION,                955, 1, },
        { xi.item.ETHER,                1658, 1, }, -- *
-- { xi.item.KINGDOM_WAYSTONE,    10500, 3, }, (Synergy)
    }

    player:showText(npc, zones[player:getZoneID()].text.PIRVIDIAUCE_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.SANDORIA)
end)

m:addOverride('xi.zones.Southern_San_dOria.npcs.Ostalie.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LEATHER_BELT,          442, 3 },
        { xi.item.LIZARD_BELT,          2808, 3 },
        { xi.item.SILVER_BELT,         11618, 1 },
        { xi.item.CIRCLET,               166, 3 },
        { xi.item.ROBE,                  249, 3 },
        { xi.item.CUFFS,                 137, 3 },
        { xi.item.SLOPS,                 199, 3 },
        { xi.item.FLASK_OF_EYE_DROPS,   1362, 3 }, -- *
        { xi.item.ANTIDOTE,              331, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,   840, 2 },
        { xi.item.POTION,                955, 1 },
        { xi.item.ETHER,                1658, 1 }, -- *
        { xi.item.PICKAXE,               210, 3 },
        { xi.item.HATCHET,               525, 3 },
    }

    -- Thief's tools.
    if GetNationRank(player:getNation()) >= 2 then -- Player nation rank 2 or 3.
        table.insert(stock, { xi.item.SET_OF_THIEFS_TOOLS, 4158, 3 })
    end

    -- Living Key.
    local sandyNationRank  = GetNationRank(xi.nation.SANDORIA)
    local bastokNationRank = GetNationRank(xi.nation.BASTOK)
    local windyNationRank  = GetNationRank(xi.nation.WINDURST)
    if
        (sandyNationRank == bastokNationRank and sandyNationRank == windyNationRank) or                       -- All 3 nations tied.
        (sandyNationRank ~= bastokNationRank and sandyNationRank ~= windyNationRank and sandyNationRank == 3) -- Nation not tied and nation last.
    then
        table.insert(stock, { xi.item.LIVING_KEY, 5520, 3 })
    end

    player:showText(npc, zones[player:getZoneID()].text.Ostalie)
    xi.shop.nation(player, stock, xi.nation.SANDORIA)
end)

m:addOverride('xi.zones.Port_San_dOria.npcs.Coullave.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LEATHER_RING,        1312, 3, },
        { xi.item.SILVER_EARRING,      1312, 2, },
        { xi.item.HACHIMAKI,            866, 2, },
        { xi.item.KENPOGI,             1307, 2, },
        { xi.item.TEKKO,                719, 2, },
        { xi.item.SITABAKI,            1040, 2, },
        { xi.item.KYAHAN,               666, 2, },
        { xi.item.BAMBOO_STICK,         151, 2, },
        { xi.item.FLASK_OF_EYE_DROPS,  1362, 3, }, -- *
        { xi.item.ANTIDOTE,             331, 3, },
        { xi.item.FLASK_OF_ECHO_DROPS,  840, 2, },
        { xi.item.POTION,               955, 1, },
        { xi.item.ETHER,               1658, 1, }, -- *
        { xi.item.GRENADE,             1264, 1, },
    }

    player:showText(npc, zones[player:getZoneID()].text.COULLAVE_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.SANDORIA)
end)

m:addOverride('xi.zones.Bastok_Markets.npcs.Olwyn.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,  1362, 3 }, -- *
        { xi.item.ANTIDOTE,             331, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,  840, 2 },
        { xi.item.POTION,               955, 2 },
        { xi.item.ETHER,               1658, 1 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.OLWYN_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Bastok_Mines.npcs.Boytz.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BRASS_FLOWERPOT,      1050, 3 },
        { xi.item.PICKAXE,               210, 3 },
        { xi.item.FLASK_OF_EYE_DROPS,   1362, 3 }, -- *
        { xi.item.ANTIDOTE,              331, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,   840, 2 },
        { xi.item.POTION,                955, 2 },
        { xi.item.ETHER,                1658, 1 }, -- *
        { xi.item.WOODEN_ARROW,            4, 2 },
        { xi.item.IRON_ARROW,              8, 3 },
        { xi.item.CROSSBOW_BOLT,           6, 3 },
-- { xi.item.REPUBLIC_WAYSTONE,   10500, 3 }, (Synergy)
    }

    -- Thief's tools.
    if GetNationRank(player:getNation()) >= 2 then -- Player nation rank 2 or 3.
        table.insert(stock, { xi.item.SET_OF_THIEFS_TOOLS, 4158, 3 })
    end

    -- Living Key.
    local sandyNationRank  = GetNationRank(xi.nation.SANDORIA)
    local bastokNationRank = GetNationRank(xi.nation.BASTOK)
    local windyNationRank  = GetNationRank(xi.nation.WINDURST)
    if
        (bastokNationRank == sandyNationRank and bastokNationRank == windyNationRank) or                        -- All 3 nations tied.
        (bastokNationRank ~= sandyNationRank and bastokNationRank ~= windyNationRank and bastokNationRank == 3) -- Nation not tied and nation last.
    then
        table.insert(stock, { xi.item.LIVING_KEY, 5520, 3 })
    end

    player:showText(npc, zones[player:getZoneID()].text.BOYTZ_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Port_Bastok.npcs.Numa.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HACHIMAKI,                 866, 2 },
        { xi.item.COTTON_HACHIMAKI,         5079, 1 },
        { xi.item.KENPOGI,                  1307, 2 },
        { xi.item.COTTON_DOGI,              7654, 1 },
        { xi.item.TEKKO,                     719, 2 },
        { xi.item.COTTON_TEKKO,             4212, 1 },
        { xi.item.SITABAKI,                 1044, 2 },
        { xi.item.COTTON_SITABAKI,          6133, 1 },
        { xi.item.KYAHAN,                    666, 2 },
        { xi.item.COTTON_KYAHAN,            3924, 1 },
        { xi.item.SILVER_OBI,               3825, 1 },
        { xi.item.BAMBOO_STICK,              151, 2 },
        { xi.item.TOOLBAG_INOSHISHINOFUDA, 17325, 3 }, -- *
        { xi.item.TOOLBAG_SHIKANOFUDA,     21000, 3 },
        { xi.item.TOOLBAG_CHONOFUDA,       21000, 3 },
        { xi.item.PICKAXE,                   210, 3 },
    }

    player:showText(npc, zones[player:getZoneID()].text.NUMA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Port_Bastok.npcs.Sawyer.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LOAF_OF_IRON_BREAD,         105, 3 },
        { xi.item.BRETZEL,                     25, 2 },
        { xi.item.LOAF_OF_PUMPERNICKEL,       166, 1 },
        { xi.item.BAKED_POPOTO,               336, 3 },
        { xi.item.SAUSAGE,                    163, 2 },
        { xi.item.BOWL_OF_PEBBLE_SOUP,        210, 3 },
        { xi.item.BOWL_OF_EGG_SOUP,          3432, 1 },
        { xi.item.FLASK_OF_DISTILLED_WATER,    12, 3 },
        { xi.item.BOTTLE_OF_MELON_JUICE,     1200, 2 }, -- *
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  624, 1 }, -- *
        { xi.item.SLICE_OF_ROAST_MUTTON,      756, 2 },
    }

    player:showText(npc, zones[player:getZoneID()].text.SAWYER_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Port_Bastok.npcs.Melloa.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LOAF_OF_IRON_BREAD,         104, 3 },
        { xi.item.BRETZEL,                     24, 2 },
        { xi.item.LOAF_OF_PUMPERNICKEL,       166, 1 },
        { xi.item.BAKED_POPOTO,               332, 3 },
        { xi.item.SAUSAGE,                    162, 2 },
        { xi.item.BOWL_OF_PEBBLE_SOUP,        208, 3 },
        { xi.item.BOWL_OF_EGG_SOUP,          3432, 1 },
        { xi.item.FLASK_OF_DISTILLED_WATER,    12, 3 },
        { xi.item.BOTTLE_OF_MELON_JUICE,     1200, 2 }, -- *
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  624, 1 }, -- *
        { xi.item.SLICE_OF_ROAST_MUTTON,      756, 2 },
    }

    player:showText(npc, zones[player:getZoneID()].text.MELLOA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Port_Bastok.npcs.Galvin.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,  1362, 3 }, -- *
        { xi.item.ANTIDOTE,             331, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,  840, 2 },
        { xi.item.POTION,               955, 2 },
        { xi.item.ETHER,               1658, 1 }, -- *
        { xi.item.WOODEN_ARROW,           4, 2 },
        { xi.item.IRON_ARROW,             8, 3 },
        { xi.item.CROSSBOW_BOLT,          6, 3 },
    }

    player:showText(npc, zones[player:getZoneID()].text.GALVIN_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Bastok_Mines.npcs.Griselda.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LOAF_OF_IRON_BREAD,         105, 3 },
        { xi.item.BRETZEL,                     25, 2 },
        { xi.item.STRIP_OF_MEAT_JERKY,        126, 3 },
        { xi.item.PICKLED_HERRING,           1497, 2 }, -- *
        { xi.item.FLASK_OF_DISTILLED_WATER,    12, 3 },
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  624, 1 }, -- *
        { xi.item.BOTTLE_OF_MELON_JUICE,     1200, 2 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.GRISELDA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Metalworks.npcs.Tomasa.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LOAF_OF_IRON_BREAD,         105, 3 },
        { xi.item.BRETZEL,                     25, 2 },
        { xi.item.SAUSAGE_ROLL,               873, 1 }, -- *
        { xi.item.BAKED_POPOTO,               336, 3 },
        { xi.item.SAUSAGE,                    163, 2 },
        { xi.item.HARD_BOILED_EGG,             83, 1 },
        { xi.item.BOWL_OF_PEBBLE_SOUP,        210, 3 },
        { xi.item.BOWL_OF_EGG_SOUP,          3432, 1 },
        { xi.item.FLASK_OF_DISTILLED_WATER,    12, 3 },
        { xi.item.BOTTLE_OF_MELON_JUICE,     1155, 2 },
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  624, 1 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.TOMASA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.zones.Windurst_Waters.npcs.Orez-Ebrez.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HEADGEAR,          2013, 3 },
        { xi.item.CIRCLET,            166, 2 },
        { xi.item.POETS_CIRCLET,     2152, 2 },
        { xi.item.HACHIMAKI,          858, 3 },
        { xi.item.COTTON_HEADBAND,   2080, 3 },
        { xi.item.BRONZE_CAP,         174, 3 },
        { xi.item.COTTON_HEADGEAR,   9274, 2 },
        { xi.item.LEATHER_BANDANA,    457, 2 },
        { xi.item.FLAX_HEADBAND,    16640, 2 },
        { xi.item.COTTON_HACHIMAKI,  5079, 2 },
        { xi.item.BRASS_CAP,         1700, 3 },
        { xi.item.WOOL_HAT,         12623, 2 },
        { xi.item.RED_CAP,          20800, 1 },
        { xi.item.SOIL_HACHIMAKI,   13927, 1 },
    }

    -- Windshear Hat sold after quest
    if player:getQuestStatus(xi.questLog.WINDURST, xi.quest.id.windurst.HAT_IN_HAND) == xi.questStatus.QUEST_COMPLETED then
        table.insert(stock, 9, { xi.item.WINDSHEAR_HAT, 780, 3 }) -- *
    end

    player:showText(npc, zones[xi.zone.WINDURST_WATERS].text.OREZEBREZ_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end)

m:addOverride('xi.zones.Windurst_Waters.npcs.Ness_Rugetomal.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.ACORN_COOKIE,               24, 3 },
        { xi.item.CINNA_COOKIE,               16, 2 },
        { xi.item.GINGER_COOKIE,              12, 1 },
        { xi.item.STRIP_OF_MEAT_JERKY,       124, 3 },
        { xi.item.CARP_SUSHI,                748, 1 },
        { xi.item.FLASK_OF_DISTILLED_WATER,   12, 3 },
        { xi.item.BOTTLE_OF_ORANGE_JUICE,    208, 2 },
        { xi.item.BOTTLE_OF_TOMATO_JUICE,    332, 1 },
        { xi.item.ROAST_PIPIRA,             2868, 3 }, -- *
        { xi.item.BOILED_CRAB,              1540, 2 }, -- *
        { xi.item.NEBIMONITE_BAKE,          1872, 1 },
    }

    player:showText(npc, zones[player:getZoneID()].text.NESSRUGETOMALL_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end)

m:addOverride('xi.zones.Windurst_Waters.npcs.Taajiji.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.TORTILLA,                        145, 3 },
        { xi.item.MUTTON_TORTILLA,                2240, 2 }, -- *
        { xi.item.DHALMEL_PIE,                    1964, 1 }, -- *
        { xi.item.BOWL_OF_PULS,                    624, 3 },
        { xi.item.PLATE_OF_MUSHROOM_RISOTTO,      5200, 1 },
        { xi.item.BOWL_OF_DHALMEL_STEW,           2698, 3 },
        { xi.item.BOWL_OF_WHITEFISH_STEW,        13710, 2 }, -- *
        { xi.item.SERVING_OF_SHALLOPS_TROPICALE, 13141, 1 },
        { xi.item.SERVING_OF_BEAUGREEN_SAUTE,     1887, 2 },
        { xi.item.FLASK_OF_DISTILLED_WATER,         12, 3 },
        { xi.item.BOTTLE_OF_ORANGE_JUICE,          208, 2 },
        { xi.item.CUP_OF_WINDURSTIAN_TEA,          260, 3 }, -- *
        { xi.item.ORANGE_KUCHEN,                  1014, 1 },
        { xi.item.DHALMEL_STEAK,                  1497, 2 },
        { xi.item.WINDURST_SALAD,                 1934, 3 },
    }

    player:showText(npc, zones[player:getZoneID()].text.TAAJIJI_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end)

m:addOverride('xi.zones.Windurst_Waters.npcs.Upih_Khachla.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.PINCH_OF_DRIED_MARJORAM,   50, 3 },
        { xi.item.CHAMOMILE,                135, 2 },
        { xi.item.WIJNRUIT,                 124, 1 },
        { xi.item.FLASK_OF_EYE_DROPS,      1362, 3 }, -- *
        { xi.item.ANTIDOTE,                 331, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,      840, 2 },
        { xi.item.POTION,                   955, 1 },
        { xi.item.ETHER,                   1658, 2 }, -- *
        { xi.item.GRENADE,                 1252, 1 },
        { xi.item.PINCH_OF_TWINKLE_POWDER,  400, 3 },
        { xi.item.ONZ_OF_DESALINATOR,      4576, 3 },
        { xi.item.ONZ_OF_SALINATOR,        4576, 3 },
        { xi.item.PICKAXE,                  210, 3 },
        { xi.item.SICKLE,                   315, 3 },
    }

    -- Thief's tools.
    if GetNationRank(player:getNation()) >= 2 then -- Player nation rank 2 or 3.
        table.insert(stock, { xi.item.SET_OF_THIEFS_TOOLS, 4158, 3 })
    end

    -- Living Key.
    local sandyNationRank  = GetNationRank(xi.nation.SANDORIA)
    local bastokNationRank = GetNationRank(xi.nation.BASTOK)
    local windyNationRank  = GetNationRank(xi.nation.WINDURST)
    if
        (windyNationRank == sandyNationRank and windyNationRank == bastokNationRank) or                       -- All 3 nations tied.
        (windyNationRank ~= sandyNationRank and windyNationRank ~= bastokNationRank and windyNationRank == 3) -- Nation not tied and nation last.
    then
        table.insert(stock, { xi.item.LIVING_KEY, 5520, 3 })
    end

    player:showText(npc, zones[player:getZoneID()].text.UPIHKHACHLA_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.WINDURST)
end)

m:addOverride('xi.zones.Windurst_Woods.npcs.Wije_Tiren.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
        { xi.item.SCROLL_OF_HERB_PASTORAL,    112 },
        { xi.item.FLASK_OF_DISTILLED_WATER,    12 },
-- { xi.item.FEDERATION_WAYSTONE,      10400 }, (Synergy)
    }

    player:showText(npc, zones[player:getZoneID()].text.WIJETIREN_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Mhaura.npcs.Pikini-Mikini.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
        { xi.item.FLASK_OF_DISTILLED_WATER,    12 },
        { xi.item.SHEET_OF_PARCHMENT,        2059 },
        { xi.item.LUGWORM,                     12 },
        { xi.item.HATCHET,                    525 },
        { xi.item.STRIP_OF_MEAT_JERKY,        124 },
        { xi.item.DISH_OF_SALSA,              153 },
-- { xi.item.MHAURA_WAYSTONE,          10500 }, (Synergy)
    }

    player:showText(npc, zones[player:getZoneID()].text.PIKINIMIKINI_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Ship_bound_for_Mhaura.npcs.Chhaya.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.CHHAYA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Ship_bound_for_Mhaura_Pirates.npcs.Chhaya.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.CHHAYA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Ship_bound_for_Selbina.npcs.Maera.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.MAERA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Ship_bound_for_Selbina_Pirates.npcs.Maera.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,        1362 }, -- *
        { xi.item.ANTIDOTE,                   331 },
        { xi.item.FLASK_OF_ECHO_DROPS,        840 },
        { xi.item.POTION,                     955 },
        { xi.item.ETHER,                     1658 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.MAERA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Stinknix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.PINCH_OF_POISON_DUST,      320 },
        { xi.item.PINCH_OF_VENOM_DUST,      1035 },
        { xi.item.PINCH_OF_PARALYSIS_DUST,  2000 },
        { xi.item.IRON_ARROW,                  8 },
        { xi.item.CROSSBOW_BOLT,               6 },
        { xi.item.GRENADE,                  1204 },
-- { xi.item.DUCHY_WAYSTONE,          10000 }, (Synergy)
    }

    player:showText(npc, zones[player:getZoneID()].text.JUNK_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Lower_Jeuno.npcs.Pawkrix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BAG_OF_HORO_FLOUR,           40 },
        { xi.item.LOAF_OF_GOBLIN_BREAD,       300 },
        { xi.item.GOBLIN_PIE,                 650 },
        { xi.item.CHUNK_OF_GOBLIN_CHOCOLATE,   35 },
        { xi.item.GOBLIN_MUSHPOT,           10140 }, -- *
        { xi.item.BAG_OF_POISON_FLOUR,        515 },
        { xi.item.GOBLIN_DOLL,                500 },
    }

    player:showText(npc, zones[player:getZoneID()].text.PAWKRIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-- Restores Antonia to pre 2016 wares
m:addOverride('xi.zones.Upper_Jeuno.npcs.Antonia.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.MYTHRIL_ROD,       6256 },
        { xi.item.OAK_CUDGEL,       11232 },
        { xi.item.MYTHRIL_MACE,     18048 },
        { xi.item.WARHAMMER,         6558 },
        { xi.item.OAK_POLE,         37440 },
        { xi.item.HALBERD,          40095 }, -- *44,550 (x.9)
        { xi.item.SCYTHE,           10596 },
        { xi.item.IRON_ARROW,           8 },
    }

    -- Bonus wares if Rank 10
    if
        player:getRank(xi.nation.BASTOK) >= 10 or
        player:getRank(xi.nation.SANDORIA) >= 10 or
        player:getRank(xi.nation.WINDURST) >= 10
    then
        table.insert(stock, 2, { xi.item.DARKSTEEL_ROD,   53122 }) -- *
        table.insert(stock, 5, { xi.item.DARKSTEEL_MACE,  62348 }) -- *
        table.insert(stock, 9, { xi.item.DARKSTEEL_LANCE, 68912 }) -- *
        table.insert(stock, 12, { xi.item.SILVER_ARROW,      20 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.JEUNO)
end)

-- Restores Coumuna to pre 2016 wares
m:addOverride('xi.zones.Upper_Jeuno.npcs.Coumuna.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.MYTHRIL_CLAWS,    29760 },
        { xi.item.KATARS,           15488 },
        { xi.item.MYTHRIL_KNIFE,    14560 },
        { xi.item.KRIS,             12096 },
        { xi.item.MYTHRIL_DEGEN,    31000 },
        { xi.item.KNIGHTS_SWORD,    55413 }, -- * 85,250 (x.65)
        { xi.item.TWO_HANDED_SWORD, 13926 },
        { xi.item.MYTHRIL_AXE,      43740 }, -- * 48,600 (x.9)
        { xi.item.GREATAXE,          4550 },
    }

    -- Bonus wares if Rank 10
    if
        player:getRank(xi.nation.BASTOK) >= 10 or
        player:getRank(xi.nation.SANDORIA) >= 10 or
        player:getRank(xi.nation.WINDURST) >= 10
    then
        table.insert(stock, 2, { xi.item.DARKSTEEL_CLAWS, 62496 }) -- *
        table.insert(stock, 5, { xi.item.DARKSTEEL_KNIFE, 59520 }) -- *
        table.insert(stock, 11, { xi.item.DARKSTEEL_AXE,  65630 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.JEUNO)
end)

m:addOverride('xi.zones.Upper_Jeuno.npcs.Deadly_Minnow.onTrigger', function(player, npc)
        local stock =
        {
            { xi.item.STUDDED_BANDANA, 14326 },
            { xi.item.SILVER_MASK,     22800 },
            { xi.item.BANDED_HELM,     47025 },
            { xi.item.STUDDED_VEST,    22800 },
            { xi.item.SILVER_MAIL,     35200 },
            { xi.item.BANDED_MAIL,     72600 },
            { xi.item.STUDDED_GLOVES,  11970 },
            { xi.item.SILVER_MITTENS,  18800 },
            { xi.item.GAUNTLETS,       25920 },
            { xi.item.MUFFLERS,        38775 },
        }

    -- Bonus wares if Rank 10
    if
        player:getRank(xi.nation.BASTOK) >= 10 or
        player:getRank(xi.nation.SANDORIA) >= 10 or
        player:getRank(xi.nation.WINDURST) >= 10
    then
        table.insert(stock, 4, { xi.item.BASCINET, 78968 }) -- *
        table.insert(stock, 12, { xi.item.DARKSTEEL_MUFFLERS, 65113 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.DURABLE_SHIELDS_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.JEUNO)
end)

m:addOverride('xi.zones.Upper_Jeuno.npcs.Khe_Chalahko.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SALLET,         31860 },
        { xi.item.BREASTPLATE,    49140 },
        { xi.item.CUISSES,        37800 },
        { xi.item.PLATE_LEGGINGS, 23760 },
        { xi.item.BREECHES,       57750 },
        { xi.item.SOLLERETS,      35475 },
    }

    -- Bonus wares if Rank 10
    if
        player:getRank(xi.nation.BASTOK) >= 10 or
        player:getRank(xi.nation.SANDORIA) >= 10 or
        player:getRank(xi.nation.WINDURST) >= 10
    then
        table.insert(stock, 6, { xi.item.DARKSTEEL_BREECHES,  96976 }) -- *
        table.insert(stock, 8, { xi.item.DARKSTEEL_SOLLERETS, 59571 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.DURABLE_SHIELDS_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.JEUNO)
end)

m:addOverride('xi.zones.Upper_Jeuno.npcs.Leillaine.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 },
        { xi.item.FLASK_OF_EYE_DROPS,       1294 }, -- *
        { xi.item.ANTIDOTE,                  316 },
        { xi.item.FLASK_OF_ECHO_DROPS,       800 },
        { xi.item.POTION,                    910 },
        { xi.item.ETHER,                    1575 }, -- *
        { xi.item.REMEDY,                   3360 },
    }
-- Bonus wares after mission 3-5
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        table.insert(stock, 6, { xi.item.POTION_P1, 1001 }) -- *
        table.insert(stock, 8, { xi.item.ETHER_P1, 1858 }) -- *
    end

    -- Bonus wares after mission 5-3
    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.FOR_WHOM_THE_VERSE_IS_SUNG then
        table.insert(stock, 7, { xi.item.HI_POTION, 2500 }) -- *
        table.insert(stock, 10, { xi.item.HI_ETHER, 4125 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.LEILLAINE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Upper_Jeuno.npcs.Glyke.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LOAF_OF_IRON_BREAD,         100 },
        { xi.item.TORTILLA,                   145 },
        { xi.item.LOAF_OF_WHITE_BREAD,        200 },
        { xi.item.BOWL_OF_PEA_SOUP,          1400 },
        { xi.item.BOWL_OF_TOMATO_SOUP,       2510 }, -- *
        { xi.item.CHEESE_SANDWICH,            820 }, -- *
        { xi.item.BOILED_CRAB,               1540 }, -- *
        { xi.item.SLICE_OF_ROAST_MUTTON,      756 },
        { xi.item.PICKLED_HERRING,           1497 }, -- *
        { xi.item.BAKED_APPLE,                540 }, -- *
        { xi.item.CHERRY_MUFFIN,              910 }, -- *
        { xi.item.WINDURST_SALAD,            1934 },
        { xi.item.SERVING_OF_HERB_QUUS,      4984 },
        { xi.item.BOTTLE_OF_ORANGE_JUICE,     200 },
        { xi.item.BOTTLE_OF_APPLE_JUICE,      410 }, -- *
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  600 }, -- *
        { xi.item.BOTTLE_OF_MELON_JUICE,     1180 }, -- *
        { xi.item.BOTTLE_OF_GRAPE_JUICE,      967 },
        { xi.item.FLASK_OF_ORANGE_AU_LAIT,    360 }, -- *
        { xi.item.FLASK_OF_APPLE_AU_LAIT,     570 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.GLYKE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Upper_Jeuno.npcs.Areebah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.CHAMOMILE,           130 },
        { xi.item.WIJNRUIT,            120 },
        { xi.item.CARNATION,            60 },
        { xi.item.RED_ROSE,             80 },
        { xi.item.RAIN_LILY,            96 },
        { xi.item.LILAC,               120 },
        { xi.item.AMARYLLIS,           120 },
        { xi.item.MARGUERITE,          120 },
-- { xi.item.BAG_OF_FLOWER_SEEDS, 520 }, (Synergy)
-- { xi.item.WATER_LILY,          630 }, Kaberno (Myoshu: Ichi)
-- { xi.item.QUEEN_OF_THE_NIGHT,  690 }, Ranka (Gekka: Ichi)
    }

    player:showText(npc, zones[player:getZoneID()].text.MP_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Kazham.npcs.Pahya_Lolohoiv.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 },
        { xi.item.FLASK_OF_EYE_DROPS,       1362 }, -- *
        { xi.item.ANTIDOTE,                  331 },
        { xi.item.FLASK_OF_ECHO_DROPS,       840 },
        { xi.item.POTION,                    955 },
        { xi.item.ETHER,                    1658 }, -- *
        { xi.item.VIAL_OF_FIEND_BLOOD,       635 },
        { xi.item.PINCH_OF_POISON_DUST,      336 },
    }

    player:showText(npc, zones[player:getZoneID()].text.PAHYALOLOHOIV_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Kazham.npcs.Nuh_Celodehki.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FISH_MITHKABOB,            3402 }, -- *
        { xi.item.BLACKENED_FROG,            3576 },
        { xi.item.ROAST_MUSHROOM,             722 }, -- *
        { xi.item.EEL_KABOB,                 3150 },
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  624 }, -- *
        { xi.item.WINDURST_SALAD,            1934 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.NUHCELODENKI_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Kazham.npcs.Ghemi_Sinterilo.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BUNCH_OF_PAMAMAS,           84 },
        { xi.item.KAZHAM_PINEAPPLE,           63 },
        { xi.item.MITHRAN_TOMATO,             42 },
        { xi.item.BUNCH_OF_KAZHAM_PEPPERS,    63 },
        { xi.item.STICK_OF_CINNAMON,         273 },
        { xi.item.KUKURU_BEAN,               126 },
        { xi.item.ELSHIMO_COCONUT,           180 },
        { xi.item.ELSHIMO_PACHIRA_FRUIT,     352 }, -- *
-- { xi.item.KAZHAM_WAYSTONE,         10500 }, (Synergy)
        { xi.item.AQUILARIA_LOG,            3284 },
    }

    player:showText(npc, zones[player:getZoneID()].text.GHEMISENTERILO_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Kazham.npcs.Khifo_Ryuhkowa.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.KUKRI,            6520 },
        { xi.item.RAM_DAO,         96050 }, -- *174,636  (x.55)
        { xi.item.BRONZE_SPEAR,      924 },
        { xi.item.SPEAR,           18522 },
        { xi.item.PARTISAN,        68972 }, -- *86,215 (x.8)
        { xi.item.CHESTNUT_CLUB,    1827 },
        { xi.item.BONE_CUDGEL,      5644 },
        { xi.item.CHESTNUT_WAND,    5997 },
        { xi.item.MAHOGANY_STAFF,  33957 },
        { xi.item.MAHOGANY_POLE,   67914 }, -- *113,190 (x.6)
        { xi.item.BATTLE_BOW,      45360 },
        { xi.item.HAWKEYE,            63 },
        { xi.item.BOOMERANG,        1837 },
        { xi.item.WOODEN_ARROW,        4 },
    }

    player:showText(npc, zones[player:getZoneID()].text.KHIFORYUHKOWA_SHOP_DIALOG)
    xi.shop.general(player, stock, xi.fameArea.WINDURST)
end)

m:addOverride('xi.zones.Rabao.npcs.Scamplix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_DISTILLED_WATER,     12 },
        { xi.item.STRIP_OF_MEAT_JERKY,         124 },
        { xi.item.LOAF_OF_GOBLIN_BREAD,        312 },
        { xi.item.CACTUS_ARM,                  832 },
-- { xi.item.RABAO_WAYSTONE,            10500 }, (Synergy)
        { xi.item.ETHER,                      1658 }, -- *
        { xi.item.THUNDERMELON,                338 },
        { xi.item.WATERMELON,                  208 },
        { xi.item.POTION,                      946 },
        { xi.item.ANTIDOTE,                    328 },
        { xi.item.FLASK_OF_BLINDNESS_POTION,  1248 },
        { xi.item.MYTHRIL_EARRING,            4680 },
        { xi.item.WATER_JUG,                   208 },
    }

    player:showText(npc, zones[player:getZoneID()].text.SCAMPLIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Khaf_Jhifanm.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_AYRAN,            400, }, -- *
        { xi.item.BALIK_SANDVICI,            2810 }, -- *
        { xi.item.BAG_OF_WILDGRASS_SEEDS,    320, },
        { xi.item.SCROLL_OF_RAPTOR_MAZURKA, 4400, },
-- { xi.item.EMPIRE_WAYSTONE,         10000, }, (Synergy)
    }

    if player:getCurrentMission(xi.mission.log_id.TOAU) >= xi.mission.id.toau.SOCIAL_GRACES then
        table.insert(stock, 1, { xi.item.DRIED_DATE,      650 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.KHAFJHIFANM_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Fayeewah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.CUP_OF_CHAI,        544, }, -- *
        { xi.item.POGACA,              41, }, -- *
    }

    if player:getCurrentMission(xi.mission.log_id.TOAU) >= xi.mission.id.toau.SOCIAL_GRACES then
        table.insert(stock, 3, { xi.item.PLATE_OF_IC_PILAV, 4600 }) -- *
    end

    if player:getQuestStatus(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.A_TASTE_OF_HONEY) == xi.questStatus.QUEST_COMPLETED then
        table.insert(stock, { xi.item.IRMIK_HELVASI, 4150 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.FAYEEWAH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Yafaaf.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.BOTTLE_OF_MULSUM,        785, }, -- *
        { xi.item.CUP_OF_IMPERIAL_COFFEE, 1800, }, -- *
    }

    if player:getCurrentMission(xi.mission.log_id.TOAU) >= xi.mission.id.toau.SOCIAL_GRACES then
        table.insert(stock, { xi.item.SIMIT, 1875 }) -- *
    end

    if player:getQuestStatus(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.ARTS_AND_CRAFTS) == xi.questStatus.QUEST_COMPLETED then
        table.insert(stock, 1, { xi.item.BOWL_OF_SUTLAC, 3000 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.YAFAAF_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Mulnith.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.ROAST_MUSHROOM, 688, }, -- *
        { xi.item.SIS_KEBABI,    3700, }, -- *
        { xi.item.BALIK_SIS,     4700, }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.MULNITH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Rubahah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.EAR_OF_MILLIONCORN,    57, }, -- *
        { xi.item.BAG_OF_IMPERIAL_FLOUR, 60, },
        { xi.item.BAG_OF_IMPERIAL_RICE,  68, },
        { xi.item.BAG_OF_COFFEE_BEANS,  948, }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.RUBAHAH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Gavrie.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_EYE_DROPS,      1294 }, -- *
        { xi.item.ANTIDOTE,                 316 },
        { xi.item.FLASK_OF_ECHO_DROPS,      800 },
        { xi.item.POTION,                   910 },
        { xi.item.ETHER,                   1575 }, -- *
        { xi.item.REMEDY,                  3360 },
        { xi.item.FLASK_OF_DISTILLED_WATER,  12 },
        { xi.item.CAN_OF_AUTOMATON_OIL,     500 }, -- *
        { xi.item.CAN_OF_AUTOMATON_OIL_P1, 1000 }, -- *
        { xi.item.CAN_OF_AUTOMATON_OIL_P2, 1500 }, -- *
        { xi.item.CAN_OF_AUTOMATON_OIL_P3, 2000 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.GAVRIE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Pipiroon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.PEBBLE,                   31, }, -- *
        { xi.item.GRENADE,                1204, },
        { xi.item.RIOT_GRENADE,           6000, },
        { xi.item.CHAKRAM,               10395, }, -- *
        { xi.item.PINCH_OF_BOMB_ASH,       515, },
        { xi.item.FLASK_OF_DISTILLED_WATER, 12, }, -- *
        { xi.item.LITTLE_WORM,               3, }, -- *
        { xi.item.CLUMP_OF_MOKO_GRASS,      20, }, -- *
        { xi.item.HATCHET,                 500, }, -- *
-- { xi.item.NASHMAU_WAYSTONE,      10000, }, (Synergy)
    }

    if player:getCurrentMission(xi.mission.log_id.TOAU) >= xi.mission.id.toau.SOCIAL_GRACES then
        table.insert(stock, 10, { xi.item.JAR_OF_REMEDY_OINTMENT, 2700 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.PIPIROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Poporoon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LEATHER_HIGHBOOTS,  336, },
        { xi.item.LIZARD_LEDELSENS,  3438, },
        { xi.item.STUDDED_BOOTS,    11172, },
        { xi.item.SOCKS,            16000, }, -- *
        { xi.item.CUIR_HIGHBOOTS,   20532, },
        { xi.item.TIGER_LEDELSENS,  65528, }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.POPOROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Chichiroon.onTrigger', function(player, npc)
    local stock =
    {
-- { xi.item.GEOMANCER_DIE,    69288, }, -- (Adoulin)
-- { xi.item.RUNE_FENCER_DIE,  73920, }, -- (Adoulin)
-- { xi.item.CASTERS_DIE,      85500, }, -- (Abyssea)
        { xi.item.BOLTERS_DIE,      99224, },
    }

    player:showText(npc, zones[player:getZoneID()].text.CHICHIROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Jajaroon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FIRE_CARD,           75, }, -- *
        { xi.item.ICE_CARD,            75, }, -- *
        { xi.item.WIND_CARD,           75, }, -- *
        { xi.item.EARTH_CARD,          75, }, -- *
        { xi.item.THUNDER_CARD,        75, }, -- *
        { xi.item.WATER_CARD,          75, }, -- *
        { xi.item.LIGHT_CARD,          75, }, -- *
        { xi.item.DARK_CARD,           75, }, -- *
        { xi.item.TRUMP_CARD,         151, }, -- *
        { xi.item.CORSAIR_DIE,        316, },
        { xi.item.NINJA_DIE,          600, },
        { xi.item.BLUE_MAGE_DIE,     3525, },
        { xi.item.DRAGOON_DIE,       9216, },
        { xi.item.SAMURAI_DIE,      35200, },
        { xi.item.SUMMONER_DIE,     40000, },
        { xi.item.PUPPETMASTER_DIE, 82500, },
    }

    player:showText(npc, zones[player:getZoneID()].text.JAJAROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Yoyoroon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.TENSION_SPRING,  9940, }, -- *
        { xi.item.LOUDSPEAKER,     9940, }, -- *
        { xi.item.ACCELERATOR,     9940, }, -- *
        { xi.item.ARMOR_PLATE,     9940, }, -- *
        { xi.item.STABILIZER,      9940, }, -- *
        { xi.item.MANA_JAMMER,     9940, }, -- *
        { xi.item.AUTO_REPAIR_KIT, 9940, }, -- *
        { xi.item.MANA_TANK,       9940, }, -- *
        { xi.item.SHOCK_ABSORBER, 14925, }, -- *
        { xi.item.VOLT_GUN,       14925, }, -- *
        { xi.item.STEALTH_SCREEN, 14925, }, -- *
        { xi.item.INHIBITOR,      19925, }, -- *
        { xi.item.MANA_BOOSTER,   19925, }, -- *
        { xi.item.SCOPE,          19925, }, -- *
        { xi.item.DAMAGE_GAUGE,   19925, }, -- *
        { xi.item.MANA_CONSERVER, 19925, }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.YOYOROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-----------------------------------
-- Outpost Vendor Overrides
-----------------------------------

m:addOverride('xi.shop.outpost', function(player, npc)
    local stock =
    {
        { xi.item.ANTIDOTE,                  316 },
        { xi.item.FLASK_OF_ECHO_DROPS,       800 },
        { xi.item.ETHER,                    1575 }, -- *
        { xi.item.FLASK_OF_EYE_DROPS,       1294 }, -- *
        { xi.item.POTION,                    910 },
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
        { xi.item.BOTTLE_OF_ORANGE_JUICE,    210 }, -- *
        { xi.item.SLICE_OF_SALTED_HARE,      150 }, -- *
        { xi.item.CHUNK_OF_SWEET_LIZARD,     150 }, -- *
        { xi.item.MUG_OF_HONEYED_EGG,        150 }, -- *
        { xi.item.PET_FOOD_ALPHA_BISCUIT,     20 }, -- *
        { xi.item.PET_FOOD_BETA_BISCUIT,     110 }, -- *
        { xi.item.PET_FOOD_GAMMA_BISCUIT,    415 }, -- *
        { xi.item.PET_FOOD_DELTA_BISCUIT,    680 }, -- *
    }
    -- Bonus wares if Rank 6 or higher
    if player:getRank(player:getNation()) >= 6 then
        table.insert(stock, 8, { xi.item.BOTTLE_OF_PINEAPPLE_JUICE, 650 }) -- *
        table.insert(stock, 10, { xi.item.STRIP_OF_MEAT_JERKY, 300 }) -- *
        table.insert(stock, 12, { xi.item.BOILED_CRAYFISH, 450 }) -- *
        table.insert(stock, 14, { xi.item.BAKED_APPLE, 560 }) -- *
        table.insert(stock, 19, { xi.item.PET_FOOD_EPSILON_BISCUIT, 1160 }) -- *
    end

    xi.shop.general(player, stock)
end)

-----------------------------------
-- WOTG Goblin Vendor Overrides
-----------------------------------

m:addOverride('xi.zones.Southern_San_dOria_[S].npcs.Geltpix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 4125 }, -- *
        { xi.item.HATCHET,                   500 },
        { xi.item.ASPHODEL,                  100 },
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { xi.item.BOWL_OF_GOBLIN_STEW,      3900 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.DONT_HURT_GELTPIX)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Bastok_Markets_[S].npcs.Blingbrix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 4125 }, -- *
        { xi.item.PICKAXE,                   200 },
        { xi.item.SICKLE,                    300 },
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { xi.item.BOWL_OF_GOBLIN_STEW,      3900 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.BLINGBRIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Windurst_Waters_[S].npcs.Pelftrix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 4125 }, -- *
        { xi.item.SICKLE,                    300 },
        { xi.item.HATCHET,                   500 },
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { xi.item.BOWL_OF_GOBLIN_STEW,      3900 }, -- *
    }

    if player:getQuestStatus(xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.HEALING_HERBS) == xi.questStatus.QUEST_COMPLETED then
        table.insert(stock, 9, { xi.item.VIAL_OF_TINCTURE, 1500 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.PELFTRIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-- TODO: Spondulix is not yet implemented.
m:addOverride('xi.zones.Fort_Karugo-Narugo_[S].npcs.Spondulix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                  2500 }, -- *
        { xi.item.HI_ETHER,                   4125 }, -- *
        { xi.item.LUMP_OF_KARUGO_NARUGO_CLAY, 3035 },
    }

    player:showText(npc, zones[player:getZoneID()].text.SPONDULIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-- Other shops that can't fit into the paradigm above

m:addOverride('xi.shop.handleValerianoShop', function(player, npc)
    local zoneTable =
    {
        [xi.zone.SOUTHERN_SAN_DORIA] = { xi.nation.SANDORIA, xi.fameArea.SANDORIA },
        [xi.zone.PORT_BASTOK       ] = { xi.nation.BASTOK,   xi.fameArea.BASTOK   },
        [xi.zone.WINDURST_WOODS    ] = { xi.nation.WINDURST, xi.fameArea.WINDURST },
    }

    local stock =
    {
        { xi.item.GINGER_COOKIE,               12 },
        { xi.item.FLUTE,                       49 },
        { xi.item.PICCOLO,                   1144 },
        { xi.item.SCROLL_OF_SCOPS_OPERETTA,   677 },
        { xi.item.SCROLL_OF_FOWL_AUBADE,     3369 },
        { xi.item.SCROLL_OF_ADVANCING_MARCH, 2379 },
    }

    if xi.settings.main.MAX_LEVEL >= 70 then
        table.insert(stock, 5, { xi.item.SCROLL_OF_PUPPETS_OPERETTA,  19552 })
    end

    if xi.settings.main.MAX_LEVEL >= 75 then
        table.insert(stock, { xi.item.SCROLL_OF_GODDESSS_HYMNUS,  104000 })
    end

    local zoneId = player:getZoneID()

    -- fail-safe in case npc didnt despawn.
    if GetNationRank(zoneTable[zoneId][1]) ~= 1 then
        --return
    end

    player:showText(npc, zones[zoneId].text.VALERIANO_SHOP_DIALOG)
    xi.shop.general(player, stock, zoneTable[zoneId][2])
end)

return m
