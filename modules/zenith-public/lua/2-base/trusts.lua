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

-- True once the player has completed LB1 (IN_DEFIANT_CHALLENGE), which unlocks
-- the second trust slot and the Cooldown2 charvar.
local function hasAdditionalTrustUnlock(player)
    return player:getCharVar(trustLimitVar) >= 1
end

-- Gets the cooldown time remaining for the next available trust.
-- Players without LB1 only use Cooldown1, so Cooldown1 alone blocks casting.
-- Players with LB1 use both slots; cast is blocked only when both are active.
local function getNextAvailableTrustTime(caster)
    local now = GetSystemTime()
    local cooldown = 0
    local t1Cooldown = caster:getCharVar(trust1CooldownVar)
    local t2Cooldown = caster:getCharVar(trust2CooldownVar)

    if hasAdditionalTrustUnlock(caster) then
        if
            t1Cooldown > now and
            t2Cooldown > now
        then
            cooldown = math.min(t1Cooldown, t2Cooldown) - now
        end
    elseif t1Cooldown > now then
        cooldown = t1Cooldown - now
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

    -- Enforce custom trust count cap:
    --   default: 1 trust
    --   after LB1 (IN_DEFIANT_CHALLENGE) and level 50+: 2 trusts
    -- ROV key items still gate higher counts via the base canCast.
    local numTrusts = 0
    for _, member in pairs(caster:getPartyWithTrusts()) do
        if member:getObjType() == xi.objType.TRUST then
            numTrusts = numTrusts + 1
        end
    end

    local maxTrusts = 1
    if
        caster:getMainLvl() >= 50 and
        hasAdditionalTrustUnlock(caster)
    then
        maxTrusts = 2
    end

    if numTrusts >= maxTrusts then
        caster:messageSystem(xi.msg.system.TRUST_MAXIMUM_NUMBER)
        return -1
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

    -- Cooldown1 is the primary slot for everyone. Cooldown2 is only enabled
    -- once the player has completed LB1 (IN_DEFIANT_CHALLENGE) — without that
    -- unlock, the second slot is never written, so re-summoning after dismissal
    -- still has to wait on Cooldown1.
    if caster:getCharVar(trust1CooldownVar) <= now then
        caster:setCharVar(trust1CooldownVar, trustCdTimeStamp, trustCdTimeStamp)
    elseif hasAdditionalTrustUnlock(caster) then
        caster:setCharVar(trust2CooldownVar, trustCdTimeStamp, trustCdTimeStamp)
    end
end)

m:addOverride('npcUtil.completeQuest', function(player, area, quest, params)
    -- Capture state before super(): the base npcUtil.completeQuest returns true
    -- on every call (even re-completion), so we can't use the result to detect a
    -- first-time completion. Snapshot the unlock var beforehand instead.
    local alreadyUnlocked = hasAdditionalTrustUnlock(player)
    local result = super(player, area, quest, params)

    if
        result and
        not alreadyUnlocked and
        area == xi.questLog.JEUNO and
        quest == xi.quest.id.jeuno.IN_DEFIANT_CHALLENGE
    then
        -- First-time LB1 completion: unlock the second trust slot and notify.
        player:setCharVar(trustLimitVar, 1)
        player:printToPlayer('You may now call forth an additional alter ego at level 50.', xi.msg.channel.SYSTEM_3)
    end

    return result
end)

return m
