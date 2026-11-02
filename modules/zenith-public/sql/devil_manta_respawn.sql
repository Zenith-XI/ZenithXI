-----------------------------------
-- Devil Manta respawn time update
-- Sets Kuftal Tunnel Devil Manta to a fixed 960 second (16 minute) respawn
-- Public module for ZenithXI
-- Use in tandem with lua/3-complete/mobs/devil_manta_respawn.lua
-----------------------------------

-- Both columns must change: fishingutils::CatchMonster only rolls rand(min, max) when
-- max_respawn > min_respawn, otherwise it uses max_respawn (base row is 600 / 600).
UPDATE `fishing_mob` SET `min_respawn` = 960, `max_respawn` = 960 WHERE `name` = 'Devil Manta' AND `zoneid` = 174;
