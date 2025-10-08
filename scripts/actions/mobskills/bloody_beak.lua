-----------------------------------
--  Bloody Beak
--    Mob Ability: 2428
--  Description: Steals HP from targets within a fan-shaped area.
--  Type: Magical
--  Utsusemi/Blink absorb: Ignores Utsusemi
--  Range: 5'
--  TODO: Umeboshi: "This seems to be a physical skill, will fix it in the pass on mobPhysicalMove()"
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 3, 3, 3 }
    params.element         = xi.element.WIND
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, damage))
    end

    return damage
end

return mobskillObject
