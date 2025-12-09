-----------------------------------
-- Penumbral Impact
-- Family: Djinn
-- Description: Deals Dark damage to a single target. Deals more damage at night.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.0, 3.0, 3.0 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK

    local timeOfDay = VanadielTOTD()

    if
        -- 20:00 to 4:00
        timeOfDay == xi.time.NIGHT or
        timeOfDay == xi.time.MIDNIGHT
    then
        params.fTP = { 4.5, 4.5, 4.5 } -- TODO: Capture fTPs. JP Wiki says damage increase is about 50%.
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)
    end

    return damage
end

return mobskillObject
