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

        -- Apply Saboteur duration bonus.
        if caster:hasStatusEffect(xi.effect.SABOTEUR) then
            duration = duration * (target:isNM() and 1.25 or 2)
        end

        -- Apply RDM Enfeebling Magic Duration merits.
        if caster:getMainJob() == xi.job.RDM then
            duration = duration + caster:getMerit(xi.merit.ENFEEBLING_MAGIC_DURATION)
        end

        -- Apply equipment and other enfeebling duration modifiers.
        duration = math.floor(duration * (1 + caster:getMod(xi.mod.ENF_MAG_DURATION) / 100))

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

-----------------------------------
-- Enfeebling Magic: Blind and Poison
-----------------------------------

-- Poison / Poisonga / Poison II: Revert potency formula to pre-2015 values.
-- Source: https://wiki.ffo.jp/html/833.html
-- Source: https://forum.square-enix.com/ffxi/threads/46531-Mar-26-2015-%28JST%29-Version-Update
local poisonPotency =
{
    [xi.magic.spell.POISON] =
    {
        { maxSkill = 79, potency = 1 },
        { maxSkill = 159, potency = 2 },
        { maxSkill = 239, potency = 3 },
        { maxSkill = 999, potency = 4 },
    },
    [xi.magic.spell.POISONGA] =
    {
        { maxSkill = 79, potency = 1 },
        { maxSkill = 159, potency = 2 },
        { maxSkill = 239, potency = 3 },
        { maxSkill = 999, potency = 4 },
    },
    [xi.magic.spell.POISON_II] =
    {
        { maxSkill = 124, potency = 4 },
        { maxSkill = 149, potency = 5 },
        { maxSkill = 174, potency = 6 },
        { maxSkill = 199, potency = 7 },
        { maxSkill = 224, potency = 8 },
        { maxSkill = 249, potency = 9 },
        { maxSkill = 999, potency = 10 },
    },
}

-- Blind / Blind II: Revert post-2015 potency formula.
-- Poison / Poison II / Poisonga: Revert post-2015 potency formula.
-- Source: https://forum.square-enix.com/ffxi/threads/46531-Mar-26-2015-%28JST%29-Version-Update
-- Source: https://wiki.ffo.jp/html/3596.html
-- Dokumori: Ichi potency and duration is unchanged (-3/tick instead of -2/tick).
-- Unrelated enfeebles retain their original calculations.
m:addOverride('xi.spells.enfeebling.calculatePotency', function(caster, target, spellId, spellEffect, skillType, statUsed)
    local potency

    if
        spellId == xi.magic.spell.BLIND or
        spellId == xi.magic.spell.BLIND_II
    then
        local statDiff = caster:getStat(statUsed) - target:getStat(xi.mod.MND)
        local offset = spellId == xi.magic.spell.BLIND_II and 100 or 60
        potency = math.max(math.floor((statDiff + offset) / 4), 0)
    elseif poisonPotency[spellId] then
        local skillLevel = caster:getSkillLevel(skillType)
        for _, entry in ipairs(poisonPotency[spellId]) do
            if skillLevel <= entry.maxSkill then
                potency = entry.potency
                break
            end
        end
    else
        return super(caster, target, spellId, spellEffect, skillType, statUsed)
    end

    -- Preserve Saboteur multiplier and enfeebling potency gear.
    -- All affected spells are Saboteur-eligible.
    if
        caster:hasStatusEffect(xi.effect.SABOTEUR) and
        skillType == xi.skill.ENFEEBLING_MAGIC
    then
        if target:isNM() then
            potency = math.floor(potency * (1.3 + caster:getMod(xi.mod.ENHANCES_SABOTEUR)))
        else
            potency = math.floor(potency * (2 + caster:getMod(xi.mod.ENHANCES_SABOTEUR)))
        end
    end

    return math.floor(potency * (1 + caster:getMod(xi.mod.ENF_MAG_POTENCY) / 100))
end)

return m
