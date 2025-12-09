-----------------------------------
-- Nosferatu's Kiss
-- Family: Vampyr
-- Deals Dark damage to all targets in an area around the user. Additional effect: HP, MP and TP drain.
-- Note: Foe level * 0.5~1 for HP/TP. MP unknown.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.baseDamage = mob:getMainLvl()
    params.fTP        = { 1.00, 1.00, 1.00 }
    params.element    = xi.element.DARK

    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info.damage, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, info.hitsLanded)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then

        -- Capture shows the following effects on a level 99 player from a level 85 mob:
        -- 108 HP drained
        -- 60 TP drained
        -- 25 MP drained

        local drainedHP = math.random(damage / 2, damage)
        local drainedMP = math.random(damage / 3, damage / 2)
        local drainedTP = math.random(damage / 2, damage)

        -- TODO: Capture power for effects. Current numbers roughly based off video capture.
        xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.HP, drainedHP)
        xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.MP, drainedMP)
        xi.mobskills.mobDrainMove(mob, target, xi.mobskills.drainType.TP, drainedTP)

        skill:setMsg(xi.msg.basic.SKILL_DRAIN_HP)
    end

    return damage
end

return mobskillObject
