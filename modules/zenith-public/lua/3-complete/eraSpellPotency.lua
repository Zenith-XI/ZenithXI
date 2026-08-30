-----------------------------------
-- Reverts out-of-era potency of various spells.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c-era_spell_potency')

-----------------------------------
-- Enfeebling Magic
-----------------------------------

-- Revert the 5% increase to Dia defense down from the April 2019 update
-- https://forum.square-enix.com/ffxi/threads/55263-April.-3-2019-%28JST%29-Version-Update
local function castDia(caster, target, spell, tier, dotPower, duration, defenseDown)
    local damage = xi.spells.damage.useDamageSpell(caster, target, spell)

    -- Dia and Bio can't coexist. Replace Bio only if this Dia is stronger.
    local bio = target:getStatusEffect(xi.effect.BIO)
    if
        not bio or
        (bio and bio:getTier() < tier)
    then
        target:delStatusEffect(xi.effect.BIO)
        local power = dotPower + caster:getMod(xi.mod.DIA_DOT)

        target:addStatusEffect(xi.effect.DIA, { power = power, duration = duration, origin = caster, tick = 3, subPower = defenseDown, tier = tier })
    end

    return damage
end

m:addOverride('xi.actions.spells.white.dia.onSpellCast', function(caster, target, spell)
    return castDia(caster, target, spell, 1, 1, 60, 5)
end)

m:addOverride('xi.actions.spells.white.dia_ii.onSpellCast', function(caster, target, spell)
    return castDia(caster, target, spell, 3, 2, 120, 10)
end)

m:addOverride('xi.actions.spells.white.dia_iii.onSpellCast', function(caster, target, spell)
    return castDia(caster, target, spell, 5, 3, 180, 15)
end)

m:addOverride('xi.actions.spells.white.diaga.onSpellCast', function(caster, target, spell)
    return castDia(caster, target, spell, 1, 1, 60, 5)
end)

-----------------------------------
-- Dark Magic
-----------------------------------

-- Revert the 5% increase to Bio attack down from the April 2019 update
-- https://forum.square-enix.com/ffxi/threads/55263-April.-3-2019-%28JST%29-Version-Update
local function calculateBioPower(caster, tier)
    local skillLevel = caster:getSkillLevel(xi.skill.DARK_MAGIC)

    -- Bio potency scales with Dark Magic skill using the pre-2019 formula.
    if tier == 2 then
        return utils.clamp(math.ceil(skillLevel / 40), 1, 3)
    elseif tier == 4 then
        return utils.clamp(math.floor((skillLevel + 29) / 40), 3, 8)
    end

    local power = 0
    if skillLevel > 291 then
        power = 13 + math.floor((skillLevel - 291) / 27) -- 13 + 1 every 27 skill levels.
    elseif skillLevel > 246 then
        power = 9 + math.floor((skillLevel - 246) / 11) -- 9 + 1 every 11 skill levels.
    else
        power = 5 + math.floor((skillLevel - 106) / 35) -- 5 + 1 every 35 skill levels.
    end

    return utils.clamp(power, 5, 17)
end

local function castBio(caster, target, spell, tier, duration, attackDown)
    local damage = xi.spells.damage.useDamageSpell(caster, target, spell)

    -- Dia and Bio can't coexist. Replace Dia only if this Bio is stronger.
    local dia = target:getStatusEffect(xi.effect.DIA)
    if
        not dia or
        (dia and dia:getTier() < tier)
    then
        target:delStatusEffect(xi.effect.DIA)
        local power = calculateBioPower(caster, tier)

        target:addStatusEffect(xi.effect.BIO, { power = power, duration = duration, origin = caster, tick = 3, subPower = attackDown, tier = tier })
    end

    return damage
end

m:addOverride('xi.actions.spells.black.bio.onSpellCast', function(caster, target, spell)
    return castBio(caster, target, spell, 2, 60, 5)
end)

m:addOverride('xi.actions.spells.black.bio_ii.onSpellCast', function(caster, target, spell)
    return castBio(caster, target, spell, 4, 120, 10)
end)

m:addOverride('xi.actions.spells.black.bio_iii.onSpellCast', function(caster, target, spell)
    return castBio(caster, target, spell, 6, 180, 15)
end)

return m
