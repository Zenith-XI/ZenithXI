-----------------------------------
-- Slaverous Gale
-- Family: Sandworms
-- Description: Deals damage to targets in front of mob. Additional Effect: Plague, Slow
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 5.0, 5.0, 5.0 }
    params.element    = xi.element.EARTH

    -- TODO: JP wiki says this can miss and may be a physical skill. Need more captures to confirm.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 5, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLOW, 5000, 0, 120)
    end

    return damage
end

return mobskillObject
