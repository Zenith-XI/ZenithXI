-----------------------------------
-- Vulcan Shot
-- Family: Fomor
-- Description: Fires an explosive bullet at targets in an area of effect.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    mob:messageBasic(xi.msg.basic.READIES_WS, 0, 254)

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 32.00, 32.00, 32.00 } -- TODO: Capture fTPs (Original code was Weapon Damage * 4 * 8)
    params.element    = xi.element.FIRE
    -- TODO: Verify if magical or physical skill
    -- TODO: Capture shadowBehavior
    -- TODO: Capture AoE Type or Single hit.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    return damage
end

return mobskillObject
