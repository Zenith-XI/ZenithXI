-----------------------------------
-- Vitriolic Spray
-- Family: Wamouracampa
-- Description: Conal AoE Fire damage in front of mob. Additional Effect: Burn
-- Note: Used while in Open form. (Handled via skill list in family mixin)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage      = mob:getMainLvl() + 2
    params.fTP             = { 4.50, 4.50, 4.50 }
    params.element         = xi.element.FIRE
    params.dStatMultiplier = 1

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.WIPE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)

        -- TODO: Is power random? Based off level? Different individuals? Need captures
        -- Sources say Burn is 10-30/tic but don't go into depth.
        -- Personal captures showed 10/tick from Wamoura Prince(Mount Zhayolm). https://youtu.be/2H350wLAlFo?t=228
        xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.BURN, 10, 3, 60)
    end

    return damage
end

return mobskillObject
