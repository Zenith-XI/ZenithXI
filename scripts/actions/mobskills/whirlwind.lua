-----------------------------------
-- Whirlwind
-- Family: Sea Monks
-- Description: Deals Wind damage to enemies within range. Additional Effect: VIT Down
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.00, 2.50, 3.00 }
    params.element    = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.VIT_DOWN, 10, 9, 120) -- TODO: Capture duration
    end

    return damage
end

return mobskillObject
