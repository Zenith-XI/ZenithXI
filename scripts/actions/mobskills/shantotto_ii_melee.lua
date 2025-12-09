-----------------------------------
--  Shantotto II Melee
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 1.0, 1.0, 1.0 } -- TODO: Capture fTPs
    params.element    = xi.element.NONE
    -- TODO: Capture shadowBehavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)
    end

    skill:setMsg(xi.msg.basic.HIT_DMG) -- TODO: Set once params passed to mobFinalAdjustments

    return damage
end

return mobskillObject
