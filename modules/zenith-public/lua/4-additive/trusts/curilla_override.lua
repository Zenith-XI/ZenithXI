-----------------------------------
-- Override Trust: Curilla (configurable)
-----------------------------------
require('modules/module_utils')
require('scripts/globals/trust')
require('scripts/globals/magic')
require('scripts/globals/gambits')
-----------------------------------
local m = Module:new('a-t_curilla_override')

m:addOverride('xi.actions.spells.trust.curilla.onMobSpawn', function(trust)
    xi.trust.teamworkMessage(trust, {
        [xi.magic.spell.TRION] = xi.trust.messageOffset.TEAMWORK_1,
        [xi.magic.spell.RAINEMARD] = xi.trust.messageOffset.TEAMWORK_2,
        [xi.magic.spell.RAHAL] = xi.trust.messageOffset.TEAMWORK_3,
        [xi.magic.spell.HALVER] = xi.trust.messageOffset.TEAMWORK_4,
    })

    -- Curilla's Trust profile has Guardian 5/5 and Sentinel Recast 5/5. Trusts have no merits, so the
    -- timing parts are applied here directly; Guardian's enmity retention is intentionally not reproduced.
    trust:addListener('ABILITY_USE', 'CURILLA_SENTINEL_USE', function(mobArg, target, skill, action)
        if skill:getID() == xi.jobAbility.SENTINEL then
            -- Sentinel Recast 5/5 equivalent: 300s -> 250s
            skill:setRecast(skill:getRecast() - 50)

            -- Guardian 5/5 equivalent: Sentinel duration 30s -> 40s.
            -- The listener runs after Sentinel is applied, so extend that effect instead of re-adding it.
            local sentinel = mobArg:getStatusEffect(xi.effect.SENTINEL)
            if sentinel then
                sentinel:setDuration(40000)
                sentinel:resetStartTime()
            end
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

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.SENTINEL }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.SENTINEL })

    trust:addGambit(ai.t.TARGET, { ai.c.NOT_STATUS, xi.effect.FLASH }, { ai.r.MA, ai.s.SPECIFIC, xi.magic.spell.FLASH      })
    trust:addGambit(ai.t.PARTY,  { ai.c.HPP_LT,     75              }, { ai.r.MA, ai.s.HIGHEST,  xi.magic.spellFamily.CURE })

    trust:setTrustTPSkillSettings(ai.tp.ASAP, ai.s.RANDOM)
end)
