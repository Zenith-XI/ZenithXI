-----------------------------------
-- Black Cloud
-- Family: Skeletons
-- Description: A cloud deals Dark damage to enemies in an area of effect. Additional Effect: Blind
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage   = mob:getMainLvl() + 2
    params.fTP          = { 1.5, 1.5, 1.5 }
    params.element      = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

        -- TODO: Determine duration type(Random, Scaling based on TP, etc.)
        -- https://docs.google.com/spreadsheets/d/1YBoveP-weMdidrirY-vPDzHyxbEI2ryECINlfCnFkLI/edit?pli=1&gid=57955395#gid=57955395&range=A683
        local duration = xi.mobskills.calculateDuration(skill:getTP(), 300, 420)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BLINDNESS, 20, 0, duration)
    end

    return damage
end

return mobskillObject
