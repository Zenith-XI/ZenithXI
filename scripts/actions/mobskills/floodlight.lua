-----------------------------------
-- Floodlight
-- Family: Omega (Proto Omega)
-- Description:  ~300 magic damage, Flash, Blind and Silence
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.5, 4.5, 4.5 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        -- TODO: Capture power/durations.
        -- Note: Flash decay not implemented as of time of this comment.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 15, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.FLASH, 200, 3, 20)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SILENCE, 1, 0, 60)
    end

    return damage
end

return mobskillObject
