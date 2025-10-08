-----------------------------------
-- Cyclone Wing
-- Family: Wyrm (Vrtra)
-- Description: Deals darkness damage to enemies within a very wide area of effect. Additional Effect: Sleep
-- Type: Magical
-- Utsusemi/Blink absorb: Wipes shadows
-- Range: 30' radial.
-- Notes: Used only by Vrtra and Azdaja
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if
        mob:getAnimationSub() == 1 or
        target:isBehind(mob, 48)
    then
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 4, 4, 4 }
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

    xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLEEP_I, 1, 0, 60)

    return damage
end

return mobskillObject
