-----------------------------------
-- Custom monster behavior overrides
-- Public module for ZenithXI
-----------------------------------

-- INNER_HORUTOTO_RUINS (Zone 192)
-----------------------------------
UPDATE `mob_pools` SET `aggro` = 1 WHERE `name` = 'Deathwatch_Beetle'; -- Deprecated Beady Beetles used to aggro

-- CRAWLERS_NEST (Zone 197)
-----------------------------------
UPDATE `mob_pools` SET `aggro` = 1 WHERE `name` = 'Vespo'; -- Typical Nest behavior
UPDATE `mob_pools` SET `aggro` = 1 WHERE `name` = 'Olid_Funguar'; -- Typical Nest behavior

-- GUSTAV_TUNNEL (Zone 212)
-----------------------------------
UPDATE `mob_pools` SET `aggro` = 1 WHERE `name` = 'Boulder_Eater'; -- Balance target's appeal (does not link)
