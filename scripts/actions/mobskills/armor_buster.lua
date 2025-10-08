-----------------------------------
-- Armor Buster
-- Family: Ultima
-- Description: Deals Light damage to players in an area of effect. Additional Effect: Weight
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getLocalVar('citadelBuster') == 0 then
        return 0
    end

    return 1
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2 -- TODO: Capture fTP
    params.fTP        = { 7.5, 7.5, 7.5 }
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.WEIGHT, 20, 0, 45) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
