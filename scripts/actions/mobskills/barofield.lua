-----------------------------------
-- Barofield
-- Family: Hydra
-- Description: Deals Wind damage to enemies within a fan-shaped area. Additional Effect: Weight
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = mob:getMainLvl() + 2
    params.fTP          = { 4, 4, 4 } -- TODO: Capture fTPs
    params.element      = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.WEIGHT, 25, 0, 60) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
