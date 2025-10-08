-----------------------------------
-- Artifical Gravity
-- Family: Gear (Single)
-- Description: Deals Light damage to targets in range. Additional Effect: Weight
-- Notes: This is for gear mobs that only have a single gear at all times (Example: Not 1/3 gears).
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2, 2, 2 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.WEIGHT, 15, 0, 60) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
