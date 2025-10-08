-----------------------------------
-- Blastbomb
-- Family: Orc Warmachine
-- Description: Deals Fire damage in an area of effect. Additional Effect: Bind
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = mob:getMainLvl() + 2
    params.fTP          = { 3.00, 3.00, 3.00 }
    params.element      = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE, { breakBind = false })

        local duration = xi.mobskills.calculateDuration(skill:getTP(), 30, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIND, 1, 0, duration)
    end

    return damage
end

return mobskillObject
