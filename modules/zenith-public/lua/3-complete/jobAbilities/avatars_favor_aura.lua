local m = Module:new('c-j_avatarsFavorAura')

-----------------------------------
-- Avatar's Favor aura keeps ticking (ZXIALPHA-128, ZXIALPHA-129)
-- LSB re-adds the avatar's Favor aura on every Avatar's Favor tick, which restarts the aura's 3 s tick. The engine
-- runs effect ticks on a zone-wide clock whose checks land 2.8 s and 3.2 s apart (a 3 s grid, 0.4 s zone ticks).
-- After a 2.8 s gap the new aura is not 3 s old yet, so its first tick slips to about 6 s, and the 4 s copy it
-- gives party members (Ifrit's Favor and the rest) wears off for about 2 s: the icon blinks and the bonus drops.
--
-- While the avatar already carries the aura at the same Favor power, keep it and give it the 15 s a fresh aura
-- would have. When the power changes, LSB re-adds it with the new strength.
--
-- A fresh aura can still miss a check the same way (ZXIALPHA-129): its first tick waits for a full tick interval,
-- and re-using Favor while it is up replaces the aura while party members still carry its copy. So a fresh aura is
-- backdated by 3 s and given a 1 s tick. Effects only tick on the 3 s grid, so it ticks on the very next check and
-- on every check after that, refreshing the 4 s copy every 2.8 to 3.2 s.
-----------------------------------

local auraDuration = 15000 -- ms, as LSB's applyAvatarsFavorAuraToPet adds it
local auraTick     = 1000  -- ms, below the effect check spacing so no check is skipped
local auraBackdate = 3     -- s, at least one aura tick so the next check ticks at once
local powerVar     = '[avatarsFavorAura]power'

-- getStatusEffects also lists an aura removed earlier this tick (re-using Favor removes the old Favor and its aura
-- before the new Favor is gained). getStatusEffect skips removed effects, so it returns only a live aura.
local getAura = function(pet)
    for _, effect in ipairs(pet:getStatusEffects()) do
        if effect:hasEffectFlag(xi.effectFlag.AURA) then
            local live = pet:getStatusEffect(effect:getEffectType())

            if live then
                return live
            end
        end
    end

    return nil
end

-- Leaves the aura auraDuration ms to run from now
local extendAura = function(aura)
    aura:setDuration(aura:getDuration() - aura:getTimeRemaining() + auraDuration)
end

m:addOverride('xi.avatarsFavor.applyAvatarsFavorAuraToPet', function(target, effect)
    local pet  = target:getPet()
    local aura = pet and getAura(pet)

    if aura and pet:getLocalVar(powerVar) == effect:getPower() then
        extendAura(aura)

        return
    end

    super(target, effect)

    if pet then
        aura = getAura(pet)

        if aura then
            aura:setTick(auraTick)
            aura:setStartTime(aura:getStartTime() - auraBackdate)
            extendAura(aura)
        end

        pet:setLocalVar(powerVar, effect:getPower())
    end
end)

return m
