-----------------------------------
-- Diffusion Ray
-- Family: Chariot
-- Description: Deals Light damage to enemies within a fan-shaped area originating from the caster.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill, action)
    local params = {}

    params.baseDamage       = mob:getMainLvl() + 2
    params.fTP              = { 5, 5, 5 }
    params.element          = xi.element.LIGHT
    params.dStatMultiplier  = 1.5

    -- TODO: Pulled from JP Wiki. Need captures to confirm.
    params.dStatAttackerMod = xi.mod.MND
    params.dStatDefenderMod = xi.mod.MND

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.LIGHT)
    end

    return info.damage
end

return mobskillObject
