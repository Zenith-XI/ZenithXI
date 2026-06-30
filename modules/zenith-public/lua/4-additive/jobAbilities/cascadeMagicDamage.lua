-----------------------------------
-- Cascade Magic Damage Equation Override
-- Custom modifications for ZenithXI
-- Reduces the Cascade magic damage bonus from floor(TP / 10) to floor(TP / 40).
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('a-j_blm_cascade')

m:addOverride('xi.job_utils.black_mage.calculateCascadeMagicDamage', function(player, tp)
    return math.floor(tp / 40)
end)

return m
