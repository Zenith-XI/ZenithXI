-- Disables Zones by setting IP and Port to zero.
-- SET an expansion variable to 1 to skip disabling that expansion's zones.
SET @enable_rotz = 0;
SET @enable_cop = 0;
SET @enable_toau = 0;
SET @enable_wotg = 0;
SET @enable_abyssea = 0;
SET @enable_soa = 0;
SET @enable_rov = 0;
SET @enable_tvr = 0;
SET @enable_voidwatch = 0;

-- ROTZ
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_rotz=0, '0', `zoneip`),
`zoneport` = IF(@enable_rotz=0, '0', `zoneport`)
WHERE `name` in
(
'Cape_Teriggan',
'Celestial_Nexus',
'Chamber_of_Oracles',
'Cloister_of_Flames',
'Cloister_of_Frost',
'Cloister_of_Gales',
'Cloister_of_Storms',
'Cloister_of_Tides',
'Cloister_of_Tremors',
'Den_of_Rancor',
'Dragons_Aery',
'Dynamis-Bastok',
'Dynamis-Beaucedine',
'Dynamis-Jeuno',
'Dynamis-San_dOria',
'Dynamis-Windurst',
'Dynamis-Xarcabard',
'Eastern_Altepa_Desert',
'Full_Moon_Fountain',
'Gustav_Tunnel',
'Hall_of_the_Gods',
'Ifrits_Cauldron',
'Kazham',
'Kazham-Jeuno_Airship',
'Korroloka_Tunnel',
'Kuftal_Tunnel',
'Labyrinth_of_Onzozo',
'LaLoff_Amphitheater',
'Norg',
'Quicksand_Caves',
'Rabao',
'RoMaeve',
'RuAun_Gardens',
'Sacrificial_Chamber',
'Sea_Serpent_Grotto',
'Stellar_Fulcrum',
'Temple_of_Uggalepih',
'The_Boyahda_Tree',
'The_Celestial_Nexus',
'The_Sanctuary_of_ZiTah',
'The_Shrine_of_RuAvitau',
'Valley_of_Sorrows',
'VeLugannon_Palace',
'Western_Altepa_Desert',
'Yhoator_Jungle',
'Yuhtunga_Jungle'
);

-- COP
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_cop=0, '0', `zoneip`),
`zoneport` = IF(@enable_cop=0, '0', `zoneport`)
WHERE `name` in
(
'Abdhaljs_Isle-Purgonorgo',
'AlTaieu',
'Apollyon',
'Attohwa_Chasm',
'Bearclaw_Pinnacle',
'Bibiki_Bay',
'Boneyard_Gully',
'Carpenters_Landing',
'Diorama_Abdhaljs-Ghelsba',
'Dynamis-Buburimu',
'Dynamis-Qufim',
'Dynamis-Tavnazia',
'Dynamis-Valkurm',
'Empyreal_Paradox',
'Grand_Palace_of_HuXzoi',
'Hall_of_Transference',
'Lufaise_Meadows',
'Manaclipper',
'Mine_Shaft_2716',
'Misareaux_Coast',
'Monarch_Linn',
'Newton_Movalpolos',
'Oldton_Movalpolos',
'Phanauet_Channel',
'Phomiuna_Aqueducts',
'Promyvion-Dem',
'Promyvion-Holla',
'Promyvion-Mea',
'Promyvion-Vahzl',
'PsoXja',
'Riverne-Site_A01',
'Riverne-Site_B01',
'Sacrarium',
'Sealions_Den',
'Spire_of_Dem',
'Spire_of_Holla',
'Spire_of_Mea',
'Spire_of_Vahzl',
'Tavnazian_Safehold',
'Temenos',
'The_Garden_of_RuHmet',
'The_Shrouded_Maw',
'Uleguerand_Range'
);

-- TOAU
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_toau=0, '0', `zoneip`),
`zoneport` = IF(@enable_toau=0, '0', `zoneport`)
WHERE `name` in
(
'Aht_Urhgan_Whitegate',
'Al_Zahbi',
'Alzadaal_Undersea_Ruins',
'Arrapago_Reef',
'Arrapago_Remnants',
'Aydeewa_Subterrane',
'Bhaflau_Remnants',
'Bhaflau_Thickets',
'Caedarva_Mire',
'Chocobo_Circuit',
'Halvung',
'Hazhalm_Testing_Grounds',
'Ilrusi_Atoll',
'Jade_Sepulcher',
'Lebros_Cavern',
'Leujaoam_Sanctum',
'Mamook',
'Mamool_Ja_Training_Grounds',
'Mount_Zhayolm',
'Nashmau',
'Navukgo_Execution_Chamber',
'Nyzul_Isle',
'Open_sea_route_to_Al_Zahbi',
'Open_sea_route_to_Mhaura',
'Periqia',
'Silver_Sea_Remnants',
'Silver_Sea_route_to_Al_Zahbi',
'Silver_Sea_route_to_Nashmau',
'Talacca_Cove',
'The_Ashu_Talif',
'The_Colosseum',
'Wajaom_Woodlands',
'Zhayolm_Remnants'
);

-- WOTG
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_wotg=0, '0', `zoneip`),
`zoneport` = IF(@enable_wotg=0, '0', `zoneport`)
WHERE `name` IN
(
'Bastok_Markets_[S]',
'Batallia_Downs_[S]',
'Beadeaux_[S]',
'Beaucedine_Glacier_[S]',
'Castle_Oztroja_[S]',
'Castle_Zvahl_Baileys_[S]',
'Castle_Zvahl_Keep_[S]',
'Crawlers_Nest_[S]',
'East_Ronfaure_[S]',
'Everbloom_Hollow',
'Fort_Karugo-Narugo_[S]',
'Garlaige_Citadel_[S]',
'Ghoyus_Reverie',
'Grauberg_[S]',
'Jugner_Forest_[S]',
'La_Vaule_[S]',
'Meriphataud_Mountains_[S]',
'North_Gustaberg_[S]',
'Pashhow_Marshlands_[S]',
'Rolanberry_Fields_[S]',
'Ruhotz_Silvermines',
'Sauromugue_Champaign_[S]',
'Southern_San_dOria_[S]',
'The_Eldieme_Necropolis_[S]',
'Throne_Room_[S]',
'Vunkerl_Inlet_[S]',
'Walk_of_Echoes',
'Walk_of_Echoes_[P1]',
'Walk_of_Echoes_[P2]',
'West_Sarutabaruta_[S]',
'Windurst_Waters_[S]',
'Xarcabard_[S]'
);

-- ABYSSEA
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_abyssea=0, '0', `zoneip`),
`zoneport` = IF(@enable_abyssea=0, '0', `zoneport`)
WHERE `name` IN
(
'Abyssea-Altepa',
'Abyssea-Attohwa',
'Abyssea-Empyreal_Paradox',
'Abyssea-Grauberg',
'Abyssea-Konschtat',
'Abyssea-La_Theine',
'Abyssea-Misareaux',
'Abyssea-Tahrongi',
'Abyssea-Uleguerand',
'Abyssea-Vunkerl',
'Maquette_Abdhaljs-Legion_A',
'Maquette_Abdhaljs-Legion_B'
);

-- SOA
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_soa=0, '0', `zoneip`),
`zoneport` = IF(@enable_soa=0, '0', `zoneport`)
WHERE `name` IN
(
'Ceizak_Battlegrounds',
'Celennia_Memorial_Library',
'Cirdas_Caverns',
'Cirdas_Caverns_U',
'Dho_Gates',
'Eastern_Adoulin',
'Feretory',
'Foret_de_Hennetiel',
'Kamihr_Drifts',
'Leafallia',
'Marjami_Ravine',
'Mog_Garden',
'Moh_Gates',
'Morimar_Basalt_Fields',
'Mount_Kamihr',
'Outer_RaKaznar',
'Outer_RaKaznar_[U1]',
'Outer_RaKaznar_[U2]',
'Outer_RaKaznar_[U3]',
'RaKaznar_Inner_Court',
'RaKaznar_Turris',
'Rala_Waterways',
'Rala_Waterways_U',
'Sih_Gates',
'Western_Adoulin',
'Woh_Gates',
'Yahse_Hunting_Grounds',
'Yorcia_Weald',
'Yorcia_Weald_U'
);

-- ROV
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_rov=0, '0', `zoneip`),
`zoneport` = IF(@enable_rov=0, '0', `zoneport`)
WHERE `name` IN
(
'Desuetia_Empyreal_Paradox',
'Dynamis-Bastok_[D]',
'Dynamis-Jeuno_[D]',
'Dynamis-San_dOria_[D]',
'Dynamis-Windurst_[D]',
'Escha_RuAun',
'Escha_ZiTah',
'Reisenjima',
'Reisenjima_Henge',
'Reisenjima_Sanctorium'
);

-- TVR
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_tvr=0, '0', `zoneip`),
`zoneport` = IF(@enable_tvr=0, '0', `zoneport`)
WHERE `name` IN
(
'Gwora-Corridor',
'Gwora-Throne_Room',
'Silver_Knife',
'Throne_Room_[V]'
);

-- VOIDWATCH
UPDATE `zone_settings`
SET 
`zoneip` = IF(@enable_voidwatch=0, '0', `zoneip`),
`zoneport` = IF(@enable_voidwatch=0, '0', `zoneport`)
WHERE `name` IN
(
'Provenance'
);
