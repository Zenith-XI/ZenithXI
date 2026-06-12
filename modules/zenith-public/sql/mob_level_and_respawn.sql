-----------------------------------
-- Monster level and respawn overrides
-- Does not restore Era functionality
-- "-- *" Denotes a customization from Era. Original database values are listed.
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 2 AND mg.`name` IN ( -- *16-20
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 2 AND mg.`name` = 'Marsh_Funguar'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 2 AND mg.`name` IN ( -- *21-25
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 34, msp.`maxLevel` = 36 WHERE mg.`zoneid` = 2 AND mg.`name` = 'Hercules_Beetle'; -- *34-34
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 2 AND mg.`name` = 'Tempest_Tigon'; -- *43-43

-- BIBIKI_BAY (Zone 4)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Marine_Dhalmel'; -- *34-37
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Island_Rarab'; -- *34-38
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Catoblepas'; -- *76-80
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Splacknuck'; -- *69-69
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Locus_Ghost_Crab';
UPDATE `mob_groups` SET `dropid` = 93, `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Ghost_Crab';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Locus_Bight_Rarab';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Bight_Rarab';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Locus_Hypnos_Eft';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Hypnos_Eft';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 4 AND mg.`name` = 'Locus_Camelopard';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 4 AND `name` = 'Locus_Camelopard';

UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 4 AND `name` IN (
    'Locus_Bight_Rarab',
    'Locus_Camelopard',
    'Locus_Hypnos_Eft',
    'Locus_Ghost_Crab'
);

-- ULEGUERAND_RANGE (Zone 5)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 59, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 5 AND mg.`name` = 'Glacier_Eater'; -- *58-62
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 5 AND mg.`name` = 'Polar_Hare'; -- *65-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 5 AND mg.`name` = 'Doom_Soldier'; -- *66-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 5 AND mg.`name` = 'Mountain_Worm'; -- *66-70
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 5 AND mg.`name` = 'Scowlenkos';

-- ATTOHWA_CHASM (Zone 7)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 7 AND mg.`name` = 'Hecteyes'; -- *35-39
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 7 AND mg.`name` = 'Tulwar_Scorpion'; -- *58-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 7 AND mg.`name` = 'Arch_Corse'; -- *75-81

-- PSOXJA (Zone 9)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Diremite'; -- *42-46
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Maze_Lizard'; -- *43-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Labyrinth_Lizard'; -- *52-58
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Blubber_Eyes'; -- *53-58
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Cryptonberry_Plaguer'; -- *53-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Cryptonberry_Cutter'; -- *53-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Cryptonberry_Harrier'; -- *53-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Cryptonberry_Stalker'; -- *53-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 59, msp.`maxLevel` = 61 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Goblins_Bat'; -- *57-61
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Goblin_Bandit'; -- *62-67
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 9 AND mg.`name` IN ( -- *62/63/64-68
    'Goblin_Alchemist',
    'Goblin_Mercenary',
    'Goblin_Veterinarian',
    'Diremite_Assaulter',
    'Thousand_Eyes'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Purgatory_Bat'; -- *72-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 74, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 9 AND mg.`name` = 'Frost_Lizard'; -- *73-77

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 32, msp.`maxLevel` = 35 WHERE mg.`zoneid` = 11 AND mg.`name` = 'Dark_Bats'; -- 31-35
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 11 AND mg.`name` = 'Ancient_Bomb'; -- 40-45
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 11 AND mg.`name` = 'Goblin_Wolfman'; -- 50-55

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 12 AND mg.`name` = 'Bugbear_Watchman'; -- * 71-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 76, msp.`maxLevel` = 79 WHERE mg.`zoneid` = 12 AND mg.`name` IN ( -- *75-79
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 50, msp.`maxLevel` = 53 WHERE mg.`zoneid` = 24 AND mg.`name` = 'Leshachikha'; -- *49-53
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 24 AND mg.`name` = 'Flockbock'; -- *82

-- MISAREAUX_COAST (Zone 25)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 25 AND mg.`name` = 'Mantrap'; -- *44-49
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 48, msp.`maxLevel` = 51 WHERE mg.`zoneid` = 25 AND mg.`name` = 'Diatryma'; -- *47-51
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 50, msp.`maxLevel` = 52 WHERE mg.`zoneid` = 25 AND mg.`name` = 'Upyri'; -- *43-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 25 AND mg.`name` = 'Gration'; -- *79-79
-- Out of Era
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 25 AND `name` = 'Seaboard_Vulture';

-- PHOMIUNA_AQUEDUCTS (Zone 27)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 27 AND mg.`name` = 'Diremite'; -- *42-48
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 27 AND mg.`name` = 'Aqueduct_Spider';

-- Revert to Era dungeon respawn times.
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
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 28 AND mg.`name` = 'Aqueduct_Spider';
UPDATE `mob_groups` SET `respawntime` = 960 WHERE `zoneid` = 28 AND `name` = 'Aqueduct_Spider';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 28 AND `name` IN (
    'Gazer',
    'Greater_Gaylas',
    'Stegotaur'
);

-- RIVERNE_SITE_B01 (Zone 29)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 49, msp.`maxLevel` = 51 WHERE mg.`zoneid` = 29 AND mg.`name` = 'Lesser_Roc'; -- *47-51
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 29 AND mg.`name` = 'Pyrodrake'; -- *50-55
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 58, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 29 AND mg.`name` = 'Blazedrake';

-- RIVERNE_SITE_A01 (Zone 30)
-----------------------------------
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 30 AND mg.`name` = 'Darner';

-- DYNAMIS_VALKURM (Zone 39)
-----------------------------------
-- Tier 1 Beastmen - 78-80 -- Unchanged
-- Tier 2 Beastmen - 88-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 39 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Footsoldier',
    'Vanguard_Pillager',
    'Vanguard_Neckchopper',
    'Vanguard_Bugler',
    'Vanguard_Dollmaster',
    'Vanguards_Avatar',
    'Vanguard_Neckchopper',
    'Vanguard_Grappler',
    'Vanguard_Mesmerizer',
    'Vanguard_Predator',
    'Vanguard_Backstabber',
    'Vanguard_Hawker',
    'Vanguards_Hecteyes',
    'Vanguard_Amputator',
    'Vanguard_Vexer',
    'Vanguard_Trooper',
    'Vanguard_Gutslasher',
    'Vanguard_Impaler',
    'Vanguards_Wyvern',
    'Vanguard_Vindicator',
    'Vanguard_Vigilante',
    'Vanguard_Kusa',
    'Vanguard_Militant',
    'Vanguard_Mason',
    'Vanguard_Beasttender',
    'Vanguards_Scorpion',
    'Vanguard_Constable',
    'Vanguard_Purloiner',
    'Vanguard_Drakekeeper',
    'Vanguard_Thaumaturge',
    'Vanguard_Minstrel',
    'Vanguard_Hatamoto',
    'Vanguard_Protector',
    'Vanguard_Defender',
    'Vanguard_Undertaker',
    'Vanguard_Skirmisher',
    'Vanguard_Visionary',
    'Vanguard_Chanter',
    'Vanguard_Oracle',
    'Vanguard_Sentinel',
    'Vanguard_Liberator',
    'Vanguard_Salvager',
    'Vanguard_Priest',
    'Vanguard_Exemplar',
    'Vanguard_Persecutor',
    'Vanguard_Partisan',
    'Vanguard_Prelate',
    'Vanguard_Inciter',
    'Vanguard_Assassin',
    'Vanguard_Ogresoother',
    'Vanguards_Crow',
    'Vanguard_Smithy',
    'Vanguard_Pitfighter',
    'Vanguard_Alchemist',
    'Vanguard_Ambusher',
    'Vanguard_Necromancer',
    'Vanguard_Shaman',
    'Vanguard_Enchanter',
    'Vanguard_Welldigger',
    'Vanguard_Ronin',
    'Vanguard_Pathfinder',
    'Vanguards_Slime',
    'Vanguard_Armorer',
    'Vanguard_Tinkerer',
    'Vanguard_Maestro',
    'Vanguard_Hitman',
    'Vanguard_Dragontamer'
);
-- Tier 1 Nightmare - 78-80 -- Unchanged
-- Tier 2 Nightmare - 90-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 39 AND `minLevel` > 84 AND mg.`name` IN (
    'Nightmare_Goobbue',
    'Nightmare_Sabotender',
    'Nightmare_Flytrap',
    'Nightmare_Manticore',
    'Nightmare_Hippogryph',
    'Nightmare_Treant',
    'Nightmare_Funguar',
    'Nightmare_Sheep',
    'Nightmare_Fly'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_BUBURIMU (Zone 40)
-----------------------------------
-- Tier 1 Beastmen - 78-80 -- Unchanged
-- Tier 2 Beastmen - 88-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 40 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Pitfighter',
    'Vanguard_Enchanter',
    'Vanguard_Welldigger',
    'Vanguard_Armorer',
    'Vanguard_Pathfinder',
    'Vanguards_Slime',
    'Vanguard_Maestro',
    'Vanguard_Ronin',
    'Vanguard_Necromancer',
    'Vanguards_Avatar',
    'Vanguard_Smithy',
    'Vanguard_Alchemist',
    'Vanguard_Shaman',
    'Vanguard_Tinkerer',
    'Vanguard_Ambusher',
    'Vanguard_Hitman',
    'Vanguard_Dragontamer',
    'Vanguards_Wyvern',
    'Vanguard_Mesmerizer',
    'Vanguard_Vexer',
    'Vanguard_Pillager',
    'Vanguard_Neckchopper',
    'Vanguard_Hawker',
    'Vanguards_Hecteyes',
    'Vanguard_Bugler',
    'Vanguard_Backstabber',
    'Vanguard_Impaler',
    'Vanguard_Footsoldier',
    'Vanguard_Grappler',
    'Vanguard_Amputator',
    'Vanguard_Predator',
    'Vanguard_Trooper',
    'Vanguard_Gutslasher',
    'Vanguard_Dollmaster',
    'Vanguard_Vindicator',
    'Vanguard_Militant',
    'Vanguard_Constable',
    'Vanguard_Beasttender',
    'Vanguards_Scorpion',
    'Vanguard_Minstrel',
    'Vanguard_Mason',
    'Vanguard_Drakekeeper',
    'Vanguard_Thaumaturge',
    'Vanguard_Protector',
    'Vanguard_Purloiner',
    'Vanguard_Defender',
    'Vanguard_Vigilante',
    'Vanguard_Hatamoto',
    'Vanguard_Kusa',
    'Vanguard_Undertaker',
    'Vanguard_Sentinel',
    'Vanguard_Priest',
    'Vanguard_Liberator',
    'Vanguard_Exemplar',
    'Vanguard_Ogresoother',
    'Vanguards_Crow',
    'Vanguard_Chanter',
    'Vanguard_Persecutor',
    'Vanguard_Partisan',
    'Vanguard_Skirmisher',
    'Vanguard_Prelate',
    'Vanguard_Visionary',
    'Vanguard_Inciter',
    'Vanguard_Salvager',
    'Vanguard_Assassin',
    'Vanguard_Oracle'
);
-- Tier 1 Nightmare - 78-80 -- Unchanged
-- Tier 2 Nightmare - 90-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 40 AND `minLevel` > 84 AND mg.`name` IN (
    'Nightmare_Crab',
    'Nightmare_Dhalmel',
    'Nightmare_Uragnite',
    'Nightmare_Scorpion',
    'Nightmare_Bunny',
    'Nightmare_Mandragora',
    'Nightmare_Crawler',
    'Nightmare_Raven',
    'Nightmare_Eft'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_QUFIM (Zone 41)
-----------------------------------
-- Tier 1 Beastmen - 78-80 -- Unchanged
-- Tier 2 Beastmen - 88-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 41 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Amputator',
    'Vanguard_Vexer',
    'Vanguard_Neckchopper',
    'Vanguard_Predator',
    'Vanguard_Impaler',
    'Vanguards_Wyvern',
    'Vanguard_Footsoldier',
    'Vanguard_Pillager',
    'Vanguard_Trooper',
    'Vanguard_Bugler',
    'Vanguard_Gutslasher',
    'Vanguard_Dollmaster',
    'Vanguards_Avatar',
    'Vanguard_Grappler',
    'Vanguard_Mesmerizer',
    'Vanguard_Hawker',
    'Vanguards_Hecteyes',
    'Vanguard_Backstabber',
    'Vanguard_Alchemist',
    'Vanguard_Armorer',
    'Vanguard_Pathfinder',
    'Vanguards_Slime',
    'Vanguard_Ronin',
    'Vanguard_Smithy',
    'Vanguard_Welldigger',
    'Vanguard_Tinkerer',
    'Vanguard_Enchanter',
    'Vanguard_Ambusher',
    'Vanguard_Hitman',
    'Vanguard_Dragontamer',
    'Vanguard_Pitfighter',
    'Vanguard_Shaman',
    'Vanguard_Maestro',
    'Vanguard_Necromancer',
    'Vanguard_Militant',
    'Vanguard_Thaumaturge',
    'Vanguard_Beasttender',
    'Vanguards_Scorpion',
    'Vanguard_Mason',
    'Vanguard_Hatamoto',
    'Vanguard_Vindicator',
    'Vanguard_Protector',
    'Vanguard_Defender',
    'Vanguard_Kusa',
    'Vanguard_Undertaker',
    'Vanguard_Constable',
    'Vanguard_Purloiner',
    'Vanguard_Vigilante',
    'Vanguard_Minstrel',
    'Vanguard_Drakekeeper',
    'Vanguard_Skirmisher',
    'Vanguard_Sentinel',
    'Vanguard_Exemplar',
    'Vanguard_Inciter',
    'Vanguard_Ogresoother',
    'Vanguards_Crow',
    'Vanguard_Priest',
    'Vanguard_Prelate',
    'Vanguard_Chanter',
    'Vanguard_Partisan',
    'Vanguard_Assassin',
    'Vanguard_Visionary',
    'Vanguard_Liberator',
    'Vanguard_Salvager',
    'Vanguard_Persecutor',
    'Vanguard_Oracle'
);
-- Tier 1 Nightmare - 78-80 -- Unchanged
-- Tier 2 Nightmare - 90-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 41 AND `minLevel` > 84 AND mg.`name` IN (
    'Nightmare_Roc',
    'Nightmare_Stirge',
    'Nightmare_Diremite',
    'Nightmare_Gaylas',
    'Nightmare_Kraken',
    'Nightmare_Snoll',
    'Nightmare_Tiger',
    'Nightmare_Weapon',
    'Nightmare_Raptor'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_TAVNAZIA (Zone 42)
-----------------------------------
-- Hyrdra - 77-79 -- Unchanged
-- Kindred - 90-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 42 AND `minLevel` > 84 AND mg.`name` IN (
    'Kindred_Monk',
    'Kindred_Black_Mage',
    'Kindred_Beastmaster',
    'Kindreds_Vouivre',
    'Kindred_White_Mage',
    'Kindred_Dark_Knight',
    'Kindred_Ranger',
    'Kindred_Red_Mage',
    'Kindred_Paladin',
    'Kindred_Samurai',
    'Kindred_Warrior',
    'Kindred_Thief',
    'Kindred_Summoner',
    'Kindreds_Avatar',
    'Kindred_Bard',
    'Kindred_Ninja',
    'Kindred_Dragoon',
    'Kindreds_Wyvern'
);
-- Tier 1 Nightmare - 78-80 -- Unchanged
-- Tier 2 Nightmare - 90-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 42 AND `minLevel` > 84 AND mg.`name` IN (
    'Nightmare_Cluster',
    'Nightmare_Leech'
);

-- TODO: OoE force spawn NMs

-- ABYSSEA_TAHRONGI (Zone 45)
-----------------------------------
-- TODO

-- WAJAOM_WOODLANDS (Zone 51)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 51 AND mg.`name` = 'Carmine_Eruca'; -- *70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 51 AND mg.`name` = 'Great_Ameretat'; -- *71-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 51 AND mg.`name` = 'Hydra'; -- *80-80

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 52 AND mg.`name` = 'Locus_Colibri';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 52 AND `name` = 'Locus_Colibri';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 52 AND mg.`name` = 'Locus_Wivre';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 52 AND `name` = 'Locus_Wivre';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Lamia_No19'; -- *78-78
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Lamie_No9'; -- *80-85
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 87, msp.`maxLevel` = 89 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Euryale'; -- *87-87
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Medusa'; -- *85-85
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Nirgali';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Naraka_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Dweomershell';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 86 WHERE mg.`zoneid` = 54 AND mg.`name` = 'Nostokulshedra';

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 54 AND `name` IN (
    'Arrapago_Apkallu',
    'Purgatory_Bat',
    'Nipper',
    'Heraldic_Imp'
);

-- MOUNT_ZHAYOLM (Zone 61)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Wootzshell'; -- *70-71
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 71, msp.`maxLevel` = 74 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Magmatic_Eruca'; -- *71-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 71, msp.`maxLevel` = 74 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Zhayolm_Apkallu'; -- *70-74
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Assassin_Fly'; -- *71-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 78 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Sweeping_Cluster'; -- *73-78
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Cerberus'; -- *85-85
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Scoriaceous_Eruca';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Sulphuric_Jagil';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 86 WHERE mg.`zoneid` = 61 AND mg.`name` = 'Orichalcumshell';

UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 61 AND `name` = 'Ebony_Pudding'; -- *

-- HALVUNG (Zone 62)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 72, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 62 AND mg.`name` = 'Magmatic_Eruca'; -- *71-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 62 AND mg.`name` = 'Friars_Lantern'; -- *72-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 62 AND mg.`name` IN ( -- *71-75
    'Troll_Gemologist',
    'Troll_Stoneworker',
    'Troll_Lapidarist',
    'Troll_Smelter',
    'Troll_Engraver',
    'Troll_Cameist',
    'Troll_Ironworker'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 74, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 62 AND mg.`name` = 'Wamouracampa'; -- *72-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 62 AND mg.`name` = 'Dahak'; -- *79-79
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 62 AND mg.`name` IN ( -- *78-83
    'Troll_Artilleryman',
    'Troll_Combatant',
    'Troll_Targeteer',
    'Troll_Machinist',
    'Troll_Scrimer',
    'Troll_Grenadier',
    'Troll_Cuirasser'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 62 AND mg.`name` = 'Gurfurlur_the_Menacing'; -- *85-90

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 65 AND mg.`name` = 'Colibri'; -- *70-71
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 88, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 65 AND mg.`name` = 'Gulool_Ja_Ja'; -- *85-88

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 68 AND mg.`name` = 'Defoliator'; -- *68-73
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 71, msp.`maxLevel` = 74 WHERE mg.`zoneid` = 68 AND mg.`name` = 'Aydeewa_Diremite'; -- *70-74
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 68 AND mg.`name` = 'Slime_Eater';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 68 AND mg.`name` = 'Mycoskulker';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 68 AND mg.`name` = 'Deforester';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Marsh_Murre'; -- *64-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Orderly_Imp'; -- *63-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Jnun'; -- *72-77
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Spongilla_Fly'; -- *78-79
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Heraldic_Imp'; -- *79-82
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Khimaira'; -- *85-85
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Vauxia_Fly';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 86, msp.`maxLevel` = 88 WHERE mg.`zoneid` = 79 AND mg.`name` = 'Slough_Skua';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 100 AND mg.`name` = 'Ding_Bats'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 100 AND mg.`name` = 'Forest_Hare'; -- *1-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 100 AND mg.`name` = 'Carrion_Worm'; -- *1-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 100 AND mg.`name` = 'Scarab_Beetle'; -- *3-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 100 AND mg.`name` IN ( -- *3/4-8
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 101 AND mg.`name` = 'Ding_Bats'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 101 AND mg.`name` = 'Forest_Hare'; -- *1-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 101 AND mg.`name` = 'Carrion_Worm'; -- *1-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 101 AND mg.`name` = 'Scarab_Beetle'; -- *3-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 101 AND mg.`name` IN ( -- *3/4-8
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 102 AND mg.`name` = 'Rock_Eater'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 9, msp.`maxLevel` = 12 WHERE mg.`zoneid` = 102 AND mg.`name` = 'Huge_Wasp'; -- *8-12
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 13 WHERE mg.`zoneid` = 102 AND mg.`name` = 'Akbaba'; -- *9-13
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 13, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 102 AND mg.`name` IN ( -- *12-16
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);

-- VALKURM_DUNES (Zone 103)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 19 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Hill_Lizard'; -- *15-19
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 19, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Snipper'; -- *18-22
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Ghoul_war'; -- *18-22
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Ghoul_blm'; -- *18-22
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Goblin_Bounty_Hunter'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 103 AND mg.`name` = 'Thread_Leech'; -- *21-25

-- JUGNER_FOREST (Zone 104)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 104 AND mg.`name` = 'Screamer'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 104 AND mg.`name` IN ( -- *16-20
    'Orcish_Grunt',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 104 AND mg.`name` = 'Jugner_Funguar'; -- *21-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 104 AND mg.`name` IN ( -- *21-25
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);

-- BATALLIA_DOWNS (Zone 105)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 105 AND mg.`name` = 'Stalking_Sapling'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 105 AND mg.`name` = 'May_Fly'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 24, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 105 AND mg.`name` = 'Goblin_Bounty_Hunter'; -- *20-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 105 AND mg.`name` IN ( -- *26-30
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 28, msp.`maxLevel` = 31 WHERE mg.`zoneid` = 105 AND mg.`name` = 'Wight_war'; -- *26-36
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 29, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 105 AND mg.`name` = 'Sabertooth_Tiger'; -- *28-32
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 105 AND mg.`name` = 'Mauthe_Doog'; -- *28-32
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 105 AND mg.`name` IN ( -- *28-36
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 33, msp.`maxLevel` = 36 WHERE mg.`zoneid` = 105 AND mg.`name` IN ( -- *30-36
    'Orcish_Impaler',
    'Orcish_Beastrider',
    'Orcish_Nightraider',
    'Orcish_Brawler'
);

-- NORTH_GUSTABERG (Zone 106)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 4 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Ding_Bats'; -- *1-4
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 106 AND mg.`name` = 'River_Crab'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Stone_Eater'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Walking_Sapling'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Maneating_Hornet'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Vulture'; -- *2-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 106 AND mg.`name` = 'Rock_Lizard'; -- *3-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 106 AND mg.`name` IN ( -- *3/4-8
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 4 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Ding_Bats'; -- *1-4
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 107 AND mg.`name` = 'River_Crab'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Stone_Eater'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Walking_Sapling'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Maneating_Hornet'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Vulture'; -- *2-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 107 AND mg.`name` = 'Rock_Lizard'; -- *3-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 107 AND mg.`name` IN ( -- *3/4-8
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 108 AND mg.`name` = 'Strolling_Sapling'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 108 AND mg.`name` = 'Rock_Eater'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 108 AND mg.`name` = 'Huge_Wasp'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 13, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 108 AND mg.`name` IN ( -- *10/12-16
    'Goblin_Ambusher',
    'Goblin_Butcher',
    'Onyx_Quadav',
    'Veteran_Quadav',
    'Greater_Quadav',
    'Goblin_Tinkerer'
);

-- PASHHOW_MARSHLANDS (Zone 109)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Water_Wasp'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 18, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Snipper'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 18, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Land_Pugil'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 109 AND mg.`name` IN ( -- *16-20
    'Veteran_Quadav',
    'Greater_Quadav',
    'Onyx_Quadav',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Bog_Dog'; -- *18-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Ghoul_war'; -- *18-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 109 AND mg.`name` = 'Marsh_Funguar'; -- *21-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 109 AND mg.`name` IN ( -- *21-25
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 109 AND mg.`name` IN ( -- *20-26
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav'
);

-- ROLANBERRY_FIELDS (Zone 110)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 110 AND mg.`name` = 'Death_Wasp'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 110 AND mg.`name` = 'Berry_Grub'; -- *25-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 110 AND mg.`name` IN ( -- *26-30
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 110 AND mg.`name` IN ( -- *30-36
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 49, msp.`maxLevel` = 52 WHERE mg.`zoneid` = 112 AND mg.`name` IN ( -- *48-52
    'Demon_Pawn',
    'Demon_Wizard',
    'Demon_Knight'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 58, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 112 AND mg.`name` IN ( -- *53
    'Boreal_Hound',
    'Boreal_Coeurl',
    'Boreal_Tiger'
);

-- CAPE_TERIGGAN (Zone 113)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Beach_Bunny'; -- *62-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 66 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Sand_Lizard'; -- *62-66
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Terror_Pugil'; -- *66-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Doom_Soldier'; -- *66-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Doom_Mage'; -- *67-71
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 71, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 113 AND mg.`name` = 'Sand_Cockatrice'; -- *71-74

-- EASTERN_ALTEPA_DESERT (Zone 114)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Giant_Spider'; -- *30-34
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 114 AND mg.`name` IN ( -- *35-39
    'Antican_Auxiliarius',
    'Antican_Funditor',
    'Antican_Faber'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 37, msp.`maxLevel` = 40 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Sand_Beetle'; -- *36-40
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 42 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Flesh_Eater'; -- *37-42
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Desert_Dhalmel'; -- *39-44
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Lost_Soul_war'; -- *44-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 114 AND mg.`name` = 'Lost_Soul_blm'; -- *44-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 114 AND mg.`name` IN ( -- *44/45-49
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 115 AND mg.`name` = 'Savanna_Rarab'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 115 AND mg.`name` = 'River_Crab'; -- *1-3
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 115 AND mg.`name` = 'Goblin_Fisher'; -- *3-4
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 115 AND mg.`name` = 'Carrion_Crow'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 115 AND mg.`name` = 'Crawler'; -- *3-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 115 AND mg.`name` IN ( -- *4-8
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 2, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 116 AND mg.`name` = 'Savanna_Rarab'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 116 AND mg.`name` = 'River_Crab'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 116 AND mg.`name` = 'Pug_Pugil'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 116 AND mg.`name` = 'Goblin_Fisher'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 116 AND mg.`name` IN ( -- *1/3-8
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe',
    'Goblin_Thug',
    'Goblin_Weaver',
    'Mad_Fox',
    'Magicked_Bones_war',
    'Magicked_Bones_blm'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 12 WHERE mg.`zoneid` = 116 AND mg.`name` = 'Duke_Decapod'; -- *8-8
UPDATE `mob_groups` SET `HP` = 0, `MP` = 200 WHERE `zoneid` = 116 AND `name` = 'Duke_Decapod';

-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 116 AND `name` IN (
    'Tiny_Mandragora',
    'Bumblebee'
);

-- TAHRONGI_CANYON (Zone 117)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 117 AND mg.`name` = 'Canyon_Rarab'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 8, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 117 AND mg.`name` = 'Strolling_Sapling'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 9, msp.`maxLevel` = 11 WHERE mg.`zoneid` = 117 AND mg.`name` = 'Pygmaioi'; -- *7-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 13 WHERE mg.`zoneid` = 117 AND mg.`name` = 'Akbaba'; -- *9-13
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 13, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 117 AND mg.`name` IN ( -- *12-16
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 29, msp.`maxLevel` = 31 WHERE mg.`zoneid` = 117 AND mg.`name` = 'Herbage_Hunter'; -- *29-29

-- BUBURIMU_PENINSULA (Zone 118)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 19 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Sylvestre'; -- *15-19
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 18, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 118 AND mg.`name` IN ( -- *17-20
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Zombie_war'; -- *18-22
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Goblin_Bounty_Hunter'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Snipper'; -- *18-23
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Zu'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Bull_Dhalmel'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Ghoul_blm'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Poison_Leech'; -- *21-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 24, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 118 AND mg.`name` = 'Shoal_Pugil'; -- *24-28

-- MERIPHATAUD_MOUNTAINS (Zone 119)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Wandering_Sapling'; -- *13-16
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 119 AND mg.`name` IN ( -- *16-20
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Yagudo_Mendicant',
    'Yagudo_Piper',
    'Yagudo_Persecutor'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 19, msp.`maxLevel` = 21 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Zombie_war'; -- *16-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 19, msp.`maxLevel` = 21 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Zombie_blm'; -- *16-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Scavenging_Hound'; -- *18-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 119 AND mg.`name` IN ( -- *21-25
    'Raptor',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Coeurl'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 119 AND mg.`name` = 'Chonchon'; -- *42-42
UPDATE `mob_groups` SET `HP` = 5000 WHERE `zoneid` = 119 AND `name` = 'Chonchon';

-- SAUROMUGUE_CHAMPAIGN (Zone 120)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Midnight_Wings'; -- *20-24
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Hill_Lizard'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Diving_Beetle'; -- *25-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 120 AND mg.`name` IN ( -- *26-30
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 29, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Sauromugue_Skink'; -- *28-32
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Goblin_Digger'; -- *28-32
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Wight_war'; -- *26-36
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 120 AND mg.`name` = 'Champaign_Coeurl'; -- *30-34
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 33, msp.`maxLevel` = 36 WHERE mg.`zoneid` = 120 AND mg.`name` IN ( -- *30-36
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 121 AND mg.`name` IN ( -- *25-29
    'Goblin_Mugger',
    'Goblin_Gambler',
    'Goblin_Leecher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 43 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Goobbue_Gardener'; -- *40-43
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Ogrefly'; -- *41-44
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Myxomycete'; -- *41-46
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 121 AND mg.`name` IN ( -- *42-46
    'Goblin_Robber',
    'Goblin_Trader',
    'Goblin_Poacher',
    'Goblin_Reaper'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Master_Coeurl'; -- *44-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Hell_Hound'; -- *46-50
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Rot_Prowler'; -- *49-53
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 47, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 121 AND mg.`name` = 'Lost_Soul_blm'; -- *51-55

-- ROMAEVE (Zone 122)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 64 WHERE mg.`zoneid` = 122 AND mg.`name` = 'Killing_Weapon'; -- *60-64
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 122 AND mg.`name` = 'Ominous_Weapon'; -- *61-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 122 AND mg.`name` = 'Magic_Flagon'; -- *64-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 122 AND mg.`name` = 'Cursed_Puppet'; -- *65-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 122 AND mg.`name` = 'Shikigami_Weapon'; -- *77-80

-- YUHTUNGA_JUNGLE (Zone 123)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 33 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Yuhtunga_Mandragora'; -- *29-33
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 32, msp.`maxLevel` = 35 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Goblin_Smithy'; -- *32-37
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 34, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Death_Jacket'; -- *33-37
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Goblin_Furrier'; -- *32-37
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 123 AND mg.`name` IN ( -- *34-38
    'Creek_Sahagin',
    'River_Sahagin',
    'Stream_Sahagin'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Makara'; -- *35-38
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 38, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Soldier_Crawler'; -- *37-41
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 38, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Goblin_Reaper'; -- *42-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 42 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Goblin_Robber'; -- *42-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 42 WHERE mg.`zoneid` = 123 AND mg.`name` = 'Goblin_Poacher'; -- *42-47

-- YHOATOR_JUNGLE (Zone 124)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 124 AND mg.`name` IN ( -- *35-39
    'Goblin_Smithy',
    'Goblin_Pathfinder',
    'Goblin_Shaman'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 38, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 124 AND mg.`name` = 'Goblin_Reaper'; -- *41-45
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 124 AND mg.`name` = 'Young_Opo-opo'; -- *40-44
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 124 AND mg.`name` = 'Big_Jaw'; -- *43-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 124 AND mg.`name` IN ( -- *45-49
    'Goblin_Robber',
    'Goblin_Trader',
    'Goblin_Poacher',
    'Tonberry_Creeper',
    'Tonberry_Hexer',
    'Tonberry_Harasser'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 124 AND mg.`name` = 'Goblin_Bouncer'; -- *51-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 124 AND mg.`name` = 'Goblin_Hunter'; -- *51-55

-- WESTERN_ALTEPA_DESERT (Zone 125)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Desert_Spider'; -- *40-44
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Antican_Essedarius'; -- *41-45
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Desert_Worm'; -- *43-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Desert_Dhalmel'; -- *44-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Antican_Retiarius'; -- *45-49
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 46, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Antican_Eques'; -- *45-49
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 48, msp.`maxLevel` = 51 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Desert_Beetle'; -- *47-51
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 50, msp.`maxLevel` = 53 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Cactuar'; -- *48-53
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 125 AND mg.`name` IN ( -- *51-55
    'Goblin_Welldigger',
    'Goblin_Bouncer',
    'Goblin_Enchanter',
    'Goblin_Hunter',
    'Goblin_Digger'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 54, msp.`maxLevel` = 57 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Desert_Manticore'; -- *53-57
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 54, msp.`maxLevel` = 57 WHERE mg.`zoneid` = 125 AND mg.`name` IN ( -- *54-58
    'Antican_Secutor',
    'Antican_Lanista',
    'Antican_Hoplomachus'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 61, msp.`maxLevel` = 63 WHERE mg.`zoneid` = 125 AND mg.`name` = 'Dahu'; -- *57-57
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 125 AND mg.`name` = 'King_Vinegarroon'; -- *80-85

-- Custom change.
UPDATE `mob_groups` SET `HP` = 2500 WHERE `zoneid` = 125 AND `name` = 'Celphie';

-- QUFIM_ISLAND (Zone 126)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 126 AND mg.`name` = 'Clipper'; -- *25-29
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 126 AND mg.`groupid` = 15 AND mg.`name` = 'Gigass_Leech'; -- *21-30

-- BEHEMOTHS_DOMINION (Zone 127)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 127 AND mg.`name` = 'Demonic_Weapon'; -- *45-46
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 127 AND mg.`name` = 'Lost_Soul_blm'; -- *45-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 127 AND mg.`name` = 'Lost_Soul_war'; -- *45-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 127 AND mg.`name` = 'Master_Coeurl'; -- *45-50
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 127 AND mg.`name` = 'Behemoth'; -- *70-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 127 AND mg.`name` = 'King_Behemoth'; -- *85-85

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 128 AND mg.`name` = 'Velociraptor'; -- *66-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 128 AND mg.`name` = 'Adamantoise'; -- *70-70

-- RUAUN_GARDENS (Zone 130)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 130 AND mg.`name` = 'Despot'; -- *80-82
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 130 AND mg.`name` IN ( -- *88-90
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 77, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 134 AND `minLevel` > 84 AND mg.`name` IN (
    'Hydra_Warrior',
    'Hydra_Monk',
    'Hydra_White_Mage',
    'Hydra_Red_Mage',
    'Hydra_Black_Mage',
    'Hydra_Thief',
    'Hydra_Paladin',
    'Hydra_Dark_Knight',
    'Hydra_Beastmaster',
    'Hydras_Hound',
    'Hydra_Bard',
    'Hydra_Ranger',
    'Hydra_Samurai',
    'Hydra_Ninja',
    'Hydra_Dragoon',
    'Hydras_Wyvern',
    'Hydra_Summoner',
    'Hydras_Avatar'
);
-- Hydra Tier 2 - 87-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 87, msp.`maxLevel` = 90 WHERE mg.`zoneid` = 134 AND `minLevel` > 84 AND mg.`name` IN (
    'Hydra_Beastmaster',
    'Hydras_Hound',
    'Hydra_Thief',
    'Hydra_Dark_Knight',
    'Hydra_Warrior',
    'Hydra_Bard',
    'Hydra_Ranger',
    'Hydra_White_Mage',
    'Hydra_Monk',
    'Hydra_Ninja',
    'Hydra_Summoner',
    'Hydras_Avatar',
    'Hydra_Black_Mage',
    'Hydra_Dragoon',
    'Hydras_Wyvern',
    'Hydra_Red_Mage',
    'Hydra_Paladin',
    'Hydra_Samurai'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_XARCABARD (Zone 135)
-----------------------------------
-- Tier 1 Kindred - 77-80 -- Unchanged
-- Tier 2 Kindred - 88-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 135 AND `minLevel` > 84 AND mg.`name` IN (
    'Kindred_Warrior',
    'Kindred_White_Mage',
    'Kindred_Red_Mage',
    'Kindred_Monk',
    'Kindred_Black_Mage',
    'Kindred_Thief',
    'Kindred_Paladin',
    'Kindred_Dark_Knight',
    'Kindred_Beastmaster',
    'Kindreds_Vouivre',
    'Kindred_Bard',
    'Kindred_Ranger',
    'Kindred_Samurai',
    'Kindred_Ninja',
    'Kindred_Dragoon',
    'Kindreds_Wyvern',
    'Kindred_Summoner',
    'Kindreds_Avatar'
);
-- Satelite Weapons
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 77, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 135 AND mg.`name` IN ( -- *77-79
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 7, msp.`maxLevel` = 9 WHERE mg.`zoneid` = 140 AND mg.`name` IN ( -- *3-9
    'Orcish_Fodder',
    'Orcish_Stonechucker',
    'Orcish_Neckchopper'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 15 WHERE mg.`zoneid` = 140 AND mg.`name` IN ( -- *11-15
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 17 WHERE mg.`zoneid` = 141 AND mg.`name` IN ( -- *11-17
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 15, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 142 AND mg.`name` IN ( -- *14-18
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 6 WHERE mg.`zoneid` = 143 AND mg.`name` = 'Pit_Hare'; -- *2-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 12 WHERE mg.`zoneid` = 143 AND mg.`name` = 'Copper_Beetle'; -- *9-12
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 7, msp.`maxLevel` = 10 WHERE mg.`zoneid` = 143 AND mg.`name` IN ( -- *3-10
    'Young_Quadav',
    'Amethyst_Quadav',
    'Amber_Quadav'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 143 AND mg.`name` IN ( -- *11-18
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 14 WHERE mg.`zoneid` = 145 AND mg.`name` = 'Giant_Pugil'; -- *9-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 14 WHERE mg.`zoneid` = 145 AND mg.`name` = 'Digger_Wasp'; -- *11-13
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 7, msp.`maxLevel` = 10 WHERE mg.`zoneid` = 145 AND mg.`name` IN ( -- *3-10
    'Yagudo_Initiate',
    'Yagudo_Acolyte',
    'Yagudo_Scribe'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 15, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 145 AND mg.`name` IN ( -- *11-18
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 147 AND mg.`name` IN ( -- *22-26/27/28
    'Old_Quadav',
    'Copper_Quadav',
    'Brass_Quadav'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 147 AND mg.`name` IN ( -- *32/33/34/35-36/37/38/39
    'Silver_Quadav',
    'Garnet_Quadav',
    'Zircon_Quadav',
    'Bronze_Quadav'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 147 AND mg.`name` IN ( -- *42/43/44/45-46/47/48/49
    'Silver_Quadav',
    'Garnet_Quadav',
    'Zircon_Quadav',
    'Bronze_Quadav'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 147 AND mg.`name` IN ( -- *52/53/54/55-56/57/58/59
    'Steel_Quadav',
    'Mythril_Quadav',
    'Gold_Quadav',
    'Topaz_Quadav'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 147 AND mg.`name` IN ( -- *62/63/64/65-66/67/68/69
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 148 AND mg.`name` = 'Diamond_Quadav'; -- *75-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 148 AND mg.`name` = 'ZaDha_Adamantking'; -- *85-85

-- DAVOI (Zone 149)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 149 AND mg.`name` IN ( -- *22-26/27/28
    'Orcish_Fighter',
    'Orcish_Cursemaker',
    'Orcish_Serjeant'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 149 AND mg.`name` IN ( -- *32/33/34/35-36/37/38/39
    'Orcish_Impaler',
    'Orcish_Beastrider',
    'Orcish_Nightraider',
    'Orcish_Brawler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 149 AND mg.`name` IN ( -- *42/43/44/45-46/47/48/49
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 149 AND mg.`name` IN ( -- *52/53/54/55-56/57/58/59
    'Orcish_Veteran',
    'Orcish_Predator',
    'Orcish_Zerker',
    'Orcish_Warchief'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 149 AND mg.`name` IN ( -- *62/63/64/65-66/67/68/69
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 150 AND mg.`name` IN ( -- *42/43/44/45-46/47/48/49
    'Orcish_Bowshooter',
    'Orcish_Footsoldier',
    'Orcish_Gladiator',
    'Orcish_Trooper'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 150 AND mg.`name` IN ( -- *52/53/54/55-56/57/58/59
    'Orcish_Veteran',
    'Orcish_Predator',
    'Orcish_Zerker',
    'Orcish_Warchief'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 150 AND mg.`name` IN ( -- *62/63/64/65-72
    'Orcish_Farkiller',
    'Orcish_Dreadnought',
    'Orcish_Champion',
    'Orcish_Dragoon'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 150 AND mg.`name` = 'Orcish_Overlord'; -- *75-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 150 AND mg.`name` = 'Overlord_Bakgodek'; -- *85-85

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 151 AND mg.`name` IN ( -- *22/23-26/27/28
    'Yagudo_Votary',
    'Yagudo_Theologist',
    'Yagudo_Priest'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 151 AND mg.`name` IN ( -- *32/33/34/35-36/37/38/39
    'Yagudo_Herald',
    'Yagudo_Oracle',
    'Yagudo_Interrogator',
    'Yagudo_Drummer'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 151 AND mg.`name` IN ( -- *42/43/44/45-46/47/48/49
    'Yagudo_Zealot',
    'Yagudo_Prior',
    'Yagudo_Conquistador',
    'Yagudo_Lutenist'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 151 AND mg.`name` IN ( -- *51/53/54-56/57/59
    'Yagudo_Sentinel',
    'Yagudo_Abbot',
    'Yagudo_Chanter',
    'Yagudo_Inquisitor'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 151 AND mg.`name` IN ( -- *62/63/64/65-66/67/69/72
    'Yagudo_Flagellant',
    'Yagudo_Prelate',
    'Yagudo_Conductor',
    'Yagudo_Assassin'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 151 AND mg.`name` = 'Yagudo_Avatar'; -- *75-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 151 AND mg.`name` = 'Tzee_Xicu_the_Manifest'; -- *85-85

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Robber_Crab'; -- *62-66
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 66 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Moss_Eater'; -- *62-66
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Knight_Crawler'; -- *62-67
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Mourioche'; -- *62-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 72, msp.`maxLevel` = 74 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Unut'; -- *72-72
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 76, msp.`maxLevel` = 79 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Bark_Tarantula'; -- *75-79
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Voluptuous_Vivian'; -- *85-85
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Snaggletooth_Peapuk'; -- *102-105
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Viseclaw'; -- *102-105
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 153 AND mg.`name` = 'Mourning_Crawler'; -- *103-105

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 153 AND `name` IN (
    'Bark_Spider',
    'Death_Cap',
    'Robber_Crab',
    'Moss_Eater',
    'Mourioche',
    'Old_Goobbue',
    'Morbol_Menace',
    'Water_Elemental',
    'Thunder_Elemental',
    'Korrigan',
    'Skimmer',
    'Processionaire',
    'Steelshell',
    'Elder_Goobbue',
    'Boyahda_Sapling',
    'Darter',
    'Blood_Ball',
    'Demonic_Rose',
    'Bark_Tarantula'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 153 AND `name` = 'Snaggletooth_Peapuk';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 153 AND `name` = 'Viseclaw';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 153 AND `name` = 'Mourning_Crawler';

-- DRAGONS_AERY (Zone 154)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 90, msp.`maxLevel` = 92 WHERE mg.`zoneid` = 154 AND mg.`name` = 'Fafnir'; -- *90-90
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 92, msp.`maxLevel` = 94 WHERE mg.`zoneid` = 154 AND mg.`name` = 'Nidhogg'; -- *90-90

-- CASTLE_ZVAHL_KEEP_S (Zone 155)
-----------------------------------
-- TODO

-- MIDDLE_DELKFUTTS_TOWER (Zone 157)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 157 AND mg.`name` = 'Mold_Bats'; -- *25-27
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 28, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 157 AND mg.`name` = 'Tower_Bats'; -- *27-29
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 28, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 157 AND mg.`name` = 'Stirge'; -- *27-29
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 157 AND mg.`name` = 'Big_Bat'; -- *29-31
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 157 AND mg.`name` IN ( -- *30-34
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 157 AND mg.`name` IN ( -- *30-32
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 34, msp.`maxLevel` = 36 WHERE mg.`zoneid` = 158 AND mg.`name` IN ( -- *34-35
    'Gigas_Torturer',
    'Gigas_Bonecutter',
    'Gigas_Stonemason',
    'Gigas_Spirekeeper',
    'Magic_Urn'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 158 AND mg.`name` = 'Mimas'; -- *36-36
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 158 AND mg.`name` = 'Porphyrion'; -- *36-36
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 158 AND mg.`name` = 'Pallas'; -- *72-72
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 158 AND mg.`name` = 'Alkyoneus'; -- *75-75

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 159 AND mg.`name` = 'Iron_Maiden'; -- *64-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 159 AND mg.`name` IN ( -- *51-59
    'Tonberry_Stalker',
    'Tonberry_Cutter',
    'Tonberry_Harrier'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 159 AND mg.`name` IN ( -- *61-68/69
    'Tonberry_Maledictor',
    'Tonberry_Pursuer',
    'Tonberry_Stabber',
    'Tonberry_Dismayer'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 159 AND mg.`name` = 'Temple_Guardian'; -- *65-65

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 160 AND mg.`name` = 'Mousse'; -- *64-70 - Only fished Mousse exceed 67.
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 160 AND mg.`name` = 'Succubus_Bats'; -- *65-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 76, msp.`maxLevel` = 79 WHERE mg.`zoneid` = 160 AND mg.`name` = 'Tormentor'; -- *75-79
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 160 AND mg.`name` = 'Friar_Rush'; -- *70-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 160 AND mg.`name` = 'Hakutaku'; -- *85-85

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
    'Bullbeggar',
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 48, msp.`maxLevel` = 50 WHERE mg.`zoneid` = 161 AND mg.`name` = 'Evil_Eye'; -- *46-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 49, msp.`maxLevel` = 52 WHERE mg.`zoneid` = 161 AND mg.`name` = 'Demon_Pawn'; -- *48-52

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 50, msp.`maxLevel` = 52 WHERE mg.`zoneid` = 162 AND mg.`name` = 'Evil_Eye'; -- *46-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 162 AND mg.`name` = 'Morbid_Eye'; -- *52-53 (52-55 in Baileys)

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Wind_Bats'; -- *3-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Blade_Bat'; -- *4-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Goblin_Thug'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Goblin_Weaver'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Seeker_Bats'; -- *25-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 166 AND mg.`name` IN ( -- *26-30
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 40, msp.`maxLevel` = 43 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Bilesucker'; -- (Passive)
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Hovering_Oculus';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 166 AND mg.`name` IN (
    'Goblin_Hoodoo',
    'Goblin_Artificer',
    'Goblin_Tanner',
    'Goblin_Chaser'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 166 AND mg.`name` = 'Goblins_Bats';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 56 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Funnel_Bats'; -- *52-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Werebat'; -- *55-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Mousse'; -- *58-62
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Arioch'; -- *56-62
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 76, msp.`maxLevel` = 78 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Nachtmahr';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Blind_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Dabilla';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Panna_Cotta';
UPDATE `mob_groups` SET `MP` = 3000 WHERE `zoneid` = 167 AND `name` = 'Panna_Cotta';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 167 AND mg.`name` = 'Wurdalak';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Plunderer_Crab';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Blackwater_Pugil';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Deviling_Bats';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Rapier_Scorpion';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Starborer';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Sodden_Bones';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Drowned_Bones';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Flume_Toad';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 71, msp.`maxLevel` = 73 WHERE mg.`zoneid` = 169 AND mg.`name` = 'Poroggo_Excavator';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 172 AND mg.`name` = 'Soot_Crab';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 172 AND mg.`name` = 'Burrower_Worm';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 172 AND mg.`name` = 'Colliery_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 172 AND mg.`name` = 'Veindigger_Leech';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Land_Worm'; -- *20-25
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Seeker_Bats'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 29, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Greater_Pugil'; -- *25-32
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 32, msp.`maxLevel` = 33 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Korroloka_Leech'; -- *32-32
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Lacerator';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 173 AND mg.`name` = 'Spool_Leech';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 174 AND mg.`name` = 'Devil_Manta_fished'; -- *66-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 174 AND mg.`name` = 'Amemet'; -- *66-66
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 174 AND mg.`name` = 'Pelican'; -- *80-81
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 174 AND mg.`name` = 'Kuftal_Delver';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 174 AND mg.`name` = 'Machairodus';

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Vampire_Bat'; -- *42-45
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Brook_Sahagin'; -- *41-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 44, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Rivulet_Sahagin'; -- *41-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Bigclaw'; -- *43-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 56 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Sahagin_Parasite'; -- *50-53
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Rock_Crab'; -- *53-58
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Blubber_Eyes'; -- *55-58
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 176 AND mg.`name` IN ( -- * 52-59
    'Marsh_Sahagin',
    'Swamp_Sahagin',
    'Bog_Sahagin'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Mousse'; -- *62-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Dire_Bat'; -- *63-66
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Robber_Crab'; -- *62-67
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Devil_Manta'; -- *66-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 71 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Mindgazer'; -- *66-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 71 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Greatclaw'; -- *66-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 71 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Nightmare_Bats'; -- *66-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 176 AND mg.`name` IN ( -- * 62-72
    'Shore_Sahagin',
    'Coastal_Sahagin',
    'Delta_Sahagin',
    'Lagoon_Sahagin'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Masan'; -- *39-39
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 48, msp.`maxLevel` = 50 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Seww_the_Squidlimbed'; -- *48-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Pahh_the_Gullcaller'; -- *57-57
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 64 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Sea_Hog'; -- *62-62
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Zuug_the_Shoreleaper'; -- *70-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Ocean_Sahagin'; -- *75-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Water_Leaper'; -- *80-80
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 176 AND mg.`name` = 'Charybdis'; -- *80-81

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 78 WHERE mg.`zoneid` = 177 AND mg.`name` = 'Mystic_Weapon'; -- *74-77
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 177 AND mg.`name` = 'Steam_Cleaner'; -- *81-82
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 86 WHERE mg.`zoneid` = 177 AND mg.`name` = 'Brigandish_Blade'; -- *82-84
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 177 AND mg.`name` = 'Zipacna'; -- *83-85

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 74, msp.`maxLevel` = 76 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Defender'; -- *71-76
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 78, msp.`maxLevel` = 80 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Aura_Pot'; -- *75-80
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Aura_Gear'; -- *76-81
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Aura_Butler'; -- *77-82
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Mother_Globe'; -- *83-83
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Faust'; -- *83-85
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 86, msp.`maxLevel` = 88 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Ullikummi'; -- *85-87
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 94, msp.`maxLevel` = 94 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Kirin'; -- *92-92
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Genbu_pet'; -- *83-84
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Seiryu_pet'; -- *83-84
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Byakko_pet'; -- *83-84
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 84, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 178 AND mg.`name` = 'Suzaku_pet'; -- *83-84
UPDATE `mob_groups` SET `HP` = 6500 WHERE `zoneid` = 178 AND `name` = 'Olla_Media'; -- *5200
UPDATE `mob_groups` SET `HP` = 8000 WHERE `zoneid` = 178 AND `name` = 'Olla_Grande'; -- *5300
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 178 AND mg.`name` IN (
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 184 AND mg.`name` = 'Seeker_Bats'; -- *25-27
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 28, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 184 AND mg.`name` = 'Ancient_Bat'; -- *27-29

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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 185 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Footsoldier',
    'Vanguard_Grappler',
    'Vanguard_Amputator',
    'Vanguard_Mesmerizer',
    'Vanguard_Vexer',
    'Vanguard_Pillager',
    'Vanguard_Trooper',
    'Vanguard_Neckchopper',
    'Vanguard_Hawker',
    'Vanguards_Hecteyes',
    'Vanguard_Bugler',
    'Vanguard_Predator',
    'Vanguard_Gutslasher',
    'Vanguard_Backstabber',
    'Vanguard_Impaler',
    'Vanguards_Wyvern',
    'Vanguard_Dollmaster',
    'Vanguards_Avatar'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_BASTOK (Zone 186)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 2 - 85-87
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 186 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Vindicator',
    'Vanguard_Militant',
    'Vanguard_Constable',
    'Vanguard_Thaumaturge',
    'Vanguard_Protector',
    'Vanguard_Defender',
    'Vanguard_Beasttender',
    'Vanguards_Scorpion',
    'Vanguard_Drakekeeper',
    'Vanguards_Wyvern',
    'Vanguard_Purloiner',
    'Vanguard_Vigilante',
    'Vanguard_Minstrel',
    'Vanguard_Hatamoto',
    'Vanguard_Mason',
    'Vanguard_Kusa',
    'Vanguard_Undertaker',
    'Vanguards_Avatar'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_WINDURST (Zone 187)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 2 - 85-87
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 187 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Salvager',
    'Vanguard_Skirmisher',
    'Vanguard_Priest',
    'Vanguard_Prelate',
    'Vanguard_Visionary',
    'Vanguard_Sentinel',
    'Vanguard_Exemplar',
    'Vanguard_Ogresoother',
    'Vanguards_Crow',
    'Vanguard_Inciter',
    'Vanguard_Liberator',
    'Vanguard_Assassin',
    'Vanguard_Persecutor',
    'Vanguard_Chanter',
    'Vanguard_Partisan',
    'Vanguards_Wyvern',
    'Vanguard_Oracle',
    'Vanguards_Avatar'
);
-- TODO: OoE force spawn NMs

-- DYNAMIS_JEUNO (Zone 188)
-----------------------------------
-- Tier 1 - 75-77 -- Unchanged
-- Tier 1 NMs
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 188 AND mg.`name` IN ( -- * 73/75/79-73/77/79
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 188 AND `minLevel` > 84 AND mg.`name` IN (
    'Vanguard_Smithy',
    'Vanguard_Pitfighter',
    'Vanguard_Welldigger',
    'Vanguard_Alchemist',
    'Vanguard_Shaman',
    'Vanguard_Enchanter',
    'Vanguard_Tinkerer',
    'Vanguard_Dragontamer',
    'Vanguards_Wyvern',
    'Vanguard_Pathfinder',
    'Vanguards_Slime',
    'Vanguard_Maestro',
    'Vanguard_Armorer',
    'Vanguard_Necromancer',
    'Vanguards_Avatar',
    'Vanguard_Ambusher',
    'Vanguard_Hitman'
);
-- Tier 2 NMs
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 87, msp.`maxLevel` = 89 WHERE mg.`zoneid` = 188 AND mg.`name` IN (
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
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Ding_Bats'; -- *2-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Carrion_Worm'; -- *2-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Mouse_Bat'; -- *3-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Goblin_Thug'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Goblin_Weaver'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Enchanted_Bones_blm'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Enchanted_Bones_war'; -- *4-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 12 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Wind_Bats'; -- *9-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 10, msp.`maxLevel` = 12 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Hati'; -- *9-11
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 14 WHERE mg.`zoneid` = 190 AND mg.`name` IN ( -- *12-16
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 58, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Tomb_Worm';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Tomb_Worm';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Thousand_Eyes';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Thousand_Eyes';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 64 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Dire_Bat';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Dire_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Cutlass_Scorpion';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Cutlass_Scorpion';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 66 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Armet_Beetle';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Armet_Beetle';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 80, msp.`maxLevel` = 82 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Lemures';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Lemures';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Hati';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Hati';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Spartoi_Sorcerer';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Spartoi_Sorcerer';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 190 AND mg.`name` = 'Locus_Spartoi_Warrior';
UPDATE `mob_groups` SET `HP` = 0 WHERE `zoneid` = 190 AND `name` = 'Locus_Spartoi_Warrior';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 190 AND `name` IN (
    'Ding_Bats',
    'Carrion_Worm',
    'Goblin_Thug',
    'Mouse_Bat',
    'Goblin_Weaver',
    'Stone_Eater',
    'Enchanted_Bones_blm',
    'Spook',
    'Wind_Bats',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Grave_Bat',
    'Rock_Eater',
    'Nachzehrer_war',
    'Tomb_Bat',
    'Plague_Bats',
    'Enchanted_Bones_war',
    'Nachzehrer_blm'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 190 AND `name` IN (
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 190 AND `name` IN (
    'Locus_Cutlass_Scorpion',
    'Locus_Thousand_Eyes',
    'Hati',
    'Spartoi_Warrior',
    'Spartoi_Sorcerer',
    'Locus_Lemures'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 190 AND `name` IN (
    'Locus_Tomb_Worm',
    'Locus_Dire_Bat',
    'Locus_Armet_Beetle',
    'Locus_Hati',
    'Locus_Spartoi_Sorcerer',
    'Locus_Spartoi_Warrior'
);

-- DANGRUF_WADI (Zone 191)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Stone_Eater'; -- *3-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Goblin_Thug'; -- *5-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Goblin_Weaver'; -- *5-8
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 15 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Wadi_Leech'; -- *11-14
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 13, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 191 AND mg.`name` IN ( -- *12-16
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 15, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Steam_Lizard'; -- *16-20
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Prim_Pika';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Witchetty_Grub';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Couloir_Leech';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 191 AND mg.`name` IN (
    'Goblin_Brigand',
    'Goblin_Headsman',
    'Goblin_Healer'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Fume_Lizard';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Trimmer';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 191 AND mg.`name` = 'Natty_Gibbon';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 191 AND mg.`name` IN (
    'Goblin_Conjurer',
    'Goblin_Bladesmith',
    'Goblin_Bushwhacker'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 191 AND `name` IN (
    'Rock_Lizard',
    'Goblin_Thug',
    'Goblin_Weaver',
    'Hoarder_Hare',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Wadi_Hare',
    'Steam_Lizard',
    'Goblin_Fisher',
    'Stone_Eater',
    'Wadi_Crab',
    'Wadi_Leech'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 191 AND `name` IN (
    'Goblin_Brigand',
    'Goblin_Headsman',
    'Goblin_Healer',
    'Witchetty_Grub',
    'Couloir_Leech',
    'Prim_Pika',
    'Natty_Gibbon',
    'Trimmer',
    'Fume_Lizard',
    'Goblin_Bladesmith',
    'Goblin_Bushwhacker'
);

-- INNER_HORUTOTO_RUINS (Zone 192)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Battue_Bats'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Goblin_Thug'; -- *1-6
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Goblin_Weaver'; -- *1-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Blob'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 19, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Battle_Bat'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Boggart'; -- *22-26
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 11, msp.`maxLevel` = 14 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Troika_Bats'; -- *Aggressive
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 12, msp.`maxLevel` = 15 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Deathwatch_Beetle'; -- *Aggressive
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 13, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Covin_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Skinnymalinks';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 16 WHERE mg.`zoneid` = 192 AND mg.`name` = 'Skinnymajinx';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 17 WHERE mg.`zoneid` = 192 AND mg.`name` IN (
    'Goblin_Flesher',
    'Goblin_Metallurgist',
    'Goblin_Lurcher',
    'Goblin_Trailblazer'
);

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 192 AND `name` IN (
    'Battue_Bats',
    'Goblin_Thug',
    'Blade_Bat',
    'Goblin_Weaver',
    'Troika_Bats',
    'Deathwatch_Beetle',
    'Goblin_Flesher',
    'Goblin_Metallurgist',
    'Goblin_Lurcher',
    'Skinnymalinks',
    'Skinnymajinx',
    'Covin_Bat',
    'Goblin_Trailblazer',
    'Blob',
    'Balloon'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 192 AND `name` IN (
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Battle_Bat',
    'Will-o-the-Wisp',
    'Boggart',
    'Wendigo_war',
    'Wendigo_blm'
);

-- ORDELLES_CAVES (Zone 193)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 19 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Stink_Bats'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 18, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Blood_Bunny'; -- *17-19
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 18, msp.`maxLevel` = 21 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Hognosed_Bat'; -- *17-20
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 19, msp.`maxLevel` = 22 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Stalking_Sapling'; -- *18-21
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 193 AND mg.`name` IN ( -- *22-26
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Seeker_Bats'; -- *23-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 28, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Ancient_Bat'; -- *26-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 30, msp.`maxLevel` = 32 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Slash_Pine'; -- *27-29
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 32, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Stroper'; -- *31-34
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Buds_Bunny';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Swagger_Spruce';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 37 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Targe_Beetle';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 37, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 193 AND mg.`name` = 'Bilis_Leech';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 193 AND `name` IN (
    'Stink_Bats',
    'Snipper',
    'Blood_Bunny',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Goblin_Ambusher',
    'Hognosed_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 193 AND `name` IN (
    'Stalking_Sapling',
    'Fly_Agaric',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Buds_Bunny',
    'Dung_Beetle',
    'Vorpal_Bunny',
    'Jelly',
    'Swagger_Spruce',
    'Shrieker',
    'Will-o-the-Wisp',
    'Clipper',
    'Seeker_Bats',
    'Ancient_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 193 AND `name` IN (
    'Targe_Beetle',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Buds_Bunny',
    'Goliath_Beetle',
    'Stroper_Chyme',
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman',
    'Slash_Pine',
    'Stroper',
    'Napalm'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime` = 330 WHERE `zoneid` = 193 AND `name` = 'Bilis_Leech';

-- OUTER_HORUTOTO_RUINS (Zone 194)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 3, msp.`maxLevel` = 5 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Battue_Bats'; -- *1-5
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Goblin_Thug'; -- *1-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 4, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Goblin_Weaver'; -- *1-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 7 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Blade_Bat'; -- *4-7
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 5, msp.`maxLevel` = 8 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *1-5
    'Two_of_Cups',
    'Two_of_Batons',
    'Two_of_Swords',
    'Two_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 6, msp.`maxLevel` = 9 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *5-9
    'Three_of_Cups',
    'Three_of_Batons',
    'Three_of_Swords',
    'Three_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 11, msp.`maxLevel` = 14 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *10-14
    'Four_of_Cups',
    'Four_of_Batons',
    'Four_of_Swords',
    'Four_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 14, msp.`maxLevel` = 17 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *10-14
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 15, msp.`maxLevel` = 18 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Stink_Bats'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 19 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *15-19
    'Five_of_Cups',
    'Five_of_Batons',
    'Five_of_Swords',
    'Five_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 21, msp.`maxLevel` = 24 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *20-24
    'Six_of_Cups',
    'Six_of_Batons',
    'Six_of_Swords',
    'Six_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 26, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *25-29
    'Seven_of_Cups',
    'Seven_of_Batons',
    'Seven_of_Swords',
    'Seven_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *30-34
    'Eight_of_Cups',
    'Eight_of_Batons',
    'Eight_of_Swords',
    'Eight_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *35-39
    'Nine_of_Batons',
    'Nine_of_Cups',
    'Nine_of_Swords',
    'Nine_of_Coins'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 194 AND mg.`name` IN ( -- *40-44
    'Ten_of_Cups',
    'Ten_of_Batons',
    'Ten_of_Swords',
    'Ten_of_Coins'
);
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 22, msp.`maxLevel` = 25 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Fuligo';
UPDATE `mob_groups` SET `MP` = 500 WHERE `zoneid` = 194 AND `name` = 'Fuligo';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Thorn_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 29 WHERE mg.`zoneid` = 194 AND mg.`name` = 'Fetor_Bats';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 194 AND `name` IN (
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Stink_Bats',
    'Rotten_Jam',
    'Two_of_Cups',
    'Two_of_Batons',
    'Two_of_Swords',
    'Two_of_Coins',
    'Three_of_Cups',
    'Three_of_Batons',
    'Three_of_Swords',
    'Three_of_Coins',
    'Four_of_Cups',
    'Four_of_Batons',
    'Four_of_Swords',
    'Four_of_Coins',
    'Five_of_Cups',
    'Five_of_Batons',
    'Five_of_Swords',
    'Five_of_Coins',
    'Balloon',
    'Battue_Bats',
    'Goblin_Thug',
    'Goblin_Weaver',
    'Blade_Bat'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 194 AND `name` IN (
    'Black_Slime',
    'Ghoul_war',
    'Combat',
    'Six_of_Cups',
    'Six_of_Batons',
    'Six_of_Swords',
    'Six_of_Coins',
    'Seven_of_Cups',
    'Seven_of_Batons',
    'Seven_of_Swords',
    'Seven_of_Coins',
    'Dancing_Weapon',
    'Ghoul_blm'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 194 AND `name` IN (
    'Eight_of_Cups',
    'Eight_of_Batons',
    'Eight_of_Swords',
    'Eight_of_Coins',
    'Nine_of_Batons',
    'Nine_of_Cups',
    'Nine_of_Swords',
    'Nine_of_Coins'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 194 AND `name` IN (
    'Ten_of_Cups',
    'Ten_of_Batons',
    'Ten_of_Swords',
    'Ten_of_Coins'
);
UPDATE `mob_groups` SET `respawntime` = 4200 WHERE `zoneid` = 194 AND `name` = 'Legalox_Heftyhind';
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 194 AND `name` IN (
    'Fuligo',
    'Thorn_Bat',
    'Fetor_Bats'
);

-- THE_ELDIEME_NECROPOLIS (Zone 195)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Lost_Soul_blm'; -- *42-46
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 43, msp.`maxLevel` = 46 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Lost_Soul_war'; -- *42-46
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Lich'; -- *51-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Gluttony'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Greed'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Sloth'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Lust'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Pride'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Envy'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Skull_of_Wrath'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Cwn_Cyrff'; -- *68-68
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Hellbound_Warrior';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Hellbound_Warlock';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 57, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 195 AND mg.`name` = 'Nekros_Hound';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 195 AND `name` IN (
    'Marchosias',
    'Lost_Soul_blm',
    'Shade_war',
    'Shade_rng',
    'Shade_thf',
    'Shade_drk',
    'Revenant',
    'Hell_Hound',
    'Anemone',
    'Gazer',
    'Puroboros',
    'Lost_Soul_war'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 195 AND `name` IN (
    'Mummy',
    'Lich',
    'Blood_Soul',
    'Ka_war',
    'Ka_blm',
    'Ka_rng',
    'Ka_thf',
    'Tomb_Wolf',
    'Utukku',
    'Dark_Stalker_war',
    'Dark_Stalker_blm',
    'Dark_Stalker_thf',
    'Dark_Stalker_rng',
    'Azer',
    'Fallen_Knight',
    'Ice_Elemental',
    'Earth_Elemental',
    'Haunt',
    'Tomb_Warrior',
    'Tomb_Mage',
    'Spriggan_war',
    'Spriggan_blm',
    'Spriggan_thf',
    'Spriggan_rng'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 195 AND `name` IN (
    'Hellbound_Warrior',
    'Hellbound_Warlock',
    'Nekros_Hound'
);

-- GUSGEN_MINES (Zone 196)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 20, msp.`maxLevel` = 23 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Ghoul_war'; -- *20-27
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 27, msp.`maxLevel` = 30 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Wendigo_war'; -- *26-30
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Wight_war'; -- *30-34
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Ghast_blm'; -- *33-36
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 40, msp.`maxLevel` = 43 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Rockmill';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Madfly';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Accursed_Soldier';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 42, msp.`maxLevel` = 45 WHERE mg.`zoneid` = 196 AND mg.`name` = 'Accursed_Sorcerer';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 196 AND `name` = 'Skeleton_Warrior';
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 196 AND `name` IN (
    'Fly_Agaric',
    'Ghoul_war',
    'Bandersnatch',
    'Ore_Eater',
    'Spunkie',
    'Bogy',
    'Wendigo_war',
    'Sadfly',
    'Jelly',
    'Mauthe_Doog',
    'Amphisbaena'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 196 AND `name` IN (
    'Wight_war',
    'Myconid',
    'Feu_Follet',
    'Thunder_Elemental',
    'Earth_Elemental',
    'Rancid_Ooze',
    'Gallinipper',
    'Banshee',
    'Ghast_blm',
    'Wight_blm'
);
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 196 AND `name` IN (
    'Rockmill',
    'Madfly',
    'Accursed_Soldier',
    'Accursed_Sorcerer'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 196 AND `name` = 'Greater_Pugil';

-- CRAWLERS_NEST (Zone 197)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 41, msp.`maxLevel` = 44 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Worker_Crawler'; -- *40-44
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 47, msp.`maxLevel` = 49 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Doom_Scorpion'; -- *45-47
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Demonic_Tiphia'; -- *60-60
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Dynast_Beetle'; -- *56-65
-- Basket spawned Crawler level is not correctly distinguished by location. Spawning the higher location level for both.
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 50, msp.`maxLevel` = 50 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Guardian_Crawler'; -- *45-50
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Drone_Crawler'; -- *50-50
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 61, msp.`maxLevel` = 64 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Vespo';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Olid_Funguar';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 197 AND mg.`name` = 'Dancing_Jewel';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 197 AND mg.`name` = 'King_Crawler';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 197 AND `name` IN (
    'Worker_Crawler',
    'Death_Jacket',
    'Maze_Lizard',
    'Killer_Mushroom',
    'Doom_Scorpion',
    'Caveberry',
    'Nest_Beetle',
    'Soul_Stinger'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 197 AND `name` IN (
    'Hornfly',
    'Exoray',
    'King_Crawler',
    'Vespo',
    'Dancing_Jewel',
    'Olid_Funguar',
    'Fire_Elemental',
    'Water_Elemental',
    'Blazer_Beetle',
    'Dynast_Beetle',
    'Helm_Beetle',
    'Knight_Crawler',
    'Labyrinth_Lizard',
    'Witch_Hazel',
    'Soul_Stinger',
    'Mushussu',
    'Dragonfly',
    'Crawler_Hunter'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 197 AND `name` = 'Soldier_Crawler';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 197 AND `name` = 'Rumble_Crawler';

-- MAZE_OF_SHAKHRAMI (Zone 198)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 16, msp.`maxLevel` = 19 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Stink_Bats'; -- *15-18
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 17, msp.`maxLevel` = 20 WHERE mg.`zoneid` = 198 AND mg.`name` IN ( -- *16-18
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Ghoul_war'; -- *22-26
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 23, msp.`maxLevel` = 26 WHERE mg.`zoneid` = 198 AND mg.`name` IN ( -- *22-26
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 24, msp.`maxLevel` = 27 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Wendigo_blm'; -- *24-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 24, msp.`maxLevel` = 27 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Maze_Scorpion'; -- *25-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 25, msp.`maxLevel` = 28 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Poison_Leech'; -- *24-28
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 31, msp.`maxLevel` = 34 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Goblin_Shaman'; -- *30-34
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Lesath'; -- *36-36
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 57 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Trembler_Tabitha'; -- *55-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 58, msp.`maxLevel` = 60 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Gloombound_Lurker'; -- *58-58
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 35, msp.`maxLevel` = 38 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Chaser_Bats';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 36, msp.`maxLevel` = 39 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Bleeder_Leech';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 38, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Warren_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 42 WHERE mg.`zoneid` = 198 AND mg.`name` = 'Crypterpillar';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 480 WHERE `zoneid` = 198 AND `name` IN (
    'Stink_Bats',
    'Goblin_Ambusher',
    'Goblin_Tinkerer',
    'Goblin_Butcher',
    'Maze_Maker'
);
UPDATE `mob_groups` SET `respawntime`= 600 WHERE `zoneid` = 198 AND `name` IN (
    'Combat',
    'Carnivorous_Crawler',
    'Goblin_Mugger',
    'Goblin_Leecher',
    'Goblin_Gambler',
    'Ghoul_war',
    'Seeker_Bats',
    'Wendigo_blm',
    'Poison_Leech',
    'Goblins_Bat',
    'Maze_Scorpion',
    'Jelly',
    'Ancient_Bat',
    'Abyss_Worm'
);
UPDATE `mob_groups` SET `respawntime`= 720 WHERE `zoneid` = 198 AND `name` IN (
    'Protozoan',
    'Caterchipillar',
    'Labyrinth_Scorpion',
    'Goblin_Pathfinder',
    'Goblin_Furrier',
    'Goblin_Smithy',
    'Goblin_Shaman',
    'Wight_war',
    'Wight_blm',
    'Air_Elemental',
    'Earth_Elemental',
    'Bleeder_Leech',
    'Chaser_Bats',
    'Crypterpillar',
    'Warren_Bat'
);

-- GARLAIGE_CITADEL (Zone 200)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Funnel_Bats'; -- *51-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 54 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Old_Two-Wings'; -- *52-52
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 54, msp.`maxLevel` = 56 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Skewer_Sam'; -- *54-54
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Serket'; -- *70-70
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 58, msp.`maxLevel` = 61 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Fortalice_Bats';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 63 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Donjon_Bat';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 61, msp.`maxLevel` = 64 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Warden_Beetle';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 62, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 200 AND mg.`name` = 'Kaboom';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 200 AND `name` IN (
    'Borer_Beetle',
    'Siege_Bat',
    'Wingrats',
    'Fallen_Evacuee_blm',
    'Puroboros',
    'Oil_Spill',
    'Clockwork_Pod',
    'Revenant',
    'Citadel_Bats',
    'Demonic_Weapon',
    'Fallen_Soldier_blm',
    'Bhuta',
    'Fallen_Evacuee_war',
    'Fallen_Soldier_war'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 200 AND `name` IN (
    'Fortalice_Bats',
    'Fetid_Flesh',
    'Explosure',
    'Earth_Elemental',
    'Droma',
    'Thunder_Elemental',
    'Fallen_Officer_blm',
    'Acid_Grease',
    'Wraith',
    'Tainted_Flesh',
    'Hellmine',
    'Kaboom',
    'Over_Weapon',
    'Vault_Weapon',
    'Fallen_Major',
    'Fallen_Mage',
    'Warden_Beetle',
    'Magic_Jug',
    'Donjon_Bat',
    'Warren_Bat',
    'Fallen_Officer_war'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 200 AND `name` = 'Chamber_Beetle';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 200 AND `name` = 'Funnel_Bats';

-- FEIYIN (Zone 204)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 39, msp.`maxLevel` = 41 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Undead_Bats'; -- *38-40
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 51, msp.`maxLevel` = 54 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Underworld_Bats'; -- *50-52
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 52, msp.`maxLevel` = 55 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Camazotz'; -- *51-54
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 61, msp.`maxLevel` = 63 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Mind_Hoarder'; -- *61-61
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Capricious_Cassie'; -- *70-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Jenglot'; -- *73-73
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 47 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Wekufe';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 59, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Balayang';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 60, msp.`maxLevel` = 62 WHERE mg.`zoneid` = 204 AND mg.`name` = 'Sentient_Carafe';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 204 AND `name` IN (
    'Undead_Bats',
    'Revenant',
    'Vampire_Bat',
    'Drone',
    'Clockwork_Pod',
    'Ore_Golem',
    'Shadow_war',
    'Shadow_rng',
    'Shadow_blm',
    'Shadow_thf'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 204 AND `name` IN (
    'Underworld_Bats',
    'Camazotz',
    'Talos',
    'Droma',
    'Utukku',
    'Specter_war',
    'Specter_blm',
    'Specter_thf',
    'Specter_rng',
    'Colossus',
    'Ice_Elemental',
    'Dark_Elemental',
    'Killing_Weapon',
    'Hellish_Weapon',
    'Sentient_Carafe',
    'Balayang',
    'Wekufe'
);

-- IFRITS_CAULDRON (Zone 205)
-----------------------------------
-- Lower levels were raised due to the wide level range for bombs being narrowed.
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 66 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Dire_Bat'; -- *60-64 (Night Only)
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Volcano_Wasp'; -- *61-64
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 64, msp.`maxLevel` = 67 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Old_Opo-opo'; -- *61-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Volcanic_Gas'; -- *62-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Dodomeki'; -- *63-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 205 AND mg.`name` IN ( -- *66-69
    'Goblin_Bandit',
    'Goblin_Shepherd',
    'Goblin_Alchemist',
    'Goblin_Mercenary'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 72, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Nightmare_Bats'; -- *68-72
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 74, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Volcanic_Bomb'; -- *71-78
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Vouivre'; -- *79-80
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 85, msp.`maxLevel` = 87 WHERE mg.`zoneid` = 205 AND mg.`name` = 'Ash_Dragon'; -- *85-85

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 205 AND `name` IN (
    'Dire_Bat',
    'Old_Opo-opo',
    'Volcano_Wasp',
    'Volcanic_Gas',
    'Dodomeki',
    'Goblin_Bandit',
    'Goblin_Shepherd',
    'Goblin_Alchemist',
    'Goblin_Mercenary',
    'Nightmare_Bats',
    'Sulfur_Scorpion',
    'Eotyrannus',
    'Volcanic_Bomb',
    'Ash_Lizard',
    'Hurricane_Wyvern'
);

-- QUICKSAND_CAVES (Zone 208)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 56 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sand_Spider'; -- *51-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Helm_Beetle'; -- *51-58
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sand_Eater'; -- *51-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 208 AND mg.`name` IN ( -- *52-59
    'Antican_Hastatus',
    'Antican_Princeps',
    'Antican_Signifer',
    'Sabotender_Bailaor'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 65, msp.`maxLevel` = 68 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sand_Digger'; -- *62-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 66, msp.`maxLevel` = 69 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sand_Tarantula'; -- *65-69
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Girtab'; -- *62-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 67, msp.`maxLevel` = 70 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Spelunking_Sabotender'; -- *62-68
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 68, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 208 AND mg.`name` IN ( -- *62-72
    'Antican_Hastatus',
    'Antican_Princeps',
    'Antican_Signifer',
    'Sabotender_Bailaor'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 57 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sagittarius_X-XIII'; -- *55-55
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 59, msp.`maxLevel` = 61 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sabotender_Bailarin'; -- *59-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 70, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Diamond_Daig'; -- *70-70
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Ancient_Vessel'; -- *72-72 (ZM12)
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 75, msp.`maxLevel` = 77 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Antican_Consul'; -- *75-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 208 AND mg.`name` = 'Sabotender_Bailarina'; -- *81-81

-- GUSTAV_TUNNEL (Zone 212)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 45, msp.`maxLevel` = 48 WHERE mg.`zoneid` = 212 AND mg.`name` = 'Hell_Bat'; -- *44-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 73, msp.`maxLevel` = 75 WHERE mg.`zoneid` = 212 AND mg.`name` = 'Wyvernpoacher_Drachlox'; -- *70-75
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 79, msp.`maxLevel` = 81 WHERE mg.`zoneid` = 212 AND mg.`name` = 'Baobhan_Sith'; -- *77-81
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 81, msp.`maxLevel` = 83 WHERE mg.`zoneid` = 212 AND mg.`name` = 'Boulder_Eater';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 82, msp.`maxLevel` = 84 WHERE mg.`zoneid` = 212 AND mg.`name` = 'Pygmytoise';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 212 AND `name` IN (
    'Hell_Bat',
    'Labyrinth_Leech',
    'Hawker',
    'Greater_Gaylas',
    'Goblin_Poacher',
    'Goblin_Robber',
    'Labyrinth_Lizard',
    'Goblin_Reaper',
    'Makara'
);
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 212 AND `name` IN (
    'Robber_Crab',
    'Goblin_Mercenary',
    'Goblin_Alchemist',
    'Goblin_Shepherd',
    'Doom_Soldier',
    'Doom_Mage',
    'Demonic_Pugil',
    'Earth_Elemental',
    'Doom_Guard',
    'Fire_Elemental',
    'Erlik',
    'Doom_Warlock',
    'Antares',
    'Typhoon_Wyvern'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 212 AND `name` = 'Boulder_Eater';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 212 AND `name` = 'Pygmytoise';

-- LABYRINTH_OF_ONZOZO (Zone 213)
-----------------------------------
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 48, msp.`maxLevel` = 51 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Labyrinth_Leech'; -- *45-48
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 49, msp.`maxLevel` = 52 WHERE mg.`zoneid` = 213 AND mg.`name` IN ( -- *46-49 (Cockatrice are 50-53)
    'Goblin_Poacher',
    'Goblin_Robber',
    'Goblin_Reaper',
    'Goblin_Trader'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 53, msp.`maxLevel` = 56 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Mushussu'; -- *51-57
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 55, msp.`maxLevel` = 58 WHERE mg.`zoneid` = 213 AND mg.`name` IN ( -- *51-58
    'Goblin_Miner',
    'Goblin_Bouncer',
    'Goblin_Hunter',
    'Goblin_Enchanter'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 56, msp.`maxLevel` = 59 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Flying_Manta'; -- *55-59
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 69, msp.`maxLevel` = 72 WHERE mg.`zoneid` = 213 AND mg.`name` IN ( -- *66-69 (Torama are 70-73)
    'Goblin_Alchemist',
    'Goblin_Bandit',
    'Goblin_Shepherd',
    'Goblin_Mercenary'
);
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 61, msp.`maxLevel` = 63 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Peg_Powler'; -- *61-61
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 63, msp.`maxLevel` = 65 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Ubume'; -- *60-65
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 77, msp.`maxLevel` = 79 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Lord_of_Onzozo'; -- *74-77
-- Out of Era
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Babaulas';
UPDATE `mob_spawn_points` msp INNER JOIN `mob_groups` mg ON msp.`groupid` = mg.`groupid` AND mg.`zoneid` = ((msp.`mobid` >> 12) & 0xFFF) SET msp.`minLevel` = 83, msp.`maxLevel` = 85 WHERE mg.`zoneid` = 213 AND mg.`name` = 'Boribaba';

-- Revert to Era dungeon respawn times.
UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 213 AND `name` = 'Labyrinth_Leech';
UPDATE `mob_groups` SET `respawntime`= 960 WHERE `zoneid` = 213 AND `name` IN (
    'Goblin_Poacher',
    'Goblin_Robber',
    'Goblin_Reaper',
    'Goblin_Trader',
    'Cockatrice',
    'Mushussu',
    'Goblin_Miner',
    'Goblin_Bouncer',
    'Goblin_Hunter',
    'Goblin_Enchanter',
    'Flying_Manta',
    'Air_Elemental',
    'Water_Elemental',
    'Tainted_Flesh',
    'Goblin_Alchemist',
    'Goblin_Bandit',
    'Goblin_Shepherd',
    'Goblin_Mercenary',
    'Torama',
    'Labyrinth_Manticore',
    'Wyvern'
);
-- Custom respawn changes.
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 213 AND `name` = 'Babaulas';
UPDATE `mob_groups` SET `respawntime`= 330 WHERE `zoneid` = 213 AND `name` = 'Boribaba';

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

-- FORET_DE_HENNETIEL (Zone 262)
-----------------------------------
-- TODO

-- YORCIA_WEALD (Zone 263)
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
