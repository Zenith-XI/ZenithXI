-----------------------------------
-- Override Trust: Halver (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_halver_override')

m:addOverride('xi.actions.spells.trust.halver.onMobSpawn', function(trust)
    xi.trust.message(trust, xi.trust.messageOffset.SPAWN)

    trust:setMobMod(xi.mobMod.CAN_PARRY, 3)
    trust:addMod(xi.mod.ENMITY, 10)
    trust:addMod(xi.mod.HPP, 10) -- HP+10%
    trust:addMod(xi.mod.MPP, 30) -- MP+30%

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.BERSERK }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BERSERK })

    -- Switch to defensive abilities when any party member falls below 40% HP.
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 40 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 40 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 40 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.RAMPART })

    trust:addGambit(ai.t.PARTY, { ai.c.STATUS, xi.effect.SLEEP_I }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE })
    trust:addGambit(ai.t.PARTY, { ai.c.STATUS, xi.effect.SLEEP_II }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE })

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 50 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })

    local lvl = trust:getMainLvl()
    if lvl >= 15 then
        trust:setMod(xi.mod.DOUBLE_ATTACK, 10)
    end
end)
