-----------------------------------
-- Pestilent Penance
-- Family: Promathia
-- Description: Conal AoE: Deals Dark damage to targets in range. Additional Effect: Plague
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3, 3, 3 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK
    -- TODO: Capture shadowBehavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_3, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 10, 0, 120) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
