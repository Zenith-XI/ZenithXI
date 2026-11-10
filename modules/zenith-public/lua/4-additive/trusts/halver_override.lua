-----------------------------------
-- Override Trust: Halver (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('halver_override')

m:addOverride('xi.actions.spells.trust.halver.onMobSpawn', function(trust)
    xi.trust.message(trust, xi.trust.messageOffset.SPAWN)

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.BERSERK }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BERSERK  })

    -- Tries to back up tank when members are low, needs a retail check but mimics other trusts as is --
    trust:addGambit(ai.t.TANK, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE  })
    trust:addGambit(ai.t.TANK, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL })
    trust:addGambit(ai.t.TANK, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.RAMPART  })

    trust:addGambit(ai.t.PARTY, { ai.c.STATUS, xi.effect.SLEEP_I }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE })
    trust:addGambit(ai.t.PARTY, { ai.c.STATUS, xi.effect.SLEEP_II }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.CURE })

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH })
    trust:addGambit(ai.t.PARTY, { ai.c.HPP_LT, 50 }, { ai.r.MA, ai.s.HIGHEST, xi.magic.spellFamily.CURE })
    local lvl = trust:getMainLvl()
    if lvl >= 15 then
        trust:setMod(xi.mod.DOUBLE_ATTACK, 10)
    end
end)
