-----------------------------------
-- 75 Era Combat Adjustments
-- Restores hit rate cap to 95% for all weapons
-----------------------------------
local m = Module:new('b_era_hitrate_cap')

-- Override hit rate cap to 95% for all weapon types (75 Era behavior)
-- See: https://github.com/LandSandBoat/server/pull/9071
m:addOverride('xi.combat.physicalHitRate.getPhysicalHitRateCap', function(attacker, slot)
    return 0.95
end)

return m
