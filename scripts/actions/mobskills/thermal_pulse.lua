-----------------------------------
-- Thermal Pulse
-- Family: Wamouracampa
-- Description: Deals Fire damage to enemies within area of effect. Additional Effect: Blindness
-- Notes: Open form only.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getAnimationSub() ~= 0 then
        return 1
    else
        return 0
    end
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.5, 4.5, 4.5 }
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)


    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        local duration = xi.mobskills.calculateDuration(skill:getTP(), 30, 90)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 100, 0, duration)
    end

    return damage
end

return mobskillObject
