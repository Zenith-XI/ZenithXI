-----------------------------------
-- Override Trust: Iron Eater (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_iron_eater_override')

m:addOverride('xi.actions.spells.trust.iron_eater.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.NAJI] = xi.trust.messageOffset.TEAMWORK_1,
    })

    trust:addGambit(ai.t.MASTER, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })
    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.BERSERK }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BERSERK  })

    local lvl = trust:getMainLvl()

    if lvl >= 50 then
        trust:addMod(xi.mod.STORETP, 20)
    elseif lvl >= 30 then
        trust:addMod(xi.mod.STORETP, 15)
    elseif lvl >= 10 then
        trust:addMod(xi.mod.STORETP, 10)
    end

    if lvl >= 25 then
        trust:addMod(xi.mod.DOUBLE_ATTACK, 5) -- Native 5% higher DA rate
    end
end)
