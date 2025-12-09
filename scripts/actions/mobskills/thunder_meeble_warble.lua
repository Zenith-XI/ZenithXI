-----------------------------------
-- Thunder Meeble Warble
-- Family: Meebles
-- Description: AOE Lightning Elemental damage, inflicts Stun and Shock (50 HP/tick).
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 18.00, 18.00, 18.00 } -- TODO: Capture fTPs
    params.element    = xi.element.THUNDER
    -- TODO: Capture shadowBehavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

        -- TODO: Capture effect power/duration
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SHOCK, 50, 3, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STUN, 30, 0, 15)
    end

    return damage
end

return mobskillObject
