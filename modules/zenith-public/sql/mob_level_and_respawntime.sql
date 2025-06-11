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

-- MISAREAUX_COAST (Zone 25)
-----------------------------------
UPDATE `mob_groups` SET `respawntime`= 300 WHERE `zoneid` = 25 AND `name` = 'Seaboard_Vulture';

-- PHOMIUNA_AQUEDUCTS (Zone 27)
-----------------------------------
UPDATE `mob_groups` SET `minLevel` = 46, `maxLevel` = 48 WHERE `zoneid` = 27 AND `name` = 'Aqueduct_Spider';

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
UPDATE `mob_groups` SET, `respawntime` = 960, `minLevel` = 57, `maxLevel` = 59 WHERE `zoneid` = 28 AND `name` = 'Aqueduct_Spider';

UPDATE `mob_groups` SET `respawntime`= 840 WHERE `zoneid` = 28 AND `name` IN (
    'Gazer',
    'Greater_Gaylas',
    'Stegotaur'
);

-- RIVERNE_SITE_B01 (Zone 29)
-----------------------------------
UPDATE `mob_groups` SET, `minLevel` = 58, `maxLevel` = 60 WHERE `zoneid` = 29 AND `name` = 'Blazedrake';

-- RIVERNE_SITE_A01 (Zone 30)
-----------------------------------
UPDATE `mob_groups` SET, `minLevel` = 46, `maxLevel` = 49 WHERE `zoneid` = 29 AND `name` = 'Darner';

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
UPDATE `mob_groups` SET, `minLevel` = 81, `maxLevel` = 82 WHERE `zoneid` = 52 AND `name` = 'Locus_Colibri';
UPDATE `mob_groups` SET, `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 52 AND `name` = 'Locus_Wivre';

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
UPDATE `mob_groups` SET, `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 54 AND `name` = 'Naraka_Bat';
UPDATE `mob_groups` SET, `minLevel` = 82, `maxLevel` = 84 WHERE `zoneid` = 54 AND `name` = 'Nirgali';
UPDATE `mob_groups` SET, `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 54 AND `name` = 'Nostokulshedra';
UPDATE `mob_groups` SET, `minLevel` = 83, `maxLevel` = 85 WHERE `zoneid` = 54 AND `name` = 'Dweomershell';

-- MOUNT_ZHAYOLM (Zone 61)
-----------------------------------
UPDATE `mob_groups` SET, `minLevel` = 70, `maxLevel` = 72 WHERE `zoneid` = 61 AND `name` = 'Wootzshell'; -- *70-71
UPDATE `mob_groups` SET, `minLevel` = 73, `maxLevel` = 76 WHERE `zoneid` = 61 AND `name` = 'Assassin_Fly'; -- *71-76
UPDATE `mob_groups` SET, `minLevel` = 71, `maxLevel` = 74 WHERE `zoneid` = 61 AND `name` = 'Magmatic_Eruca'; -- *71-75
UPDATE `mob_groups` SET, `minLevel` = 81, `maxLevel` = 83 WHERE `zoneid` = 61 AND `name` = 'Sulphuric_Jagil';
UPDATE `mob_groups` SET, `minLevel` = 84, `maxLevel` = 86 WHERE `zoneid` = 61 AND `name` = 'Orichalcumshell';
