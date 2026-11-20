-----------------------------------
-- Override Trust: Volker (configurable)
-- Adds the ticket's (ZENITHDEV-200) Warcry gambit, TP settings and mods on top of LSB's onMobSpawn.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('a-t_volker_override')

m:addOverride('xi.actions.spells.trust.volker.onMobSpawn', function(trust)
    super(trust)

    trust:setMobMod(xi.mobMod.CAN_PARRY, 3)
    trust:addMod(xi.mod.HPP, 15) -- HP+15%
    trust:addMod(xi.mod.ALL_WSDMG_ALL_HITS, 10) -- WSD+10%

    trust:addGambit(ai.t.SELF, { ai.c.NOT_SC_AVAILABLE, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.WARCRY })

    -- Uses weaponskills at 2000TP without prioritizing skillchains.
    trust:setTrustTPSkillSettings(ai.tp.RANDOM, ai.s.RANDOM, 2000)

    -- Custom bonus to differentiate the trust
    local lvl = trust:getMainLvl()

    if lvl >= 15 then
        trust:addMod(xi.mod.ACC, 10) -- Accuracy+10
    end
end)
