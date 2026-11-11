-----------------------------------
-- Override Trust: Ajido-Marujido (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('ajido_marujido_override')

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
    trust:addGambit(ai.t.TARGET, { ai.c.MB_AVAILABLE, 0 }, { ai.r.MA, ai.s.MB_ELEMENT, xi.magic.spellFamily.NONE })
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_GTE, 35 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.NONE }, 60)
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_LT, 35 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.NONE }, 60)

    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 25 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })
    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.SLOW }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.SLOW }, 60)

    -- Be aggressive with Dispel, cast if off Cooldown
    trust:addGambit(ai.t.TARGET, { ai.c.STATUS_FLAG, xi.effectFlag.DISPELABLE }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.DISPEL }, 10)
    -- This is lose fit and matches Shantotto. He SHOULD cast the spell family for each which would require a check on each Threnody
    trust:addGambit(ai.t.TARGET, { ai.c.STATUS, xi.effect.THRENODY }, { ai.r.MA, ai.s.BEST_AGAINST_TARGET, 0 }, 60)

    trust:setMobMod(xi.mobMod.TRUST_DISTANCE, xi.trust.movementType.NO_MOVE)
end)
