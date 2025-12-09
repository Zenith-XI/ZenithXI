-----------------------------------
-- Promyvion Brume
-- Family: Cravers
-- Description: Deals AoE Elemental damage. Additional Effect: Poison
-- Notes: Element varies based on Empty mob's core element.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

-- Element table based on Craver model IDs and animation subs
local elementTable =
{
    [1134] =
    {
        [14] = { element = xi.element.WATER, damageType = xi.damageType.WATER },
        [13] = { element = xi.element.DARK, damageType = xi.damageType.DARK },
    },
    [1135] =
    {
        [14] = { element = xi.element.EARTH, damageType = xi.damageType.EARTH },
        [13] = { element = xi.element.THUNDER, damageType = xi.damageType.THUNDER },
    },
    [1137] =
    {
        [14] = { element = xi.element.FIRE, damageType = xi.damageType.FIRE },
        [13] = { element = xi.element.LIGHT, damageType = xi.damageType.LIGHT },
    },
    [1138] =
    {
        [13] = { element = xi.element.ICE, damageType = xi.damageType.ICE },
        [14] = { element = xi.element.WIND, damageType = xi.damageType.WIND },
    },
}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3, 3, 3 }
    params.element    = xi.element.NONE

    -- Determine element based on model ID and animation sub
    local modelId      = mob:getModelId()
    local animationSub = mob:getAnimationSub()
    local damageType   = xi.damageType.ELEMENTAL

    if elementTable[modelId] and elementTable[modelId][animationSub] then
        params.element = elementTable[modelId][animationSub].element
        damageType     = elementTable[modelId][animationSub].damageType
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, damageType, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, damageType)

        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.POISON, 9, 3, 180)
    end

    return damage
end

return mobskillObject
