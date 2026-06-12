require('modules/module_utils')

local m = Module:new('utsusemi_ninja_sub')

m:addOverride('xi.actions.spells.ninjutsu.utsusemi_ichi.onMagicCastingCheck', function(caster, target, spell)
    -- +1 s cast time when NIN is subjob
    if caster:getMainJob() ~= xi.job.NIN then
        spell:setCastTime(spell:getCastTime() + 1000)
    end

    return super(caster, target, spell)
end)

m:addOverride('xi.actions.spells.ninjutsu.utsusemi_ni.onMagicCastingCheck', function(caster, target, spell)
    -- +1 s cast time when NIN is subjob
    if caster:getMainJob() ~= xi.job.NIN then
        spell:setCastTime(spell:getCastTime() + 1000)
    end

    return super(caster, target, spell)
end)

m:addOverride('xi.spells.enhancing.calculateNinjutsuPower', function(caster, target, spell, spellId, tier, spellEffect)
    local power, subPower = super(caster, target, spell, spellId, tier, spellEffect)
    if spellEffect == xi.effect.COPY_IMAGE then
        -- Utsusemi Ichi gives one less shadow when Ninja is subjob
        if
            spellId == xi.magic.spell.UTSUSEMI_ICHI and
            caster:getMainJob() ~= xi.job.NIN
        then
            power = power - 1
            if power == 2 then
                subPower = xi.effect.COPY_IMAGE_2
            end
        end
    end

    return power, subPower
end)

return m
