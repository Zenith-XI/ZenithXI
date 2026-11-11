-----------------------------------
-- Override Trust: Curilla (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('curilla_override')

m:addOverride('xi.actions.spells.trust.curilla.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.TRION] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.RAINEMARD] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.RAHAL] = xi.trust.messageOffset.TEAMWORK_3,
        [xi.magic.spell.HALVER] = xi.trust.messageOffset.TEAMWORK_4,
    })

    trust:addListener('ABILITY_USE', 'SENTINEL_USE' .. 'ABILITY', function(mobArg, target, skill, action)
        if skill:getID() == xi.jobAbility.SENTINEL then
            skill:setRecast(skill:getRecast() - 50) -- Sentinel Recast merited (-50 sec)
            mobArg:addStatusEffect(xi.effect.SENTINEL, { duration = 40 }) -- Set to 40s
        end
    end)

    trust:addListener('COMBAT_TICK', 'CURILLA_CTICK', function(mobArg)
        local effect = trust:getStatusEffect(xi.effect.SENTINEL)
        if effect and effect:getSubPower() ~= 95 then
            effect:setSubPower(95) -- Guardian (Sentinel enmity loss -95%)
        end
    end)

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

    trust:setMobMod(xi.mobMod.CAN_SHIELD_BLOCK, 1)
    trust:setMobMod(xi.mobMod.CAN_PARRY, 3)
    trust:setMod(xi.mod.SHIELD_MASTERY_TP, shieldMasteryPower)
    trust:setMod(xi.mod.SHIELDBLOCKRATE, 20)
    trust:addMod(xi.mod.CURE_CAST_TIME, 50)
    trust:addMod(xi.mod.CURE_POTENCY, 25)
    trust:addMod(xi.mod.ENMITY, 15)
    trust:addMod(xi.mod.DMG, -500) -- Damage Taken -5%
    trust:addMod(xi.mod.HPP, 10)
    trust:addMod(xi.mod.MPP, 30)

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.SENTINEL }, { ai.r.JA, ai.s.BY_LEVEL, xi.ja.SENTINEL })

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH      })
    trust:addGambit(ai.t.PARTY,  { ai.c.HPP_LT,     75              }, { ai.r.MA, ai.s.HIGHEST,  xi.magic.spellFamily.CURE })

    trust:setTrustTPSkillSettings(ai.tp.ASAP, ai.s.RANDOM)
end)
