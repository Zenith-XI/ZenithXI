-----------------------------------
-- Flame Blast Regular Attack
-- Family: Wyrms
-- Description: Deals single target Fire damage to target.
-- Notes: Used only by KS99 Wyrm in while flying as regular auto attack. Only use in a dedicated flying attack skill set.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.0, 3.0, 3.0 }
    params.element    = xi.element.FIRE

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        skill:setMsg(xi.msg.basic.HIT_DMG) -- TODO: Move logic to mob final adjustments eventually.
    end

    return damage
end

return mobskillObject
