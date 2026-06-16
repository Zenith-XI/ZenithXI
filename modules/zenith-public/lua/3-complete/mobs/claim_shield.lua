-----------------------------------
-- Claim Shield v2.0
-- Redesigned based on MowFord's PR #112 feedback
-- Uses ENGAGE listener + Dynamic Entity pattern
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c-m_claim_shield')

-----------------------------------
-- Configuration
-----------------------------------
local claimshieldTime       = 15000  -- Duration of claimshield window (ms)
local engageWindowSeconds   = 30    -- Time after spawn where engage triggers claimshield
local claimRecoveryDelay    = 2000  -- Safety timer to re-award claim (ms)
local dynamicEntityTP       = 3000  -- Starting TP for dynamic entity

-----------------------------------
-- NMs to shield, keyed by zone ID enum
-- Format: [xi.zone.ZONE_NAME] = { 'Mob_Name', ... }
-----------------------------------
local nmsToShield =
{
    [xi.zone.ABYSSEA_ATTOHWA] =
    {
        'Tunga',
    },
    [xi.zone.ABYSSEA_KONSCHTAT] =
    {
        'Bakka',
        'Balaur',
        'Fistule',
        'Turul',
    },
    [xi.zone.ABYSSEA_LA_THEINE] =
    {
        'Piasa',
    },
    [xi.zone.ABYSSEA_MISAREAUX] =
    {
        'Athamas',
    },
    [xi.zone.ABYSSEA_TAHRONGI] =
    {
        'Iratham',
        'Manananggal',
    },
    [xi.zone.ABYSSEA_VUNKERL] =
    {
        'Div-e_Sepid',
        'Sippoy',
    },
    [xi.zone.ALZADAAL_UNDERSEA_RUINS] =
    {
        'Boompadu',
        'Cookieduster_Lipiroon',
        'Oupire',
    },
    [xi.zone.ARRAPAGO_REEF] =
    {
        'Bloody_Bones',
        'Euryale',
        'Lamie_No9',
        'Medusa',
    },
    [xi.zone.ATTOHWA_CHASM] =
    {
        'Ambusher_Antlion',
        'Citipati',
        'Sargas',
        'Sekhmet',
        'Tiamat',
        'Xolotl',
    },
    [xi.zone.AYDEEWA_SUBTERRANE] =
    {
        'Bluestreak_Gyugyuroon',
        'Lizardtrap',
    },
    [xi.zone.BATALLIA_DOWNS] =
    {
        'Ahtu',
        'Eyegouger',
        'Prankster_Maverix',
        'Skirling_Liger',
        'Tottering_Toby',
    },
    [xi.zone.BATALLIA_DOWNS_S] =
    {
        'Burlibix_Brawnback',
        'Chaneque',
        'Habergoass',
        'La_Velue',
    },
    [xi.zone.BEADEAUX] =
    {
        'BiGho_Headtaker',
        'DaDha_Hundredmask',
        'GaBhu_Unvanquished',
        'GeDha_Evileye',
        'ZoKhu_Blackcloud',
    },
    [xi.zone.BEADEAUX_S] =
    {
        'BaTho_Mercifulheart',
        'DaDha_Hundredmask',
        'EaTho_Cruelheart',
        'Observant_Zekka',
    },
    [xi.zone.BEAUCEDINE_GLACIER] =
    {
        'Calcabrina',
        'Gargantua',
        'Humbaba',
        'Kirata',
        'Nue',
    },
    [xi.zone.BEAUCEDINE_GLACIER_S] =
    {
        'Becut',
        'Came-cruse',
        'GrandGoule',
        'Scylla',
    },
    [xi.zone.BHAFLAU_THICKETS] =
    {
        'Emergent_Elm',
        'Harvestman',
        'Mahishasura',
        'Nis_Puk',
    },
    [xi.zone.BIBIKI_BAY] =
    {
        'Intulo',
        'Serra',
        'Shankha',
        'Splacknuck',
    },
    [xi.zone.BOSTAUNIEUX_OUBLIETTE] =
    {
        'Arioch',
        'Bloodsucker',
        'Drexerion_the_Condemned',
        'Manes',
        'Phanduron_the_Condemned',
        'Sewer_Syrup',
        'Shii',
    },
    [xi.zone.BUBURIMU_PENINSULA] =
    {
        'Backoo',
        'Buburimboo',
        'Helldiver',
        'Wake_Warder_Wanda',
    },
    [xi.zone.CAEDARVA_MIRE] =
    {
        'Khimaira',
        'Peallaidh',
        'Zikko',
    },
    [xi.zone.CAPE_TERIGGAN] =
    {
        'Frostmane',
        'Killer_Jonny',
        'Kreutzet',
        'Zmey_Gorynych',
    },
    [xi.zone.CARPENTERS_LANDING] =
    {
        'Orctrap',
        'Tempest_Tigon',
    },
    [xi.zone.CASTLE_OZTROJA] =
    {
        'Lii_Jixa_the_Somnolist',
        'Mee_Deggi_the_Punisher',
        'Moo_Ouzi_the_Swiftblade',
        'Quu_Domi_the_Gallant',
        'Saa_Doyi_the_Fervid',
        'Tzee_Xicu_the_Manifest',
        'Yaa_Haqa_the_Profane',
        'Yagudo_Avatar',
        'Yagudo_High_Priest',
        'Yagudo_Templar',
    },
    [xi.zone.CASTLE_OZTROJA_S] =
    {
        'Aa_Xalmo_the_Savage',
        'Asterion',
        'Dee_Zelko_the_Esoteric',
        'Duu_Masa_the_Onecut',
        'Fleshgnasher',
        'Loo_Kutto_the_Pensive',
        'Maa_Illmu_the_Bestower',
        'Marquis_Forneus',
        'Suu_Xicu_the_Cantabile',
        'Vee_Ladu_the_Titterer',
        'Zhuu_Buxu_the_Silent',
    },
    [xi.zone.CASTLE_ZVAHL_BAILEYS] =
    {
        'Duke_Haborym',
        'Grand_Duke_Batym',
        'Likho',
        'Marquis_Allocen',
        'Marquis_Amon',
        'Marquis_Naberius',
        'Marquis_Sabnock',
    },
    [xi.zone.CASTLE_ZVAHL_KEEP] =
    {
        'Baronet_Romwe',
        'Baron_Vapula',
        'Count_Bifrons',
        'Viscount_Morax',
    },
    [xi.zone.CRAWLERS_NEST] =
    {
        'Aqrabuamelu',
        'Demonic_Tiphia',
        'Dynast_Beetle',
    },
    [xi.zone.CRAWLERS_NEST_S] =
    {
        'Morille_Mortelle',
    },
    [xi.zone.DANGRUF_WADI] =
    {
        'Geyser_Lizard',
        'Teporingo',
    },
    [xi.zone.DAVOI] =
    {
        'Blubbery_Bulge',
        'Hawkeyed_Dnatbat',
        'One-eyed_Gwajboj',
        'Poisonhand_Gnadgad',
        'Steelbiter_Gudrud',
        'Tigerbane_Bakdak',
    },
    [xi.zone.DEN_OF_RANCOR] =
    {
        'Bistre-hearted_Malberry',
        'Carmine-tailed_Janberry',
        'Celeste-eyed_Tozberry',
        'Friar_Rush',
        'Ogama',
        'Sozu_Bliberry',
        'Tawny-fingered_Mugberry',
        'Tonberry_Decapitator',
        'Tonberry_Pontifex',
        'Tonberry_Tracker',
    },
    [xi.zone.DYNAMIS_BASTOK] =
    {
        'GiPha_Manameister',
        'GuNhi_Noondozer',
        'KoDho_Cannonball',
        'ZeVho_Fallsplitter',
    },
    [xi.zone.DYNAMIS_BEAUCEDINE] =
    {
        'Ascetox_Ratgums',
        'BeZhe_Keeprazer',
        'Bhuu_Wjato_the_Firepool',
        'Bordox_Kittyback',
        'Brewnix_Bittypupils',
        'Caa_Xaza_the_Madpiercer',
        'Cobraclaw_Buchzvotch',
        'Deathcaller_Bidfbid',
        'DeBho_Pyrohand',
        'Drakefeast_Wubmfub',
        'Draklix_Scalecrust',
        'Droprix_Granitepalms',
        'Elvaanlopper_Grokdok',
        'Foo_Peku_the_Bloodcloak',
        'GaFho_Venomtouch',
        'Galkarider_Retzpratz',
        'Gibberox_Pimplebeak',
        'GoTyo_Magenapper',
        'GuKhu_Dukesniper',
        'GuNha_Wallstormer',
        'Guu_Waji_the_Preacher',
        'Heavymail_Djidzbad',
        'Hee_Mida_the_Meticulous',
        'Humegutter_Adzjbadj',
        'Jeunoraider_Gepkzip',
        'JiFhu_Infiltrator',
        'JiKhu_Towercleaver',
        'Knii_Hoqo_the_Bisector',
        'Koo_Saxu_the_Everfast',
        'Kuu_Xuka_the_Nimble',
        'Lockbuster_Zapdjipp',
        'Maa_Zaua_the_Wyrmkeeper',
        'MiRhe_Whisperblade',
        'Mithraslaver_Debhabob',
        'Moltenox_Stubthumbs',
        'Morblox_Chubbychin',
        'MuGha_Legionkiller',
        'NaHya_Floodmaker',
        'Nee_Huxa_the_Judgmental',
        'NuBhi_Spiraleye',
        'Puu_Timu_the_Phantasmal',
        'Routsix_Rubbertendon',
        'Ruffbix_Jumbolobes',
        'Ryy_Qihi_the_Idolrobber',
        'Shisox_Widebrow',
        'Skinmask_Ugghfogg',
        'Slinkix_Trufflesniff',
        'SoGho_Adderhandler',
        'Soo_Jopo_the_Fiendking',
        'SoZho_Metalbender',
        'Spinalsucker_Galflmall',
        'Swypestix_Tigershins',
        'TaHyu_Gallanthunter',
        'Taruroaster_Biggsjig',
        'Tocktix_Thinlids',
        'Ultrasonic_Zeknajak',
        'Whistrix_Toadthroat',
        'Wraithdancer_Gidbnod',
        'Xaa_Chau_the_Roctalon',
        'Xhoo_Fuza_the_Sublime',
    },
    [xi.zone.DYNAMIS_BUBURIMU] =
    {
        'Baa_Dava_the_Bibliophage',
        'Doo_Peku_the_Fleetfoot',
        'Elvaansticker_Bxafraff',
        'Flamecaller_Zoeqdoq',
        'GiBhe_Fleshfeaster',
        'Gosspix_Blabberlips',
        'Hamfist_Gukhbuk',
        'Koo_Rahi_the_Levinblade',
        'Lyncean_Juwgneg',
        'QuPho_Bloodspiller',
        'Ree_Nata_the_Melomanic',
        'Shamblix_Rottenheart',
        'TeZha_Ironclad',
        'VaRhu_Bodysnatcher',
        'Woodnix_Shrillwhistle',
    },
    [xi.zone.DYNAMIS_JEUNO] =
    {
        'Anvilix_Sootwrists',
        'Bandrix_Rockjaw',
        'Blazox_Boneybod',
        'Bootrix_Jaggedelbow',
        'Buffrix_Eargone',
        'Cloktix_Longnail',
        'Distilix_Stickytoes',
        'Elixmix_Hooknose',
        'Eremix_Snottynostril',
        'Gabblox_Magpietongue',
        'Hermitrix_Toothrot',
        'Humnox_Drumbelly',
        'Jabbrox_Grannyguise',
        'Jabkix_Pigeonpecs',
        'Karashix_Swollenskull',
        'Kikklix_Longlegs',
        'Lurklox_Dhalmelneck',
        'Mobpix_Mucousmouth',
        'Morgmox_Moldnoggin',
        'Mortilox_Wartpaws',
        'Prowlox_Barrelbelly',
        'Rutrix_Hamgams',
        'Scruffix_Shaggychest',
        'Slystix_Megapeepers',
        'Smeltix_Thickhide',
        'Snypestix_Eaglebeak',
        'Sparkspox_Sweatbrow',
        'Ticktox_Beadyeyes',
        'Trailblix_Goatmug',
        'Tufflix_Loglimbs',
        'Tymexox_Ninefingers',
        'Wasabix_Callusdigit',
        'Wyrmwix_Snakespecs',
    },
    [xi.zone.DYNAMIS_SAN_DORIA] =
    {
        'Reapertongue_Gadgquok',
        'Voidstreaker_Butchnotch',
        'Wyrmgnasher_Bjakdek',
    },
    [xi.zone.DYNAMIS_VALKURM] =
    {
        'Fairy_Ring',
        'Nantina',
        'Stcemqestcint',
    },
    [xi.zone.DYNAMIS_WINDURST] =
    {
        'Haa_Pevi_the_Stentorian',
        'Loo_Hepe_the_Eyepiercer',
        'Wuu_Qoho_the_Razorclaw',
        'Xoo_Kaza_the_Solemn',
    },
    [xi.zone.DYNAMIS_XARCABARD] =
    {
        'Count_Raum',
        'Count_Vine',
        'Count_Zaebos',
        'Duke_Berith',
        'Duke_Gomory',
        'Duke_Scox',
        'King_Zagan',
        'Marquis_Andras',
        'Marquis_Cimeries',
        'Marquis_Decarabia',
        'Marquis_Gamygyn',
        'Marquis_Nebiros',
        'Marquis_Orias',
        'Marquis_Sabnak',
        'Prince_Seere',
    },
    [xi.zone.EASTERN_ALTEPA_DESERT] =
    {
        'Centurio_XII-I',
        'Donnergugi',
        'Dune_Widow',
        'Nandi',
        'Sabotender_Corrido',
    },
    [xi.zone.EAST_RONFAURE] =
    {
        'Bigmouth_Billy',
        'Rambukk',
        'Swamfisk',
    },
    [xi.zone.EAST_RONFAURE_S] =
    {
        'Goblintrap',
        'Melusine',
        'Myradrosh',
    },
    [xi.zone.EAST_SARUTABARUTA] =
    {
        'Duke_Decapod',
        'Sharp-Eared_Ropipi',
        'Spiny_Spipi',
    },
    [xi.zone.FEIYIN] =
    {
        'Capricious_Cassie',
        'Eastern_Shadow',
        'Goliath',
        'Jenglot',
        'Mind_Hoarder',
        'Northern_Shadow',
        'Sluagh',
        'Southern_Shadow',
        'Western_Shadow',
    },
    [xi.zone.FORT_GHELSBA] =
    {
        'Hundredscar_Hajwaj',
        'Kegpaunch_Doshgnosh',
        'Orcish_Panzer',
    },
    [xi.zone.FORT_KARUGO_NARUGO_S] =
    {
        'Demoiselle_Desolee',
        'Emela-ntouka',
        'Kirtimukha',
        'Ratatoskr',
    },
    [xi.zone.GARLAIGE_CITADEL] =
    {
        'Frogamander',
        'Hazmat',
        'Hovering_Hotpot',
        'Old_Two-Wings',
        'Serket',
        'Skewer_Sam',
    },
    [xi.zone.GARLAIGE_CITADEL_S] =
    {
        'Buarainech',
        'Citadel_Pipistrelles',
        'Elatha',
    },
    [xi.zone.GHELSBA_OUTPOST] =
    {
        'Thousandarm_Deshglesh',
    },
    [xi.zone.GIDDEUS] =
    {
        'Hoo_Mjuu_the_Torrent',
        'Juu_Duzu_the_Whirlwind',
        'Quu_Xijo_the_Illusory',
        'Vuu_Puqu_the_Beguiler',
    },
    [xi.zone.GRAUBERG_S] =
    {
        'Kotan-kor_Kamuy',
        'Sarcopsylla',
        'Scitalis',
        'Vasiliceratops',
    },
    [xi.zone.GUSGEN_MINES] =
    {
        'Asphyxiated_Amsel',
        'Burned_Bergmann',
        'Crushed_Krause',
        'Foul_Meat',
        'Juggler_Hecatomb',
        'Pulverized_Pfeffer',
        'Smothered_Schmidt',
        'Wounded_Wurfel',
    },
    [xi.zone.GUSTAV_TUNNEL] =
    {
        'Amikiri',
        'Baobhan_Sith',
        'Bune',
        'Goblinsavior_Heronox',
        'Taxim',
        'Ungur',
        'Wyvernpoacher_Drachlox',
    },
    [xi.zone.HALVUNG] =
    {
        'Big_Bomb',
        'Copper_Borer',
        'Dorgerwor_the_Astute',
        'Farlarder_the_Shrewd',
        'Flammeri',
        'Gurfurlur_the_Menacing',
        'Kirlirger_the_Abhorrent',
    },
    [xi.zone.INNER_HORUTOTO_RUINS] =
    {
        'Maltha',
        'Nocuous_Weapon',
        'Slendlix_Spindlethumb',
    },
    [xi.zone.JUGNER_FOREST] =
    {
        'Fradubio',
        'Fraelissa',
        'King_Arthro',
        'Meteormauler_Zhagtegg',
        'Panzer_Percival',
        'Sappy_Sycamore',
    },
    [xi.zone.JUGNER_FOREST_S] =
    {
        'Boll_Weevil',
        'Drumskull_Zogdregg',
        'Voirloup',
    },
    [xi.zone.KING_RANPERRES_TOMB] =
    {
        'Ankou',
        'Barbastelle',
        'Cemetery_Cherry',
        'Crypt_Ghost',
        'Gwyllgi',
        'Vrtra',
    },
    [xi.zone.KONSCHTAT_HIGHLANDS] =
    {
        'Bendigeit_Vran',
        'Ghillie_Dhu',
        'Haty',
        'Highlander_Lizard',
        'Rampaging_Ram',
        'Steelfleece_Baldarich',
        'Stray_Mary',
    },
    [xi.zone.KORROLOKA_TUNNEL] =
    {
        'Cargo_Crab_Colin',
        'Dame_Blanche',
        'Falcatus_Aranei',
        'Thoon',
    },
    [xi.zone.KUFTAL_TUNNEL] =
    {
        'Amemet',
        'Arachne',
        'Bloodthirster_Madkix',
        'Guivre',
        'Pelican',
        'Sabotender_Mariachi',
        'Yowie',
    },
    [xi.zone.LABYRINTH_OF_ONZOZO] =
    {
        'Hellion',
        'Lord_of_Onzozo',
        'Mysticmaker_Profblix',
        'Narasimha',
        'Ose',
        'Peg_Powler',
        'Soulstealer_Skullnix',
    },
    [xi.zone.LA_THEINE_PLATEAU] =
    {
        'Bloodtear_Baldurf',
        'Lumbering_Lambert',
        'Slumbering_Samwell',
        'Tumbling_Truffle',
    },
    [xi.zone.LA_VAULE_S] =
    {
        'Agrios',
        'Ashmaker_Gotblut',
        'Cogtooth_Skagnogg',
        'Coinbiter_Cjaknokk',
        'Draketrader_Zlodgodd',
        'Falsespinner_Bhudbrodd',
        'Feeblescheme_Bhogbigg',
        'Shatterskull_Mippdapp',
    },
    [xi.zone.LOWER_DELKFUTTS_TOWER] =
    {
        'Epialtes',
        'Eurymedon',
        'Hippolytos',
        'Tyrant',
    },
    [xi.zone.LUFAISE_MEADOWS] =
    {
        'Colorful_Leshy',
        'Defoliate_Leshy',
        'Flockbock',
        'Megalobugard',
        'Padfoot',
        'Sengann',
        'Yal-un_Eke',
    },
    [xi.zone.MAMOOK] =
    {
        'Darting_Kachaal_Ja',
        'Devout_Radol_Ja',
        'Dragonscaled_Bugaal_Ja',
        'Firedance_Magmaal_Ja',
        'Gulool_Ja_Ja',
        'Hundredfaced_Hapool_Ja',
        'Venomfang',
        'Zizzy_Zillah',
    },
    [xi.zone.MANACLIPPER] =
    {
        'Zoredonite',
    },
    [xi.zone.MAZE_OF_SHAKHRAMI] =
    {
        'Argus',
        'Gloombound_Lurker',
        'Leech_King',
        'Lesath',
        'Trembler_Tabitha',
    },
    [xi.zone.MERIPHATAUD_MOUNTAINS] =
    {
        'Chonchon',
        'Coo_Keja_the_Unseen',
        'Daggerclaw_Dracos',
        'Naa_Zeku_the_Unwaiting',
        'Patripatan',
        'Waraxe_Beak',
    },
    [xi.zone.MERIPHATAUD_MOUNTAINS_S] =
    {
        'Centipedal_Centruroides',
        'Hemodrosophila',
        'Muq_Shabeel',
    },
    [xi.zone.MIDDLE_DELKFUTTS_TOWER] =
    {
        'Eurytos',
        'Ogygos',
        'Ophion',
        'Polybotes',
        'Rhoikos',
        'Rhoitos',
    },
    [xi.zone.MISAREAUX_COAST] =
    {
        'Goaftrap',
        'Odqan',
        'Okyupete',
        'Upyri',
    },
    [xi.zone.MONASTIC_CAVERN] =
    {
        'Orcish_Hexspinner',
        'Orcish_Overlord',
        'Orcish_Warlord',
        'Overlord_Bakgodek',
    },
    [xi.zone.MOUNT_ZHAYOLM] =
    {
        'Cerberus',
        'Chary_Apkallu',
        'Energetic_Eruca',
        'Fahrafahr_the_Bloodied',
        'Ignamoth',
    },
    [xi.zone.NEWTON_MOVALPOLOS] =
    {
        'Swashstox_Beadblinker',
        'Sword_Sorcerer_Solisoq',
    },
    [xi.zone.NORTH_GUSTABERG] =
    {
        'Bedrock_Barry',
        'Maighdean_Uaine',
        'Stinging_Sophie',
    },
    [xi.zone.NORTH_GUSTABERG_S] =
    {
        'Ankabut',
        'Gloomanita',
        'Olgoi-Khorkhoi',
        'Peaseblossom',
    },
    [xi.zone.OLDTON_MOVALPOLOS] =
    {
        'Bugbear_Muscleman',
        'Bugbear_Strongman',
    },
    [xi.zone.ORDELLES_CAVES] =
    {
        'Agar_Agar',
        'Bombast',
        'Donggu',
        'Morbolger',
    },
    [xi.zone.OUTER_HORUTOTO_RUINS] =
    {
        'Ah_Puch',
        'Bomb_King',
        'Desmodont',
        'Doppelganger_Dio',
        'Doppelganger_Gog',
        'Legalox_Heftyhind',
    },
    [xi.zone.PALBOROUGH_MINES] =
    {
        'BeHya_Hundredwall',
        'BuGhi_Howlblade',
        'NoMho_Crimsonarmor',
        'QuVho_Deathhurler',
        'ZiGhi_Boneeater',
    },
    [xi.zone.PASHHOW_MARSHLANDS] =
    {
        'Bloodpool_Vorax',
        'BoWho_Warmonger',
        'Jolly_Green',
        'NiZho_Bladebender',
        'Toxic_Tamlyn',
    },
    [xi.zone.PASHHOW_MARSHLANDS_S] =
    {
        'Nommo',
        'Sugaar',
    },
    [xi.zone.PHANAUET_CHANNEL] =
    {
        'Stubborn_Dredvodd',
        'Vodyanoi',
    },
    [xi.zone.PHOMIUNA_AQUEDUCTS] =
    {
        'Eba',
        'Mahisha',
        'Tres_Duendes',
    },
    [xi.zone.PROMYVION_DEM] =
    {
        'Satiator',
    },
    [xi.zone.PROMYVION_HOLLA] =
    {
        'Cerebrator',
    },
    [xi.zone.PROMYVION_MEA] =
    {
        'Coveter',
    },
    [xi.zone.PSOXJA] =
    {
        'Gyre-Carlin',
    },
    [xi.zone.QUFIM_ISLAND] =
    {
        'Atkorkamuy',
        'Qoofim',
        'Slippery_Sucker',
        'Trickster_Kinetix',
    },
    [xi.zone.QUICKSAND_CAVES] =
    {
        'Antican_Consul',
        'Antican_Legatus',
        'Antican_Magister',
        'Antican_Praefectus',
        'Antican_Praetor',
        'Antican_Proconsul',
        'Antican_Tribunus',
        'Centurio_X-I',
        'Diamond_Daig',
        'Hastatus_XI-XII',
        'Nussknacker',
        'Proconsul_XII',
        'Sabotender_Bailarin',
        'Sabotender_Bailarina',
        'Sagittarius_X-XIII',
        'Triarius_X-XV',
    },
    [xi.zone.RANGUEMONT_PASS] =
    {
        'Gloom_Eye',
        'Hyakume',
        'Mucoid_Mass',
        'Taisaijin',
    },
    [xi.zone.RIVERNE_SITE_A01] =
    {
        'Aiatar',
        'Heliodromos',
    },
    [xi.zone.RIVERNE_SITE_B01] =
    {
        'Boroka',
        'Imdugud',
    },
    [xi.zone.ROLANBERRY_FIELDS] =
    {
        'Black_Triple_Stars',
        'Drooling_Daisy',
        'Eldritch_Edge',
        'Ravenous_Crawler',
        'Simurgh',
    },
    [xi.zone.ROLANBERRY_FIELDS_S] =
    {
        'Delicieuse_Delphine',
        'Dyinyinga',
        'Erle',
        'Lamina',
    },
    [xi.zone.ROMAEVE] =
    {
        'Martinet',
        'Nargun',
        'Nightmare_Vase',
        'Rogue_Receptacle',
        'Shikigami_Weapon',
    },
    [xi.zone.RUAUN_GARDENS] =
    {
        'Despot',
    },
    [xi.zone.SACRARIUM] =
    {
        'Elel',
        'Keremet',
    },
    [xi.zone.SAUROMUGUE_CHAMPAIGN] =
    {
        'Blighting_Brand',
        'Deadly_Dodo',
        'Roc',
        'Thunderclaw_Thuban',
    },
    [xi.zone.SAUROMUGUE_CHAMPAIGN_S] =
    {
        'Balam-Quitz',
        'Coquecigrue',
        'Herensugue',
        'Hyakinthos',
    },
    [xi.zone.SEA_SERPENT_GROTTO] =
    {
        'Abyss_Sahagin',
        'Charybdis',
        'Coral_Sahagin',
        'Denn_the_Orcavoiced',
        'Fyuu_the_Seabellow',
        'Masan',
        'Mouu_the_Waverider',
        'Namtar',
        'Novv_the_Whitehearted',
        'Ocean_Sahagin',
        'Pahh_the_Gullcaller',
        'Qull_the_Shellbuster',
        'Sea_Hog',
        'Seww_the_Squidlimbed',
        'Voll_the_Sharkfinned',
        'Worr_the_Clawfisted',
        'Wuur_the_Sandcomber',
        'Yarr_the_Pearleyed',
        'Zuug_the_Shoreleaper',
    },
    [xi.zone.SOUTH_GUSTABERG] =
    {
        'Carnero',
        'Leaping_Lizzy',
        'Tococo',
    },
    [xi.zone.TAHRONGI_CANYON] =
    {
        'Habrok',
        'Herbage_Hunter',
        'Serpopard_Ishtar',
    },
    [xi.zone.TEMPLE_OF_UGGALEPIH] =
    {
        'Flauros',
        'Manipulator',
        'Sozu_Sarberry',
        'Sozu_Terberry',
        'Tonberry_Kinq',
    },
    [xi.zone.THE_BOYAHDA_TREE] =
    {
        'Ancient_Goobbue',
        'Aquarius',
        'Ellyllon',
        'Leshonki',
        'Unut',
        'Voluptuous_Vivian',
    },
    [xi.zone.THE_ELDIEME_NECROPOLIS] =
    {
        'Cwn_Cyrff',
    },
    [xi.zone.THE_ELDIEME_NECROPOLIS_S] =
    {
        'Ethniu',
        'Laelaps',
        'Tethra',
    },
    [xi.zone.THE_SANCTUARY_OF_ZITAH] =
    {
        'Bastet',
        'Elusive_Edwin',
        'Huwasi',
        'Keeper_of_Halidom',
        'Noble_Mold',
    },
    [xi.zone.THE_SHRINE_OF_RUAVITAU] =
    {
        'Faust',
        'Mother_Globe',
    },
    [xi.zone.TORAIMARAI_CANAL] =
    {
        'Brazen_Bones',
        'Canal_Moocher',
        'Konjac',
        'Oni_Carcass',
    },
    [xi.zone.ULEGUERAND_RANGE] =
    {
        'Bonnacon',
        'Frost_Flambeau',
        'Jormungand',
        'Magnotaur',
        'Mountain_Worm_NM',
        'Skvader',
    },
    [xi.zone.UPPER_DELKFUTTS_TOWER] =
    {
        'Autarch',
        'Enkelados',
        'Ixtab',
        'Mimas',
        'Porphyrion',
    },
    [xi.zone.VALKURM_DUNES] =
    {
        'Golden_Bat',
        'Hippomaritimus',
        'Metal_Shears',
        'Valkurm_Emperor',
    },
    [xi.zone.VELUGANNON_PALACE] =
    {
        'Zipacna',
    },
    [xi.zone.VUNKERL_INLET_S] =
    {
        'Big_Bang',
        'Judgmental_Julika',
        'Pallas',
        'Warabouc',
    },
    [xi.zone.WAJAOM_WOODLANDS] =
    {
        'Chelicerata',
        'Gharial',
        'Hydra',
        'Jaded_Jody',
        'Zoraal_Jas_Pkuucha',
    },
    [xi.zone.WESTERN_ALTEPA_DESERT] =
    {
        'Cactuar_Cantautor',
        'Calchas',
        'Celphie',
        'Dahu',
        'King_Vinegarroon',
        'Picolaton',
    },
    [xi.zone.WEST_SARUTABARUTA] =
    {
        'Numbing_Norman',
        'Nunyenunc',
        'Tom_Tit_Tat',
    },
    [xi.zone.WEST_SARUTABARUTA_S] =
    {
        'Belladonna',
        'Jeduah',
        'Ramponneau',
        'Tiffenotte',
    },
    [xi.zone.XARCABARD] =
    {
        'Barbaric_Weapon',
        'Biast',
        'Duke_Focalor',
        'Ereshkigal',
        'Shadow_Eye',
        'Timeworn_Warrior',
    },
    [xi.zone.XARCABARD_S] =
    {
        'Graoully',
        'Prince_Orobas',
        'Tikbalang',
        'Zirnitra',
    },
    [xi.zone.YHOATOR_JUNGLE] =
    {
        'Acolnahuacatl',
        'Bright-handed_Kunberry',
        'Edacious_Opo-opo',
        'Hoar-knuckled_Rimberry',
        'Powderer_Penny',
        'Woodland_Sage',
    },
    [xi.zone.YUGHOTT_GROTTO] =
    {
        'Ashmaker_Gotblut',
    },
    [xi.zone.YUHTUNGA_JUNGLE] =
    {
        'Bayawak',
        'Koropokkur',
        'Meww_the_Turtlerider',
        'Mischievous_Micholas',
        'Pyuu_the_Spatemaker',
        'Rose_Garden',
        'Voluptuous_Vilma',
    },
}

-----------------------------------
-- Helper Functions
-----------------------------------

-- Find the position of a target entity in a table by ID
---@param t table: Table of entities to search
---@param target CBaseEntity: Entity to find
---@return integer|nil: Index position or nil if not found
local tableFindPosByID = function(t, target)
    for index, entity in ipairs(t) do
        if entity:getID() == target:getID() then
            return index
        end
    end

    return nil
end

-- Deduplicate a table in-place using entity IDs
---@param t table: Table of entities to deduplicate (modified in-place)
local dedupeByID = function(t)
    local seen = {}
    local i = 1
    while i <= #t do
        local entity = t[i]
        if seen[entity:getID()] then
            table.remove(t, i)
        else
            seen[entity:getID()] = true
            i = i + 1
        end
    end
end

-- Build deduplicated entries list from enmity list
-- Pets and trusts count as their master (one entry per player)
---@param enmityList table: Raw enmity list from mob:getEnmityList()
---@return table: Deduplicated table of player entities
local buildEntriesFromEnmity = function(enmityList)
    local entries = {}
    for _, v in pairs(enmityList) do
        local entity = v.entity
        if entity then
            local master = entity:getMaster()
            if
                not entity:isPC() and
                master and
                master:isPC()
            then
                -- Pet/trust - add the master instead
                table.insert(entries, master)
            elseif entity:isPC() then
                -- Player
                table.insert(entries, entity)
            end
        end
    end

    dedupeByID(entries)
    return entries
end

-----------------------------------
-- Claimshield Process Functions
-----------------------------------

-- Forward declarations
local endClaimshieldProcess
local claimRecoveryCheck

-- Hide the real NM (Pandemonium Warden pattern)
---@param mob CMobEntity: The real NM to hide
local hideRealMob = function(mob)
    mob:setStatus(xi.status.INVISIBLE)
    mob:hideHP(true)
    mob:hideName(true)
    mob:setUntargetable(true)
end

-- Unhide the real NM and restore normal state
---@param mob CMobEntity: The real NM to unhide
---@param claimWinner CCharEntity|nil: Player to award claim to (or nil)
local unhideRealMob = function(mob, claimWinner)
    mob:setStatus(xi.status.UPDATE)
    mob:hideHP(false)
    mob:hideName(false)
    mob:setUntargetable(false)

    -- Restore normal claim behavior
    mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.EXCLUSIVE)
    mob:setUnkillable(false)
    mob:setCallForHelpBlocked(false)

    -- Reset to full HP and clear status effects
    mob:setHP(mob:getMaxHP())
    mob:delStatusEffectsByFlag(0xFFFF)
    mob:resetAI()

    if claimWinner then
        mob:updateClaim(claimWinner)
    end
end

-- Start the claimshield process
-- Hides real NM, spawns dynamic entity, and starts the claimshield timer
---@param realMob CMobEntity: The real NM being engaged
---@param engager CCharEntity: The player who engaged the mob
local startClaimshieldProcess = function(realMob, engager)
    local zone = realMob:getZone()
    local mobPos = realMob:getPos()
    local mobName = realMob:getPacketName()
    local mobLevel = realMob:getMainLvl()
    local mobGroupId = realMob:getGroupId()
    local mobZoneId = realMob:getZoneID()
    local mobModelId = realMob:getModelId()

    print(string.format('[ClaimShield] Activated for %s (engaged by %s, groupId=%d, zoneId=%d, modelId=%d)', mobName, engager:getName(), mobGroupId, mobZoneId, mobModelId))

    -- Hide the real NM
    hideRealMob(realMob)

    -- Clear real NM's enmity
    local enmityList = realMob:getEnmityList()
    for _, entry in pairs(enmityList) do
        if entry.entity then
            realMob:resetEnmity(entry.entity)
        end
    end

    -- Spawn dynamic entity with same appearance and AI from mob_groups
    -- Model is set explicitly in onMobSpawn callback (like Empty_Mobs_model_IDs.lua pattern)
    local displayName = string.gsub(mobName, '_', ' ')
    local dynamicMob = zone:insertDynamicEntity({
        objtype = xi.objType.MOB,
        name = 'CS_' .. mobName,
        packetName = displayName,
        x = mobPos.x,
        y = mobPos.y,
        z = mobPos.z,
        rotation = mobPos.rot or 0,
        groupId = mobGroupId,
        groupZoneId = mobZoneId,
        minLevel = mobLevel,
        maxLevel = mobLevel,
        releaseIdOnDisappear = true,
        specialSpawnAnimation = false,
        onMobSpawn = function(mob)
            -- Explicitly set the model to match the real NM
            mob:setModelId(mobModelId)
        end,

        onMobDeath = function(mob, player, optParams)
            -- DE should never die during claimshield, but handle gracefully
            print(string.format('[ClaimShield] Warning: Dynamic entity died unexpectedly'))
        end,
    })

    if not dynamicMob then
        -- Fallback: unhide real mob and abort
        print(string.format('[ClaimShield] Failed to spawn dynamic entity for %s', mobName))
        unhideRealMob(realMob, nil)
        realMob:setLocalVar('CS_Active', 0)
        return
    end

    -- Store DE ID on real mob for later reference
    local deId = dynamicMob:getID()
    realMob:setLocalVar('CS_DynamicEntityID', deId)
    print(string.format('[ClaimShield] DEBUG: Created DE with ID %d for %s', deId, mobName))

    -- Configure DE - setSpawn before spawn (required pattern for visibility)
    dynamicMob:setSpawn(mobPos.x, mobPos.y, mobPos.z, mobPos.rot or 0)
    dynamicMob:spawn()

    -- Make DE invulnerable using damage reduction mods (Pandemonium Warden pattern)
    -- This allows attacks but prevents damage, unlike setUnkillable which may block attacks
    dynamicMob:setMod(xi.mod.UDMGPHYS, -10000)
    dynamicMob:setMod(xi.mod.UDMGRANGE, -10000)
    dynamicMob:setMod(xi.mod.UDMGBREATH, -10000)
    dynamicMob:setMod(xi.mod.UDMGMAGIC, -10000)

    dynamicMob:addTP(dynamicEntityTP)
    dynamicMob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.UNCLAIMABLE)
    dynamicMob:setCallForHelpBlocked(true)

    -- Initial engagement with the DE
    -- Add substantial enmity (CE=1000, VE=1000) to prevent decay issues
    dynamicMob:addEnmity(engager, 1000, 1000)

    -- Make the DE actively engage the player
    dynamicMob:engage(engager:getTargID())

    print(string.format('[ClaimShield] DEBUG: Added initial enmity for %s on DE (targID=%d)', engager:getName(), engager:getTargID()))

    -- Start the claimshield timer
    realMob:timer(claimshieldTime, function(mobArg)
        endClaimshieldProcess(mobArg)
    end)
end

-- End the claimshield process and award claim
-- Despawns dynamic entity, selects winner, unhides real NM, and notifies participants
---@param realMob CMobEntity: The real NM that was hidden
endClaimshieldProcess = function(realMob)
    local deId = realMob:getLocalVar('CS_DynamicEntityID')
    local mobName = realMob:getPacketName()
    local displayName = string.gsub(mobName, '_', ' ')

    -- Get dynamic entity
    local dynamicMob = nil
    if deId > 0 then
        dynamicMob = GetMobByID(deId)
    end

    local entries = {}
    local numEntries = 0

    if dynamicMob and dynamicMob:isSpawned() then
        -- Get enmity list from dynamic entity
        local enmityList = dynamicMob:getEnmityList()

        -- Debug: Print raw enmity list contents
        print(string.format('[ClaimShield] DEBUG: DE enmity list has %d entries', #enmityList))
        for i, v in pairs(enmityList) do
            if v.entity then
                print(string.format('[ClaimShield] DEBUG: Enmity entry %s: %s (isPC=%s, id=%d)',
                    tostring(i),
                    v.entity:getName(),
                    tostring(v.entity:isPC()),
                    v.entity:getID()))
            else
                print(string.format('[ClaimShield] DEBUG: Enmity entry %s: entity is nil', tostring(i)))
            end
        end

        entries = buildEntriesFromEnmity(enmityList)
        numEntries = #entries
        print(string.format('[ClaimShield] DEBUG: After processing, %d valid player entries', numEntries))

        -- Despawn dynamic entity
        DespawnMob(deId)
    else
        print(string.format('[ClaimShield] Dynamic entity not found for %s (deId=%d)', mobName, deId))
    end

    -- Select winner
    local claimWinner = nil
    if numEntries > 0 then
        claimWinner = utils.randomEntry(entries)
    end

    -- Unhide real mob and award claim
    unhideRealMob(realMob, claimWinner)

    if claimWinner then
        print(string.format('[ClaimShield] Winner for %s: %s (out of %d)', mobName, claimWinner:getName(), numEntries))

        -- Message winner and their alliance
        local alliance = claimWinner:getAlliance()
        for _, member in pairs(alliance) do
            local str
            if #alliance == 1 then
                str = string.format('You have won the lottery for %s! (out of %i players)', displayName, numEntries)
            else
                str = string.format('Your group has won the lottery for %s! (out of %i players)', displayName, numEntries)
            end

            member:printToPlayer(str, xi.msg.channel.SYSTEM_3, '')

            -- Remove from entries table
            local pos = tableFindPosByID(entries, member)
            if pos then
                table.remove(entries, pos)
            end
        end

        -- Message losers (everyone left in entries)
        for _, member in pairs(entries) do
            if member:isPC() then
                local str
                if #alliance == 1 then
                    str = string.format('You were not successful in the lottery for %s. (out of %i players)', displayName, numEntries)
                else
                    str = string.format('Your group was not successful in the lottery for %s. (out of %i players)', displayName, numEntries)
                end

                member:printToPlayer(str, xi.msg.channel.SYSTEM_3, '')

                -- Note: Losers' enmity doesn't matter since real mob's enmity was cleared
                -- Winner's party will need to build fresh enmity
            end
        end

        -- Store winner ID for claim recovery check
        realMob:setLocalVar('CS_WinnerID', claimWinner:getID())

        -- Start claim recovery timer (handle disengage edge case)
        realMob:timer(claimRecoveryDelay, function(mobArg)
            claimRecoveryCheck(mobArg)
        end)
    else
        print(string.format('[ClaimShield] No valid participants for %s', mobName))
    end

    -- Clear active flag
    realMob:setLocalVar('CS_Active', 0)
    realMob:setLocalVar('CS_DynamicEntityID', 0)
end

-- Re-award claim to winner if mob became unclaimed (disengage edge case)
-- Called after a delay to handle winners who immediately disengage
---@param mob CMobEntity: The real NM to check claim on
claimRecoveryCheck = function(mob)
    local winnerId = mob:getLocalVar('CS_WinnerID')
    if winnerId == 0 then
        return
    end

    local winner = GetPlayerByID(winnerId)
    if winner and mob:isSpawned() then
        -- updateClaim handles the case where mob is already claimed by someone else
        mob:updateClaim(winner)
    end

    -- Clear the stored winner ID
    mob:setLocalVar('CS_WinnerID', 0)
end

-----------------------------------
-- Listener Functions
-----------------------------------

-- SPAWN listener - Records spawn time and resets claimshield state
---@param mob CMobEntity: The mob that spawned
local spawnListenerFunc = function(mob)
    mob:setLocalVar('CS_SpawnTime', GetSystemTime())
    mob:setLocalVar('CS_Active', 0)
end

-- ENGAGE listener - Triggers claimshield if within the engage window
-- Only activates if the mob was engaged within engageWindowSeconds of spawn
---@param mob CMobEntity: The mob being engaged
---@param target CCharEntity: The player who engaged the mob
local engageListenerFunc = function(mob, target)
    local spawnTime = mob:getLocalVar('CS_SpawnTime')
    local now = GetSystemTime()

    -- Only trigger if engaged within X seconds of spawn
    if now - spawnTime > engageWindowSeconds then
        return -- Normal engage, no claimshield
    end

    -- Prevent double-triggering
    if mob:getLocalVar('CS_Active') == 1 then
        return
    end

    mob:setLocalVar('CS_Active', 1)

    startClaimshieldProcess(mob, target)
end

-----------------------------------
-- Module Registration
-- Uses m:addOverride() pattern for reliable mob table access
-----------------------------------

local nmCount = 0

for zoneId, mobNames in pairs(nmsToShield) do
    local zoneName = zxi.zoneName[zoneId]
    if not zoneName then
        print(string.format('[claim_shield] Warning: Unknown zone ID %d', zoneId))
    else
        for _, mobName in ipairs(mobNames) do
            local mobPath = string.format('xi.zones.%s.mobs.%s', zoneName, mobName)

            -- Ensure the table path exists
            xi.module.ensureTable(mobPath)

            -- Add override using m:addOverride() for proper chaining
            m:addOverride(mobPath .. '.onMobInitialize', function(mob)
                super(mob)

                local listenerPrefix = string.format('%s_CS', mob:getPacketName())

                -- Add SPAWN listener to record spawn time
                mob:addListener('SPAWN', listenerPrefix .. '_SPAWN', spawnListenerFunc)

                -- Add ENGAGE listener to potentially trigger claimshield
                mob:addListener('ENGAGE', listenerPrefix .. '_ENGAGE', engageListenerFunc)
            end)

            nmCount = nmCount + 1
        end
    end
end

print(string.format('[claim_shield] Registered claim shield for %d NMs', nmCount))

return m
