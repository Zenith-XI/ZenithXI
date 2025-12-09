-----------------------------------
-- Soulshattering Roar
-- Family: Yztarg
-- Description: Deals (TODO: Physical/Magical?) damage to enemies in range of mob. Additional Effect: Terror
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 8.00, 8.00, 8.00 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK      -- TODO: Capture element if skill is a magicalMove
    -- TODO: Capture Skill range and AoE Radius

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params) -- TODO: Is move magical or physical? Need captures
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        xi.mobskills.mobPhysicalStatusEffectMove(mob, target, skill, xi.effect.TERROR, 1, 0, 30) -- TODO: Capture duration
    end

    -- TODO: Temporary immunity to a single weapon damage type
    -- Note: This should probably be handled in a mixin or within the mob script.

    return damage
end

return mobskillObject
