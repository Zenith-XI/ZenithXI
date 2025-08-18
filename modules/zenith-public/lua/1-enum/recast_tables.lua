-- -----------------------------------
-- Recast Tables Module
--
-- This module overrides the recast table for players and mobs.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('recast_tables')

-- Override the recast Tables

xi = xi or {}

xi.recast.LOOT     = 3

xi.recastID.SEAL           =   1
xi.recastID.GEODE          =   2

return m
