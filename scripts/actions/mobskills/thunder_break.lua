-----------------------------------
-- Thunder Break
-- Family: Golems
-- Description: Deals Thunder damage to targets in range. Additional Effect: Stun
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.00, 1.00, 1.00 } -- TODO: Capture fTP scaling
    params.element    = xi.element.THUNDER

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STUN, 1, 0, math.random(10, 20))
    end

    return damage
end

return mobskillObject
