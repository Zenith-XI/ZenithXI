-----------------------------------
-- Monster level and respawn overrides
-- Does not restore Era functionality
-- Public module for ZenitXI
-----------------------------------

-- Retail dungeon respawn times
-- Level 1~19 - 8 Minutes - 480
-- Level 20~29 - 10 Minutes - 600
-- Level 30~39 - 12 Minutes - 720
-- Level 40~49 - 14 Minutes - 840
-- Level 50+ - 16 Minutes - 960
-----------------------------------

-- CARPENTERS_LANDING (Zone 2)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 24 WHERE `zoneid` = 2 AND `name` = 'Marsh_Funguar'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 24, `maxLevel` = 27 WHERE `zoneid` = 2 AND `name` = 'Battrap'; -- *23-27
UPDATE `mob_groups` SET `minLevel` = 17, `maxLevel` = 20 WHERE `zoneid` = 2 AND `name` IN ( -- *16-20
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 2 AND `name` IN ( -- *21-25
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);

-- BIBIKI_BAY (Zone 4)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 37 WHERE `zoneid` = 4 AND `name` = 'Marine_Dhalmel'; -- *34-37
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 38 WHERE `zoneid` = 4 AND `name` = 'Island_Rarab'; -- *34-38
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 4 AND `name` = 'Catoblepas'; -- *76-80
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 4 AND `name` = 'Splacknuck'; -- *69-69
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69, `dropid` = 93, `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Ghost_Crab'; -- *
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 83, `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Bight_Rarab'; -- *
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 84, `HP` = 0  WHERE `zoneid` = 4 AND `name` = 'Locus_Hypnos_Eft'; -- *
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85, `HP` = 0  WHERE `zoneid` = 4 AND `name` = 'Locus_Camelopard'; -- *

UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 4 AND `name` IN (
    'Locus_Bight_Rarab',
    'Locus_Camelopard',
    'Locus_Hypnos_Eft',
    'Locus_Ghost_Crab'
);

-- ULEGUERAND_RANGE (Zone 5)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 59, `maxLevel` = 62 WHERE `zoneid` = 5 AND `name` = 'Glacier_Eater'; -- *58-62
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 70 WHERE `zoneid` = 5 AND `name` = 'Doom_Soldier'; -- *66-70
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 70 WHERE `zoneid` = 5 AND `name` = 'Mountain_Worm'; -- *66-70

-- ATTOHWA_CHASM (Zone 7)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 39 WHERE `zoneid` = 7 AND `name` = 'Hecteyes'; -- *35-39
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 81 WHERE `zoneid` = 7 AND `name` = 'Arch_Corse'; -- *75-81

-- PSOXJA (Zone 9)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 46 WHERE `zoneid` = 9 AND `name` = 'Diremite'; -- *42-46
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 9 AND `name` = 'Maze_Lizard'; -- *43-47
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 58 WHERE `zoneid` = 9 AND `name` = 'Labyrinth_Lizard'; -- *52-58
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 58 WHERE `zoneid` = 9 AND `name` = 'Blubber_Eyes'; -- *53-58
UPDATE `mob_groups` SET `minLevel` = 56, `maxLevel` = 59 WHERE `zoneid` = 9 AND `name` = 'Cryptonberry_Plaguer'; -- *53-59
UPDATE `mob_groups` SET `minLevel` = 56, `maxLevel` = 59 WHERE `zoneid` = 9 AND `name` = 'Cryptonberry_Cutter'; -- *53-59
UPDATE `mob_groups` SET `minLevel` = 57, `maxLevel` = 60 WHERE `zoneid` = 9 AND `name` = 'Cryptonberry_Harrier'; -- *53-60
UPDATE `mob_groups` SET `minLevel` = 57, `maxLevel` = 60 WHERE `zoneid` = 9 AND `name` = 'Cryptonberry_Stalker'; -- *53-60
UPDATE `mob_groups` SET `minLevel` = 59, `maxLevel` = 61 WHERE `zoneid` = 9 AND `name` = 'Goblins_Bat'; -- *57-61
UPDATE `mob_groups` SET `minLevel` = 64, `maxLevel` = 67 WHERE `zoneid` = 9 AND `name` = 'Goblin_Bandit'; -- *62-67
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 68 WHERE `zoneid` = 9 AND `name` IN ( -- *62/63/64-68
    'Goblin_Alchemist',
    'Goblin_Mercenary',
    'Goblin_Veterinarian',
    'Diremite_Assaulter',
    'Thousand_Eyes'
);
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 76 WHERE `zoneid` = 9 AND `name` = 'Purgatory_Bat'; -- *72-76
UPDATE `mob_groups` SET `minLevel` = 74, `maxLevel` = 77 WHERE `zoneid` = 9 AND `name` = 'Frost_Lizard'; -- *73-77

-- Address inconsistent respawn times across zone.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 9 AND `name` IN (
    'Vampire_Bat',
    'Maze_Lizard',
    'Gazer',
    'Diremite',
    'Snowball'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 9 AND `name` IN (
    'Diremite_Stalker',
    'Diremite_Assaulter',
    'Diremite_Dominator'
);

-- OLDTON_MOVALPOLOS (Zone 11)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 32, `maxLevel` = 35 WHERE `zoneid` = 11 AND `name` = 'Dark_Bats'; -- 31-35
UPDATE `mob_groups` SET `minLevel` = 42, `maxLevel` = 45 WHERE `zoneid` = 11 AND `name` = 'Ancient_Bomb'; -- 40-45
UPDATE `mob_groups` SET `minLevel` = 53, `maxLevel` = 55 WHERE `zoneid` = 11 AND `name` = 'Goblin_Wolfman'; -- 50-55

-- Address inconsistent respawn times across zone.
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 11 AND `name` IN (
    'Dark_Bats',
    'Goblin_Craftsman',
    'Goblin_Gutterman',
    'Moblin_Pickman',
    'Goblin_Leadman',
    'Moblin_Witchman',
    'Goblin_Hammerman',
    'Moblin_Ragmanmob',
    'Moblin_Chapman',
    'Stirge'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 11 AND `name` IN (
    'Earth_Elemental',
    'Ancient_Bomb',
    'Thunder_Elemental',
    'Moblin_Rodman',
    'Bugbear_Bondman',
    'Goblin_Tollman',
    'Moblin_Gasman',
    'Moblin_Coalman',
    'Moblin_Repairman',
    'Goblin_Doorman',
    'Goblin_Oilman',
    'Moblin_Pikeman',
    'Goblin_Shovelman',
    'Goblin_Freelance',
    'Moblin_Ashman',
    'Moblin_Gurneyman'
);
-- NEWTON_MOVALPOLOS (Zone 12)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 76 WHERE `zoneid` = 12 AND `name` = 'Bugbear_Watchman'; -- * 71-76
UPDATE `mob_groups` SET `minLevel` = 76, `maxLevel` = 79 WHERE `zoneid` = 12 AND `name` IN ( -- *75-79
    'Goblin_Headman',
    'Goblin_Junkman',
    'Moblin_Aidman',
    'Moblin_Topsman',
    'Goblin_Marksman',
    'Moblin_Engineman',
    'Moblin_Roadman',
    'Goblin_Hangman',
    'Bugbear_Matman'
);

-- ABYSSEA_KONSCHTAT (Zone 15)
-----------------------------------
-- TODO

-- PROMYVION_HOLLA (Zone 16)
-----------------------------------
-- TODO. Zone is currently missing Apex.

-- PROMYVION_DEM (Zone 18)
-----------------------------------
-- TODO. Zone is currently missing Apex.

-- PROMYVION_MEA (Zone 20)
-----------------------------------
-- TODO. Zone is currently missing Apex.

-- PROMYVION_VAHZL (Zone 22)
-----------------------------------
-- TODO. Zone is currently missing Apex.

-- LUFAISE_MEADOWS (Zone 24)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 50, `maxLevel` = 53 WHERE `zoneid` = 24 AND `name` = 'Leshachikha'; -- *49-53
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 85 WHERE `zoneid` = 24 AND `name` = 'Flockbock'; -- *82

-- MISAREAUX_COAST (Zone 25)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 25 AND `name` = 'Mantrap'; -- *44-49
UPDATE `mob_groups` SET `minLevel` = 48, `maxLevel` = 51 WHERE `zoneid` = 25 AND `name` = 'Diatryma'; -- *47-51
UPDATE `mob_groups` SET `minLevel` = 50, `maxLevel` = 52 WHERE `zoneid` = 25 AND `name` = 'Upyri'; -- *43-47
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 80 WHERE `zoneid` = 25 AND `name` = 'Gration'; -- *79-79

UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 25 AND `name` = 'Seaboard_Vulture'; -- *

-- PHOMIUNA_AQUEDUCTS (Zone 27)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 48 WHERE `zoneid` = 27 AND `name` = 'Diremite'; -- *42-48
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 48 WHERE `zoneid` = 27 AND `name` = 'Aqueduct_Spider';

-- Address inconsistent respawn times across zone.
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 27 AND `name` IN (
    'Big_Jaw_noaggro',
    'Gloop',
    'Addled_Tumor',
    'Taurus',
    'Vampire_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 27 AND `name` IN (
    'Diremite',
    'Canal_Bats',
    'Hell_Bat',
    'Stegotaur',
    'Fomor_Beastmaster',
    'Makara',
    'Fomor_Dragoon',
    'Fomor_Ninja',
    'Oil_Spill',
    'Fomor_Warrior',
    'Fomor_Thief',
    'Fomor_Summoner',
    'Foul_Meat',
    'Fomor_Paladin',
    'Fomor_Bard',
    'Air_Elemental',
    'Thunder_Elemental',
    'Dark_Elemental',
    'Fomor_Monk',
    'Fomor_Samurai',
    'Fomor_Ranger',
    'Fomor_Dark_Knight',
    'Fomor_Black_Mage',
    'Fomor_Red_Mage',
    'Aqueduct_Spider'
);

-- SACRARIUM (Zone 28)
-----------------------------------
UPDATE `mob_groups` SET `respawntime` = 960, `minLevel` = 57, `maxLevel` = 59 WHERE `zoneid` = 28 AND `name` = 'Aqueduct_Spider';

UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 28 AND `name` IN (
    'Gazer',
    'Greater_Gaylas',
    'Stegotaur'
);

-- RIVERNE_SITE_B01 (Zone 29)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 49, `maxLevel` = 51 WHERE `zoneid` = 29 AND `name` = 'Lesser_Roc'; -- *47-51
UPDATE `mob_groups` SET `minLevel` = 52, `maxLevel` = 55 WHERE `zoneid` = 29 AND `name` = 'Pyrodrake'; -- *50-55
UPDATE `mob_groups` SET `minLevel` = 58, `maxLevel` = 60 WHERE `zoneid` = 29 AND `name` = 'Blazedrake';

-- RIVERNE_SITE_A01 (Zone 30)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 29 AND `name` = 'Darner';

-- DYNAMIS_VALKURM (Zone 39)
-----------------------------------
-- TODO

-- DYNAMIS_BUBURIMU (Zone 40)
-----------------------------------
-- TODO

-- DYNAMIS_QUFIM (Zone 41)
-----------------------------------
-- TODO

-- DYNAMIS_TAVNAZIA (Zone 42)
-----------------------------------
-- TODO

-- ABYSSEA_TAHRONGI (Zone 45)
-----------------------------------
-- TODO

-- WAJAOM_WOODLANDS (Zone 51)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 51 AND `name` = 'Carmine_Eruca'; -- *70
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 75 WHERE `zoneid` = 51 AND `name` = 'Great_Ameretat'; -- *71-75

-- Address inconsistent respawn times across zone.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 51 AND `name` IN (
    'Aht_Urhgan_Attercop',
    'Mamool_Ja_Mimicker',
    'Colorful_Treant',
    'Woodtroll_Dark_Knight',
    'Mamool_Ja_Sophist',
    'Mamool_Ja_Bounder',
    'Mamool_Ja_Savant',
    'Mamool_Ja_Zenist'
);

-- BHAFLAU_THICKETS (Zone 52)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 82 WHERE `zoneid` = 52 AND `name` = 'Locus_Colibri';
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 83 WHERE `zoneid` = 52 AND `name` = 'Locus_Wivre';

-- Address inconsistent respawn times in database.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 52 AND `name` IN (
    'Aht_Urhgan_Attercop',
    'Colorful_Treant',
    'Mamool_Ja_Stabler',
    'Mamool_Ja_Infiltrator',
    'Mamool_Ja_Philosopher',
    'Mamool_Ja_Pikeman',
    'Mamool_Ja_Lurker',
    'Mamool_Ja_Blusterer'
);

-- ARRAPAGO_REEF (Zone 54)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 54 AND `name` = 'Nirgali';
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 54 AND `name` = 'Naraka_Bat';
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 54 AND `name` = 'Dweomershell';
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 54 AND `name` = 'Nostokulshedra';
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 54 AND `name` = 'Lamia_No19'; -- *78-78
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 54 AND `name` = 'Lamie_No9'; -- *80-85
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 89 WHERE `zoneid` = 54 AND `name` = 'Euryale'; -- *87-87
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 54 AND `name` = 'Medusa'; -- *85-85

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 54 AND `name` IN (
    'Arrapago_Apkallu',
    'Purgatory_Bat',
    'Nipper',
    'Heraldic_Imp'
);

-- MOUNT_ZHAYOLM (Zone 61)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 61 AND `name` = 'Wootzshell'; -- *70-71
UPDATE `mob_groups` SET `minLevel` = 71, `maxLevel` = 74 WHERE `zoneid` = 61 AND `name` = 'Magmatic_Eruca'; -- *71-75
UPDATE `mob_groups` SET `minLevel` = 71, `maxLevel` = 74 WHERE `zoneid` = 61 AND `name` = 'Zhayolm_Apkallu'; -- *70-74
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 76 WHERE `zoneid` = 61 AND `name` = 'Assassin_Fly'; -- *71-76
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 78 WHERE `zoneid` = 61 AND `name` = 'Sweeping_Cluster'; -- *73-78
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 61 AND `name` = 'Scoriaceous_Eruca';
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 61 AND `name` = 'Sulphuric_Jagil';
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 61 AND `name` = 'Orichalcumshell';

UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 61 AND `name` = 'Ebony_Pudding'; -- *

-- HALVUNG (Zone 62)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 72, `maxLevel` = 75 WHERE `zoneid` = 62 AND `name` = 'Magmatic_Eruca'; -- *71-75
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 76 WHERE `zoneid` = 62 AND `name` = 'Friars_Lantern'; -- *72-76
UPDATE `mob_groups` SET `minLevel` = 74, `maxLevel` = 76 WHERE `zoneid` = 62 AND `name` = 'Wamouracampa'; -- *72-76
UPDATE `mob_groups` SET `minLevel` = 79, `maxLevel` = 81 WHERE `zoneid` = 62 AND `name` = 'Dahak'; -- *79-79
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 62 AND `name` = 'Gurfurlur_the_Menacing'; -- *85-90
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 75 WHERE `zoneid` = 62 AND `name` IN ( -- *71-75
    'Troll_Gemologist',
    'Troll_Stoneworker',
    'Troll_Lapidarist',
    'Troll_Smelter',
    'Troll_Engraver',
    'Troll_Cameist',
    'Troll_Ironworker'
);
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 83 WHERE `zoneid` = 62 AND `name` IN ( -- *78-83
    'Troll_Artilleryman',
    'Troll_Combatant',
    'Troll_Targeteer',
    'Troll_Machinist',
    'Troll_Scrimer',
    'Troll_Grenadier',
    'Troll_Cuirasser'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 62 AND `name` IN (
    'Volcanic_Bats',
    'Purgatory_Bat',
    'Black_Pudding',
    'Ebony_Pudding',
    'Wamouracampa',
    'Magmatic_Eruca'
);

-- MAMOOK (Zone 65)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 73 WHERE `zoneid` = 65 AND `name` = 'Colibri'; -- *70-71
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 65 AND `name` = 'Gulool_Ja_Ja'; -- *85-88

-- Address inconsistent respawn times in database.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 65 AND `name` IN (
    'Mamool_Ja_Mimicker',
    'Mamool_Ja_Zenist',
    'Mamool_Ja_Savant',
    'Mamool_Ja_Sophist',
    'Mamool_Ja_Bounder',
    'Mamool_Ja_Strapper',
    'Mamool_Ja_Spearman',
    'Mamool_Ja_Frogman',
    'Mamool_Ja_Lurker',
    'Mamool_Ja_Philosopher',
    'Mamool_Ja_Infiltrator',
    'Mamool_Ja_Blusterer',
    'Mamool_Ja_Pikeman',
    'Mamool_Ja_Stabler'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 65 AND `name` IN (
    'Colibri',
    'Carriage_Lizard',
    'Puk_M',
    'Sea_Puk',
    'Nipper',
    'Suhur_Mas'
);

-- AYDEEWA_SUBTERRANE (Zone 68)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 73 WHERE `zoneid` = 68 AND `name` = 'Defoliator'; -- *68-73
UPDATE `mob_groups` SET `minLevel` = 71, `maxLevel` = 74 WHERE `zoneid` = 68 AND `name` = 'Aydeewa_Diremite'; -- *70-74
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 83 WHERE `zoneid` = 68 AND `name` = 'Slime_Eater';
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 82 WHERE `zoneid` = 68 AND `name` = 'Mycoskulker';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 68 AND `name` = 'Deforester';

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 68 AND `name` IN (
    'Treant_Sapling',
    'Puktrap',
    'Qiqirn_Enterpriser',
    'Qiqirn_Lieuter',
    'Defoliator',
    'Qiqirn_Archaeologist',
    'Qiqirn_Mosstrooper',
    'Mold_Eater'
);

-- CAEDARVA_MIRE (Zone 79)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 65 WHERE `zoneid` = 79 AND `name` = 'Marsh_Murre'; -- *64-68
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 68 WHERE `zoneid` = 79 AND `name` = 'Orderly_Imp'; -- *63-68
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 79 AND `name` = 'Jnun'; -- *72-77
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 79 AND `name` = 'Spongilla_Fly'; -- *78-79
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 79 AND `name` = 'Heraldic_Imp'; -- *79-82
UPDATE `mob_groups` SET `minLevel` = 86, `maxLevel` = 88 WHERE `zoneid` = 79 AND `name` = 'Slough_Skua';
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 79 AND `name` = 'Vauxia_Fly';

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 79 AND `name` IN (
    'Qiqirn_Rock_Hound',
    'Qiqirn_Mireguide'
);

-- EAST_RONFAURE_S (Zone 81)
-----------------------------------
-- TODO

-- JUGNER_FOREST_S (Zone 82)
-----------------------------------
-- TODO

-- VUNKERL_INLET_S (Zone 83)
-----------------------------------
-- TODO

-- BATALLIA_DOWNS_S (Zone 84)
-----------------------------------
-- TODO

-- LA_VAULE_S (Zone 85)
-----------------------------------
-- TODO

-- NORTH_GUSTABERG_S (Zone 88)
-----------------------------------
-- TODO

-- GRAUBERG_S (Zone 89)
-----------------------------------
-- TODO

-- PASHHOW_MARSHLANDS_S (Zone 90)
-----------------------------------
-- TODO

-- ROLANBERRY_FIELDS_S (Zone 91)
-----------------------------------
-- TODO

-- BEADEAUX_S (Zone 92)
-----------------------------------
-- TODO

-- WEST_SARUTABARUTA_S (Zone 95)
-----------------------------------
-- TODO

-- FORT_KARUGO_NARUGO_S (Zone 96)
-----------------------------------
-- TODO

-- MERIPHATAUD_MOUNTAINS_S (Zone 97)
-----------------------------------
-- TODO

-- SAUROMUGUE_CHAMPAIGN_S (Zone 98)
-----------------------------------
-- TODO

-- CASTLE_OZTROJA_S (Zone 99)
-----------------------------------
-- TODO

-- WEST_RONFAURE (Zone 100)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 5 WHERE `zoneid` = 100 AND `name` = 'Ding_Bats'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 100 AND `name` = 'Forest_Hare'; -- *1-6
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 100 AND `name` = 'Carrion_Worm'; -- *1-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 7 WHERE `zoneid` = 100 AND `name` = 'Scarab_Beetle'; -- *3-7
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 100 AND `name` IN ( -- *3/4-8
    'Orcish_Fodder',
    'Orcish_Grappler',
    'Orcish_Mesmerizer',
    'Goblin_Thug',
    'Goblin_Weaver'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 100 AND `name` IN (
    'Wild_Rabbit',
    'Tunnel_Worm'
);

-- EAST_RONFAURE (Zone 101)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 5 WHERE `zoneid` = 101 AND `name` = 'Ding_Bats'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 101 AND `name` = 'Forest_Hare'; -- *1-6
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 101 AND `name` = 'Carrion_Worm'; -- *1-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 7 WHERE `zoneid` = 101 AND `name` = 'Scarab_Beetle'; -- *3-7
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 101 AND `name` IN ( -- *3/4-8
    'Orcish_Fodder',
    'Orcish_Grappler',
    'Orcish_Mesmerizer',
    'Goblin_Thug',
    'Goblin_Weaver'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 101 AND `name` IN (
    'Wild_Rabbit',
    'Tunnel_Worm'
);

-- LA_THEINE_PLATEAU (Zone 102)
-----------------------------------
-- Custom level changes.
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 102 AND `name` = 'Rock_Eater'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 9, `maxLevel` = 12 WHERE `zoneid` = 102 AND `name` = 'Huge_Wasp'; -- *8-12
UPDATE `mob_groups` SET `minLevel` = 10, `maxLevel` = 13 WHERE `zoneid` = 102 AND `name` = 'Akbaba'; -- *9-13
UPDATE `mob_groups` SET `minLevel` = 13, `maxLevel` = 16 WHERE `zoneid` = 102 AND `name` IN ( -- *12-16
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);

-- VALKURM_DUNES (Zone 103)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 16, `maxLevel` = 19 WHERE `zoneid` = 103 AND `name` = 'Hill_Lizard'; -- *15-19
UPDATE `mob_groups` SET `minLevel` = 19, `maxLevel` = 22 WHERE `zoneid` = 103 AND `name` = 'Snipper'; -- *18-22
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 22 WHERE `zoneid` = 103 AND `name` = 'Ghoul_war'; -- *18-22
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 22 WHERE `zoneid` = 103 AND `name` = 'Ghoul_blm'; -- *18-22
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 22 WHERE `zoneid` = 103 AND `name` = 'Goblin_Bounty_Hunter'; -- *17-20
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 103 AND `name` = 'Thread_Leech'; -- *21-25

-- JUGNER_FOREST (Zone 104)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 16, `maxLevel` = 18 WHERE `zoneid` = 104 AND `name` = 'Screamer'; -- *15-18
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 104 AND `name` = 'Jugner_Funguar'; -- *21-25
UPDATE `mob_groups` SET `minLevel` = 17, `maxLevel` = 20 WHERE `zoneid` = 104 AND `name` IN ( -- *16-20
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 104 AND `name` IN ( -- *21-25
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);

-- BATALLIA_DOWNS (Zone 105)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 24 WHERE `zoneid` = 105 AND `name` = 'Stalking_Sapling'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 105 AND `name` = 'May_Fly'; -- *22-26
UPDATE `mob_groups` SET `minLevel` = 24, `maxLevel` = 26 WHERE `zoneid` = 105 AND `name` = 'Goblin_Bounty_Hunter'; -- *30-26
UPDATE `mob_groups` SET `minLevel` = 28, `maxLevel` = 31 WHERE `zoneid` = 105 AND `name` = 'Wight_war'; -- *26-36
UPDATE `mob_groups` SET `minLevel` = 29, `maxLevel` = 32 WHERE `zoneid` = 105 AND `name` = 'Sabertooth_Tiger'; -- *28-32
UPDATE `mob_groups` SET `minLevel` = 30, `maxLevel` = 32 WHERE `zoneid` = 105 AND `name` = 'Mauthe_Doog'; -- *28-32

UPDATE `mob_groups` SET `minLevel` = 27, `maxLevel` = 30 WHERE `zoneid` = 105 AND `name` IN ( -- *26-30
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 105 AND `name` IN ( -- *28-36
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman'
);
UPDATE `mob_groups` SET `minLevel` = 33, `maxLevel` = 36 WHERE `zoneid` = 105 AND `name` IN ( -- *30-36
    'Orcish_Impaler',
    'Orcish_Beastrider',
    'Orcish_Nightraider',
    'Orcish_Brawler'
);

-- NORTH_GUSTABERG (Zone 106)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 4 WHERE `zoneid` = 106 AND `name` = 'Ding_Bats'; -- *1-4
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 5 WHERE `zoneid` = 106 AND `name` = 'River_Crab'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 106 AND `name` = 'Stone_Eater'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 106 AND `name` = 'Walking_Sapling'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 6 WHERE `zoneid` = 106 AND `name` = 'Maneating_Hornet'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 7 WHERE `zoneid` = 106 AND `name` = 'Vulture'; -- *2-7
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 106 AND `name` = 'Rock_Lizard'; -- *3-8
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 106 AND `name` IN ( -- *3/4-8
    'Young_Quadav',
    'Amber_Quadav',
    'Amethyst_Quadav',
    'Goblin_Thug',
    'Goblin_Weaver'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 106 AND `name` IN (
    'Huge_Hornet',
    'Tunnel_Worm'
);

-- Address inconsistent respawn times in database.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 106 AND `name` IN (
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);

-- SOUTH_GUSTABERG (Zone 107)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 4 WHERE `zoneid` = 107 AND `name` = 'Ding_Bats'; -- *1-4
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 5 WHERE `zoneid` = 107 AND `name` = 'River_Crab'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 107 AND `name` = 'Stone_Eater'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 107 AND `name` = 'Walking_Sapling'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 6 WHERE `zoneid` = 107 AND `name` = 'Maneating_Hornet'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 7 WHERE `zoneid` = 107 AND `name` = 'Vulture'; -- *2-7
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 107 AND `name` = 'Rock_Lizard'; -- *3-8
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 107 AND `name` IN ( -- *3/4-8
    'Young_Quadav',
    'Amber_Quadav',
    'Amethyst_Quadav',
    'Goblin_Thug',
    'Goblin_Weaver'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 107 AND `name` IN (
    'Huge_Hornet',
    'Tunnel_Worm'
);

-- KONSCHTAT_HIGHLANDS (Zone 108)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 108 AND `name` = 'Strolling_Sapling'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 108 AND `name` = 'Rock_Eater'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 108 AND `name` = 'Huge_Wasp'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 13, `maxLevel` = 16 WHERE `zoneid` = 108 AND `name` IN ( -- *10/12-16
    'Goblin_Ambusher',
    'Goblin_Butcher',
    'Onyx_Quadav',
    'Veteran_Quadav',
    'Greater_Quadav',
    'Goblin_Tinkerer'
);

-- PASHHOW_MARSHLANDS (Zone 109)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 16, `maxLevel` = 18 WHERE `zoneid` = 109 AND `name` = 'Water_Wasp'; -- *15-18
UPDATE `mob_groups` SET `minLevel` = 18, `maxLevel` = 20 WHERE `zoneid` = 109 AND `name` = 'Snipper'; -- *17-20
UPDATE `mob_groups` SET `minLevel` = 18, `maxLevel` = 20 WHERE `zoneid` = 109 AND `name` = 'Land_Pugil'; -- *17-20
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 23 WHERE `zoneid` = 109 AND `name` = 'Bog_Dog'; -- *18-25
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 23 WHERE `zoneid` = 109 AND `name` = 'Ghoul_war'; -- *18-25
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 23 WHERE `zoneid` = 109 AND `name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 23 WHERE `zoneid` = 109 AND `name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 109 AND `name` = 'Marsh_Funguar'; -- *21-25
UPDATE `mob_groups` SET `minLevel` = 17, `maxLevel` = 20 WHERE `zoneid` = 109 AND `name` IN ( -- *16-20
    'Veteran_Quadav',
    'Greater_Quadav',
    'Onyx_Quadav',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 109 AND `name` IN ( -- *21-25
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 109 AND `name` IN ( -- *20-26
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav'
);

-- ROLANBERRY_FIELDS (Zone 110)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 110 AND `name` = 'Death_Wasp'; -- *22-26
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 28 WHERE `zoneid` = 110 AND `name` = 'Berry_Grub'; -- *25-28
UPDATE `mob_groups` SET `minLevel` = 27, `maxLevel` = 30 WHERE `zoneid` = 110 AND `name` IN ( -- *26-30
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 110 AND `name` IN ( -- *30-36
    'Bronze_Quadav',
    'Silver_Quadav',
    'Zircon_Quadav',
    'Garnet_Quadav',
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman',
    'Wight_war',
    'Wight_blm'
);

-- BEAUCEDINE_GLACIER (Zone 111)
-----------------------------------

-- XARCABARD (Zone 112)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 49, `maxLevel` = 52 WHERE `zoneid` = 112 AND `name` IN ( -- *48-52
    'Demon_Pawn',
    'Demon_Wizard',
    'Demon_Knight'
);
UPDATE `mob_groups` SET `minLevel` = 58, `maxLevel` = 58 WHERE `zoneid` = 112 AND `name` IN ( -- *53
    'Boreal_Hound',
    'Boreal_Coeurl',
    'Boreal_Tiger'
);

-- CAPE_TERIGGAN (Zone 113)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 63, `maxLevel` = 65 WHERE `zoneid` = 113 AND `name` = 'Beach_Bunny'; -- *62-65
UPDATE `mob_groups` SET `minLevel` = 63, `maxLevel` = 66 WHERE `zoneid` = 113 AND `name` = 'Sand_Lizard'; -- *62-66
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69 WHERE `zoneid` = 113 AND `name` = 'Terror_Pugil'; -- *66-70
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 70 WHERE `zoneid` = 113 AND `name` = 'Doom_Soldier'; -- *66-70
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 70 WHERE `zoneid` = 113 AND `name` = 'Doom_Mage'; -- *67-71
UPDATE `mob_groups` SET `minLevel` = 71, `maxLevel` = 73 WHERE `zoneid` = 113 AND `name` = 'Sand_Cockatrice'; -- *71-74

-- EASTERN_ALTEPA_DESERT (Zone 114)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 114 AND `name` = 'Giant_Spider'; -- *30-34
UPDATE `mob_groups` SET `minLevel` = 37, `maxLevel` = 40 WHERE `zoneid` = 114 AND `name` = 'Sand_Beetle'; -- *36-40
UPDATE `mob_groups` SET `minLevel` = 39, `maxLevel` = 42 WHERE `zoneid` = 114 AND `name` = 'Flesh_Eater'; -- *37-42
UPDATE `mob_groups` SET `minLevel` = 41, `maxLevel` = 44 WHERE `zoneid` = 114 AND `name` = 'Desert_Dhalmel'; -- *39-44
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 46 WHERE `zoneid` = 114 AND `name` = 'Lost_Soul_war'; -- *44-48
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 46 WHERE `zoneid` = 114 AND `name` = 'Lost_Soul_blm'; -- *44-48
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 39 WHERE `zoneid` = 114 AND `name` IN ( -- *35-39
    'Antican_Auxiliarius',
    'Antican_Funditor',
    'Antican_Faber'
);
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 114 AND `name` IN ( -- *44/45-49
    'Antican_Decurio',
    'Antican_Sagittarius',
    'Antican_Speculator',
    'Goblin_Robber',
    'Goblin_Poacher',
    'Goblin_Reaper',
    'Goblin_Trader',
    'Goblin_Digger'
);

-- WEST_SARUTABARUTA (Zone 115)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 5 WHERE `zoneid` = 115 AND `name` = 'Savanna_Rarab'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 5 WHERE `zoneid` = 115 AND `name` = 'River_Crab'; -- *1-3
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 115 AND `name` = 'Goblin_Fisher'; -- *3-4
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 115 AND `name` = 'Carrion_Crow'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 115 AND `name` = 'Crawler'; -- *3-8
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 115 AND `name` IN ( -- *4-8
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe',
    'Magicked_Bones_war',
    'Magicked_Bones_blm'
);

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 115 AND `name` IN (
    'Tiny_Mandragora',
    'Bumblebee'
);

-- EAST_SARUTABARUTA (Zone 116)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 2, `maxLevel` = 5 WHERE `zoneid` = 116 AND `name` = 'Savanna_Rarab'; -- *1-5
UPDATE `mob_groups` SET `minLevel` = 3, `maxLevel` = 6 WHERE `zoneid` = 116 AND `name` = 'River_Crab'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 7 WHERE `zoneid` = 116 AND `name` = 'Pug_Pugil'; -- *4-8
UPDATE `mob_groups` SET `minLevel` = 6, `maxLevel` = 8 WHERE `zoneid` = 116 AND `name` = 'Goblin_Fisher'; -- *4-8
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 116 AND `name` IN ( -- *1/3-8
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe',
    'Goblin_Thug',
    'Goblin_Weaver',
    'Mad_Fox',
    'Magicked_Bones_war',
    'Magicked_Bones_blm'
);
UPDATE `mob_groups` SET `minLevel` = 10, `maxLevel` = 12, `HP` = 0, `MP` = 200 WHERE `zoneid` = 116 AND `name` = 'Duke_Decapod'; -- *8-8

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 116 AND `name` IN (
    'Tiny_Mandragora',
    'Bumblebee'
);

-- TAHRONGI_CANYON (Zone 117)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 117 AND `name` = 'Canyon_Rarab'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 8, `maxLevel` = 11 WHERE `zoneid` = 117 AND `name` = 'Strolling_Sapling'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 9, `maxLevel` = 11 WHERE `zoneid` = 117 AND `name` = 'Pygmaioi'; -- *7-11
UPDATE `mob_groups` SET `minLevel` = 10, `maxLevel` = 13 WHERE `zoneid` = 117 AND `name` = 'Akbaba'; -- *9-13
UPDATE `mob_groups` SET `minLevel` = 13, `maxLevel` = 16 WHERE `zoneid` = 117 AND `name` IN ( -- *12-16
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor'
);
UPDATE `mob_groups` SET `minLevel` = 29, `maxLevel` = 31 WHERE `zoneid` = 117 AND `name` = 'Herbage_Hunter'; -- *29-29

-- BUBURIMU_PENINSULA (Zone 118)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 16, `maxLevel` = 19 WHERE `zoneid` = 118 AND `name` = 'Sylvestre'; -- *15-19
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 22 WHERE `zoneid` = 118 AND `name` = 'Zombie_war'; -- *18-22
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 23 WHERE `zoneid` = 118 AND `name` = 'Goblin_Bounty_Hunter'; -- *17-20
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 23 WHERE `zoneid` = 118 AND `name` = 'Snipper'; -- *18-23
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 24 WHERE `zoneid` = 118 AND `name` = 'Zu'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 24 WHERE `zoneid` = 118 AND `name` = 'Bull_Dhalmel'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 24 WHERE `zoneid` = 118 AND `name` = 'Ghoul_blm'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 118 AND `name` = 'Poison_Leech'; -- *21-25
UPDATE `mob_groups` SET `minLevel` = 24, `maxLevel` = 26 WHERE `zoneid` = 118 AND `name` = 'Shoal_Pugil'; -- *24-28
UPDATE `mob_groups` SET `minLevel` = 18, `maxLevel` = 20 WHERE `zoneid` = 118 AND `name` IN ( -- *17-20
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);

-- MERIPHATAUD_MOUNTAINS (Zone 119)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 14, `maxLevel` = 16 WHERE `zoneid` = 119 AND `name` = 'Wandering_Sapling'; -- *13-16
UPDATE `mob_groups` SET `minLevel` = 19, `maxLevel` = 21 WHERE `zoneid` = 119 AND `name` = 'Zombie_war'; -- *16-26
UPDATE `mob_groups` SET `minLevel` = 19, `maxLevel` = 21 WHERE `zoneid` = 119 AND `name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 22 WHERE `zoneid` = 119 AND `name` = 'Scavenging_Hound'; -- *18-25
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 119 AND `name` = 'Coeurl'; -- *22-26
UPDATE `mob_groups` SET `minLevel` = 17, `maxLevel` = 20 WHERE `zoneid` = 119 AND `name` IN ( -- *16-20
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor'
);
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 119 AND `name` IN ( -- *21-25
    'Raptor',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
UPDATE `mob_groups` SET `minLevel` = 53, `maxLevel` = 55, `HP` = 5000 WHERE `zoneid` = 119 AND `name` = 'Chonchon'; -- *42-42

-- SAUROMUGUE_CHAMPAIGN (Zone 120)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 24 WHERE `zoneid` = 120 AND `name` = 'Midnight_Wings'; -- *20-24
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 120 AND `name` = 'Hill_Lizard'; -- *22-26
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 28 WHERE `zoneid` = 120 AND `name` = 'Diving_Beetle'; -- *25-28
UPDATE `mob_groups` SET `minLevel` = 29, `maxLevel` = 32 WHERE `zoneid` = 120 AND `name` = 'Sauromugue_Skink'; -- *28-32
UPDATE `mob_groups` SET `minLevel` = 30, `maxLevel` = 32 WHERE `zoneid` = 120 AND `name` = 'Goblin_Digger'; -- *28-32
UPDATE `mob_groups` SET `minLevel` = 30, `maxLevel` = 32 WHERE `zoneid` = 120 AND `name` = 'Wight_war'; -- *26-36
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 120 AND `name` = 'Champaign_Coeurl'; -- *30-34
UPDATE `mob_groups` SET `minLevel` = 27, `maxLevel` = 30 WHERE `zoneid` = 120 AND `name` IN ( -- *26-30
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_groups` SET `minLevel` = 33, `maxLevel` = 36 WHERE `zoneid` = 120 AND `name` IN ( -- *30-36
    'Yagudo_Herald',
    'Yagudo_Drummer',
    'Yagudo_Oracle',
    'Yagudo_Interrogator',
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman'
);

-- THE_SANCTUARY_OF_ZITAH (Zone 121)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 41, `maxLevel` = 43 WHERE `zoneid` = 121 AND `name` = 'Goobbue_Gardener'; -- *40-43
UPDATE `mob_groups` SET `minLevel` = 42, `maxLevel` = 44 WHERE `zoneid` = 121 AND `name` = 'Ogrefly'; -- *41-44
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 46 WHERE `zoneid` = 121 AND `name` = 'Myxomycete'; -- *41-46
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 47 WHERE `zoneid` = 121 AND `name` = 'Master_Coeurl'; -- *44-47
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 48 WHERE `zoneid` = 121 AND `name` = 'Hell_Hound'; -- *46-50
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 121 AND `name` = 'Rot_Prowler'; -- *49-53
UPDATE `mob_groups` SET `minLevel` = 47, `maxLevel` = 49 WHERE `zoneid` = 121 AND `name` = 'Lost_Soul_blm'; -- *51-55
UPDATE `mob_groups` SET `minLevel` = 27, `maxLevel` = 29 WHERE `zoneid` = 121 AND `name` IN ( -- *25-29
    'Goblin_Mugger',
    'Goblin_Gambler',
    'Goblin_Leecher'
);
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 46 WHERE `zoneid` = 121 AND `name` IN ( -- *42-46
    'Goblin_Robber',
    'Goblin_Trader',
    'Goblin_Poacher',
    'Goblin_Reaper'
);

-- ROMAEVE (Zone 122)
-----------------------------------

-- YUHTUNGA_JUNGLE (Zone 123)
-----------------------------------

-- YHOATOR_JUNGLE (Zone 124)
-----------------------------------
