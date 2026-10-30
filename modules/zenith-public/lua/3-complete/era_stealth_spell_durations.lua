-----------------------------------
-- Era durations for Sneak, Invisible and Deodorize (ZENITHDEV-266)
-- Undoes the April 30, 2013 update: the base duration is a random 30 to 300 seconds on each cast, instead of
-- LSB's 420 seconds plus 0, 60 or 120. Everything after the base duration is the same as
-- xi.spells.enhancing.calculateEnhancingDuration, which keeps its table of base durations local.
-- Source: https://forum.square-enix.com/ffxi/threads/32909-April-30-2013-%28JST%29-Version-Update
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_eraStealthSpellDurations')

local spellLevels =
{
    [xi.effect.DEODORIZE] = 15,
    [xi.effect.INVISIBLE] = 20,
    [xi.effect.SNEAK]     = 20,
}

m:addOverride('xi.spells.enhancing.calculateEnhancingDuration', function(caster, target, spell, spellId, spellGroup, spellEffect)
    local spellLevel = spellLevels[spellEffect]

    if not spellLevel then
        return super(caster, target, spell, spellId, spellGroup, spellEffect)
    end

    local duration    = math.randomInt(30, 300)
    local targetLevel = target:getMainLvl()

    if
        not caster:isPet() and
        target:hasStatusEffect(xi.effect.EMBOLDEN) and
        spellGroup == xi.magic.spellGroup.WHITE
    then
        duration = duration * (0.5 + target:getMod(xi.mod.EMBOLDEN_DURATION) / 100)
    end

    duration = duration + duration * caster:getMod(xi.mod.ENH_MAGIC_DURATION) / 100

    if caster:getMainJob() == xi.job.RDM then
        duration = duration + caster:getMerit(xi.merit.ENHANCING_MAGIC_DURATION) + caster:getJobPointLevel(xi.jp.ENHANCING_DURATION)
    end

    if spellEffect == xi.effect.INVISIBLE then
        duration = duration + target:getMod(xi.mod.INVISIBLE_DURATION)
    elseif spellEffect == xi.effect.SNEAK then
        duration = duration + target:getMod(xi.mod.SNEAK_DURATION)
    end

    if
        caster:hasStatusEffect(xi.effect.COMPOSURE) and
        caster:getID() == target:getID()
    then
        duration = duration * 3
    end

    if
        caster:hasStatusEffect(xi.effect.PERPETUANCE) and
        spellGroup == xi.magic.spellGroup.WHITE
    then
        duration = duration * 2
    end

    if targetLevel < spellLevel then
        duration = duration * targetLevel / spellLevel
    end

    return duration
end)

return m
