-- -----------------------------------------------------------------------------
-- ZenithXI NPC Resale Price Adjustments
--
-- Adjusts the base sale price of NPCed items
--
-- resaleItemChanges.sql applies Zenith's global 10% resale reduction.
-- This module overrides the discounted BaseSell directly and update the same tracking table to prevent the reduction from being applied twice.
--
-- Keep this SQL in sync with resaleItemChanges.sql
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `zenith_resale_applied` (
    `itemid` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'item_basic.itemid',
    `applied_sell` INT(10) UNSIGNED NOT NULL COMMENT 'BaseSell this file last wrote for the item',
    PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Ninja tools
-- ----------------------------------------------------------------------
-- Sairui-Ran: 25 -> 17g (15g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(17 * 0.90) WHERE `name` = 'sairui-ran';
-- Tsurara: 10 -> 5g (4g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(5 * 0.90) WHERE `name` = 'tsurara';
-- Shihei: 25 -> 17g (15g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(17 * 0.90) WHERE `name` = 'shihei';
-- Soshi: 25 -> 17g (15g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(17 * 0.90) WHERE `name` = 'soshi';
-- Shinobi-Tabi: 25 -> 17g (15g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(17 * 0.90) WHERE `name` = 'shinobi-tabi';

-- Consumables and utility
-- ----------------------------------------------------------------------
-- Holy Water: 145 -> 75g (67g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(75 * 0.90) WHERE `name` = 'flask_of_holy_water';
-- Rock Cheese: 97 -> 85g (76g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(85 * 0.90) WHERE `name` = 'block_of_rock_cheese';
-- Tortilla Buena: 52 -> 47g (42g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(47 * 0.90) WHERE `name` = 'tortilla_buena';
-- Pumpkin Soup: 519 -> 419g (377g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(419 * 0.90) WHERE `name` = 'bowl_of_pumpkin_soup';
-- Silent Oil: 300 -> 250g (225g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(250 * 0.90) WHERE `name` = 'pot_of_silent_oil';
-- Prism Powder: 350 -> 300g (270g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(300 * 0.90) WHERE `name` = 'pinch_of_prism_powder';

-- Jug pet items
-- ----------------------------------------------------------------------
-- Quadav Bug Broth: 225 -> 25g (22g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(25 * 0.90) WHERE `name` = 'jug_of_quadav_bug_broth';
-- Grasshopper Broth: 172 -> 15g (13g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(15 * 0.90) WHERE `name` = 'jug_of_grasshopper_broth';
-- Cold Carrion Broth: 237 -> 48g (43g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(48 * 0.90) WHERE `name` = 'jug_of_cold_carrion_broth';
-- Tree Sap: 104 -> 92g (82g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(92 * 0.90) WHERE `name` = 'jug_of_tree_sap';
-- Blood Broth: 341 -> 54g (48g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(54 * 0.90) WHERE `name` = 'jug_of_blood_broth';
-- Clear Blood Broth: 451 -> 71g (63g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(71 * 0.90) WHERE `name` = 'jug_of_clear_blood_broth';
-- Fragrant Antica Broth: 512 -> 102g (91g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(102 * 0.90) WHERE `name` = 'jug_of_fragrant_antica_broth';
-- Pet Food Delta Biscuit: 96 -> 75g (67g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(75 * 0.90) WHERE `name` = 'pet_food_delta_biscuit';

-- Potions and powders
-- ----------------------------------------------------------------------
-- Potion Drop: 332 -> 50g (45g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(50 * 0.90) WHERE `name` = 'bottle_of_potion_drops';
-- Silencing Potion: 150 -> 125g (112g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(125 * 0.90) WHERE `name` = 'flask_of_silencing_potion';
-- Ether Drop: 415 -> 219g (197g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(219 * 0.90) WHERE `name` = 'bottle_of_ether_drops';
-- Hi-Ether Drop: 573 -> 319g (287g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = FLOOR(319 * 0.90) WHERE `name` = 'bottle_of_hi-ether_drops';
-- Rainbow Powder: 590 -> 466g (419g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(466 * 0.90) WHERE `name` = 'pinch_of_rainbow_powder';

-- Food and crafting
-- ----------------------------------------------------------------------
-- Pogaca: 299 -> 1g (1g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = CEILING(1 * 0.90) WHERE `name` = 'pogaca';
-- Pogaca +1: 373 -> 2g (2g final base) -- Retail resale correction
UPDATE `item_basic` SET `BaseSell` = CEILING(2 * 0.90) WHERE `name` = 'pogaca_+1';
-- Living Key: 300 -> 250g (225g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(250 * 0.90) WHERE `name` = 'living_key';
-- Yogurt: 204 -> 180g (162g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(180 * 0.90) WHERE `name` = 'bowl_of_yogurt';
-- Ramen Noodles: 310 -> 250g (225g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(250 * 0.90) WHERE `name` = 'container_of_ramen_noodles';
-- Mercury: 300 -> 250g (225g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(250 * 0.90) WHERE `name` = 'vial_of_mercury';
-- Carbon Fiber: 200 -> 173g (155g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(173 * 0.90) WHERE `name` = 'loop_of_carbon_fiber';
-- Octopus Sushi (NQ only): 532 -> 302g (271g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(302 * 0.90) WHERE `name` = 'plate_of_octopus_sushi';

-- Equipment and ammunition
-- ----------------------------------------------------------------------
-- Riot Grenade: 600 -> 575g (517g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(575 * 0.90) WHERE `name` = 'riot_grenade';
-- Darksteel Pick: 12,180 -> 11,180g (10,062g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(11180 * 0.90) WHERE `name` = 'darksteel_pick';
-- Mythril Pick: 7,395 -> 6,895g (6,205g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(6895 * 0.90) WHERE `name` = 'mythril_pick';
-- Trumpet Ring: 3,315 -> 1,000g (900g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(1000 * 0.90) WHERE `name` = 'trumpet_ring';

-- Fishing resale reductions (-25%)
-- ----------------------------------------------------------------------
-- Giant Chirai: 1,100 -> 825g (742g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(825 * 0.90) WHERE `name` = 'giant_chirai' AND `BaseSell` > 0;
-- Pirarucu: 1,032 -> 774g (696g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(774 * 0.90) WHERE `name` = 'pirarucu' AND `BaseSell` > 0;
-- Armored Pisces: 950 -> 713g (641g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(713 * 0.90) WHERE `name` = 'armored_pisces' AND `BaseSell` > 0;
-- Pterygotus: 780 -> 585g (526g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(585 * 0.90) WHERE `name` = 'pterygotus' AND `BaseSell` > 0;
-- Bibiki Urchin: 750 -> 562g (505g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(562 * 0.90) WHERE `name` = 'bibiki_urchin' AND `BaseSell` > 0;
-- Ahtapot: 700 -> 525g (472g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(525 * 0.90) WHERE `name` = 'ahtapot' AND `BaseSell` > 0;
-- Black Sole: 700 -> 525g (472g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(525 * 0.90) WHERE `name` = 'black_sole' AND `BaseSell` > 0;
-- Dil: 700 -> 525g (472g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(525 * 0.90) WHERE `name` = 'dil' AND `BaseSell` > 0;
-- Grimmonite: 700 -> 525g (472g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(525 * 0.90) WHERE `name` = 'grimmonite' AND `BaseSell` > 0;
-- Garpike: 610 -> 457g (411g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(457 * 0.90) WHERE `name` = 'garpike' AND `BaseSell` > 0;
-- Bastore Bream: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'bastore_bream' AND `BaseSell` > 0;
-- Black Ghost: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'black_ghost' AND `BaseSell` > 0;
-- Emperor Fish: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'emperor_fish' AND `BaseSell` > 0;
-- Gigant Squid: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'gigant_squid' AND `BaseSell` > 0;
-- Jungle Catfish: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'jungle_catfish' AND `BaseSell` > 0;
-- Mercanbaligi: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'mercanbaligi' AND `BaseSell` > 0;
-- Morinabaligi: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'morinabaligi' AND `BaseSell` > 0;
-- Rhinochimera: 600 -> 450g (405g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(450 * 0.90) WHERE `name` = 'rhinochimera' AND `BaseSell` > 0;
-- Ca Cuong: 560 -> 420g (378g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(420 * 0.90) WHERE `name` = 'ca_cuong' AND `BaseSell` > 0;
-- Trumpet Shell (50%): 512 -> 256 (230 final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(256 * 0.90) WHERE `name` = 'trumpet_shell' AND `BaseSell` > 0;
-- Gavial Fish: 500 -> 375g (337g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(375 * 0.90) WHERE `name` = 'gavial_fish' AND `BaseSell` > 0;
-- Norg Shell (50%): 500 -> 250g (225g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(250 * 0.90) WHERE `name` = 'norg_shell' AND `BaseSell` > 0;
-- Silver Shark: 500 -> 375g (337g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(375 * 0.90) WHERE `name` = 'silver_shark' AND `BaseSell` > 0;
-- Three-Eyed Fish: 500 -> 375g (337g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(375 * 0.90) WHERE `name` = 'three-eyed_fish' AND `BaseSell` > 0;
-- Gurnard: 475 -> 356g (320g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(356 * 0.90) WHERE `name` = 'gurnard' AND `BaseSell` > 0;
-- Veydal Wrasse: 450 -> 337g (303g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(337 * 0.90) WHERE `name` = 'veydal_wrasse' AND `BaseSell` > 0;
-- Crescent Fish: 440 -> 330g (297g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(330 * 0.90) WHERE `name` = 'crescent_fish' AND `BaseSell` > 0;
-- Bladefish: 400 -> 300g (270g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(300 * 0.90) WHERE `name` = 'bladefish' AND `BaseSell` > 0;
-- Noble Lady: 400 -> 300g (270g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(300 * 0.90) WHERE `name` = 'noble_lady' AND `BaseSell` > 0;
-- Zebra Eel: 400 -> 300g (270g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(300 * 0.90) WHERE `name` = 'zebra_eel' AND `BaseSell` > 0;
-- Tavnazian Goby: 331 -> 248g (223g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(248 * 0.90) WHERE `name` = 'tavnazian_goby' AND `BaseSell` > 0;
-- Kayabaligi: 310 -> 248g (223g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(248 * 0.90) WHERE `name` = 'kayabaligi' AND `BaseSell` > 0;
-- Bhefhel Marlin: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'bhefhel_marlin' AND `BaseSell` > 0;
-- Bluetail: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'bluetail' AND `BaseSell` > 0;
-- Gold Carp: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'gold_carp' AND `BaseSell` > 0;
-- Istiridye: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'istiridye' AND `BaseSell` > 0;
-- Kaplumbaga: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'kaplumbaga' AND `BaseSell` > 0;
-- Kilicbaligi: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'kilicbaligi' AND `BaseSell` > 0;
-- Monke-Onke: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'monke-onke' AND `BaseSell` > 0;
-- Red Terrapin: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'red_terrapin' AND `BaseSell` > 0;
-- Sazanbaligi: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'sazanbaligi' AND `BaseSell` > 0;
-- Shall Shell: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'shall_shell' AND `BaseSell` > 0;
-- Uskumru: 300 -> 225g (202g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(225 * 0.90) WHERE `name` = 'uskumru' AND `BaseSell` > 0;
-- Brass Loach: 270 -> 202g (181g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(202 * 0.90) WHERE `name` = 'brass_loach' AND `BaseSell` > 0;
-- Blindfish: 225 -> 168g (151g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(168 * 0.90) WHERE `name` = 'blindfish' AND `BaseSell` > 0;
-- Yilanbaligi: 200 -> 144g (129g final base) -- TOAU version of Black Eel. Standardizing the resale.
UPDATE `item_basic` SET `BaseSell` = FLOOR(144 * 0.90) WHERE `name` = 'yilanbaligi' AND `BaseSell` > 0;
-- Black Eel: 192 -> 144g (129g final base)
UPDATE `item_basic` SET `BaseSell` = FLOOR(144 * 0.90) WHERE `name` = 'black_eel' AND `BaseSell` > 0;

-- Records the final basesell values so resaleItemChanges.sql doesn't apply them twice.
REPLACE INTO `zenith_resale_applied` (`itemid`, `applied_sell`)
SELECT `itemid`, `BaseSell`
FROM `item_basic`
WHERE `name` IN (
    'sairui-ran',
    'tsurara',
    'shihei',
    'soshi',
    'shinobi-tabi',
    'flask_of_holy_water',
    'block_of_rock_cheese',
    'tortilla_buena',
    'bowl_of_pumpkin_soup',
    'pot_of_silent_oil',
    'pinch_of_prism_powder',
    'jug_of_quadav_bug_broth',
    'jug_of_grasshopper_broth',
    'jug_of_cold_carrion_broth',
    'jug_of_tree_sap',
    'jug_of_blood_broth',
    'jug_of_clear_blood_broth',
    'jug_of_fragrant_antica_broth',
    'pet_food_delta_biscuit',
    'bottle_of_potion_drops',
    'flask_of_silencing_potion',
    'bottle_of_ether_drops',
    'bottle_of_hi-ether_drops',
    'pinch_of_rainbow_powder',
    'pogaca',
    'pogaca_+1',
    'living_key',
    'bowl_of_yogurt',
    'container_of_ramen_noodles',
    'vial_of_mercury',
    'loop_of_carbon_fiber',
    'plate_of_octopus_sushi',
    'riot_grenade',
    'darksteel_pick',
    'mythril_pick',
    'trumpet_ring',
    'giant_chirai',
    'pirarucu',
    'armored_pisces',
    'pterygotus',
    'bibiki_urchin',
    'ahtapot',
    'black_sole',
    'dil',
    'grimmonite',
    'garpike',
    'bastore_bream',
    'black_ghost',
    'emperor_fish',
    'gigant_squid',
    'jungle_catfish',
    'mercanbaligi',
    'morinabaligi',
    'rhinochimera',
    'ca_cuong',
    'trumpet_shell',
    'gavial_fish',
    'norg_shell',
    'silver_shark',
    'three-eyed_fish',
    'gurnard',
    'veydal_wrasse',
    'crescent_fish',
    'bladefish',
    'noble_lady',
    'zebra_eel',
    'tavnazian_goby',
    'kayabaligi',
    'bhefhel_marlin',
    'bluetail',
    'gold_carp',
    'istiridye',
    'kaplumbaga',
    'kilicbaligi',
    'monke-onke',
    'red_terrapin',
    'sazanbaligi',
    'shall_shell',
    'uskumru',
    'brass_loach',
    'blindfish',
    'yilanbaligi',
    'black_eel'
);
