-----------------------------------
-- Trust Level Restrictions Module
--
-- Restricts certain trusts to level 50+
-- Affected: Brygid, Kuyin Hathdenna, Moogle, Star Sibyl
-----------------------------------

local m = Module:new('trust_level_restrictions')

local restrictedTrusts =
{
    [xi.magic.spell.BRYGID] = 50,
    [xi.magic.spell.KUYIN_HATHDENNA] = 50,
    [xi.magic.spell.MOOGLE] = 50,
    [xi.magic.spell.STAR_SIBYL] = 50,
}

m:addOverride('xi.trust.canCast', function(caster, spell, notAllowedTrustIds)
    local spellId = spell:getID()
    local requiredLevel = restrictedTrusts[spellId]

    if requiredLevel and caster:getMainLvl() < requiredLevel then
        caster:printToPlayer(
            string.format('You must be level %d or above to summon this alter ego.', requiredLevel),
            xi.msg.channel.SYSTEM_3
        )
        return -1
    end

    return super(caster, spell, notAllowedTrustIds)
end)

return m
