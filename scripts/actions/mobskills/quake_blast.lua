-----------------------------------
-- Quake Blast
-- Family: Antlions
-- Description: Deals Earth damage to enemies within area of effect. Additional Effect: Unequip All Equipment
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 3.0, 3.0, 3.0 }
    params.element         = xi.element.EARTH
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.EARTH, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.EARTH)


        for i = xi.slot.MAIN, xi.slot.BACK do
            target:unequipItem(i)
        end
    end

    return damage
end

return mobskillObject
