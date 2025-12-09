-----------------------------------
-- Thunderbolt
-- Family: Behemoths
-- Description: Deals Thunder damage in an area of effect. Additional Effect: Stun
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 0.6, 0.6, 0.6 }
    params.element    = xi.element.THUNDER
    -- TODO: Capture shadowBehavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STUN, 1, 0, math.random(8, 14))
    end

    return damage
end

return mobskillObject
