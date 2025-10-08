-----------------------------------
-- Firespit
-- Family: Mamool Ja
-- Description: Deals Fire damage to an enemy.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() * math.random(2, 3)
    params.fTP             = { 4, 4, 4 }
    params.element         = xi.element.FIRE
    params.dStatMultiplier = 1

    -- There are two versions of this skill (SkillIDs 1733 and 1923). 1733 is used by Brown Mamool Ja and 1923 is used by Blue Mamool Ja(Usually mage types).
    -- Blue types ignore shadows and deal fire damage. Brown types consume shadows.

    -- TODO: Capture AOE type for both skill IDs(Conal AOE, AOE near target, Single Target, etc)

    local shadowBehavior = xi.mobskills.shadowBehavior.NUMSHADOWS_3

    -- Blue Mamool Ja ignore shadows.
    if skill:getID() == xi.mobSkill.FIRESPIT_BLUE_MAMOOLJA then
        shadowBehavior = xi.mobskills.shadowBehavior.IGNORE_SHADOWS
    end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, shadowBehavior, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    return damage
end

return mobskillObject
