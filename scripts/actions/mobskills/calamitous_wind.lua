-----------------------------------
-- Calamitous Wind
-- Family: Amphipteres
-- Description: Deals Wind damage to targets in range. Additional Effect: Full Dispel, Knockback
-- Notes: Used by Zirnitra, Turul, and Amhuluk under 50%
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getHPP() >= 50 then
        return 1
    else
        return 0
    end
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4, 4, 4 }
    params.element    = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)


    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO: Should print *each* effect dispelled in addition to damage taken.
        target:dispelAllStatusEffect(bit.bor(xi.effectFlag.DISPELABLE, xi.effectFlag.FOOD))
    end

    return damage
end

return mobskillObject
