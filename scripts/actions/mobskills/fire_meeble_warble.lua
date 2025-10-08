-----------------------------------
-- Fire Meeble Warble
-- Family: Meebles
-- Description: AoE Fire Elemental damage, inflicts Plague (50 MP/tick, 300 TP/tick) and Burn (50 HP/tick).
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 9, 9, 9 } -- TODO: Capture fTP
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        -- TODO: Capture power/duration
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.PLAGUE, 30, 3, 60)
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, 50, 3, 60)
    end

    return damage
end

return mobskillObject
