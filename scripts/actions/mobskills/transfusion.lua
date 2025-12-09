-----------------------------------
--  Transfusion
--  Description: Steals HP from players within range.
--  Type: Magical
--  Utsusemi/Blink absorb: Ignores shadows
--  Range: Unknown radial
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
        local params = {}

    params.baseDamage         = mob:getMainLvl() + 2
    params.fTP                = { 3.00, 3.00, 3.00 } -- TODO: Capture fTPs
    params.element            = xi.element.DARK

    -- From captures, this HP Drains don't seem to be affected by these.
    params.skipResist         = true
    params.skipMagicBonusDiff = true

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, damage))
    end

    return damage
end

return mobskillObject
