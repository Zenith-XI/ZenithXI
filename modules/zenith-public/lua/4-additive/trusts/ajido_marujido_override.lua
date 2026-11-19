-----------------------------------
-- Override Trust: Ajido-Marujido (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_ajido_marujido_override')

m:addOverride('xi.actions.spells.trust.ajido-marujido.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.SHANTOTTO] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.STAR_SIBYL] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.KORU_MORU] = xi.trust.messageOffset.TEAMWORK_3,
        [xi.magic.spell.KARAHA_BARUHA] = xi.trust.messageOffset.TEAMWORK_4,
        [xi.magic.spell.SEMIH_LAFIHNA] = xi.trust.messageOffset.TEAMWORK_5,
    })
    if not xi.pre(xi.expansion.ABYSSEA) then
        trust:setMod(xi.mod.CURE_POTENCY, 10)
    end

    -- Be aggressive with Dispel, cast if off Cooldown. Gambits are ranked by order so this is highest prio
    trust:addGambit(ai.t.TARGET, { ai.c.STATUS_FLAG, xi.effectFlag.DISPELABLE }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.DISPEL }, 10)
    trust:addGambit(ai.t.TARGET, { ai.c.MB_AVAILABLE, 0 }, { ai.r.MA, ai.s.MB_ELEMENT, xi.magic.spellFamily.NONE })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 25 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })
    -- Plays like a caster when the mob is healthy and then doesn't really cast. Does cast lowest under ~15%. Something not yet implemented is checking if the party has a healer (as an add Gambit).
    -- TODO Take healer role and rarely casts if a healer is not present.
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_GTE, 50 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.NONE }, 60)
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_LT, 10 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.NONE }, 60)

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.SLOW }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.SLOW }, 60)

    -- This is lose fit and matches Shantotto. He SHOULD cast the spell family for each which would require a check on each Threnody
    trust:addGambit(ai.t.TARGET, { ai.c.STATUS, xi.effect.THRENODY }, { ai.r.MA, ai.s.BEST_AGAINST_TARGET, 0 }, 60)

    trust:setMobMod(xi.mobMod.TRUST_DISTANCE, xi.trust.movementType.NO_MOVE)
end)
