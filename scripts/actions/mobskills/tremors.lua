-----------------------------------
-- Tremors
-- Family: Worms
-- Description: Deals Earth damage with a seismic disturbance. Additional Effect: DEX Down
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1.50, 1.50, 1.50 }
    params.element    = xi.element.EARTH

    -- TODO: Dynamis - Nightmare Worm fTPs

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.DEX_DOWN, 10, 9, 180)
    end

    return damage
end

return mobskillObject
