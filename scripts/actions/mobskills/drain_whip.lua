-----------------------------------
-- Drain Whip
-- Family: Morbols
-- Description: Drains HP, MP, or TP from the target.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    -- TODO: Is this magical or physical? Need captures
    params.baseDamage = mob:getMainLvl() + 2
    params.fTP        = { 3.0, 3.0, 3.0 } -- TODO: Capture fTPs
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        local drainTable = { xi.mobskills.drainType.HP, xi.mobskills.drainType.MP, xi.mobskills.drainType.TP }

        skill:setMsg(xi.mobskills.mobDrainMove(mob, target, drainTable[math.random(1, 3)], damage))
    end

    return damage
end

return mobskillObject
