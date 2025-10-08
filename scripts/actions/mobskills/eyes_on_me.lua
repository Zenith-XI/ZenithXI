-----------------------------------
-- Eyes on Me
-- Family: Ahriman
-- Description: Deals Dark damage to an enemy. Not affected by % Magic Damage Taken/Shell.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 5, 5, 5 }
    params.element    = xi.element.DARK
    params.skipTMDA   = true
    -- TODO: JP Wiki states damage might scale based on distance between mob/target. Need a capture to check.

    if mob:isNM() then
        params.fTP = { 7, 7, 7 }
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)
    end

    return damage
end

return mobskillObject
