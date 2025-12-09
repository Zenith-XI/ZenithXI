-----------------------------------
-- Putrid Breath
-- Description: Deals Dark damage to enemies.
-- Notes: Deals Breath damage and follows corresponding damage reductions but damage is not based on HP.
-- Notes: Only used by Cirrate Christelle.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getWeaponDmg() -- TODO: Currently balanced around weapon damage.
    params.fTP        = { 8, 8, 8 }
    params.element    = xi.element.DARK
    params.useTBDA    = true

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.BREATH, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.DARK)

        if skill:getID() == xi.mobSkill.PUTRID_BREATH_1 then
            skill:setMsg(xi.msg.basic.DAMAGE)
        elseif skill:getID() == xi.mobSkill.PUTRID_BREATH_2 then
            skill:setMsg(xi.msg.basic.HIT_DMG)
        end
    end

    return damage
end

return mobskillObject
