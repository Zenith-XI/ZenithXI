-----------------------------------
-- Water Meeble Warble
-- AOE Water Elemental damage, inflicts Poison and Drown (50 HP/tick).
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 18, 18, 18 } -- TODO: Capture fTPs
    params.element    = xi.element.WATER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.DROWN, 50, 3, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 50, 3, 60)
    end

    return damage
end

return mobskillObject
