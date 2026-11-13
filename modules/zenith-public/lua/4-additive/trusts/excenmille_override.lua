-----------------------------------
-- Override Trust: Excenmille (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_excenmille_override')

m:addOverride('xi.actions.spells.trust.excenmille.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.RAHAL] = xi.trust.messageOffset.TEAMWORK_1,
    })

    trust:addMod(xi.mod.HPP, 10)
    trust:addMod(xi.mod.MPP, 20)
    trust:addMod(xi.mod.ENMITY, 10)
    trust:addMod(xi.mod.STORETP, 25)

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.SENTINEL }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL })
    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 75 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })
end)
