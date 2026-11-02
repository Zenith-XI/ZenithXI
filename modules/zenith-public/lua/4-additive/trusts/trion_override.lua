-----------------------------------
-- Override Trust: Trion (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require("scripts/globals/magic")
require("scripts/globals/gambits")
-----------------------------------
local m = Module:new('trion_override')

m:addOverride('xi.actions.spells.trust.trion.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.CURILLA] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.RAHAL] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.HALVER] = xi.trust.messageOffset.TEAMWORK_3,
    })

    trust:setMobMod(xi.mobMod.CAN_SHIELD_BLOCK, 1)
    trust:setMobMod(xi.mobMod.CAN_PARRY, 3)

    local lvl = trust:getMainLvl()
    local shieldMasteryPower = 0

    if lvl >= 96 then
        shieldMasteryPower = 40
    elseif lvl >= 75 then
        shieldMasteryPower = 30
    elseif lvl >= 50 then
        shieldMasteryPower = 20
    elseif lvl >= 25 then
        shieldMasteryPower = 10
    end

    trust:setMod(xi.mod.SHIELD_MASTERY_TP, shieldMasteryPower)
    trust:setMod(xi.mod.SHIELDBLOCKRATE, 25)
    trust:addMod(xi.mod.SPELLINTERRUPT, 30)
    trust:addMod(xi.mod.FASTCAST, 30)
    trust:addMod(xi.mod.ENMITY, 15)
    trust:addMod(xi.mod.DMG, -500) -- Damage Taken -5%
    trust:addMod(xi.mod.HPP, 10)
    trust:addMod(xi.mod.MPP, 10)

    -- Mob Skill thats not a WS; keep it Specific --
        trust:addGambit(ai.t.TARGET, { ai.l.OR(
            { ai.c.CASTING_MA, 0 },
            { ai.c.READYING_JA, 0 },
            { ai.c.READYING_MS, 0 },
            { ai.c.READYING_WS, 0 }) }, { ai.r.MS, ai.s.SPECIFIC, xi.mobSkill.ROYAL_BASH_TRUST }, 60)
    trust:addGambit(ai.t.SELF, { ai.c.ALWAYS, 0 }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.PROVOKE })
    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.SENTINEL }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL })

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH      })
    trust:addGambit(ai.t.PARTY,  { ai.c.HPP_LT,     75              }, { ai.r.MA, ai.s.HIGHEST,  xi.magic.spellFamily.CURE })

    trust:setTrustTPSkillSettings(ai.tp.RANDOM, ai.s.RANDOM, 1500)

    trust:addListener('WEAPONSKILL_USE', 'TRION_WEAPONSKILL_USE', function(mobArg, target, skill, tp, action, damage)
        if skill:getID() == xi.mobSkill.ROYAL_SAVIOR_TRUST then -- Royal Savior
            -- O great kings of the noble line of d'Oraguille, shield me from harm!
            xi.trust.message(mobArg, xi.trust.messageOffset.SPECIAL_MOVE_1)
        end
    end)
end)