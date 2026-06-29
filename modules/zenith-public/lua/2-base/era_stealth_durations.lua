-----------------------------------
-- Era-Accurate Stealth Durations
-----------------------------------
-- Reverts stealth spell/item/ability durations to era-appropriate values
-- reducing the extended durations added in later expansions.
--
-- Duration Changes:
--   Sneak/Invisible (White Magic): 420-540s -> 180-300s
--   Silent Oil: 600s -> 60-300s random
--   Prism Powder: 600s -> 60-300s random
--   Rainbow Powder: 600s -> 300s static
--   Spectral Jig: 180s base -> 30-90s random base
--   Ninjutsu Monomi:Ichi / Tonko:Ichi: 420s -> 180s; Tonko:Ni: 600s -> 300s
--
-- Ninjutsu (Monomi, Tonko) durations are applied below by overriding the
-- global xi.spells.enhancing.useEnhancingNinjutsu. The pTable in
-- enhancing_ninjutsu.lua is local and not directly editable from a module,
-- but the function that consumes it is global and overridable.
--
-- Caveat: The White Magic and Ninjutsu overrides use fixed era values and do
-- NOT honor xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER, whereas the
-- item and Spectral Jig overrides do. Changing that setting therefore will
-- not scale magic-based Sneak/Invisible durations.
-----------------------------------
local m = Module:new('b_era_stealth_dur')

-----------------------------------
-- White Magic Sneak/Invisible Duration Override
-----------------------------------
-- The base duration in pTable is 420s, scaled by 180/420 for an era-accurate
-- 180s base. The random +0/60/120 added by the original function is scaled
-- along with it, preserving the percentage-based modifiers (Composure, gear
-- mods, etc.) that the base function has already applied.
m:addOverride('xi.spells.enhancing.calculateEnhancingDuration', function(caster, target, spell, spellId, spellGroup, spellEffect)
    local duration = super(caster, target, spell, spellId, spellGroup, spellEffect)

    if spellEffect == xi.effect.SNEAK or spellEffect == xi.effect.INVISIBLE then
        local reductionRatio = 180 / 420
        duration = math.floor(duration * reductionRatio)
    end

    return duration
end)

-----------------------------------
-- Ninjutsu Sneak/Invisible Duration Override (Monomi, Tonko)
-----------------------------------
-- The ninjutsu duration table is local to enhancing_ninjutsu.lua, so we cannot
-- edit it from a module. Instead we override the global function that consumes
-- it. For every unaffected spell we defer to the original via super; for the
-- three stealth ninjutsu we apply era-accurate durations. The power (0),
-- tick (10) and subPower (0) values mirror exactly what the base computes for
-- these spells (see the SNEAK/INVISIBLE branch in useEnhancingNinjutsu).
local eraNinjutsuStealth =
{
    [xi.magic.spell.MONOMI_ICHI] = { effect = xi.effect.SNEAK,     duration = 180 },
    [xi.magic.spell.TONKO_ICHI ] = { effect = xi.effect.INVISIBLE, duration = 180 },
    [xi.magic.spell.TONKO_NI   ] = { effect = xi.effect.INVISIBLE, duration = 300 },
}

m:addOverride('xi.spells.enhancing.useEnhancingNinjutsu', function(caster, target, spell)
    local override = eraNinjutsuStealth[spell:getID()]
    if not override then
        return super(caster, target, spell)
    end

    if target:addStatusEffect(override.effect, { power = 0, duration = override.duration, origin = caster, tick = 10, subPower = 0 }) then
        spell:setMsg(xi.msg.basic.MAGIC_GAIN_EFFECT)
    else
        spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
    end

    return override.effect
end)

-----------------------------------
-- Silent Oil (Item ID: 4165)
-----------------------------------
-- Era duration: 60-300 seconds random (continuous distribution)
-- Current base: 600 seconds
m:addOverride('xi.items.pot_of_silent_oil.onItemUse', function(target, user)
    if not target:hasStatusEffect(xi.effect.SNEAK) then
        local duration = math.floor(math.random(60, 300) * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER)
        target:addStatusEffect(xi.effect.SNEAK, { power = 1, duration = duration, origin = user, tick = 10 })
    end
end)

-----------------------------------
-- Prism Powder (Item ID: 4164)
-----------------------------------
-- Era duration: 60-300 seconds random (continuous distribution)
-- Current base: 600 seconds
m:addOverride('xi.items.pinch_of_prism_powder.onItemUse', function(target, user)
    if target:hasStatusEffect(xi.effect.INVISIBLE) then
        target:delStatusEffect(xi.effect.INVISIBLE)
    end

    local duration = math.floor(math.random(60, 300) * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER)
    target:addStatusEffect(xi.effect.INVISIBLE, { power = 1, duration = duration, origin = user, tick = 10 })
end)

-----------------------------------
-- Rainbow Powder (Item ID: 5362)
-----------------------------------
-- Era duration: 300 seconds static
-- Current base: 600 seconds
m:addOverride('xi.items.pinch_of_rainbow_powder.onItemUse', function(target, user)
    if target:hasStatusEffect(xi.effect.INVISIBLE) then
        target:delStatusEffect(xi.effect.INVISIBLE)
    end

    local duration = math.floor(300 * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER)
    target:addStatusEffect(xi.effect.INVISIBLE, { power = 1, duration = duration, origin = user, tick = 10 })
end)

-----------------------------------
-- Spectral Jig (Dancer Level 25 Ability)
-----------------------------------
-- Era duration: 30-90 seconds random base (before JP/mods)
-- Current base: 180 seconds
-- Note: Only apply if DNC/WotG expansion is enabled (ability script loaded)
if
    xi.actions and
    xi.actions.abilities and
    xi.actions.abilities.spectral_jig
then
    m:addOverride('xi.actions.abilities.spectral_jig.onUseAbility', function(player, target, ability)
        -- Era-accurate random base duration: 30-90 seconds
        local baseDuration       = math.random(30, 90) + player:getJobPointLevel(xi.jp.JIG_DURATION)
        local durationMultiplier = 1.0 + utils.clamp(player:getMod(xi.mod.JIG_DURATION), 0, 50) / 100
        local finalDuration      = math.floor(baseDuration * durationMultiplier * xi.settings.main.SNEAK_INVIS_DURATION_MULTIPLIER)

        if not player:hasStatusEffect(xi.effect.SNEAK) then
            player:addStatusEffect(xi.effect.SNEAK, { duration = finalDuration, origin = player, tick = 10 })
            player:addStatusEffect(xi.effect.INVISIBLE, { duration = finalDuration, origin = player, tick = 10 })
            ability:setMsg(xi.msg.basic.SPECTRAL_JIG)
        else
            ability:setMsg(xi.msg.basic.NO_EFFECT)
        end

        return 1
    end)
end

return m
