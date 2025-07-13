-----------------------------------
-- Monster level and respawn overrides
-- Does not restore Era functionality
-- Public module for ZenithXI
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
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69, `dropid` = 93, `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Ghost_Crab';
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 83, `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Bight_Rarab';
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 84, `HP` = 0  WHERE `zoneid` = 4 AND `name` = 'Locus_Hypnos_Eft';
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85, `HP` = 0  WHERE `zoneid` = 4 AND `name` = 'Locus_Camelopard';

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
-- Out of Era
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 25 AND `name` = 'Seaboard_Vulture';

-- PHOMIUNA_AQUEDUCTS (Zone 27)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 48 WHERE `zoneid` = 27 AND `name` = 'Diremite'; -- *42-48
-- Out of Era
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
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 58, `maxLevel` = 60 WHERE `zoneid` = 29 AND `name` = 'Blazedrake';

-- RIVERNE_SITE_A01 (Zone 30)
-----------------------------------
-- Out of Era
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
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 51 AND `name` = 'Hydra'; -- *80-80

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
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 54 AND `name` = 'Lamia_No19'; -- *78-78
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 54 AND `name` = 'Lamie_No9'; -- *80-85
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 89 WHERE `zoneid` = 54 AND `name` = 'Euryale'; -- *87-87
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 54 AND `name` = 'Medusa'; -- *85-85
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 54 AND `name` = 'Nirgali';
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 54 AND `name` = 'Naraka_Bat';
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 54 AND `name` = 'Dweomershell';
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 54 AND `name` = 'Nostokulshedra';

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
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 61 AND `name` = 'Cerberus'; -- *85-85
-- Out of Era
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
-- Out of Era
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
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 79 AND `name` = 'Khimaira'; -- *85-85
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 79 AND `name` = 'Vauxia_Fly';
UPDATE `mob_groups` SET `minLevel` = 86, `maxLevel` = 88 WHERE `zoneid` = 79 AND `name` = 'Slough_Skua';

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
UPDATE `mob_groups` SET `minLevel` = 62, `maxLevel` = 64 WHERE `zoneid` = 122 AND `name` = 'Killing_Weapon'; -- *60-64
UPDATE `mob_groups` SET `minLevel` = 62, `maxLevel` = 65 WHERE `zoneid` = 122 AND `name` = 'Ominous_Weapon'; -- *61-65
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 68 WHERE `zoneid` = 122 AND `name` = 'Magic_Flagon'; -- *64-69
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69 WHERE `zoneid` = 122 AND `name` = 'Cursed_Puppet'; -- *65-69
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 122 AND `name` = 'Shikigami_Weapon'; -- *77-80

-- YUHTUNGA_JUNGLE (Zone 123)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 30, `maxLevel` = 33 WHERE `zoneid` = 123 AND `name` = 'Yuhtunga_Mandragora'; -- *29-33
UPDATE `mob_groups` SET `minLevel` = 32, `maxLevel` = 35 WHERE `zoneid` = 123 AND `name` = 'Goblin_Smithy'; -- *32-37
UPDATE `mob_groups` SET `minLevel` = 34, `maxLevel` = 37 WHERE `zoneid` = 123 AND `name` = 'Death_Jacket'; -- *33-37
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 37 WHERE `zoneid` = 123 AND `name` = 'Goblin_Furrier'; -- *32-37
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 38 WHERE `zoneid` = 123 AND `name` = 'Makara'; -- *35-38
UPDATE `mob_groups` SET `minLevel` = 38, `maxLevel` = 41 WHERE `zoneid` = 123 AND `name` = 'Soldier_Crawler'; -- *37-41
UPDATE `mob_groups` SET `minLevel` = 38, `maxLevel` = 41 WHERE `zoneid` = 123 AND `name` = 'Goblin_Reaper'; -- *42-47
UPDATE `mob_groups` SET `minLevel` = 39, `maxLevel` = 42 WHERE `zoneid` = 123 AND `name` = 'Goblin_Robber'; -- *42-47
UPDATE `mob_groups` SET `minLevel` = 39, `maxLevel` = 42 WHERE `zoneid` = 123 AND `name` = 'Goblin_Poacher'; -- *42-47
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 38 WHERE `zoneid` = 123 AND `name` IN ( -- *34-38
    'Creek_Sahagin',
    'River_Sahagin',
    'Stream_Sahagin'
);

-- YHOATOR_JUNGLE (Zone 124)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 38, `maxLevel` = 41 WHERE `zoneid` = 124 AND `name` = 'Goblin_Reaper'; -- *41-45
UPDATE `mob_groups` SET `minLevel` = 42, `maxLevel` = 44 WHERE `zoneid` = 124 AND `name` = 'Young_Opo-opo'; -- *40-44
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 124 AND `name` = 'Big_Jaw'; -- *43-47
UPDATE `mob_groups` SET `minLevel` = 52, `maxLevel` = 55 WHERE `zoneid` = 124 AND `name` = 'Goblin_Bouncer'; -- *51-55
UPDATE `mob_groups` SET `minLevel` = 52, `maxLevel` = 55 WHERE `zoneid` = 124 AND `name` = 'Goblin_Hunter'; -- *51-55
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 38 WHERE `zoneid` = 124 AND `name` IN ( -- *35-39
    'Goblin_Smithy',
    'Goblin_Pathfinder',
    'Goblin_Shaman'
);
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 48 WHERE `zoneid` = 124 AND `name` IN ( -- *45-49
    'Goblin_Robber',
    'Goblin_Trader',
    'Goblin_Poacher',
    'Tonberry_Creeper',
    'Tonberry_Hexer',
    'Tonberry_Harasser'
);

-- WESTERN_ALTEPA_DESERT (Zone 125)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 41, `maxLevel` = 44 WHERE `zoneid` = 125 AND `name` = 'Desert_Spider'; -- *40-44
UPDATE `mob_groups` SET `minLevel` = 42, `maxLevel` = 45 WHERE `zoneid` = 125 AND `name` = 'Antican_Essedarius'; -- *41-45
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 46 WHERE `zoneid` = 125 AND `name` = 'Desert_Worm'; -- *43-47
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 48 WHERE `zoneid` = 125 AND `name` = 'Desert_Dhalmel'; -- *44-48
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 125 AND `name` = 'Antican_Retiarius'; -- *45-49
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 125 AND `name` = 'Antican_Eques'; -- *45-49
UPDATE `mob_groups` SET `minLevel` = 48, `maxLevel` = 51 WHERE `zoneid` = 125 AND `name` = 'Desert_Beetle'; -- *47-51
UPDATE `mob_groups` SET `minLevel` = 50, `maxLevel` = 53 WHERE `zoneid` = 125 AND `name` = 'Cactuar'; -- *48-53
UPDATE `mob_groups` SET `minLevel` = 54, `maxLevel` = 57 WHERE `zoneid` = 125 AND `name` = 'Desert_Manticore'; -- *53-57
UPDATE `mob_groups` SET `minLevel` = 52, `maxLevel` = 55 WHERE `zoneid` = 125 AND `name` IN ( -- *51-55
    'Goblin_Welldigger',
    'Goblin_Bouncer',
    'Goblin_Enchanter',
    'Goblin_Hunter',
    'Goblin_Digger'
);
UPDATE `mob_groups` SET `minLevel` = 54, `maxLevel` = 57 WHERE `zoneid` = 125 AND `name` IN ( -- *54-58
    'Antican_Secutor',
    'Antican_Lanista',
    'Antican_Hoplomachus'
);
UPDATE `mob_groups` SET `minLevel` = 61, `maxLevel` = 63 WHERE `zoneid` = 125 AND `name` = 'Dahu'; -- *57-57
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 85 WHERE `zoneid` = 125 AND `name` = 'King_Vinegarroon'; -- *80-85

UPDATE `mob_groups` SET `HP` = 2500 WHERE `zoneid` = 125 AND `name` = 'Celphie';

-- QUFIM_ISLAND (Zone 126)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 29 WHERE `zoneid` = 126 AND `name` = 'Clipper'; -- *25-29
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 23 WHERE `zoneid` = 126 AND `groupid` = 15 AND `name` = 'Gigass_Leech'; -- *21-30

-- BEHEMOTHS_DOMINION (Zone 127)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 46 WHERE `zoneid` = 127 AND `name` = 'Demonic_Weapon'; -- *45-46
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 127 AND `name` = 'Lost_Soul_blm'; -- *45-47
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 127 AND `name` = 'Lost_Soul_war'; -- *45-47
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 47 WHERE `zoneid` = 127 AND `name` = 'Master_Coeurl'; -- *45-50
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 127 AND `name` = 'Behemoth'; -- *70-70
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 127 AND `name` = 'King_Behemoth'; -- *85-85

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 127 AND `name` IN (
    'Lesser_Gaylas',
    'Greater_Gayla',
    'Demonic_Weapon',
    'Master_Coeurl',
    'Lost_Soul_war'
);

-- VALLEY_OF_SORROWS (Zone 128)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 70 WHERE `zoneid` = 128 AND `name` = 'Velociraptor'; -- *66-69
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 128 AND `name` = 'Adamantoise'; -- *70-70

-- RUAUN_GARDENS (Zone 130)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 130 AND `name` = 'Despot'; -- *80-82
UPDATE `mob_groups` SET `minLevel` = 90, `maxLevel` = 92 WHERE `zoneid` = 130 AND `name` IN ( -- *88-90
    'Genbu',
    'Seiryu',
    'Byakko',
    'Suzaku'
);

-- ABYSSEA_LA_THEINE (Zone 132)
-----------------------------------
-- TODO

-- DYNAMIS_BEAUCEDINE (Zone 134)
-----------------------------------
-- Beastmen Tier 1 - 75-77 -- Unchanged
-- Hydra Tier 1 - 77-80 -- Era
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 159 AND `name` = 'Hydra_Warrior';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 160 AND `name` = 'Hydra_Monk';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 161 AND `name` = 'Hydra_White_Mage';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 162 AND `name` = 'Hydra_Red_Mage';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 164 AND `name` = 'Hydra_Black_Mage';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 165 AND `name` = 'Hydra_Thief';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 166 AND `name` = 'Hydra_Paladin';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 167 AND `name` = 'Hydra_Dark_Knight';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 168 AND `name` = 'Hydra_Beastmaster';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 169 AND `name` = 'Hydras_Hound';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 170 AND `name` = 'Hydra_Bard';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 171 AND `name` = 'Hydra_Ranger';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 172 AND `name` = 'Hydra_Samurai';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 173 AND `name` = 'Hydra_Ninja';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 174 AND `name` = 'Hydra_Dragoon';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 175 AND `name` = 'Hydras_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 176 AND `name` = 'Hydra_Summoner';
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 134 AND `groupid` = 177 AND `name` = 'Hydras_Avatar';
-- Tier 2 - 85-87
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 134 AND `groupid` = 32 AND `name` = 'Vanguard_Vindicator';
-- Hydra Tier 2 - 87-90
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 178 AND `name` = 'Hydra_Beastmaster';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 179 AND `name` = 'Hydras_Hound';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 180 AND `name` = 'Hydra_Thief';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 181 AND `name` = 'Hydra_Dark_Knight';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 183 AND `name` = 'Hydra_Warrior';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 184 AND `name` = 'Hydra_Bard';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 185 AND `name` = 'Hydra_Ranger';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 186 AND `name` = 'Hydra_White_Mage';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 187 AND `name` = 'Hydra_Monk';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 188 AND `name` = 'Hydra_Ninja';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 189 AND `name` = 'Hydra_Summoner';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 190 AND `name` = 'Hydras_Avatar';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 191 AND `name` = 'Hydra_Black_Mage';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 192 AND `name` = 'Hydra_Dragoon';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 193 AND `name` = 'Hydras_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 194 AND `name` = 'Hydra_Red_Mage';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 195 AND `name` = 'Hydra_Paladin';
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 90 WHERE `zoneid` = 134 AND `groupid` = 196 AND `name` = 'Hydra_Samurai';
-- TODO: OoE force spawn NMs

-- DYNAMIS_XARCABARD (Zone 135)
-----------------------------------
-- Tier 1 Kindred - 77-80 -- Unchanged
-- Tier 2 Kindred - 88-90
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 90 AND `name` = 'Kindred_Warrior';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 91 AND `name` = 'Kindred_White_Mage';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 92 AND `name` = 'Kindred_Red_Mage';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 94 AND `name` = 'Kindred_Monk';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 95 AND `name` = 'Kindred_Black_Mage';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 96 AND `name` = 'Kindred_Thief';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 97 AND `name` = 'Kindred_Paladin';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 98 AND `name` = 'Kindred_Dark_Knight';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 99 AND `name` = 'Kindred_Beastmaster';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 100 AND `name` = 'Kindreds_Vouivre';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 101 AND `name` = 'Kindred_Bard';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 102 AND `name` = 'Kindred_Ranger';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 103 AND `name` = 'Kindred_Samurai';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 104 AND `name` = 'Kindred_Ninja';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 105 AND `name` = 'Kindred_Dragoon';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 106 AND `name` = 'Kindreds_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 107 AND `name` = 'Kindred_Summoner';
UPDATE `mob_groups` SET `minLevel` = 88, `maxLevel` = 90 WHERE `zoneid` = 135 AND `groupid` = 108 AND `name` = 'Kindreds_Avatar';
-- Satelite Weapons
UPDATE `mob_groups` SET `minLevel` = 77, `maxLevel` = 80 WHERE `zoneid` = 135 AND `name` IN ( -- *77-79
    'Satellite_Shield',
    'Satellite_Guns',
    'Satellite_Horns',
    'Satellite_Tachi',
    'Satellite_Kunai',
    'Satellite_Spears',
    'Satellite_Scythes',
    'Satellite_Great_Axes',
    'Satellite_Tabars',
    'Satellite_Claymores',
    'Satellite_Longswords',
    'Satellite_Staves',
    'Satellite_Hammers',
    'Satellite_Knuckles',
    'Satellite_Daggers',
    'Satellite_Longbows'
);
-- TODO: OoE force spawn NMs

-- BEAUCEDINE_GLACIER_S (Zone 136)
-----------------------------------
-- TODO

-- XARCABARD_S (Zone 137)
-----------------------------------
-- TODO

-- CASTLE_ZVAHL_BAILEYS_S (Zone 138)
-----------------------------------
-- TODO

-- GHELSBA_OUTPOST (Zone 140)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 7, `maxLevel` = 9 WHERE `zoneid` = 140 AND `name` IN ( -- *3-9
    'Orcish_Fodder',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);
UPDATE `mob_groups` SET `minLevel` = 12, `maxLevel` = 15 WHERE `zoneid` = 140 AND `name` IN ( -- *11-15
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 140 AND `name` IN (
    'Orcish_Fodder',
    'Orcish_Mesmerizer',
    'Orcish_Grappler',
    'Spectacled_Bats',
    'Orcish_Stonelauncher',
    'Orcish_Grunt',
    'Watch_Lizard',
    'Toadstool',
    'Cheiroptera',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Ghelsba_Pugil'
);

-- FORT_GHELSBA (Zone 141)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 14, `maxLevel` = 17 WHERE `zoneid` = 141 AND `name` IN ( -- *11-17
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 141 AND `name` IN (
    'Orcish_Fodder',
    'Orcish_Mesmerizer',
    'Orcish_Grappler',
    'Spectacled_Bats',
    'Cheiroptera',
    'Orcish_Flamethrower',
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Sentry_Lizard',
    'Toadstool',
    'Ghelsba_Pugil'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 141 AND `name` IN (
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);

-- YUGHOTT_GROTTO (Zone 142)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 15, `maxLevel` = 18 WHERE `zoneid` = 142 AND `name` IN ( -- *14-18
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 142 AND `name` IN (
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Grotto_Bats',
    'Riding_Lizard',
    'Stealth_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 142 AND `name` IN (
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);

-- PALBOROUGH_MINES (Zone 143)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 4, `maxLevel` = 6 WHERE `zoneid` = 143 AND `name` = 'Pit_Hare'; -- *2-6
UPDATE `mob_groups` SET `minLevel` = 10, `maxLevel` = 12 WHERE `zoneid` = 143 AND `name` = 'Copper_Beetle'; -- *9-12
UPDATE `mob_groups` SET `minLevel` = 7, `maxLevel` = 10 WHERE `zoneid` = 143 AND `name` IN ( -- *3-10
    'Young_Quadav',
    'Amethyst_Quadav',
    'Amber_Quadav'
);
UPDATE `mob_groups` SET `minLevel` = 14, `maxLevel` = 18 WHERE `zoneid` = 143 AND `name` IN ( -- *11-18
    'Young_Quadav',
    'Amethyst_Quadav',
    'Amber_Quadav'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 143 AND `name` IN (
    'Young_Quadav',
    'Amethyst_Quadav',
    'Amber_Quadav',
    'Pit_Hare',
    'Cave_Funguar',
    'Veteran_Quadav',
    'Greater_Quadav',
    'Onyx_Quadav',
    'Copper_Beetle',
    'Mine_Scorpion',
    'Rabid_Rat',
    'Scimitar_Scorpion'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 143 AND `name` IN (
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav'
);

-- GIDDEUS (Zone 145)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 12, `maxLevel` = 14 WHERE `zoneid` = 145 AND `name` = 'Giant_Pugil'; -- *9-11
UPDATE `mob_groups` SET `minLevel` = 12, `maxLevel` = 14 WHERE `zoneid` = 145 AND `name` = 'Digger_Wasp'; -- *11-13
UPDATE `mob_groups` SET `minLevel` = 7, `maxLevel` = 10 WHERE `zoneid` = 145 AND `name` IN ( -- *3-10
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe'
);
UPDATE `mob_groups` SET `minLevel` = 15, `maxLevel` = 18 WHERE `zoneid` = 145 AND `name` IN ( -- *11-18
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 145 AND `name` IN (
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe',
    'Giddeus_Bee',
    'Giddeus_Pugil',
    'Dirt_Eater',
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor',
    'Digger_Wasp',
    'Giant_Pugil',
    'Earth_Eater'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 145 AND `name` IN (
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 145 AND `name` IN ( -- *
    'Eyy_Mon_the_Ironbreaker',
    'Zhuu_Buxu_the_Silent'
);

-- BEADEAUX (Zone 147)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 25, `maxLevel` = 28 WHERE `zoneid` = 147 AND `name` IN ( -- *22-26/27/28
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav'
);
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 39 WHERE `zoneid` = 147 AND `name` IN ( -- *32/33/34/35-36/37/38/39
    'Silver_Quadav',
    'Garnet_Quadav',
    'Zircon_Quadav',
    'Bronze_Quadav'
);
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 49 WHERE `zoneid` = 147 AND `name` IN ( -- *42/43/44/45-46/47/48/49
    'Silver_Quadav',
    'Garnet_Quadav',
    'Zircon_Quadav',
    'Bronze_Quadav'
);
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 59 WHERE `zoneid` = 147 AND `name` IN ( -- *52/53/54/55-56/57/58/59
    'Steel_Quadav',
    'Mythril_Quadav',
    'Gold_Quadav',
    'Topaz_Quadav'
);
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 69 WHERE `zoneid` = 147 AND `name` IN ( -- *62/63/64/65-66/67/68/69
    'Ancient_Quadav',
    'Darksteel_Quadav',
    'Platinum_Quadav',
    'Sapphire_Quadav'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 147 AND `name` IN (
    'Old_Quadav',
    'Copper_Quadav',
    'Land_Pugil',
    'Brass_Quadav',
    'Ooze',
    'Caterpillar',
    'Charging_Sheep'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 147 AND `name` IN (
    'Silver_Quadav',
    'Garnet_Quadav',
    'Zircon_Quadav',
    'Broo',
    'Gloop',
    'Big_Jaw',
    'Larva'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 147 AND `name` IN (
    'Thunder_Elemental',
    'Water_Elemental',
    'Elder_Quadav',
    'Iron_Quadav',
    'Spinel_Quadav',
    'Emerald_Quadav',
    'Elder_Quadav',
    'Charging_Sheep'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 147 AND `name` IN ( -- *
    'GoBhu_Gascon',
    'DeVyu_Headhunter'
);
-- QULUN_DOME (Zone 148)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 148 AND `name` = 'Diamond_Quadav'; -- *75-75
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 148 AND `name` = 'ZaDha_Adamantking'; -- *85-85

-- DAVOI (Zone 149)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 25, `maxLevel` = 28 WHERE `zoneid` = 149 AND `name` IN ( -- *22-26/27/28
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 39 WHERE `zoneid` = 149 AND `name` IN ( -- *32/33/34/35-36/37/38/39
    'Orcish_Impaler',
    'Orcish_Beastrider',
    'Orcish_Nightraider',
    'Orcish_Brawler'
);
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 49 WHERE `zoneid` = 149 AND `name` IN ( -- *42/43/44/45-46/47/48/49
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper'
);
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 59 WHERE `zoneid` = 149 AND `name` IN ( -- *52/53/54/55-56/57/58/59
    'Orcish_Veteran',
    'Orcish_Predator',
    'Orcish_Zerker',
    'Orcish_Warchief'
);
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 69 WHERE `zoneid` = 149 AND `name` IN ( -- *62/63/64/65-66/67/68/69
    'Orcish_Dreadnought',
    'Orcish_Farkiller',
    'Orcish_Champion',
    'Orcish_Dragoon'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 149 AND `name` IN (
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Davoi_Hornet',
    'Orcish_Serjeant',
    'Wood_Bats',
    'Wolf_Bat',
    'Davoi_Pugil'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 149 AND `name` IN (
    'Orcish_Impaler',
    'Orcish_Beastrider',
    'Orcish_Nightraider',
    'Orcish_Brawler',
    'War_Lizard',
    'Davoi_Wasp',
    'Geezard',
    'Morbol',
    'Davoi_Mush'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 149 AND `name` IN (
    'Thunder_Elemental',
    'Orcish_Firebelcher',
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper',
    'Water_Elemental'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime` = 600 WHERE `zoneid` = 149 AND `name` = 'Dirtyhanded_Gochakzuk'; -- *

-- MONASTIC_CAVERN (Zone 150)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 49 WHERE `zoneid` = 150 AND `name` IN ( -- *42/43/44/45-46/47/48/49
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper'
);
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 59 WHERE `zoneid` = 150 AND `name` IN ( -- *52/53/54/55-56/57/58/59
    'Orcish_Veteran',
    'Orcish_Predator',
    'Orcish_Zerker',
    'Orcish_Warchief'
);
UPDATE `mob_groups` SET `minLevel` = 69, `maxLevel` = 72 WHERE `zoneid` = 150 AND `name` IN ( -- *62/63/64/65-72
    'Orcish_Farkiller',
    'Orcish_Dreadnought',
    'Orcish_Champion',
    'Orcish_Dragoon'
);
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 150 AND `name` = 'Orcish_Overlord'; -- *75-75
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 150 AND `name` = 'Overlord_Bakgodek'; -- *85-85

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 150 AND `name` IN (
    'Thunder_Elemental',
    'Orcish_Firebelcher',
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper'
);

-- CASTLE_OZTROJA (Zone 151)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 25, `maxLevel` = 28 WHERE `zoneid` = 151 AND `name` IN ( -- *22/23-26/27/28
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 39 WHERE `zoneid` = 151 AND `name` IN ( -- *32/33/34/35-36/37/38/39
    'Yagudo_Herald',
    'Yagudo_Oracle',
    'Yagudo_Interrogator',
    'Yagudo_Drummer'
);
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 49 WHERE `zoneid` = 151 AND `name` IN ( -- *42/43/44/45-46/47/48/49
    'Yagudo_Zealot',
    'Yagudo_Prior',
    'Yagudo_Conquistador',
    'Yagudo_Lutenist'
);
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 59 WHERE `zoneid` = 151 AND `name` IN ( -- *51/53/54-56/57/59
    'Yagudo_Sentinel',
    'Yagudo_Abbot',
    'Yagudo_Chanter',
    'Yagudo_Inquisitor'
);
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 72 WHERE `zoneid` = 151 AND `name` IN ( -- *62/63/64/65-66/67/69/72
    'Yagudo_Flagellant',
    'Yagudo_Prelate',
    'Yagudo_Conductor',
    'Yagudo_Assassin'
);
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 151 AND `name` = 'Yagudo_Avatar'; -- *75-75
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 151 AND `name` = 'Tzee_Xicu_the_Manifest'; -- *85-85

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 151 AND `name` IN (
    'Yagudo_Votary',
    'Bastion_Bats',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 151 AND `name` IN (
    'Yagudo_Herald',
    'Yagudo_Oracle',
    'Yagudo_Interrogator',
    'Meat_Maggot',
    'Yagudo_Drummer',
    'Cutter',
    'Bulwark_Bat',
    'Ooze'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 151 AND `name` IN (
    'Fire_Elemental',
    'Earth_Elemental',
    'Yagudo_Zealot',
    'Yagudo_Prior',
    'Yagudo_Conquistador',
    'Yagudo_Lutenist',
    'Yagudo_Parasite'
);

-- THE_BOYAHDA_TREE (Zone 153)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 62, `maxLevel` = 65 WHERE `zoneid` = 153 AND `name` = 'Robber_Crab'; -- *62-66
UPDATE `mob_groups` SET `minLevel` = 63, `maxLevel` = 66 WHERE `zoneid` = 153 AND `name` = 'Moss_Eater'; -- *62-66
UPDATE `mob_groups` SET `minLevel` = 64, `maxLevel` = 67 WHERE `zoneid` = 153 AND `name` = 'Knight_Crawler'; -- *62-67
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 68 WHERE `zoneid` = 153 AND `name` = 'Mourioche'; -- *62-68
UPDATE `mob_groups` SET `minLevel` = 72, `maxLevel` = 74 WHERE `zoneid` = 153 AND `name` = 'Unut'; -- *72-72
UPDATE `mob_groups` SET `minLevel` = 76, `maxLevel` = 79 WHERE `zoneid` = 153 AND `name` = 'Bark_Tarantula'; -- *75-79
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 153 AND `name` = 'Voluptuous_Vivian'; -- *85-85
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 85 WHERE `zoneid` = 153 AND `name` = 'Snaggletooth_Peapuk'; -- *102-105
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 85 WHERE `zoneid` = 153 AND `name` = 'Viseclaw'; -- *102-105
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 153 AND `name` = 'Mourning_Crawler'; -- *103-105

-- DRAGONS_AERY (Zone 154)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 90, `maxLevel` = 92 WHERE `zoneid` = 154 AND `name` = 'Fafnir'; -- *90-90
UPDATE `mob_groups` SET `minLevel` = 92, `maxLevel` = 94 WHERE `zoneid` = 154 AND `name` = 'Nidhogg'; -- *90-90

-- CASTLE_ZVAHL_KEEP_S (Zone 155)
-----------------------------------
-- TODO

-- MIDDLE_DELKFUTTS_TOWER (Zone 157)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 29 WHERE `zoneid` = 157 AND `name` = 'Mold_Bats'; -- *25-27
UPDATE `mob_groups` SET `minLevel` = 28, `maxLevel` = 30 WHERE `zoneid` = 157 AND `name` = 'Tower_Bats'; -- *27-29
UPDATE `mob_groups` SET `minLevel` = 28, `maxLevel` = 30 WHERE `zoneid` = 157 AND `name` = 'Stirge'; -- *27-29
UPDATE `mob_groups` SET `minLevel` = 30, `maxLevel` = 32 WHERE `zoneid` = 157 AND `name` = 'Big_Bat'; -- *29-31
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 157 AND `name` IN ( -- *30-34
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman'
);
UPDATE `mob_groups` SET `minLevel` = 31, `maxLevel` = 34 WHERE `zoneid` = 157 AND `name` IN ( -- *30-32
    'Giant_Gatekeeper',
    'Giant_Guard',
    'Giant_Sentry',
    'Giant_Lobber'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 157 AND `name` IN (
    'Mold_Bats',
    'Stirge',
    'Magic_Pot',
    'Tower_Bats'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 157 AND `name` IN (
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman',
    'Giant_Gatekeeper',
    'Giant_Guard',
    'Giant_Sentry',
    'Giant_Lobber',
    'Panzer_Doll',
    'Banshee',
    'Evil_Spirit',
    'Thunder_Elemental',
    'Light_Elemental',
    'Big_Bat',
    'Magic_Jar',
    'Gigas_Wallwatcher',
    'Gigas_Jailer',
    'Gigas_Kettlemaster',
    'Gigas_Quarrier',
    'Jagd_Doll'
);

-- UPPER_DELKFUTTS_TOWER (Zone 158)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 34, `maxLevel` = 36 WHERE `zoneid` = 158 AND `name` IN ( -- *34-35
    'Gigas_Torturer',
    'Gigas_Bonecutter',
    'Gigas_Stonemason',
    'Gigas_Spirekeeper',
    'Magic_Urn'
);
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 38 WHERE `zoneid` = 158 AND `name` = 'Mimas'; -- *36-36
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 38 WHERE `zoneid` = 158 AND `name` = 'Porphyrion'; -- *36-36
UPDATE `mob_groups` SET `minLevel` = 73, `maxLevel` = 75 WHERE `zoneid` = 158 AND `name` = 'Pallas'; -- *72-72
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 158 AND `name` = 'Alkyoneus'; -- *75-75

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 158 AND `name` IN (
    'Gigas_Torturer',
    'Gigas_Bonecutter',
    'Gigas_Stonemason',
    'Gigas_Spirekeeper',
    'Thunder_Elemental',
    'Light_Elemental',
    'Magic_Urn'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 158 AND `name` IN (
    'Demonic_Doll',
    'Magic_Pot',
    'Dire_Bat',
    'Jotunn_Wallkeeper',
    'Jotunn_Gatekeeper',
    'Jotunn_Hallkeeper',
    'Phasma',
    'Incubus_Bats'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime` = 600 WHERE `zoneid` = 158 AND `name` = 'Porphyrion'; -- *

-- TEMPLE_OF_UGGALEPIH (Zone 159)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 68 WHERE `zoneid` = 159 AND `name` = 'Iron_Maiden'; -- *64-68
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 59 WHERE `zoneid` = 159 AND `name` IN ( -- *51-59
    'Tonberry_Stalker',
    'Tonberry_Cutter',
    'Tonberry_Harrier'
);
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 69 WHERE `zoneid` = 159 AND `name` IN ( -- *61-68/69
    'Tonberry_Maledictor',
    'Tonberry_Pursuer',
    'Tonberry_Stabber',
    'Tonberry_Dismayer'
);
UPDATE `mob_groups` SET `minLevel` = 65, `maxLevel` = 67 WHERE `zoneid` = 159 AND `name` = 'Temple_Guardian'; -- *65-65

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 159 AND `name` IN (
    'Temple_Opo-opo',
    'Tonberry_Stalker',
    'Tonberry_Cutter',
    'Tonberry_Harrier',
    'Rumble_Crawler',
    'Branding_Iron',
    'Torama',
    'Tonberry_Maledictor',
    'Tonberry_Pursuer',
    'Tonberry_Stabber',
    'Tonberry_Dismayer',
    'Hover_Tank',
    'Fire_Elemental',
    'Iron_Maiden',
    'Temple_Bee',
    'Water_Elemental'
);

-- DEN_OF_RANCOR (Zone 160)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 64, `maxLevel` = 67 WHERE `zoneid` = 160 AND `name` = 'Mousse'; -- *64-70 - Only fished Mousse exceed 67.
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69 WHERE `zoneid` = 160 AND `name` = 'Succubus_Bats'; -- *65-69
UPDATE `mob_groups` SET `minLevel` = 76, `maxLevel` = 79 WHERE `zoneid` = 160 AND `name` = 'Tormentor'; -- *75-79
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 73 WHERE `zoneid` = 160 AND `name` = 'Friar_Rush'; -- *70-70
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 160 AND `name` = 'Hakutaku'; -- *85-85

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 160 AND `name` IN (
    'Tonberry_Trailer',
    'Dire_Bat',
    'Fire_Elemental',
    'Tonberry_Imprecator',
    'Tonberry_Slasher',
    'Tonberry_Beleaguerer',
    'Bifrons',
    'Cave_Worm',
    'Den_Scorpion',
    'Water_Elemental',
    'Succubus_Bats',
    'Tormentor',
    'Puck',
    'Bullbeggar'
    'Cutlass_Scorpion',
    'Million_Eyes',
    'Mousse'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 160 AND `name` IN (
    'Demonic_Pugil',
    'Doom_Toad'
);

-- CASTLE_ZVAHL_BAILEYS (Zone 161)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 48, `maxLevel` = 50 WHERE `zoneid` = 161 AND `name` = 'Evil_Eye'; -- *46-48
UPDATE `mob_groups` SET `minLevel` = 49, `maxLevel` = 52 WHERE `zoneid` = 161 AND `name` = 'Demon_Pawn'; -- *48-52

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 161 AND `name` IN (
    'Evil_Eye',
    'Demon_Pawn',
    'Dark_Elemental',
    'Ice_Elemental',
    'Goblin_Poacher',
    'Goblin_Trader',
    'Goblin_Robber',
    'Goblin_Reaper',
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper',
    'Elder_Quadav',
    'Iron_Quadav',
    'Spinel_Quadav',
    'Emerald_Quadav',
    'Yagudo_Zealot',
    'Yagudo_Conquistador',
    'Yagudo_Lutenist',
    'Yagudo_Prior'
);

-- CASTLE_ZVAHL_KEEP (Zone 162)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 50, `maxLevel` = 52 WHERE `zoneid` = 162 AND `name` = 'Evil_Eye'; -- *46-48
UPDATE `mob_groups` SET `minLevel` = 52, `maxLevel` = 55 WHERE `zoneid` = 162 AND `name` = 'Morbid_Eye'; -- *52-53 (52-55 in Baileys)

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 162 AND `name` IN (
    'Goblin_Poacher',
    'Goblin_Trader',
    'Goblin_Robber',
    'Goblin_Reaper',
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper',
    'Elder_Quadav',
    'Iron_Quadav',
    'Spinel_Quadav',
    'Emerald_Quadav',
    'Yagudo_Zealot',
    'Yagudo_Conquistador',
    'Yagudo_Lutenist',
    'Yagudo_Prior'
);

-- GARLAIGE_CITADEL_S (Zone 164)
-----------------------------------
-- TODO

-- RANGUEMONT_PASS (Zone 166)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 7 WHERE `zoneid` = 166 AND `name` = 'Wind_Bats'; -- *3-5
UPDATE `mob_groups` SET `minLevel` = 5, `maxLevel` = 8 WHERE `zoneid` = 166 AND `name` = 'Blade_Bat'; -- *4-7
UPDATE `mob_groups` SET `minLevel` = 6, `maxLevel` = 8 WHERE `zoneid` = 166 AND `name` = 'Goblin_Thug'; -- *4-8
UPDATE `mob_groups` SET `minLevel` = 6, `maxLevel` = 8 WHERE `zoneid` = 166 AND `name` = 'Goblin_Weaver'; -- *4-8
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 29 WHERE `zoneid` = 166 AND `name` = 'Seeker_Bats'; -- *25-28
UPDATE `mob_groups` SET `minLevel` = 27, `maxLevel` = 30 WHERE `zoneid` = 166 AND `name` IN ( -- *26-30
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 40, `maxLevel` = 43 WHERE `zoneid` = 166 AND `name` = 'Bilesucker'; -- Passive
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 45 WHERE `zoneid` = 166 AND `name` = 'Hovering_Oculus';
UPDATE `mob_groups` SET `minLevel` = 41, `maxLevel` = 44 WHERE `zoneid` = 166 AND `name` IN (
    'Goblin_Hoodoo',
    'Goblin_Artificer',
    'Goblin_Tanner',
    'Goblin_Chaser'
);
UPDATE `mob_groups` SET `minLevel` = 36, `maxLevel` = 38 WHERE `zoneid` = 166 AND `name` = 'Goblins_Bats';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 166 AND `name` IN (
    'Wind_Bats',
    'Blade_Bat',
    'Oil_Slick',
    'Goblin_Thug',
    'Goblin_Weaver'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 166 AND `name` IN (
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Seeker_Bats',
    'Ooze'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 166 AND `name` IN (
    'Cave_Scorpion',
    'Stirge',
    'Taisai',
    'Seeker_Bats',
    'Hecteyes',
    'Evil_Weapon'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 166 AND `name` IN (
    'Hovering_Oculus',
    'Goblin_Hoodoo',
    'Goblin_Artificer',
    'Goblin_Tanner',
    'Yagudo_Conquistador',
    'Goblin_Chaser'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime` = 330 WHERE `zoneid` = 166 AND `name` = 'Bilesucker'; -- *

-- BOSTAUNIEUX_OUBLIETTE (Zone 167)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 53, `maxLevel` = 56 WHERE `zoneid` = 167 AND `name` = 'Funnel_Bats'; -- *52-55
UPDATE `mob_groups` SET `minLevel` = 56, `maxLevel` = 59 WHERE `zoneid` = 167 AND `name` = 'Werebat'; -- *55-59
UPDATE `mob_groups` SET `minLevel` = 60, `maxLevel` = 62 WHERE `zoneid` = 167 AND `name` = 'Mousse'; -- *58-62
UPDATE `mob_groups` SET `minLevel` = 60, `maxLevel` = 62 WHERE `zoneid` = 167 AND `name` = 'Arioch'; -- *56-62
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 76, `maxLevel` = 78 WHERE `zoneid` = 167 AND `name` = 'Nachtmahr';
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 167 AND `name` = 'Blind_Bat';
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 167 AND `name` = 'Dabilla';
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80, `MP` = 3000 WHERE `zoneid` = 167 AND `name` = 'Panna_Cotta';
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 83 WHERE `zoneid` = 167 AND `name` = 'Wurdalak';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 167 AND `name` IN (
    'Hecatomb_Hound',
    'Haunt',
    'Garm',
    'Dark_Aspic',
    'Mousse',
    'Nachtmahr',
    'Wurdalak',
    'Gespenst'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 167 AND `name` IN (
    'Funnel_Bats',
    'Werebat',
    'Blind_Bat',
    'Panna_Cotta',
    'Dabilla',
    'Bloodsucker'
);

-- TORAIMARAI_CANAL (Zone 169)
-----------------------------------
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69 WHERE `zoneid` = 169 AND `name` = 'Plunderer_Crab';
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 69 WHERE `zoneid` = 169 AND `name` = 'Blackwater_Pugil';
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 70 WHERE `zoneid` = 169 AND `name` = 'Deviling_Bats';
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 70 WHERE `zoneid` = 169 AND `name` = 'Rapier_Scorpion';
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 70 WHERE `zoneid` = 169 AND `name` = 'Starborer';
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 169 AND `name` = 'Sodden_Bones';
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 169 AND `name` = 'Drowned_Bones';
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 73 WHERE `zoneid` = 169 AND `name` = 'Flume_Toad';
UPDATE `mob_groups` SET `minLevel` = 71, `maxLevel` = 73 WHERE `zoneid` = 169 AND `name` = 'Poroggo_Excavator';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 169 AND `name` IN (
    'Canal_Bats',
    'Hell_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 169 AND `name` IN (
    'Bigclaw',
    'Fallen_Knight',
    'Lich',
    'Dark_Aspic',
    'Bloodsucker',
    'Girtab',
    'Fleshcraver',
    'Mindcraver',
    'Rotten_Sod',
    'Bouncing_Ball',
    'Mousse',
    'Sodden_Bones',
    'Drowned_Bones',
    'Rapier_Scorpion',
    'Hinge_Oil',
    'Poroggo_Excavator',
    'Doom_Mage',
    'Doom_Soldier',
    'Starmite'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 169 AND `name` IN (
    'Scavenger_Crab',
    'Makara',
    'Stygian_Pugil',
    'Blackwater_Pugil',
    'Plunderer_Crab',
    'Deviling_Bats',
    'Starborer',
    'Plunderer_Crab',
    'Impish_Bats',
    'Dire_Bat'
);

-- CRAWLERS_NEST_S (Zone 171)
-----------------------------------
-- TODO

-- ZERUHN_MINES (Zone 172)
-----------------------------------
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 20, `maxLevel` = 23 WHERE `zoneid` = 172 AND `name` = 'Soot_Crab';
UPDATE `mob_groups` SET `minLevel` = 21, `maxLevel` = 24 WHERE `zoneid` = 172 AND `name` = 'Burrower_Worm';
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 172 AND `name` = 'Colliery_Bat';
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 172 AND `name` = 'Veindigger_Leech';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 172 AND `name` IN (
    'Ding_Bats',
    'River_Crab'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 172 AND `name` IN (
    'Burrower_Worm',
    'Colliery_Bat',
    'Soot_Crab',
    'Veindigger_Leech'
);

-- KORROLOKA_TUNNEL (Zone 173)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 22, `maxLevel` = 25 WHERE `zoneid` = 173 AND `name` = 'Land_Worm'; -- *20-25
UPDATE `mob_groups` SET `minLevel` = 23, `maxLevel` = 26 WHERE `zoneid` = 173 AND `name` = 'Seeker_Bats'; -- *22-26
UPDATE `mob_groups` SET `minLevel` = 29, `maxLevel` = 32 WHERE `zoneid` = 173 AND `name` = 'Greater_Pugil'; -- *25-32
UPDATE `mob_groups` SET `minLevel` = 32, `maxLevel` = 33 WHERE `zoneid` = 173 AND `name` = 'Korroloka_Leech'; -- *32-32
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 37 WHERE `zoneid` = 173 AND `name` = 'Lacerator';
UPDATE `mob_groups` SET `minLevel` = 35, `maxLevel` = 37 WHERE `zoneid` = 173 AND `name` = 'Spool_Leech';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 173 AND `name` IN (
    'Land_Worm',
    'Seeker_Bats',
    'Thread_Leech',
    'Huge_Spider',
    'Combat',
    'Jelly'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 173 AND `name` IN (
    'Thunder_Elemental',
    'Sea_Monk',
    'Greater_Pugil',
    'Clipper',
    'Water_Elemental',
    'Bogy',
    'Gigas_Stonemason',
    'Gigas_Stonecarrier',
    'Gigas_Stonegrinder',
    'Gigas_Foreman'
);
UPDATE `mob_groups` SET `respawntime` = 1200 WHERE `zoneid` = 173 AND `name` = 'Jammer_Leech';
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 173 AND `name` IN (
    'Lacerator',
    'Spool_Leech'
);

-- KUFTAL_TUNNEL (Zone 174)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 174 AND `name` = 'Devil_Manta_fished'; -- *66-68
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 68 WHERE `zoneid` = 174 AND `name` = 'Amemet'; -- *66-66
UPDATE `mob_groups` SET `minLevel` = 82, `maxLevel` = 83 WHERE `zoneid` = 174 AND `name` = 'Pelican'; -- *80-81
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 79, `maxLevel` = 81 WHERE `zoneid` = 174 AND `name` = 'Kuftal_Delver';
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 174 AND `name` = 'Machairodus';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 174 AND `name` IN (
    'Sand_Lizard',
    'Robber_Crab',
    'Haunt',
    'Cave_Worm',
    'Fire_Elemental',
    'Air_Elemental',
    'Sabotender_Sediendo',
    'Recluse_Spider',
    'Diplopod',
    'Ovinnik',
    'Greater_Cockatrice',
    'Ladon',
    'Deinonychus',
    'Goblin_Mercenary',
    'Goblin_Alchemist',
    'Goblin_Bandit',
    'Goblin_Tamer',
    'Kuftal_Digger'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 174 AND `name` IN (
    'Kuftal_Delver',
    'Machairodus'
);

-- THE_ELDIEME_NECROPOLIS_S (Zone 175)
-----------------------------------
-- TODO

-- SEA_SERPENT_GROTTO (Zone 176)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 43, `maxLevel` = 45 WHERE `zoneid` = 176 AND `name` = 'Vampire_Bat'; -- *42-45
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 176 AND `name` = 'Brook_Sahagin'; -- *41-48
UPDATE `mob_groups` SET `minLevel` = 44, `maxLevel` = 47 WHERE `zoneid` = 176 AND `name` = 'Rivulet_Sahagin'; -- *41-48
UPDATE `mob_groups` SET `minLevel` = 45, `maxLevel` = 48 WHERE `zoneid` = 176 AND `name` = 'Bigclaw'; -- *43-48
UPDATE `mob_groups` SET `minLevel` = 53, `maxLevel` = 56 WHERE `zoneid` = 176 AND `name` = 'Sahagin_Parasite'; -- *50-53
UPDATE `mob_groups` SET `minLevel` = 55, `maxLevel` = 58 WHERE `zoneid` = 176 AND `name` = 'Rock_Crab'; -- *53-58
UPDATE `mob_groups` SET `minLevel` = 56, `maxLevel` = 58 WHERE `zoneid` = 176 AND `name` = 'Blubber_Eyes'; -- *55-58
UPDATE `mob_groups` SET `minLevel` = 56, `maxLevel` = 59 WHERE `zoneid` = 176 AND `name` IN ( -- * 52-59
    'Marsh_Sahagin',
    'Swamp_Sahagin',
    'Bog_Sahagin'
);
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 68 WHERE `zoneid` = 176 AND `name` = 'Mousse'; -- *62-65
UPDATE `mob_groups` SET `minLevel` = 66, `maxLevel` = 69 WHERE `zoneid` = 176 AND `name` = 'Dire_Bat'; -- *63-66
UPDATE `mob_groups` SET `minLevel` = 67, `maxLevel` = 70 WHERE `zoneid` = 176 AND `name` = 'Robber_Crab'; -- *62-67
UPDATE `mob_groups` SET `minLevel` = 68, `maxLevel` = 70 WHERE `zoneid` = 176 AND `name` = 'Devil_Manta'; -- *66-69
UPDATE `mob_groups` SET `minLevel` = 69, `maxLevel` = 71 WHERE `zoneid` = 176 AND `name` = 'Mindgazer'; -- *66-69
UPDATE `mob_groups` SET `minLevel` = 69, `maxLevel` = 71 WHERE `zoneid` = 176 AND `name` = 'Greatclaw'; -- *66-69
UPDATE `mob_groups` SET `minLevel` = 69, `maxLevel` = 71 WHERE `zoneid` = 176 AND `name` = 'Nightmare_Bats'; -- *66-69
UPDATE `mob_groups` SET `minLevel` = 69, `maxLevel` = 72 WHERE `zoneid` = 176 AND `name` IN ( -- * 62-72
    'Shore_Sahagin',
    'Coastal_Sahagin',
    'Delta_Sahagin',
    'Lagoon_Sahagin'
);
UPDATE `mob_groups` SET `minLevel` = 39, `maxLevel` = 41 WHERE `zoneid` = 176 AND `name` = 'Masan'; -- *39-39
UPDATE `mob_groups` SET `minLevel` = 48, `maxLevel` = 50 WHERE `zoneid` = 176 AND `name` = 'Seww_the_Squidlimbed'; -- *48-48
UPDATE `mob_groups` SET `minLevel` = 57, `maxLevel` = 59 WHERE `zoneid` = 176 AND `name` = 'Pahh_the_Gullcaller'; -- *57-57
UPDATE `mob_groups` SET `minLevel` = 62, `maxLevel` = 64 WHERE `zoneid` = 176 AND `name` = 'Sea_Hog'; -- *62-62
UPDATE `mob_groups` SET `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 176 AND `name` = 'Zuug_the_Shoreleaper'; -- *70-70
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 77 WHERE `zoneid` = 176 AND `name` = 'Ocean_Sahagin'; -- *75-75
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 176 AND `name` = 'Water_Leaper'; -- *80-80
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 84 WHERE `zoneid` = 176 AND `name` = 'Charybdis'; -- *80-81

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 176 AND `name` IN (
    'Royal_Leech',
    'Undead_Bats',
    'Spring_Sahagin',
    'Pond_Sahagin',
    'Lake_Sahagin',
    'Ironshell',
    'Ghast_blm',
    'Ghast_war'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 176 AND `name` IN (
    'Ooze',
    'Brook_Sahagin',
    'Rivulet_Sahagin',
    'Vampire_Bat',
    'Riparian_Sahagin',
    'Sea_Bonze'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 176 AND `name` IN (
    'Marsh_Sahagin',
    'Sahagin_Parasite',
    'Thunder_Elemental',
    'Swamp_Sahagin',
    'Bog_Sahagin',
    'Blubber_Eyes',
    'Mousse',
    'Water_Elemental',
    'Shore_Sahagin',
    'Coastal_Sahagin',
    'Delta_Sahagin',
    'Lagoon_Sahagin',
    'Devil_Manta',
    'Mindgazer',
    'Greatclaw',
    'Devil_Manta',
    'Rock_Crab'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 176 AND `name` IN (
    'Grotto_Pugil',
    'Bigclaw',
    'Robber_Crab',
    'Dire_Bat'
);

-- VELUGANNON_PALACE (Zone 177)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 75, `maxLevel` = 78 WHERE `zoneid` = 177 AND `name` = 'Mystic_Weapon'; -- *74-77
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 177 AND `name` = 'Steam_Cleaner'; -- *81-82
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 177 AND `name` = 'Brigandish_Blade'; -- *82-84
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 177 AND `name` = 'Zipacna'; -- *83-85

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 177 AND `name` IN (
    'Ornamental_Weapon',
    'Detector',
    'Mystic_Weapon',
    'Air_Elemental',
    'Earth_Elemental',
    'Dustbuster',
    'Thunder_Elemental',
    'Water_Elemental',
    'Enkidu',
    'Ice_Elemental',
    'Fire_Elemental',
    'Thunder_Elemental'
);

-- THE_SHRINE_OF_RUAVITAU (Zone 178)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 74, `maxLevel` = 76 WHERE `zoneid` = 178 AND `name` = 'Defender'; -- *71-76
UPDATE `mob_groups` SET `minLevel` = 78, `maxLevel` = 80 WHERE `zoneid` = 178 AND `name` = 'Aura_Pot'; -- *75-80
UPDATE `mob_groups` SET `minLevel` = 79, `maxLevel` = 81 WHERE `zoneid` = 178 AND `name` = 'Aura_Gear'; -- *76-81
UPDATE `mob_groups` SET `minLevel` = 80, `maxLevel` = 82 WHERE `zoneid` = 178 AND `name` = 'Aura_Butler'; -- *77-82
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 178 AND `name` = 'Mother_Globe'; -- *83-83
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 178 AND `name` = 'Faust'; -- *83-85
UPDATE `mob_groups` SET `minLevel` = 86, `maxLevel` = 88 WHERE `zoneid` = 178 AND `name` = 'Ullikummi'; -- *85-87
UPDATE `mob_groups` SET `minLevel` = 94, `maxLevel` = 94 WHERE `zoneid` = 178 AND `name` = 'Kirin'; -- *92-92
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 85 WHERE `zoneid` = 178 AND `name` = 'Genbu_pet'; -- *83-84
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 85 WHERE `zoneid` = 178 AND `name` = 'Seiryu_pet'; -- *83-84
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 85 WHERE `zoneid` = 178 AND `name` = 'Byakko_pet'; -- *83-84
UPDATE `mob_groups` SET `minLevel` = 84, `maxLevel` = 85 WHERE `zoneid` = 178 AND `name` = 'Suzaku_pet'; -- *83-84
UPDATE `mob_groups` SET `HP` = 7000 WHERE `zoneid` = 178 AND `name` = 'Olla_Media'; -- *5200
UPDATE `mob_groups` SET `HP` = 9000 WHERE `zoneid` = 178 AND `name` = 'Olla_Grande'; -- *5300
-- Out of Era
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 178 AND `name` IN (
    'Baelfyr',
    'Gefyrst',
    'Ungeweder',
    'Byrgen',
    'Aura_Sculpture'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 178 AND `name` IN (
    'Aura_Weapon',
    'Aura_Pot',
    'Ice_Elemental',
    'Aura_Butler',
    'Fire_Elemental',
    'Defender',
    'Aura_Statue',
    'Decorative_Weapon',
    'Thunder_Elemental',
    'Water_Elemental',
    'Air_Elemental',
    'Earth_Elemental',
    'Dark_Elemental'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 178 AND `name` IN (
    'Baelfyr',
    'Gefyrst',
    'Ungeweder',
    'Byrgen',
    'Aura_Sculpture'
);

-- LOWER_DELKFUTTS_TOWER (Zone 184)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 26, `maxLevel` = 28 WHERE `zoneid` = 184 AND `name` = 'Seeker_Bats'; -- *25-27
UPDATE `mob_groups` SET `minLevel` = 28, `maxLevel` = 30 WHERE `zoneid` = 184 AND `name` = 'Ancient_Bat'; -- *27-29

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 184 AND `name` IN (
    'Giant_Gatekeeper',
    'Giant_Guard',
    'Giant_Sentry',
    'Giant_Lobber',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Chaos_Idol',
    'Magic_Pot'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 184 AND `name` IN (
    'Bogy',
    'Gigas_Hallwatcher',
    'Gigas_Punisher',
    'Gigas_Butcher',
    'Gigas_Sculptor',
    'Thunder_Elemental',
    'Light_Elemental',
    'Magic_Urn'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 184 AND `name` IN (
    'Seeker_Bats',
    'Ancient_Bat'
);

-- TODO: Dynamis balance testing. Below is a draft.
-- Dynamis City
-- Beastmen Tier 1: 75-77
-- Beastmen Tier 2: 85-87 -- *90-92

-- Glacier
-- Beastmen Tier 1: 75-77
-- Hydra Tier 1: 78-80
-- Hydra Tier 2: 87-90 -- *92-95

-- Xarcabard
-- Kindred Tier 1: 77-80
-- Kindred Tier 2: 88-90 -- *93-95

-- Dreamlands
-- Beastmen Tier 1: 75-77
-- Beastmen Tier 2: 88-90 -- *93-95
-- Nightmare Tier 1: 78-80
-- Nightmare Tier 2: 90-92 -- *95-97

-- Tavnazia
-- Hydra: 78-80
-- Kindred: 90-92
-- Nightmare Tier 1: 78-80 - Bugard, Worm, Hornet, Taurus and Makara
-- Nightmare Tier 2: 90-92 - Cluster and Leech

-- Tier 1 City Boss - 85
-- Tier 1 Glacier Boss - 85
-- Tier 1 Dynamis Lord - 90
-- Tier 1 Dreamlands Boss - 85
-- Tier 2 City Boss - 95
-- Tier 2 Glacier Boss - 95
-- Tier 2 Arch Dynamis Lord - 95 with higher stats
-- Tier 2 Dreamlands Boss - 95

-- DYNAMIS_SAN_DORIA (Zone 185)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 2 - 85-87
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 34 AND `name` = 'Vanguard_Footsoldier';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 35 AND `name` = 'Vanguard_Grappler';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 36 AND `name` = 'Vanguard_Amputator';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 37 AND `name` = 'Vanguard_Mesmerizer';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 38 AND `name` = 'Vanguard_Vexer';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 39 AND `name` = 'Vanguard_Pillager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 40 AND `name` = 'Vanguard_Trooper';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 41 AND `name` = 'Vanguard_Neckchopper';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 42 AND `name` = 'Vanguard_Hawker';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 43 AND `name` = 'Vanguards_Hecteyes';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 44 AND `name` = 'Vanguard_Bugler';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 45 AND `name` = 'Vanguard_Predator';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 46 AND `name` = 'Vanguard_Gutslasher';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 47 AND `name` = 'Vanguard_Backstabber';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 48 AND `name` = 'Vanguard_Impaler';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 49 AND `name` = 'Vanguards_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 50 AND `name` = 'Vanguard_Dollmaster';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 185 AND `groupid` = 51 AND `name` = 'Vanguards_Avatar';
-- TODO: OoE force spawn NMs

-- DYNAMIS_BASTOK (Zone 186)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 2 - 85-87
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 32 AND `name` = 'Vanguard_Vindicator';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 33 AND `name` = 'Vanguard_Militant';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 34 AND `name` = 'Vanguard_Constable';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 35 AND `name` = 'Vanguard_Thaumaturge';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 36 AND `name` = 'Vanguard_Protector';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 37 AND `name` = 'Vanguard_Defender';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 38 AND `name` = 'Vanguard_Beasttender';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 39 AND `name` = 'Vanguards_Scorpion';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 40 AND `name` = 'Vanguard_Drakekeeper';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 41 AND `name` = 'Vanguards_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 42 AND `name` = 'Vanguard_Purloiner';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 43 AND `name` = 'Vanguard_Vigilante';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 44 AND `name` = 'Vanguard_Minstrel';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 45 AND `name` = 'Vanguard_Hatamoto';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 46 AND `name` = 'Vanguard_Mason';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 47 AND `name` = 'Vanguard_Kusa';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 48 AND `name` = 'Vanguard_Undertaker';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 186 AND `groupid` = 49 AND `name` = 'Vanguards_Avatar';
-- TODO: OoE force spawn NMs

-- DYNAMIS_WINDURST (Zone 187)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 2 - 85-87
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 34 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 35 AND `name` = 'Vanguard_Skirmisher';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 36 AND `name` = 'Vanguard_Priest';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 37 AND `name` = 'Vanguard_Prelate';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 38 AND `name` = 'Vanguard_Visionary';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 39 AND `name` = 'Vanguard_Sentinel';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 40 AND `name` = 'Vanguard_Exemplar';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 41 AND `name` = 'Vanguard_Ogresoother';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 42 AND `name` = 'Vanguards_Crow';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 43 AND `name` = 'Vanguard_Inciter';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 44 AND `name` = 'Vanguard_Liberator';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 45 AND `name` = 'Vanguard_Assassin';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 46 AND `name` = 'Vanguard_Persecutor';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 47 AND `name` = 'Vanguard_Chanter';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 48 AND `name` = 'Vanguard_Partisan';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 49 AND `name` = 'Vanguards_Wyvern';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 50 AND `name` = 'Vanguard_Oracle';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 187 AND `groupid` = 51 AND `name` = 'Vanguards_Avatar';
-- TODO: OoE force spawn NMs

-- DYNAMIS_JEUNO (Zone 188)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 1 NMs
UPDATE `mob_groups` SET `minLevel` = 83, `maxLevel` = 84 WHERE `zoneid` = 188 AND `name` IN ( -- * 73/75/79-73/77/79
    'Gabblox_Magpietongue',
    'Tufflix_Loglimbs',
    'Vanguard_Ronin',
    'Tufflix_Loglimbs',
    'Smeltix_Thickhide',
    'Jabkix_Pigeonpecs',
    'Wasabix_Callusdigit',
    'Hermitrix_Toothrot',
    'Wyrmwix_Snakespecs',
    'Morgmox_Moldnoggin',
    'Sparkspox_Sweatbrow',
    'Elixmix_Hooknose',
    'Bandrix_Rockjaw',
    'Buffrix_Eargone',
    'Humnox_Drumbelly',
    'Ticktox_Beadyeyes',
    'Lurklox_Dhalmelneck',
    'Trailblix_Goatmug',
    'Rutrix_Hamgams',
    'Anvilix_Sootwrists',
    'Bootrix_Jaggedelbow',
    'Mobpix_Mucousmouth',
    'Distilix_Stickytoes',
    'Jabbrox_Grannyguise',
    'Scruffix_Shaggychest',
    'Blazox_Boneybod',
    'Cloktix_Longnail',
    'Slystix_Megapeepers'
);
-- Tier 2 - 85-87
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 62 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 63 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 64 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 65 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 66 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 67 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 68 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 69 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 70 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 71 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 72 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 73 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 74 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 75 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 76 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 77 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 78 AND `name` = 'Vanguard_Salvager';
UPDATE `mob_groups` SET `minLevel` = 85, `maxLevel` = 87 WHERE `zoneid` = 188 AND `groupid` = 79 AND `name` = 'Vanguard_Salvager';
-- Tier 2 NMs
UPDATE `mob_groups` SET `minLevel` = 87, `maxLevel` = 89 WHERE `zoneid` = 188 AND `name` IN (
    'Kikklix_Longlegs',
    'Karashix_Swollenskull',
    'Snypestix_Eaglebeak',
    'Eremix_Snottynostril',
    'Prowlox_Barrelbelly',
    'Mortilox_Wartpaws',
    'Tymexox_Ninefingers'
);
-- TODO: OoE force spawn NMs

-- KING_RANPERRES_TOMB (Zone 190)
-----------------------------------

-- DANGRUF_WADI (Zone 191)
-----------------------------------

-- INNER_HORUTOTO_RUINS (Zone 192)
-----------------------------------

-- ORDELLES_CAVES (Zone 193)
-----------------------------------

-- OUTER_HORUTOTO_RUINS (Zone 194)
-----------------------------------

-- THE_ELDIEME_NECROPOLIS (Zone 195)
-----------------------------------

-- GUSGEN_MINES (Zone 196)
-----------------------------------

-- CRAWLERS_NEST (Zone 197)
-----------------------------------

-- MAZE_OF_SHAKHRAMI (Zone 198)
-----------------------------------

-- GARLAIGE_CITADEL (Zone 200)
-----------------------------------

-- FEIYIN (Zone 204)
-----------------------------------

-- IFRITS_CAULDRON (Zone 205)
-----------------------------------

-- QUICKSAND_CAVES (Zone 208)
-----------------------------------

-- GUSTAV_TUNNEL (Zone 212)
-----------------------------------

-- LABYRINTH_OF_ONZOZO (Zone 213)
-----------------------------------

-- ABYSSEA_ATTOHWA (Zone 215)
-----------------------------------
-- TODO

-- ABYSSEA_MISAREAUX (Zone 216)
-----------------------------------
-- TODO

-- ABYSSEA_VUNKERL (Zone 217)
-----------------------------------
-- TODO

-- ABYSSEA_ALTEPA (Zone 218)
-----------------------------------
-- TODO

-- ABYSSEA_ULEGUERAND (Zone 253)
-----------------------------------
-- TODO

-- ABYSSEA_GRAUBERG (Zone 254)
-----------------------------------
-- TODO

-- RALA_WATERWAYS (Zone 258)
-----------------------------------
-- TODO

-- YAHSE_HUNTING_GROUNDS (Zone 260)
-----------------------------------
-- TODO

-- CEIZAK_BATTLEGROUNDS (Zone 261)
-----------------------------------
-- TODO

-- YORCIA_WEALD (Zone 262)
-----------------------------------
-- TODO

-- FORET_DE_HENNETIEL (Zone 261)
-----------------------------------
-- TODO

-- MORIMAR_BASALT_FIELDS (Zone 265)
-----------------------------------
-- TODO

-- MARJAMI_RAVINE (Zone 266)
-----------------------------------
-- TODO

-- KAMIHR_DRIFTS (Zone 267)
-----------------------------------
-- TODO

-- SIH_GATES (Zone 268)
-----------------------------------
-- TODO

-- MOH_GATES (Zone 269)
-----------------------------------
-- TODO

-- CIRDAS_CAVERNS (Zone 270)
-----------------------------------
-- TODO

-- DHO_GATES (Zone 272)
-----------------------------------
-- TODO

-- WOH_GATES (Zone 273)
-----------------------------------
-- TODO

-- OUTER_RAKAZNAR (Zone 274)
-----------------------------------
-- TODO

-- RAKAZNAR_INNER_COURT (Zone 276)
-----------------------------------
-- TODO

-- ESCHA_ZITAH (Zone 288)
-----------------------------------
-- TODO

-- ESCHA_RUAUN (Zone 289)
-----------------------------------
-- TODO

-- REISENJIMA (Zone 291)
-----------------------------------
-- TODO
