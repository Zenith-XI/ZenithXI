local m = Module:new('c-j_berserk')

-----------------------------------
-- Berserk Effect Override
-- 25 + BERSERK_POTENCY (no level scaling)
-----------------------------------

m:addOverride('xi.effects.berserk.onEffectGain', function(target, effect)
    local power    = 25 + target:getMod(xi.mod.BERSERK_POTENCY)
    local jpEffect = target:getJobPointLevel(xi.jp.BERSERK_EFFECT) * 2

    effect:addMod(xi.mod.ATTP, power)
    effect:addMod(xi.mod.RATTP, power)
    effect:addMod(xi.mod.DEFP, -25)

    -- Job Point Bonuses
    effect:addMod(xi.mod.ATT, jpEffect)
    effect:addMod(xi.mod.RATT, jpEffect)
end)

return m
