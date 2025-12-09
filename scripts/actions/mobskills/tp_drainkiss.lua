-----------------------------------
-- TP Drainkiss
-- Family: Leech
-- Description: Steals a targets TP. TP stolen varies with TP.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = target:getTP()
    params.fTP        = { 0.500, 0.666, 0.833 }
    params.element    = xi.element.DARK

    -- From captures, this TP Drains don't seem to be affected by these.
    params.skipTMDA           = true
    params.skipResist         = true
    params.skipDayWeather     = true
    params.skipMagicBonusDiff = true
    -- TODO: This skill should penetrate/deal no damage to stoneskin.
    --       Need to pass a param into mobFinalAdjustments in the future.

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_1, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.TP, damage))
    end

    return damage
end

return mobskillObject
