-----------------------------------
-- Devil Manta respawn time update
-- Updates min_respawn to 960 seconds (16 minutes)
-- Public module for ZenithXI
-----------------------------------

-- Update Devil Manta min_respawn from 600 to 960 seconds (zone 174 only)
UPDATE `fishing_mob` SET `min_respawn` = 960 WHERE `name` = 'Devil Manta' AND `zoneid` = 174;
