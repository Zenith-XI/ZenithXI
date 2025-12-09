-----------------------------------
-- Scouring Bubbles
-- Family: Mihli Aliapoh
-- Description: Deals damage in an Area of Effect.
-- Notes: Used by Mihli Aliapoh (Trust)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 12.25, 12.25, 12.25 } -- TODO: Capture fTPs
    params.element    = xi.element.WATER

    -- TODO: This is likely a physical move. JPWiki mentions there have been cases of it missing.
    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)
    end

    return damage
end

return mobskillObject
