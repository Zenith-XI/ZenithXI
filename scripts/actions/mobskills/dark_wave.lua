-----------------------------------
-- Dark Wave
-- Family: Bombs (Dijin)
-- Description: Deals Dark damage to targets in range. Additional Effect: Bio
-- Notes: Severity of Bio effect varies by time of day, from 8/tic at midday to 20/tic at midnight.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 5, 5, 5 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        local hour  = VanadielHour()
        local power = 8

         -- TODO: Need to capture value for Bio effect's ATTP reduction.
         -- Does it scale with time of day as well or is it static?
        local attPercReduction = 10 -- Set to Bio I value for now.

        if hour > 12 then
            power = 8 + hour - 11
        end

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIO, power, 3, 60, 0, attPercReduction) -- TODO: Capture power/duration
    end

    return damage
end

return mobskillObject
