-----------------------------------
-- Item Resale Price Adjustment
-- Sets every base sell price to 90% of its original value, rounded up so a
-- sellable item never drops below 1
-- Public module for ZenithXI
--
-- This file re-runs on every dbtool update, and an Express Update does not reload
-- sql/item_basic.sql first, so a bare "BaseSell * 0.90" would discount an
-- already-discounted price again. zenith_resale_applied remembers the price this
-- file wrote for each item: an item whose BaseSell still equals it is skipped, and
-- any other BaseSell (a fresh base import, a new item) is discounted once.
-----------------------------------

CREATE TABLE IF NOT EXISTS `zenith_resale_applied` (
    `itemid` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'item_basic.itemid',
    `applied_sell` INT(10) UNSIGNED NOT NULL COMMENT 'BaseSell this file last wrote for the item',
    PRIMARY KEY (`itemid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Reduce base sell prices by 10% for items not yet adjusted
UPDATE `item_basic` SET `BaseSell` = CEILING(`BaseSell` * 0.90) WHERE `BaseSell` > 0 AND NOT EXISTS (SELECT 1 FROM `zenith_resale_applied` WHERE `zenith_resale_applied`.`itemid` = `item_basic`.`itemid` AND `zenith_resale_applied`.`applied_sell` = `item_basic`.`BaseSell`);

-- Record the price now in place so the next run skips it
REPLACE INTO `zenith_resale_applied` (`itemid`, `applied_sell`) SELECT `itemid`, `BaseSell` FROM `item_basic` WHERE `BaseSell` > 0;
