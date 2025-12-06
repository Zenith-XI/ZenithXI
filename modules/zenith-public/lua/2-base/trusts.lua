-- -----------------------------------
-- Trusts Module
--
-- This module overrides the max number of trusts a player can summon
-- and implements a cooldown system for summoning trusts.
--
-- [ZENITH MOD] Also removes the LFP restriction to allow trusts while
-- seeking a party, and allows setting LFP while trusts are deployed.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('b_trusts')

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

-- [ZENITH MOD] Temporarily disable LFP during trust casting, then re-enable
-- This avoids duplicating all base casting restrictions and reduces maintenance burden
local lfpRestoreDelay = 10 -- seconds

m:addOverride('xi.trust.canCast', function(caster, spell, notAllowedTrustIds)
    -- Check if both trust cooldowns are active
    local cooldownMsg = getNextAvailableTrustTime(caster)
    if cooldownMsg then
        caster:printToPlayer(cooldownMsg, xi.msg.channel.SYSTEM_3)
        return xi.msg.basic.TRUST_NO_CAST_TRUST
    end

    local wasSeekingParty = caster:isSeekingParty()

    -- Temporarily disable LFP so base check passes
    if wasSeekingParty then
        caster:setSeekingParty(false)
    end

    -- Call the original canCast with all its checks
    local result = super(caster, spell, notAllowedTrustIds)

    -- If casting will succeed and player was LFP, schedule re-enable
    if result == 0 and wasSeekingParty then
        caster:timer(lfpRestoreDelay * 1000, function(player)
            if player and player:isAlive() then
                player:setSeekingParty(true)
            end
        end)
    elseif wasSeekingParty then
        -- Casting failed, immediately restore LFP
        caster:setSeekingParty(true)
    end

    return result
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
