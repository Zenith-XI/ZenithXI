local m = Module:new('c-j_avatarsFavorAura')

-----------------------------------
-- Avatar's Favor aura keeps ticking (ZXIALPHA-128)
-- LSB re-adds the avatar's Favor aura on every Avatar's Favor tick, which restarts the aura's 3 s tick. The engine
-- runs effect ticks on a zone-wide clock whose checks land 2.8 s and 3.2 s apart (a 3 s grid, 0.4 s zone ticks).
-- After a 2.8 s gap the new aura is not 3 s old yet, so its first tick slips to about 6 s, and the 4 s copy it
-- gives party members (Ifrit's Favor and the rest) wears off for about 2 s: the icon blinks and the bonus drops.
--
-- While the avatar already carries the aura at the same Favor power, keep it and give it the 15 s a fresh aura
-- would have. When the power changes, LSB re-adds it with the new strength.
-----------------------------------

local auraDuration = 15000 -- ms, as LSB's applyAvatarsFavorAuraToPet adds it
local powerVar     = '[avatarsFavorAura]power'

local getAura = function(pet)
    for _, effect in ipairs(pet:getStatusEffects()) do
        if effect:hasEffectFlag(xi.effectFlag.AURA) then
            return effect
        end
    end

    return nil
end

m:addOverride('xi.avatarsFavor.applyAvatarsFavorAuraToPet', function(target, effect)
    local pet  = target:getPet()
    local aura = pet and getAura(pet)

    if aura and pet:getLocalVar(powerVar) == effect:getPower() then
        aura:setDuration(aura:getDuration() - aura:getTimeRemaining() + auraDuration)

        return
    end

    super(target, effect)

    if pet then
        pet:setLocalVar(powerVar, effect:getPower())
    end
end)

return m
