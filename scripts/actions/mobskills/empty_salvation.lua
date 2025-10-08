-----------------------------------
-- Empty Salvation
-- Family: Promathia
-- Description: Damages all targets in range with the salvation of emptiness. Additional Effect: Dispels 3 effects
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2, 2, 2 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK
    -- TODO: Capture shadowBehavior
    -- TODO: There are two entries for this skill with different animations.
    -- Check to see if there are any differences between them.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_3, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

    -- Dispel 3 status effects
    for i = 1, 3 do
        if not target:dispelStatusEffect(xi.effectFlag.DISPELABLE) then
            break
        end
    end

    return damage
end

return mobskillObject
