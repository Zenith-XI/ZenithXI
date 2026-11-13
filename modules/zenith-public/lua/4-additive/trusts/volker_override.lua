-----------------------------------
-- Override Trust: Volker (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_volker_override')

m:addOverride('xi.actions.spells.trust.volker.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.NAJI] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.CID] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.KLARA] = xi.trust.messageOffset.TEAMWORK_3,
    })

    trust:setMobMod(xi.mobMod.CAN_PARRY, 3)
    trust:addMod(xi.mod.HPP, 15) -- HP+15%
    trust:addMod(xi.mod.ALL_WSDMG_ALL_HITS, 10) -- WSD+10%

    trust:addGambit(ai.t.SELF, { ai.c.NOT_SC_AVAILABLE, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.WARCRY })
    -- DD Mode
    trust:addGambit(ai.t.SELF, { ai.c.PT_HAS_TANK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BERSERK })
    trust:addGambit(ai.t.SELF, { ai.c.PT_HAS_TANK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.AGGRESSOR })
    trust:addGambit(ai.t.TANK, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })

    -- Tank Mode
    trust:addGambit(ai.t.TARGET, { ai.c.NOT_PT_HAS_TANK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })
    trust:addGambit(ai.t.SELF, { ai.c.NOT_PT_HAS_TANK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.DEFENDER })
    trust:addGambit(ai.t.SELF, { ai.c.NOT_PT_HAS_TANK, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.RETALIATION })

    trust:addGambit(ai.t.MASTER, { ai.c.HPP_LT, 50 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })

    -- Uses weaponskills at 2000TP without prioritizing skillchains.
    trust:setTrustTPSkillSettings(ai.tp.RANDOM, ai.s.RANDOM, 2000)

    -- TODO: Add Warriors Charge + WS Logic

    -- Custom bonus to differentiate the trust
    local lvl = trust:getMainLvl()

    if lvl >= 15 then
        trust:addMod(xi.mod.ACC, 10) -- Accuracy+10
    end
end)
