-----------------------------------
-- Stormwind
-- Family: Rocs
-- Description: Creates a whirlwind that deals Wind damage to targets in an area of effect.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 3.00, 3.00, 3.00 }
    params.element    = xi.element.WIND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)

    if mob:getPool() == xi.mobPools.KREUTZET then
        local stormwindDamage = mob:getLocalVar('stormwindDamage') -- TODO: Maybe change name of localVar to stormwindCounter for clarity.

        if stormwindDamage == 2 then
            params.fTP = { 3.25, 3.25, 3.25 }
        elseif stormwindDamage == 3 then
            params.fTP = { 3.60, 3.60, 3.60 }
        end
    end

    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO: Nightmare Rocs apply Silence.
    end

    return damage
end

return mobskillObject
