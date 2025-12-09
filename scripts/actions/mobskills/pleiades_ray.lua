-----------------------------------
-- Pleiades Ray
-- Family: Trolls
-- Description: Fires a magical ray at nearby targets. Additional Effects: Paralysis + Blind + Poison + Plague + Bind + Silence + Slow
-- Notes: Only used by Gurfurlur the Menacing with health below 20%.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    local mobhp = mob:getHPP()

    if mobhp <= 20 then
        return 0
    else
        return 1
    end
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 7.0, 7.0, 7.0 } -- TODO: Capture fTPs
    params.element    = xi.element.FIRE   -- TODO: Capture element

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE, { breakBind = false })

        -- TODO: Capture power/durations of status effects.
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PARALYSIS, 40, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 40, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 10, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 5, 3, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BIND, 1, 0, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SILENCE, 1, 0, 120)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.SLOW, 1250, 0, 120)
    end

    return damage
end

return mobskillObject
