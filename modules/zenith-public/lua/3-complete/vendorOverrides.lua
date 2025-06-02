-----------------------------------
-- Out of Era vendors and other shop overrides
-- Does not restore Era functionality but customizes offerings
-- Public module for ZenitXI
-- Items with an * have had their default prices changed
-----------------------------------
local m = Module:new('ooe_vendors')

-----------------------------------
-- Scroll Vendor Overrides
-----------------------------------

-----------------------------------
-- Restores Taza as a scroll vendor
-- Area: Lower Jeuno
-----------------------------------
xi.module.ensureTable('xi.zones.Lower_Jeuno.npcs.Taza')

zxi.npcHelpers.removeDefaultHandler(xi.zone.LOWER_JEUNO, 'Taza')

m:addOverride('xi.zones.Lower_Jeuno.npcs.Taza.onTrigger', function(player, npc)
    local stock = {
        { xi.item.SCROLL_OF_SLEEP_II,      18720 },
        { xi.item.SCROLL_OF_SLEEPGA,       11200 },
        { xi.item.SCROLL_OF_STONE_III,     19932 },
        { xi.item.SCROLL_OF_WATER_III,     22682 },
        { xi.item.SCROLL_OF_AERO_III,      27744 },
        { xi.item.SCROLL_OF_FIRE_III,      33306 },
        { xi.item.SCROLL_OF_BLIZZARD_III,  39368 },
        { xi.item.SCROLL_OF_THUNDER_III,   45930 },
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
    }

    player:showText(npc, zones[player:getZoneID()].text.WAAG_DEEG_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-----------------------------------
-- Stock overrides
-----------------------------------
m:addOverride('xi.zones.Bastok_Markets.npcs.Hortense.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_FOE_REQUIEM,         74, 3, },
        { xi.item.SCROLL_OF_FOE_REQUIEM_II,     509, 3, },
        { xi.item.SCROLL_OF_FOE_REQUIEM_III,   4576, 3, },
        { xi.item.SCROLL_OF_FOE_REQUIEM_IV,    7987, 3, },
        { xi.item.SCROLL_OF_ARMYS_PAEON,         43, 3, },
        { xi.item.SCROLL_OF_ARMYS_PAEON_II,     371, 3, },
        { xi.item.SCROLL_OF_ARMYS_PAEON_III,   3744, 3, },
        { xi.item.SCROLL_OF_ARMYS_PAEON_IV,    6864, 3, },
        { xi.item.SCROLL_OF_VALOR_MINUET,        24, 3, },
        { xi.item.SCROLL_OF_VALOR_MINUET_II,   1272, 3, },
        { xi.item.SCROLL_OF_VALOR_MINUET_III,  6406, 3, },
    }

    player:showText(npc, zones[player:getZoneID()].text.HORTENSE_SHOP_DIALOG)
    xi.shop.nation(player, stock, xi.nation.BASTOK)
end)

m:addOverride('xi.shop.handleValerianoShop', function(player, npc)
    local zoneTable =
    {
        [xi.zone.SOUTHERN_SAN_DORIA] = { xi.nation.SANDORIA, xi.fameArea.SANDORIA },
        [xi.zone.PORT_BASTOK       ] = { xi.nation.BASTOK,   xi.fameArea.BASTOK   },
        [xi.zone.WINDURST_WOODS    ] = { xi.nation.WINDURST, xi.fameArea.WINDURST },
    }
    local stock =
    {
        { xi.item.GINGER_COOKIE,                  12 },
        { xi.item.FLUTE,                          49 },
        { xi.item.PICCOLO,                      1144 },
        { xi.item.SCROLL_OF_SCOPS_OPERETTA,      677 },
        { xi.item.SCROLL_OF_PUPPETS_OPERETTA,  19552 },
        { xi.item.SCROLL_OF_FOWL_AUBADE,        3369 },
        { xi.item.SCROLL_OF_ADVANCING_MARCH,    2379 },
        { xi.item.SCROLL_OF_GODDESSS_HYMNUS,  104000 },
    }

    local zoneId = player:getZoneID()

    -- fail-safe in case npc didnt despawn.
    if GetNationRank(zoneTable[zoneId][1]) ~= 1 then
        return
    end

    player:showText(npc, zones[zoneId].text.VALERIANO_SHOP_DIALOG)
    xi.shop.general(player, stock, zoneTable[zoneId][2])
end)

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
        { xi.item.SCROLL_OF_CURAGA_III,     19932 },
        { xi.item.SCROLL_OF_PROTECT_III,    32000 },
        { xi.item.SCROLL_OF_PROTECTRA_II,    7074 },
        { xi.item.SCROLL_OF_PROTECTRA_III,  19200 },
        { xi.item.SCROLL_OF_SHELL_III,      26244 },
        { xi.item.SCROLL_OF_SHELLRA,         1760 },
        { xi.item.SCROLL_OF_SHELLRA_II,     14080 },
        { xi.item.SCROLL_OF_SHELLRA_III,    26244 },
-- { xi.item.SCROLL_OF_INUNDATION,     73500 },
        { xi.item.SCROLL_OF_ADDLE,         130378 },
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
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,     770 }, -- *
        { xi.item.SERVING_OF_ICECAP_ROLANBERRY, 5544 },
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
        { xi.item.BOX_OF_STICKY_RICE,       331 },
        { xi.item.ONZ_OF_CURRY_POWDER,     1039 },
        { xi.item.JAR_OF_GROUND_WASABI,    2724 },
        { xi.item.BOTTLE_OF_RICE_VINEGAR,   210 },
        { xi.item.BUNDLE_OF_SHIRATAKI,      516 },
        { xi.item.BAG_OF_BUCKWHEAT_FLOUR,  5250 },
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
        { xi.item.SCROLL_OF_FLURRY,     34320 },
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
-- { xi.item.SELBINA_WAYSTONE,         10500 },
    }

    player:showText(npc, zones[player:getZoneID()].text.DOHDJUMA_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Mhaura.npcs.Tya_Padolih.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.SCROLL_OF_SLEEPGA,    11648 },
        { xi.item.SCROLL_OF_DISTRACT,   20384 },
        { xi.item.SCROLL_OF_FRAZZLE,    28304 },
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
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Norg.npcs.Solby-Maholby.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.LUGWORM,                     12 },
        { xi.item.EARTH_SPIRIT_PACT,          500 },
-- { xi.item.NORG_WAYSTONE,            10500 },
        { xi.item.SCROLL_OF_KATON_SAN,     125212 },
        { xi.item.SCROLL_OF_HYOTON_SAN,    125212 },
        { xi.item.SCROLL_OF_HUTON_SAN,     125212 },
        { xi.item.SCROLL_OF_DOTON_SAN,     125212 },
        { xi.item.SCROLL_OF_RAITON_SAN,    125212 },
        { xi.item.SCROLL_OF_SUITON_SAN,    125212 },
        { xi.item.SCROLL_OF_GEKKA_ICHI,    163705 },
        { xi.item.SCROLL_OF_YAIN_ICHI,     163705 },
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
        { xi.item.SCROLL_OF_RERAISE_III,  624000 },
        { xi.item.SCROLL_OF_BANISH_III,    89440 },
        { xi.item.SCROLL_OF_CURA,          22713 },
        { xi.item.SCROLL_OF_SACRIFICE,     70304 },
        { xi.item.SCROLL_OF_ESUNA,         73008 },
        { xi.item.SCROLL_OF_AUSPICE,       35006 },
        { xi.item.SCROLL_OF_CRUSADE,      163705 },
    }

    player:showText(npc, zones[player:getZoneID()].text.BRAVEOX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Nilerouche.onTrigger', function(player, npc)
    local stock =
    {
        { 17005,   108, }, -- Lufaise Fly
        { 17383,  2640, }, -- Clothespole
        { 688,      20, }, -- Arrowwood Log
        { 690,    7800, }, -- Elm Log
-- { 2871,  10000, }, -- Safehold Waystone
    }

    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        stock =
        {
            { 17005,   108, }, -- Lufaise Fly
            { 17383,  2640, }, -- Clothespole
            { 688,      20, }, -- Arrowwood Log
            { 690,    7800, }, -- Elm Log
            { 4638,  66000, }, -- Banish III
-- { 2871,  10000, }, -- Safehold Waystone
        }
    end

    player:showText(npc, zones[player:getZoneID()].text.NILEROUCHE_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Tavnazian_Safehold.npcs.Mazuro-Oozuro.onTrigger', function(player, npc)
    local stock =
    {
        { 17005,   108, }, -- Lufaise Fly
        { 17383,  2640, }, -- Clothespole
        { 688,      20, }, -- Arrowwood Log
        { 690,    7800, }, -- Elm Log
-- { 2871,  10000, }, -- Safehold Waystone
    }

    if player:getCurrentMission(xi.mission.log_id.COP) >= xi.mission.id.cop.SHELTERING_DOUBT then
        stock =
        {
            { 17005,   108, }, -- Lufaise Fly
            { 17383,  2640, }, -- Clothespole
            { 688,      20, }, -- Arrowwood Log
            { 690,    7800, }, -- Elm Log
            { 4638,  66000, }, -- Banish III
-- { 2871,  10000, }, -- Safehold Waystone
        }
    end

    player:showText(npc, zones[player:getZoneID()].text.MAZUROOOZURO_SHOP_DIALOG)
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
        { 4883,                           27000 }, -- Absorb-TP
        { 4854,                           30780 }, -- Drain II
        { 4885,                           70560 }, -- Dread Spikes
-- { 4856, 79800, }, -- Aspir II
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
        { 2502,                          39950 }, -- *White Puppet Turban
        { 2501,                          39950 }, -- *Black Puppet Turban
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
-- { xi.item.KINGDOM_WAYSTONE,    10500, 3, },
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
        { xi.item.ANTIDOTE,              328, 3 },
        { xi.item.FLASK_OF_ECHO_DROPS,   832, 2 },
        { xi.item.POTION,                946, 1 },
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
-- { xi.item.REPUBLIC_WAYSTONE,   10500, 3 },
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
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  770, 1 }, -- *
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
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  770, 1 }, -- *
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
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  770, 1 }, -- *
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
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  770, 1 }, -- *
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
        { xi.item.BOILED_CRAB,              2340, 2 },
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
-- { xi.item.FEDERATION_WAYSTONE,      10400 },
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
-- { xi.item.MHAURA_WAYSTONE,          10500 },
    }

    player:showText(npc, zones[player:getZoneID()].text.PIKINIMIKINI_SHOP_DIALOG)
    xi.shop.general(player, stock)
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
        { xi.item.ETHER,                     1658 },
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
-- { xi.item.DUCHY_WAYSTONE,          10000 },
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
        { xi.item.HALBERD,          44550 },
        { xi.item.SCYTHE,           10596 },
        { xi.item.IRON_ARROW,           8 },
    }

    player:showText(npc, zones[player:getZoneID()].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock)
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
        { xi.item.KNIGHTS_SWORD,    85250 },
        { xi.item.TWO_HANDED_SWORD, 13926 },
        { xi.item.MYTHRIL_AXE,      48600 },
        { xi.item.GREATAXE,          4550 },
    }

    player:showText(npc, zones[player:getZoneID()].text.VIETTES_SHOP_DIALOG)
    xi.shop.general(player, stock)
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
        { 4420,                              2510 }, -- *Tomato Soup
        { 5686,                               900 }, -- *Cheese Sandwich
        { xi.item.BOILED_CRAB,               2340 },
        { xi.item.SLICE_OF_ROAST_MUTTON,      756 },
        { xi.item.PICKLED_HERRING,           1497 }, -- *
        { xi.item.BAKED_APPLE,                640 }, -- *
        { 5653,                               910 }, -- *Cherry Muffin
        { xi.item.WINDURST_SALAD,            1934 },
        { xi.item.SERVING_OF_HERB_QUUS,      4984 },
        { xi.item.BOTTLE_OF_ORANGE_JUICE,     200 },
        { xi.item.BOTTLE_OF_APPLE_JUICE,      410 }, -- *
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  750 }, -- *
        { xi.item.BOTTLE_OF_MELON_JUICE,     1180 }, -- *
        { xi.item.BOTTLE_OF_GRAPE_JUICE,      967 },
        { xi.item.FLASK_OF_ORANGE_AU_LAIT,    360 }, -- *
        { xi.item.FLASK_OF_APPLE_AU_LAIT,     570 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.GLYKE_SHOP_DIALOG)
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
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Kazham.npcs.Nuh_Celodehki.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FISH_MITHKABOB,            3402 }, -- *
        { xi.item.BLACKENED_FROG,            3576 },
        { xi.item.ROAST_MUSHROOM,             722 }, -- *
        { xi.item.EEL_KABOB,                 3150 },
        { xi.item.BOTTLE_OF_PINEAPPLE_JUICE,  770 }, -- *
        { xi.item.WINDURST_SALAD,            1934 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.NUHCELODENKI_SHOP_DIALOG)
    xi.shop.general(player, stock)
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
-- { xi.item.KAZHAM_WAYSTONE,         10500 },
        { xi.item.AQUILARIA_LOG,            3284 },
    }

    player:showText(npc, zones[player:getZoneID()].text.GHEMISENTERILO_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Rabao.npcs.Scamplix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FLASK_OF_DISTILLED_WATER,     12 },
        { xi.item.STRIP_OF_MEAT_JERKY,         124 },
        { xi.item.LOAF_OF_GOBLIN_BREAD,        312 },
        { xi.item.CACTUS_ARM,                  832 },
-- { xi.item.RABAO_WAYSTONE,            10500 },
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
        { 5567,                           650, }, -- *Dried Date
        { 5576,                           400, }, -- *Ayran
        { 5590,                          2810, }, -- *Balik Sandvici
        { xi.item.BAG_OF_WILDGRASS_SEEDS, 320, },
        { 5075,                          4400, }, -- Scroll of Raptor Mazurka
-- { 2872,                         10000, }, -- Empire Waystone
    }

    player:showText(npc, zones[player:getZoneID()].text.KHAFJHIFANM_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Fayeewah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.CUP_OF_CHAI,             544, }, -- *
        { 5637,                             41, }, -- Pogaca*
        { 5584,                           3500, }, -- Ic Pilav*
    }

    if player:getQuestStatus(xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.A_TASTE_OF_HONEY) == xi.questStatus.QUEST_COMPLETED then
        table.insert(stock, 4, { xi.item.IRMIK_HELVASI, 4150 }) -- *
    end

    player:showText(npc, zones[player:getZoneID()].text.FAYEEWAH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Yafaaf.onTrigger', function(player, npc)
    local stock =
    {
        { 5596,                           1875, }, -- *Simit
        { xi.item.CUP_OF_IMPERIAL_COFFEE, 1350, }, -- Imperial Coffee
        { xi.item.BOTTLE_OF_MULSUM,        785, }, -- *
    }

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
        { 5598,                  3700, }, -- *Sis Kebabi (Requires Astral Candescence)
        { 5600,                  4700, }, -- *Balik Sis (Requires Astral Candescence)
    }

    player:showText(npc, zones[player:getZoneID()].text.MULNITH_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Rubahah.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.EAR_OF_MILLIONCORN, 57, }, -- *
        { 2237,                       60, }, -- Imperial Flour (Requires Astral Candescence)
        { 2214,                       68, }, -- Imperial Rice (Requires Astral Candescence)
        { 2271,                      948, }, -- *Coffee Beans (Requires Astral Candescence)
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
        { 5356,                           2700, }, -- *Remedy Ointment
-- { 2873,                    10000, }, -- Nashmau Waystone
    }

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
        { 12958,                    95800, }, -- *Tiger Ledelsens
    }

    player:showText(npc, zones[player:getZoneID()].text.POPOROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Chichiroon.onTrigger', function(player, npc)
    local stock =
    {
-- { 6368,  69288, }, -- Geomancer Die (SOA)
-- { 6369,  73920, }, -- Rune Fencer Die (SOA)
        { 5498,  85500, }, -- Caster's Die
        { 5497,  99224, }, -- Bolter's Die
    }

    player:showText(npc, zones[player:getZoneID()].text.CHICHIROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Jajaroon.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.FIRE_CARD,    75, }, -- *
        { xi.item.ICE_CARD,     75, }, -- *
        { xi.item.WIND_CARD,    75, }, -- *
        { xi.item.EARTH_CARD,   75, }, -- *
        { xi.item.THUNDER_CARD, 75, }, -- *
        { xi.item.WATER_CARD,   75, }, -- *
        { xi.item.LIGHT_CARD,   75, }, -- *
        { xi.item.DARK_CARD,    75, }, -- *
        { xi.item.TRUMP_CARD,  151, }, -- *
        { 5493,                316, }, -- Corsair Die
        { 5489,                600, }, -- Ninja Die
        { 5492,               3525, }, -- Blue Mage Die
        { 5490,               9216, }, -- Dragoon Die
        { 5488,              35200, }, -- Samurai Die
        { 5491,              40000, }, -- Summoner Die
        { 5494,              82500, }, -- Puppetmaster Die
    }

    player:showText(npc, zones[player:getZoneID()].text.JAJAROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Nashmau.npcs.Yoyoroon.onTrigger', function(player, npc)
    local stock =
    {
        { 2239,  9940, }, -- *Tension Spring
        { 2243,  9940, }, -- *Loudspeaker
        { 2246,  9940, }, -- *Accelerator
        { 2251,  9940, }, -- *Armor Plate
        { 2254,  9940, }, -- *Stabilizer
        { 2258,  9940, }, -- *Mana Jammer
        { 2262,  9940, }, -- *Auto-Repair Kit
        { 2266,  9940, }, -- *Mana Tank
        { 2250, 14925, }, -- *Shock Absorber
        { 2255, 14925, }, -- *Volt Gun
        { 2260, 14925, }, -- *Stealth Screen
        { 2240, 19925, }, -- *Inhibitor
        { 2242, 19925, }, -- *Mana Booster
        { 2247, 19925, }, -- *Scope
        { 2264, 19925, }, -- *Damage Gauge
        { 2268, 19925, }, -- *Mana Conserver
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
        { xi.item.BOTTLE_OF_ORANGE_JUICE,    215 }, -- *
        { 5737,                              200 }, -- *Salted Hare
        { 5738,                              200 }, -- *Sweet Lizard
        { 5739,                              200 }, -- *Honeyed Egg
        { xi.item.PET_FOOD_ALPHA_BISCUIT,     20 }, -- *
        { xi.item.PET_FOOD_BETA_BISCUIT,     110 }, -- *
        { xi.item.PET_FOOD_GAMMA_BISCUIT,    415 }, -- *
        { xi.item.PET_FOOD_DELTA_BISCUIT,    680 }, -- *
        { xi.item.PET_FOOD_EPSILON_BISCUIT, 1160 }, -- *
    }

    xi.shop.general(player, stock)
end)

-----------------------------------
-- WOTG Goblin Vendor Overrides
-----------------------------------

m:addOverride('xi.zones.Southern_San_dOria_[S].npcs.Geltpix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 5025 }, -- *
        { xi.item.HATCHET,                   500 },
        { xi.item.ASPHODEL,                  100 },
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { 4465,                             3900 }, -- *Goblin Stew
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.DONT_HURT_GELTPIX)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Bastok_Markets_[S].npcs.Blingbrix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 5025 }, -- *
        { xi.item.PICKAXE,                   200 },
        { xi.item.SICKLE,                    300 },
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { 4465,                             3900 }, -- *Goblin Stew
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.BLINGBRIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Windurst_Waters_[S].npcs.Pelftrix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,                2500 }, -- *
        { xi.item.HI_ETHER,                 5025 }, -- *
        { xi.item.SICKLE,                    300 },
        { xi.item.HATCHET,                   500 },
        { xi.item.BAG_OF_HORO_FLOUR,          40 }, -- *
        { xi.item.LOAF_OF_GOBLIN_BREAD,      300 }, -- *
        { 4465,                             3900 }, -- *Goblin Stew
        { xi.item.FLASK_OF_DISTILLED_WATER,   12 }, -- *
    }

    player:showText(npc, zones[player:getZoneID()].text.PELFTRIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

m:addOverride('xi.zones.Fort_Karugo_[S].npcs.Spondulix.onTrigger', function(player, npc)
    local stock =
    {
        { xi.item.HI_POTION,            2500 }, -- *
        { xi.item.HI_ETHER,             5025 }, -- *
        { 2563,                         3035 }, -- Karugo Clay
    }

    player:showText(npc, zones[player:getZoneID()].text.SPONDULIX_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

-- TODO: Dibstix is not yet implemented.

-- TODO: Lollyspox is not yet implemented.

return m
