-----------------------------------
-- Override Trust: Nanaa Mihgo (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('nanaa_mihgo_override')

m:addOverride('xi.actions.spells.trust.nanaa_mihgo.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.ROMAA_MIHGO] = xi.trust.messageOffset.TEAMWORK_1,
    })
    trust:addGambit(ai.t.TARGET, { ai.c.ALWAYS, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.DESPOIL })
    trust:setTrustTPSkillSettings(ai.tp.OPENER, ai.s.HIGHEST)
end)
