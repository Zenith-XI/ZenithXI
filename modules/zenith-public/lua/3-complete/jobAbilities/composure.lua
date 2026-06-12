local m = Module:new('c-j_composure')

-----------------------------------
-- Composure Effect Override
-- Era accuracy bonus: floor(level/5)
-- Pre 8 Feb 2019 behavior
-----------------------------------

m:addOverride('xi.effects.composure.onEffectGain', function(target, effect)
    local power = math.floor(target:getMainLvl() / 5)

    effect:addMod(xi.mod.ACC, power)
end)

return m
