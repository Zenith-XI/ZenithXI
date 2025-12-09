-----------------------------------
-- Proboscis
-- Family: Wamoura
-- Description: Drains MP from and dispels one beneficial status effect from targets in front.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: This is likely a physical skill with a drain attatched as its subject to PDIF. Return to this in mobPhysicalMove() PR.
    -- TODO: Drain can be resisted. Need more data on if the drain is affected by anything other than Dark resists.

    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 1, 1, 1 }
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobPhysicalDrainMove(mob, target, skill, xi.mobskills.drainType.MP, damage))

        target:dispelStatusEffect()
    end

    return damage
end

return mobskillObject
