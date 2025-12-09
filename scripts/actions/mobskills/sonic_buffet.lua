-----------------------------------
-- Sonic Buffet
-- Family: Avatar (Siren)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 2.50, 2.50, 2.50 } -- TODO: Capture fTPs
    params.element    = xi.element.WIND
    -- TODO: Capture shadowBehavior

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        for i = 1, math.random(2, 3) do
            target:dispelStatusEffect(xi.effectFlag.DISPELABLE)
        end
    end

    return damage
end

return mobskillObject
