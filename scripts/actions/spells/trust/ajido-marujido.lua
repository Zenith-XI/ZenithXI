-----------------------------------
-- Trust: Ajido-Marujido
-----------------------------------
---@type TSpellTrust
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return xi.trust.canCast(caster, spell)
end

spellObject.onSpellCast = function(caster, target, spell)
    return xi.trust.spawn(caster, spell)
end

spellObject.onMobSpawn = function(mob)
    xi.trust.teamworkMessage(mob, {
        [xi.magic.spell.SHANTOTTO] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.STAR_SIBYL] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.KORU_MORU] = xi.trust.messageOffset.TEAMWORK_3,
        [xi.magic.spell.KARAHA_BARUHA] = xi.trust.messageOffset.TEAMWORK_4,
        [xi.magic.spell.SEMIH_LAFIHNA] = xi.trust.messageOffset.TEAMWORK_5,
    })

    mob:addGambit(ai.t.TARGET, { ai.c.MB_AVAILABLE, 0 }, { ai.r.MA, ai.s.MB_ELEMENT, xi.magic.spellFamily.NONE })
    mob:addGambit(ai.t.TARGET, { ai.c.HPP_GTE, 35 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.NONE }, 60)
    mob:addGambit(ai.t.TARGET, { ai.c.HPP_LT, 35 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.NONE }, 60)

    mob:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 25 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })
    mob:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.SLOW }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.SLOW }, 60)

    -- Be aggressive with Dispel, cast if off Cooldown
    mob:addGambit(ai.t.TARGET, { ai.c.STATUS_FLAG, xi.effectFlag.DISPELABLE }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.DISPEL }, 10)
    -- This is lose fit and matches Shantotto. He SHOULD cast the spell family for each which would require a check on each Threnody
    mob:addGambit(ai.t.TARGET, { ai.c.STATUS, xi.effect.THRENODY }, { ai.r.MA, ai.s.BEST_AGAINST_TARGET, 0 }, 60)

    mob:setMobMod(xi.mobMod.TRUST_DISTANCE, xi.trust.movementType.NO_MOVE)
    local lvl = mob:getMainLvl()
    if not xi.pre(xi.expansion.ABYSSEA) then
        mob:addMod(xi.mod.CURE_POTENCY, 10)
        if lvl >= 76 then
            mob:addMod(xi.mod.FASTCAST, 25)
        elseif  lvl >= 55 then
            mob:addMod(xi.mod.FASTCAST, 20)
        elseif  lvl >= 35 then
            mob:addMod(xi.mod.FASTCAST, 15)
        elseif lvl >= 15 then
            mob:addMod(xi.mod.FASTCAST, 10)
        end
    end
end

spellObject.onMobDespawn = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DESPAWN)
end

spellObject.onMobDeath = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DEATH)
end

return spellObject
