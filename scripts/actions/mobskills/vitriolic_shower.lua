-----------------------------------
-- Vitriolic Shower
-- Family: Wamouracampa
-- Description: Deals Fire damage to targets surrounding mob. Additional Effect: Burn
-- Notes: Used by Brass Borer and possibly other NMs.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 7.50, 7.50, 7.50 }
    params.element         = xi.element.FIRE
    params.dStatMultiplier = 1.33

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, 30, 3, 60)
    end

    return damage
end

return mobskillObject
