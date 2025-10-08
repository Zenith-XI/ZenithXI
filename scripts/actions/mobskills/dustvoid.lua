-----------------------------------
-- Dustvoid
-- Family: Sandworms
-- Description: Deals Wind damage to targets. Removes all equipment from targets. Additional Effect: Knockback
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 0.5, 0.5, 0.5 }
    params.element         = xi.element.WIND
    params.dStatMultiplier = 1
    -- TODO: Capture knockback

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)

        -- TODO: Wikis state this removes equipment. Need captures
        -- If it does remove equipment, does it undress before or after taking damage?

        if target:isPC() then
            for i = xi.slot.MAIN, xi.slot.BACK do
                target:unequipItem(i)
            end
        end
    end

    return damage
end

return mobskillObject
