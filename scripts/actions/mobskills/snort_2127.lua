-----------------------------------
-- Snort
-- Family: Buffalo
-- Description: Deals Wind damage to targets in a fan-shaped area of effect. Additional effect: Knockback
-- Note: Shows as a regular attack and lowers enmity
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4.0, 4.0, 4.0 }
    params.element    = xi.element.WIND
    -- params.dStatMultiplier = 1 TODO: Possible dINT multiplier, need more captures.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        skill:setMsg(xi.msg.basic.HIT_DMG)
        mob:lowerEnmity(target, 25)
    end

    return damage
end

return mobskillObject
