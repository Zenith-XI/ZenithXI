-----------------------------------
-- Undead Mold
-- Family: Doomed
-- Description: Releases undead spores that damages targets in front. Additional Effect: Disease
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.00, 2.00, 2.00 } -- TODO: Capture fTP scalings
    params.element    = xi.element.DARK
    -- TODO: Confirm whether this is physical or magical move. Jimmayus sheet says Unaspected Physical. JP Wiki says Dark.
    -- TODO: Confirm AoE type. Jimmayus sheet says single target. JP Wiki says forward cone.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.DISEASE, 1, 0, 660)
    end

    return damage
end

return mobskillObject
