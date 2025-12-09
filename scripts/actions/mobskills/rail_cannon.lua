-----------------------------------
-- Rail Cannon
-- Family: Gear
-- Notes: This version is used by single gears models (Not 1/3 triple gears).
-- Single Gear: Rail Cannon is single target and ignores Utsusemi.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 5.0, 5.0, 5.0 }
    params.element         = xi.element.LIGHT
    params.dStatMultiplier = 1.5

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)
    end

    return damage
end

return mobskillObject
