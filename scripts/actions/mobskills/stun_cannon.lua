-----------------------------------
-- Stun Cannon
-- Family: Omega
-- Description: Deals Thunder? damage to targets in front of mob. Additional Effect: Paralysis
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if not target:isBehind(mob) then
        return 0
    end

    return 1
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.50, 4.50, 4.50 } -- TODO: Capture fTPs
    params.element    = xi.element.THUNDER
    -- TODO: Capture AoE type

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params) -- TODO: Capture if Magical or Physical
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PARALYSIS, 20, 0, 120) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
