-----------------------------------
-- Nether Blast
-- Family: Avatar (Diabolos)
-- Description: Deals Dark breath damage to a target.
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: These values are pulled from JP Wiki: https://wiki.ffo.jp/html/4045.html
    -- Need retail captures as mob version may be different from summoned pets.

    params.baseDamage     = mob:getMainLvl()
    params.additiveDamage = { 10, 10, 10 }
    params.fTP            = { 5, 5, 5 }
    params.element        = xi.element.DARK
    params.useTBDA        = true -- Counts as breath damage
    -- params.mACCBonus      = { 0, 0, 0 } -- TODO: Stated to have very high accuracy but can be resisted by targets with high DARK_MEVA/DARK_RES_RANK.

    -- Diabolos Dynamis Tavnazia tosses nether blast for ~1k
    -- if skill:getID() == 1910 then
    --     params.fTP = { 10, 10, 10 }
    -- end

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.BREATH, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.DARK)
    end

    return damage
end

return mobskillObject
