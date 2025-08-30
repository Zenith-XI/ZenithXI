-- -----------------------------------
-- Recast Tables Module
--
-- This module appends the recast table with loot-based recast enums
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('e_x_recast')

-- Override the recast Tables

xi.recast.LOOT = 3

xi.recastID.SEAL  = 1
xi.recastID.GEODE = 2

return m
