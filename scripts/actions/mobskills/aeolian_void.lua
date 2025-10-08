-----------------------------------
-- Aeolian Void
-- Family: Sandworm
-- Description: Deals Wind damage to enemies in front of mob. Additional Effect: Blind, Silence
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill, action)
    local damage = mob:getWeaponDmg() * 2

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.00, 2.00, 2.00 }
    params.element    = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SILENCE, 1, 0, 180)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 50, 0, 180)
    end

    return damage
end

return mobskillObject
