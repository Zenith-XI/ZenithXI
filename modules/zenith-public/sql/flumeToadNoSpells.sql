-- Fix Flume Toad spell list
-- Toads (family 111) should not cast magic
-- The base mob_pools has spellList=2 (Beastmen_BLM) which is incorrect

UPDATE mob_pools SET spellList = 0 WHERE poolid = 6378; -- Flume_Toad
