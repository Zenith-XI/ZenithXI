-----------------------------------
-- Acrid Stream
-- Family: Vorageans
-- Description: Deals water damage to enemies within a fan-shaped area originating from the caster. Additional Effect: Magic Defense Down
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.50, 3.50, 3.50 } -- TODO: Capture fTPs
    params.element    = xi.element.WATER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        -- TODO: Capture power/duration
        local power    = 20
        local duration = 120
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.MAGIC_DEF_DOWN, power, 0, duration)
    end

    return damage
end

return mobskillObject
