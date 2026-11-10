-----------------------------------
-- Override Trust: Shantotto (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('shantotto_override')

m:addOverride('xi.actions.spells.trust.shantotto.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.AJIDO_MARUJIDO] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.STAR_SIBYL] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.KORU_MORU] = xi.trust.messageOffset.TEAMWORK_3,
        [xi.magic.spell.KING_OF_HEARTS] = xi.trust.messageOffset.TEAMWORK_4
    })

    trust:addGambit(ai.t.TARGET, { ai.c.MB_AVAILABLE, 0 }, { ai.r.MA, ai.s.MB_ELEMENT, xi.magic.spellFamily.NONE })
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_GTE, 35 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.NONE }, 60)
    trust:addGambit(ai.t.TARGET, { ai.c.HPP_LT, 35 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.NONE }, 60)
    trust:addGambit(ai.t.TARGET, { ai.c.STATUS, xi.effect.THRENODY }, { ai.r.MA, ai.s.BEST_AGAINST_TARGET, 0 }, 60)

    trust:addMod(xi.mod.MATT, xi.trust.modGrowthValMax(trust, 39))
    trust:addMod(xi.mod.MACC, xi.trust.modGrowthValMax(trust, 39))

    trust:addMod(xi.mod.HASTE_MAGIC, 1000) -- 10% Haste (Magic)
    trust:addMod(xi.mod.FASTCAST, 10)
    trust:addMod(xi.mod.MPP, 100) -- 100% MP

    trust:setAutoAttackEnabled(false)
    trust:setMobMod(xi.mobMod.TRUST_DISTANCE, xi.trust.movementType.NO_MOVE)
end)
