-----------------------------------
-- Acid Spray
-- Family: Spider
-- Description: Deals Water damage to a target. Additional Effect: Poison
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.00, 1.00, 1.00 }
    params.element    = xi.element.WATER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

        local power = math.floor(mob:getMainLvl() / 10 * 2)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, power, 3, 60)
    end

    return damage
end

return mobskillObject
