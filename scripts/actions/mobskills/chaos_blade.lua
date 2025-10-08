-----------------------------------
-- Chaos Blade
-- Family: Dragons
-- Description: Deals Dark damage to enemies within a fan-shaped area. Additional Effect: Curse
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1, 1, 1 }
    params.element    = xi.element.DARK
    -- TODO: This move should force the mob to look at the target.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        -- TODO: Capture power/durations (Varies between different mobs/NMs)
        local power    = 25
        local duration = 420

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.CURSE_I, power, 0, duration)
    end

    return damage
end

return mobskillObject
