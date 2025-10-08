-----------------------------------
-- Aqua Blast
-- Family: Ruszors
-- Description: Fires a blast of Water, dealing damage in a fan-shaped area. Additional Effect: Knockback
-- Note: There was not a lot of information about this spell available online, so
--       the initial implementation is relatively basic.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    -- Do not use this weapon skill on targets behind.
    -- Sub-Zero Smash should trigger in this case.
    if target:isBehind(mob) then
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 2, 2, 2 }
    params.element    = xi.element.WATER
    -- TODO: Capture knockback range

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)
    end

    return damage
end

return mobskillObject
