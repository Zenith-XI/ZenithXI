-----------------------------------
-- Self-Destruct
-- Family: Clusters
-- Notes: Bomb Cluster Self Destruct - 3 Bombs up
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if
        mob:getHPP() > 66 or      -- Can only be used below 66%
        mob:getAnimationSub() > 0 -- Only used when 3 bombs are remaining
    then
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = math.min(skill:getMobHP() / 3, mob:getMaxHP() / 3)
    params.fTP        = { 1.00, 1.00, 1.00 }
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    skill:setFinalAnimationSub(1)

    return damage
end

return mobskillObject
