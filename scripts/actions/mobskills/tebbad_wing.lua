-----------------------------------
-- Tebbad Wing
-- Family: Wyrms
-- Description: A hot wind deals Fire damage to enemies within a very wide area of effect. Additional Effect: Plague
-- Notes: Used by Tiamat, Smok and Ildebrann on round.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:hasStatusEffect(xi.effect.MIGHTY_STRIKES) then
        return 1
    elseif mob:getAnimationSub() == 1 then
        return 1
    elseif target:isBehind(mob, 48) then
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.00, 4.00, 4.00 }
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 10, 0, 120) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
