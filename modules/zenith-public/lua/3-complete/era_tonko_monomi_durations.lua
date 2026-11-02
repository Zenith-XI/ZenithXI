-----------------------------------
-- Era durations for Tonko and Monomi (ZENITHDEV-282)
-- Undoes the January 21, 2014 update: Tonko: Ichi and Monomi: Ichi last 180 seconds and Tonko: Ni 300, instead
-- of LSB's 420, 420 and 600. LSB keeps its ninjutsu table local, so these three spells repeat the Sneak and
-- Invisible path of xi.spells.enhancing.useEnhancingNinjutsu with the era duration. Every other spell is LSB's.
-- Source: https://forum.square-enix.com/ffxi/threads/39564-Jan-21-2014-%28JST%29-Version-Update
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_eraTonkoMonomiDurations')

-- { tier, effect, duration }
local eraSpells =
{
    [xi.magic.spell.TONKO_ICHI ] = { 1, xi.effect.INVISIBLE, 180 },
    [xi.magic.spell.TONKO_NI   ] = { 2, xi.effect.INVISIBLE, 300 },
    [xi.magic.spell.MONOMI_ICHI] = { 1, xi.effect.SNEAK,     180 },
}

m:addOverride('xi.spells.enhancing.useEnhancingNinjutsu', function(caster, target, spell)
    local spellId = spell:getID()
    local entry   = eraSpells[spellId]

    if not entry then
        return super(caster, target, spell)
    end

    local tier, spellEffect, duration = entry[1], entry[2], entry[3]
    local power, subPower = xi.spells.enhancing.calculateNinjutsuPower(caster, target, spell, spellId, tier, spellEffect)

    if target:addStatusEffect(spellEffect, { power = power, duration = duration, origin = caster, tick = 10, subPower = subPower }) then
        spell:setMsg(xi.msg.basic.MAGIC_GAIN_EFFECT)
    else
        spell:setMsg(xi.msg.basic.MAGIC_NO_EFFECT)
    end

    return spellEffect
end)

return m
