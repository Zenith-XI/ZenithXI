local m = Module:new('c-j_impetus')

-----------------------------------
-- Impetus Override
-- Half of base's bonus per landed hit, reset on a miss, up to 30 stacks instead of 50:
--   attack           +1 per stack instead of +2   (max +30)
--   critical rate    +1% every second stack instead of every stack (max +15%)
-- With the Bhikku/Tantra body augment, also halved:
--   accuracy         +1 per stack instead of +2   (max +30)
--   critical damage  the augment's bonus every second stack instead of every stack
-- super runs first so the duration change in 2-base/abilities.lua still applies; base's hit and
-- miss listeners it adds are then replaced. onEffectLose is base's, which removes both listeners.
-- A miss takes the bonus back with negative addMod calls: status effects have no delMod binding,
-- so base's miss listener errors and never resets the bonus.
-----------------------------------

local maxStacks = 30

local critForStacks = function(stacks)
    return math.floor(stacks / 2)
end

m:addOverride('xi.effects.impetus.onEffectGain', function(target, effect)
    super(target, effect)

    target:removeListener('IMPETUS_HIT')
    target:removeListener('IMPETUS_MISS')

    target:addListener('MELEE_SWING_HIT', 'IMPETUS_HIT', function(actorArg, targetArg, attack)
        local effectArg = actorArg:getStatusEffect(xi.effect.IMPETUS)
        if not effectArg then
            return
        end

        local stacks = effectArg:getPower() + 1
        if stacks > maxStacks then
            return
        end

        -- 1 on every second stack, 0 otherwise
        local critStep = critForStacks(stacks) - critForStacks(stacks - 1)

        effectArg:setPower(stacks)
        effectArg:addMod(xi.mod.ATT, 1)
        effectArg:addMod(xi.mod.CRITHITRATE, critStep)

        local subPower = effectArg:getSubPower()
        if subPower ~= 0 then
            effectArg:addMod(xi.mod.ACC, 1)
            effectArg:addMod(xi.mod.CRIT_DMG_INCREASE, critStep * math.floor(subPower / 2))
        end
    end)

    target:addListener('MELEE_SWING_MISS', 'IMPETUS_MISS', function(actorArg, targetArg, attack)
        local effectArg = actorArg:getStatusEffect(xi.effect.IMPETUS)
        if not effectArg then
            return
        end

        local stacks = effectArg:getPower()
        effectArg:setPower(0)
        effectArg:addMod(xi.mod.ATT, -stacks)
        effectArg:addMod(xi.mod.CRITHITRATE, -critForStacks(stacks))

        local subPower = effectArg:getSubPower()
        if subPower ~= 0 then
            effectArg:addMod(xi.mod.ACC, -stacks)
            effectArg:addMod(xi.mod.CRIT_DMG_INCREASE, -critForStacks(stacks) * math.floor(subPower / 2))
        end
    end)
end)

return m
