-----------------------------------
-- Reward Ability Scaling
-- Custom modifications for ZenithXI
-- Scales back pet food healing and regen duration from retail values.
-- Base xi.job_utils.beastmaster.useReward reads petFoodData at runtime,
-- so replacing the table is all that's needed -- no real function override.
-- regenTime is consumed by the companion patch (111-RewardRegenDuration).
-- The module loader errors on a module with an empty overrides table, so a
-- no-op override on xi.dummyFunc is registered to satisfy it.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c-j_rewardScaling')
m:addOverride('xi.dummyFunc', function()
end)

xi.job_utils.beastmaster.petFoodData =
{
    [xi.item.PET_FOOD_ALPHA_BISCUIT]   = { minHealing =  30, regen = 1, mndMult = 2, mndThreshold = 10, regenTime = 90 },
    [xi.item.PET_FOOD_BETA_BISCUIT]    = { minHealing =  60, regen = 2, mndMult = 1, mndThreshold = 33, regenTime = 90 },
    [xi.item.PET_FOOD_GAMMA_BISCUIT]   = { minHealing = 100, regen = 3, mndMult = 1, mndThreshold = 35, regenTime = 90 },
    [xi.item.PET_FOOD_DELTA_BISCUIT]   = { minHealing = 150, regen = 4, mndMult = 2, mndThreshold = 40, regenTime = 90 },
    [xi.item.PET_FOOD_EPSILON_BISCUIT] = { minHealing = 250, regen = 5, mndMult = 2, mndThreshold = 45, regenTime = 90 },
    [xi.item.PET_FOOD_ZETA_BISCUIT]    = { minHealing = 350, regen = 6, mndMult = 3, mndThreshold = 45, regenTime = 90 },
    [xi.item.PET_FOOD_ETA_BISCUIT]     = { minHealing = 475, regen = 7, mndMult = 4, mndThreshold = 60, regenTime = 90 },
    [xi.item.PET_FOOD_THETA_BISCUIT]   = { minHealing = 600, regen = 8, mndMult = 4, mndThreshold = 65, regenTime = 90 },
}

return m
