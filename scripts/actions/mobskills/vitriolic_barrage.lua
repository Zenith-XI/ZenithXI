-----------------------------------
-- Vitriolic Barrage
-- Family: Yovra
-- Description: Deals unaspected? magic damage to targets in range. Additional Effect: Poison
-- Notes: Affected by MDEF stat.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = 1000 / skill:getTotalTargets()
    params.fTP          = { 1.00, 1.00, 1.00 }
    params.element      = xi.element.NONE -- TODO: Verify whether unaspected or elemental

    -- https://youtu.be/DgQrZQJEqDY?t=409
    -- Looks like it bypasses MDT(Shell).
    params.skipTMDA = true

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.NONE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.NONE)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 18, 3, 180)
    end

    return damage
end

return mobskillObject
