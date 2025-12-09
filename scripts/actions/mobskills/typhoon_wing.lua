-----------------------------------
-- Typhoon Wing
-- Family: Wyrms
-- Description: Deals Wind? damage to enemies within a very wide area of effect. Additional Effect: Blind
-- Notes: Used by Ouryu and Dragua. The blinding effect does not last long
--        but is very harsh. The attack is wide enough to generally hit an entire alliance.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if target:isBehind(mob, 48) then
        return 1
    elseif mob:getAnimationSub() ~= 0 then -- Do not use while flying
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.50, 5.00, 5.50 }
    params.element    = xi.element.WIND -- TODO: Capture element

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 60, 0, 30) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
