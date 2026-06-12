-- -----------------------------------
-- QM2 Water Trade Module
--
-- This module overrides the cooldown for trading water to the ???
-- to pop the NM Yara Ma Yha Who.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('qm2_water_trade')

m:addOverride('xi.zones.Tahrongi_Canyon.npcs.qm2.onTrade', function(player, npc, trade)
    local trades = npc:getLocalVar('trades')
    local ID = zones[xi.zone.TAHRONGI_CANYON]
    super(player, npc, trade)

    if
        npc:getLocalVar('trades') == trades + 1 or
        GetMobByID(ID.mob.YARA_MA_YHA_WHO):isSpawned()
    then
        -- 20 minutes until next trade
        npc:setLocalVar('tradeCooldown', GetSystemTime() + (20 * 60))
    end
end)

return m
