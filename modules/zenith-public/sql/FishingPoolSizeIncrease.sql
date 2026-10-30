-- Blanket increase of all fishing pool sizes by 50% for ZenithXI server
--
-- This file re-runs on every dbtool update, and an Express Update does not reload
-- sql/fishing_group.sql first, so a bare "pool_size * 1.5" would grow an
-- already-grown pool again. zenith_fishing_pool_applied remembers the pool size this
-- file wrote for each row: a row whose pool_size still equals it is skipped, and
-- any other pool_size (a fresh base import, a new row) is increased once.

CREATE TABLE IF NOT EXISTS `zenith_fishing_pool_applied` (
    `groupid` INT(10) UNSIGNED NOT NULL COMMENT 'fishing_group.groupid',
    `fishid` INT(10) UNSIGNED NOT NULL COMMENT 'fishing_group.fishid',
    `applied_pool_size` SMALLINT(5) UNSIGNED NOT NULL COMMENT 'pool_size this file last wrote for the row',
    PRIMARY KEY (`groupid`, `fishid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Increase pool sizes by 50% for rows not yet adjusted
UPDATE `fishing_group` SET `pool_size` = FLOOR(`pool_size` * 1.5) WHERE NOT EXISTS (SELECT 1 FROM `zenith_fishing_pool_applied` WHERE `zenith_fishing_pool_applied`.`groupid` = `fishing_group`.`groupid` AND `zenith_fishing_pool_applied`.`fishid` = `fishing_group`.`fishid` AND `zenith_fishing_pool_applied`.`applied_pool_size` = `fishing_group`.`pool_size`);

-- Record the pool size now in place so the next run skips it
REPLACE INTO `zenith_fishing_pool_applied` (`groupid`, `fishid`, `applied_pool_size`) SELECT `groupid`, `fishid`, `pool_size` FROM `fishing_group`;
