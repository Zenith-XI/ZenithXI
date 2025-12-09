-----------------------------------
-- Stone Meeble Warble
-- Family: Meebles
-- Description: AOE Earth Elemental damage, inflicts Petrification and Rasp (50 HP/tick).
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 16.00, 16.00, 16.00 } -- TODO: Capture fTPs
    params.element    = xi.element.EARTH

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO: Capture power/durations
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PETRIFICATION, 30, 0, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.RASP, 50, 3, 60)
    end

    return damage
end

return mobskillObject
