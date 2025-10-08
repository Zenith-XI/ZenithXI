-----------------------------------
-- Cosmic Elucidation
-- Family: Tenzen
-- Description: Cosmic Elucidation inflicts heavy AOE damage to everyone in the battle.
-- Notes: Ejects all combatants from the battlefield, resulting in a failure.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 1 -- Only scripted use
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg()
    params.fTP        = { 21, 21, 21 } -- TODO: Capture fTPs
    params.element    = xi.element.LIGHT

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)
    damage = math.max(0, damage) -- Cosmic Elucidation does not have an absorb message.

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.SPECIAL, xi.damageType.ELEMENTAL)

        skill:setMsg(xi.msg.basic.SKILLCHAIN_COSMIC_ELUCIDATION)
    end

    return damage
end

return mobskillObject
