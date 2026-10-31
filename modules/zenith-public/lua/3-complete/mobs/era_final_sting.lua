-----------------------------------
-- Era Final Sting (ZENITHDEV-269)
-- Undoes the April 29, 2013 update, which raised the HP threshold to 50% and halved the damage:
--   The Bee-family skill needs 33% HP or less, and deals full current HP as damage.
-- onMobSkillCheck returns 0 when the skill can be used.
-- Source: https://wiki.ffo.jp/html/28857.html
-- Based on Phoenix's modules/phoenix/lua/actions/mobskills/final_sting_pre_2013.lua
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_eraFinalSting')

m:addOverride('xi.actions.mobskills.final_sting.onMobSkillCheck', function(target, mob, skill)
    if mob:getHPP() <= 33 then
        return 0
    end

    return 1
end)

m:addOverride('xi.actions.mobskills.final_sting.onMobWeaponSkill', function(mob, target, skill, action)
    local params = {}

    params.baseDamage           = skill:getMobHP()
    params.fTP                  = { 1.0, 1.0, 1.0 }
    params.element              = xi.element.NONE
    params.attackType           = xi.attackType.MAGICAL
    params.damageType           = xi.damageType.NONE
    params.shadowBehavior       = xi.mobskills.shadowBehavior.IGNORE_SHADOWS
    params.skipDamageAdjustment = true
    params.skipMagicBonusDiff   = true

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, action, params)

    if xi.mobskills.processDamage(mob, target, skill, action, info) then
        target:takeDamage(info.damage, mob, info.attackType, info.damageType)
    end

    return info.damage
end)

return m
