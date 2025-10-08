-----------------------------------
-- Crispy Candle (Self)
-- Family: Moblin
-- Description: Crispy Candle backfires, dealing Fire damage to mob.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage         = mob:getMainLvl() + 2
    params.fTP                = { 3.5, 3.5, 3.5 }
    params.element            = xi.element.FIRE
    params.dStatMultiplier    = 1
    params.resistTierOverride = 0.25 -- 1/4 Resist
    -- Jimmayus spreadsheet stats Crispy Candle backfire is a 1/4 resist.
    -- https://docs.google.com/spreadsheets/d/1YBoveP-weMdidrirY-vPDzHyxbEI2ryECINlfCnFkLI/edit?pli=1&gid=57955395#gid=57955395&range=A1102

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.FIRE)
    end

    return damage
end

return mobskillObject
