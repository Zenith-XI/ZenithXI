-----------------------------------
-- Warped Wail
-- Family: Amphipteres
-- Description: Deals Wind damage to targets in range. Additional Effect: Max HP Down, Max MP Down
-- Notes: Used by Zirnitra and Pteranodon
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.00, 3.00, 3.00 } -- TODO: Capture fTPs
    params.element    = xi.element.WIND      -- TODO: Capture element.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO Capture power/duration of HP/MP Down.
        -- From battle footage, it looks to be around 10-15%. (Hard to tell exact since player was gear swapping).
        xi.mobskills.mobPhysicalStatusEffectMove(mob, target, skill, xi.effect.MAX_HP_DOWN, 50, 0, 300)
        xi.mobskills.mobPhysicalStatusEffectMove(mob, target, skill, xi.effect.MAX_MP_DOWN, 50, 0, 300)
    end

    return damage
end

return mobskillObject
