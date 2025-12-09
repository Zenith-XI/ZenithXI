-----------------------------------
-- Paralyzing Microtube
-- Description: Deals Magic damage to target. Additional effect: Paralyze
-- Used by Adelheid (Trust)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 12.25, 12.25, 12.25 } -- TODO: Capture fTPs
    params.element    = xi.element.NONE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PARALYSIS, 20, 0, 60) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
