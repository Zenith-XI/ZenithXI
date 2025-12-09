-----------------------------------
-- Ochre Blast Alt
-- Family: Wyrms
-- Description: Deals Earth damage to a single target
-- Notes: Used by Ouryu in place of regular attacks
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3, 3, 3 } -- TODO: Capture fTPs
    params.element    = xi.element.EARTH

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)
        skill:setMsg(xi.msg.basic.HIT_DMG) -- TODO: Handle in mobFinalAdjustments
    end

    return damage
end

return mobskillObject
