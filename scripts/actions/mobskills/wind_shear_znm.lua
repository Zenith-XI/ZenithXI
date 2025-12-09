-----------------------------------
-- Wind Shear
-- Family: Puks
-- Description: Deals Wind damage to enemies within an area of effect. Additional Effect: Knockback
-- Notes: The knockback is rather severe. Vulpangue uses an enhanced version that inflicts Weight.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.25, 1.50, 1.75 } -- TODO: Capture fTP scaling.
    params.element    = xi.element.WIND
    -- TODO: Capture shadowBehavior.
    -- TODO: Jimmayus spreadsheet states if this is fully resisted, it misses(Knockback nullified as well?).

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.NUMSHADOWS_3, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.WEIGHT, 50, 0, 120)
    end

    return damage
end

return mobskillObject
