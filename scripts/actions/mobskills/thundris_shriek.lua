-----------------------------------
-- Thundris Shriek
-- Family: Dvergr
-- Description: Deals heavy Thunder damage to targets in area of effect. Additional Effect: Terror
-- Notes: Players will begin to be intimidated by the dvergr after this attack.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 5.00, 5.00, 5.00 } -- TODO: Capture fTPs
    params.element    = xi.element.THUNDER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)
    -- TODO: Mob gains Humanoid Killer effect after using this skill.

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.TERROR, 1, 0, 15) -- TODO: Capture duration
    end

    return damage
end

return mobskillObject
