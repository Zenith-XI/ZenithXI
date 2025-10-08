-----------------------------------
-- Bai Wing
-- Family: Wyrm (Earth)
-- Description: A dust storm deals Earth damage to enemies within a very wide area of effect. Additional Effect: Slow
-- Notes: Used only by Ouryu and Cuelebre while flying.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:getAnimationSub() ~= 1 then -- Not used while flying
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = mob:getMainLvl() + 2
    params.fTP          = { 4, 4, 4 }
    params.element      = xi.element.EARTH

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLOW, 9000, 0, 120)
    end

    return damage
end

return mobskillObject
