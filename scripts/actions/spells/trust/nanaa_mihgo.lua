-----------------------------------
-- Trust: Nanaa Mihgo
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
        [xi.magic.spell.ROMAA_MIHGO] = xi.trust.messageOffset.TEAMWORK_1,
    })
    local lvl = mob:getMainLvl()
    if lvl >= 15 then
        mob:addMod(xi.mod.GILFINDER, 1)
        mob:addMod(xi.mod.TREASURE_HUNTER, 1)
    end

    mob:setTrustTPSkillSettings(ai.tp.OPENER, ai.s.HIGHEST)
end

spellObject.onMobDespawn = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DESPAWN)
end

spellObject.onMobDeath = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DEATH)
end

return spellObject
