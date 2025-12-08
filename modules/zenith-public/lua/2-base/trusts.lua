-- -----------------------------------
-- Trusts Module
--
-- This module overrides the max number of trusts a player can summon
-- and implements a cooldown system for summoning trusts.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('trusts')

local trustLimitVar = '[TRUST]Additional'
local trust1CooldownVar = '[TRUST]Cooldown1'
local trust2CooldownVar = '[TRUST]Cooldown2'
local trustCooldownTime = (60 * 15) -- 15 minutes

-- Gets the cooldown time remaining for the next available trust.
-- If both trusts are on cooldown, it returns the shorter of the two.
local function getNextAvailableTrustTime(caster)
    local now = GetSystemTime()
    local cooldown = 0
    local t1Cooldown = caster:getCharVar(trust1CooldownVar)
    local t2Cooldown = caster:getCharVar(trust2CooldownVar)

    if
        t1Cooldown > now and
        t2Cooldown > now
    then
        cooldown = math.min(t1Cooldown, t2Cooldown) - now
    end

    if cooldown <= 0 then
        return nil
    end

    local mins = math.floor(cooldown / 60)
    local secs = cooldown % 60

    -- always show seconds as two digits to avoid 1:9 and instead display 1:09
    local secsStr = string.format('%02d', secs)

    return fmt('{}:{} remaining until you can summon another trust.', mins, secsStr)
end

m:addOverride('xi.trust.canCast', function(caster, spell, notAllowedTrustIds)
    local result = super(caster, spell, notAllowedTrustIds)

    if result ~= 0 then
        return result
    end

    local limit = 1
    local trustAvailable = getNextAvailableTrustTime(caster)

    -- Check if player has the trust limit variable set.
    if
        caster:getCharVar(trustLimitVar) ~= 0 and
        caster:getMainLvl() >= 50
    then
        limit = 2
    end

    -- Check if player has summoned 2 trusts already.
    local trusts = 0
    for _, member in pairs(caster:getPartyWithTrusts()) do
        if member:getObjType() == xi.objType.TRUST then
            trusts = trusts + 1
        end
    end

    if trusts >= limit then
        caster:messageSystem(xi.msg.system.TRUST_MAXIMUM_NUMBER)
        return -1
    end

    -- Check if player has both trusts variables on cooldown.
    if trustAvailable ~= nil then
        caster:printToPlayer(trustAvailable, xi.msg.channel.SYSTEM_3)
        return -1
    end

    return 0
end)

m:addOverride('xi.trust.spawn', function(caster, spell)
    super(caster, spell)
    local now = GetSystemTime()
    local trustCdTimeStamp = now + trustCooldownTime

    -- When a player summons a trust, check if it's the first one they have summoned.
    -- If it is, create a variable to set a 15 minute cooldown for the first trust.
    if
        caster:getCharVar(trust1CooldownVar) <= now
    then
        caster:setCharVar(trust1CooldownVar, trustCdTimeStamp, trustCdTimeStamp)
    -- If it's not the first trust, set a 15 minute cooldown for the second trust.
    else
        caster:setCharVar(trust2CooldownVar, trustCdTimeStamp, trustCdTimeStamp)
    end
end)

m:addOverride('npcUtil.completeQuest', function(player, area, quest, params)
    local result = super(player, area, quest, params)

    if
        result and
        area == xi.questLog.JEUNO and
        quest == xi.quest.id.jeuno.IN_DEFIANT_CHALLENGE
    then
        -- When a player completes LB1, set the additional variable to 1
        -- to allow them to summon two trusts at once.
        player:setCharVar(trustLimitVar, 1)
        player:printToPlayer('You may now call forth an additional alter ego at level 50.', xi.msg.channel.SYSTEM_3)
    end

    return result
end)

return m
