-----------------------------------
-- Focus and Dodge Job Ability Changes
-- Custom modifications for ZenithXI
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('focusDodgeChanges')

local getAddedBonus = function(player)
    local level = utils.getActiveJobLevel(player, xi.job.MNK)
    local first = math.floor(level / 5) + 10
    local second = math.floor((level / 3) * 0.2)

    return first, second
end

-- These modify the bonuses applied by the effects, while recast times are handled via SQL

-- Override the Focus status effect to apply the custom bonuses
m:addOverride('xi.effects.focus.onEffectGain', function(target, effect)
    local baseAcc, baseCrit = getAddedBonus(target)
    local jpModBonus = effect:getPower()

    effect:addMod(xi.mod.ACC, baseAcc + jpModBonus)
    effect:addMod(xi.mod.CRITHITRATE, baseCrit)
end)

-- Override the Dodge status effect to apply the custom bonuses
m:addOverride('xi.effects.dodge.onEffectGain', function(target, effect)
    local baseEva, baseGuard = getAddedBonus(target)
    local jpModBonus = effect:getPower()

    effect:addMod(xi.mod.EVA, baseEva + jpModBonus)
    effect:addMod(xi.mod.GUARD, baseGuard)
end)

return m
