-----------------------------------
-- Nocturnal Combustion
-- Family: Bombs (Djinn)
-- Description: Self-destructs, dealing Dark damage to targets around mob.
-- Notes:
-- * Damage is based on remaining HP and time of day (more damaging near midnight).
-- * The djinn will not use this until it has been affected by the current day's element.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
     -- TODO: Not unlocked for use unless mob is hit with elemental damage that matches day of week.
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

     -- TODO: Time of day scaling
    params.baseDamage   = skill:getMobHP() / 3
    params.fTP          = { 1, 1, 1 }
    params.element      = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)
    end

    return damage
end

mobskillObject.onMobSkillFinalize = function(mob, skill)
    mob:setHP(0)
end

return mobskillObject
