-- Drops the ledger table left behind by the removed FishingPoolSizeIncrease.sql.
--
-- LSB removed fishing stock pools (fishing_group has no pool_size any more), so
-- FishingPoolSizeIncrease.sql was deleted and nothing reads or writes
-- zenith_fishing_pool_applied now. Databases that ran the old file still hold it.
--
-- The drop does nothing once the table is gone, so this file is safe on every
-- dbtool run. Delete it after every server has run it once.

DROP TABLE IF EXISTS `zenith_fishing_pool_applied`;
