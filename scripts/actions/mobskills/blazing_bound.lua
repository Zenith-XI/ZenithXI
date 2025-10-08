-----------------------------------
-- Blazing Bound
-- Family: Limules
-- Description: Deals Fire damage to target. Additional Effect: Burn
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = mob:getMainLvl() + 2
    params.fTP          = { 3.00, 3.00, 3.00 } -- TODO: Capture fTPs
    params.element      = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        -- TODO: Capture power/durations/ if it scales on level/tp
        -- xi.mobskills.mobBuffMove(mob, xi.effect.DEFENSE_BOOST, 25, 0, 120) -- Need power/duration data
        -- xi.mobskills.mobBuffMove(mob, xi.effect.MAGIC_DEF_BOOST, 25, 0, 120) -- Need power/duration data
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, 26, 3, 120)
    end

    return damage
end

return mobskillObject
