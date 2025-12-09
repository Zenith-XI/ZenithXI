-----------------------------------
-- Self-Destruct
-- Family: Clusters
-- Description: Last remaining bomb in the Cluster explodes to deal Fire damage on targets in range.
-- Notes: Bomb Cluster Self Destruct - 1 Bomb up
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if
        mob:isMobType(xi.mobskills.mobType.NOTORIOUS) or -- Don't suicide if NM
        mob:getHPP() > 20 or                             -- Can only be used below 20%
        mob:getAnimationSub() ~= 2                       -- Only used when 1 bomb remaining
    then
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = math.min(skill:getMobHP() / 3, mob:getMaxHP() / 3)
    params.fTP          = { 1.00, 1.00, 1.00 }
    params.element      = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    mob:setHP(0)

    return damage
end

return mobskillObject
