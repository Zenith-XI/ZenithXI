-----------------------------------
-- Trust: Ayame
-----------------------------------
---@type TSpellTrust
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return xi.trust.canCast(caster, spell, xi.magic.spell.AYAME_UC)
end

spellObject.onSpellCast = function(caster, target, spell)
    return xi.trust.spawn(caster, spell)
end

spellObject.onMobSpawn = function(mob)
    xi.trust.teamworkMessage(mob, {
        [xi.magic.spell.NAJI] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.GILGAMESH] = xi.trust.messageOffset.TEAMWORK_2,
    })

    mob:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.HASSO }, { ai.r.JA, ai.s.BY_LEVEL, xi.ja.HASSO })
    mob:addGambit(ai.t.SELF, { ai.c.HAS_TOP_ENMITY, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.THIRD_EYE })
    -- Special Check for this ability. Gambit needs to check two sources SELF and MASTER; Keep trigger target as SELF, the value on the check is NOT used --
    mob:addGambit(ai.t.SELF, { ai.c.JA_AYAME_CHECK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.MEDITATE })

    mob:setTrustTPSkillSettings(ai.tp.OPENER, ai.s.SPECIAL_AYAME)
    local lvl = mob:getMainLvl()
    -- Add Zanshin traits based on Level --
    if (lvl >= 15) then
        mob:addMod(xi.mod.ZANSHIN, 20)
    end
    if (lvl >= 35) then
        mob:addMod(xi.mod.ZANSHIN, 25)
    end
    if (50) then
        mob:addMod(xi.mod.ZANSHIN, 35)
    end
    if (lvl >= 75) then
        mob:addMod(xi.mod.ZANSHIN, 45)
    end
end

spellObject.onMobDespawn = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DESPAWN)
end

spellObject.onMobDeath = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DEATH)
end

return spellObject
