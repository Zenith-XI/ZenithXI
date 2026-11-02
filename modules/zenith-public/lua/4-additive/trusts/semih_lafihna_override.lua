-----------------------------------
-- Override Trust: Semih Lafihna (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require("scripts/globals/magic")
require("scripts/globals/gambits")
-----------------------------------
local m = Module:new('semih_lafihna_override')

m:addOverride('xi.actions.spells.trust.semih_lafihna.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.STAR_SIBYL] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.AJIDO_MARUJIDO] = xi.trust.messageOffset.TEAMWORK_2,
    })

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.BARRAGE }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BARRAGE })

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.SHARPSHOT }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SHARPSHOT })

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.DOUBLE_SHOT }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.DOUBLE_SHOT })

    -- TODO: Stealth Shot not yet implemented
    -- mob:addGambit(ai.t.SELF, { ai.c.HAS_TOP_ENMITY, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.STEALTH_SHOT })

    trust:addListener('WEAPONSKILL_USE', 'SEMIH_LAFIHNA_WEAPONSKILL_USE', function(mobArg, target, skill, tp, action, damage)
        if skill:getID() == 3490 then -- Stellar Arrow
            -- I'll show you no quarter!
            xi.trust.message(mobArg, xi.trust.messageOffset.SPECIAL_MOVE_1)
        end
    end)

    -- Ranged Attack as much as possible (limited by 'weapon' delay)
    trust:addGambit(ai.t.TARGET, { ai.c.ALWAYS, 0 }, { ai.r.RATTACK, 0, 0 })

    trust:setAutoAttackEnabled(false)

    -- Gets 252 TP per hit even at level 1, see https://www.bg-wiki.com/ffxi/BGWiki:Trusts#Semih_Lafihna
    -- Using STP as a hack to ensure proper TP amount, as her delay is not that high on retail.
    trust:addMod(xi.mod.STORETP, 40)

    trust:setMobMod(xi.mobMod.TRUST_DISTANCE, xi.trust.movementType.LONG_RANGE)
end)