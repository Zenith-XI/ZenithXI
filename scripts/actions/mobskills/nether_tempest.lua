-----------------------------------
-- Nether Tempest
-- Family: Avatar (Diabolos)
-- Description:
-- Notes: Likely an AOE version of Nether Blast
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: Capture fTPs/baseDamage
    -- Using Nether Blast values for now.
    params.baseDamage     = mob:getMainLvl()
    params.additiveDamage = { 10, 10, 10 }
    params.fTP            = { 5, 5, 5 }
    params.element        = xi.element.DARK
    params.useTBDA        = true
    -- params.mACCBonus      = { 0, 0, 0 }

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.BREATH, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.DARK)
    end

    return damage
end

return mobskillObject
