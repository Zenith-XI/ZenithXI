-----------------------------------
-- Abyssal Drain
-- Family: Humanoid (Zeid)
-- Description: Deals Dark damage to a single target. Additional Effect: Drain
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 1
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.00, 2.00, 2.00 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK
    -- TODO: Capture shadow behavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, damage, xi.attackType.MAGICAL, xi.damageType.DARK))
    end

    return damage
end

return mobskillObject
