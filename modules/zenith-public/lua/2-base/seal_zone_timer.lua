-- -----------------------------------
-- Seals Zone Timer Module
--
-- This module overrides the player being able to reset the seal timer by log out or zone.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('seal_zone_timer')

m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)
    player:addRecast(xi.recast.LOOT, xi.recastID.SEAL, 150)
end)

return m
