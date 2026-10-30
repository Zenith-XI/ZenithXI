local m = Module:new('c-j_avatarsFavorPerpetuation')

-----------------------------------
-- Avatar's Favor perpetuation cost (ZENITHDEV-207, ZXIALPHA-128)
-- Base's Avatar's Favor never changes the avatar's perpetuation cost. Over the years it has:
--   original (WotG)  -2 perpetuation (base already applies the avatar penalty when ENABLE_SOA is 0)
--   October 2014     +3 perpetuation, +2 for Carbuncle
--   later            +25% of the perpetuation cost
-- Zenith uses October 2014. Pick another with the `version` setting below.
-- Base C++ also multiplies the drain by 1.2 under Favor; git patch 121 removes that.
--
-- applyPerpetuationCost adds the change while the caster has Avatar's Favor, and the cost is
-- recalculated when Favor is gained or lost (base only recalculates it with the pet's stats).
-- It checks the caster, not pet:getMaster(): on summon the cost is set before the pet has a master.
-----------------------------------

local versions =
{
    original = function(petId, cost)
        return cost - 2
    end,

    october2014 = function(petId, cost)
        if petId == xi.petId.CARBUNCLE then
            return cost + 2
        end

        return cost + 3
    end,

    modern = function(petId, cost)
        return cost + math.floor(cost * 0.25)
    end,
}

local version = versions.october2014

-- Same avatars Favor works with (scripts/globals/avatars_favor.lua)
local isFavorAvatar = function(petId)
    return (petId >= xi.petId.CARBUNCLE and petId <= xi.petId.DIABOLOS) or
        petId == xi.petId.CAIT_SITH or
        petId == xi.petId.SIREN
end

-- Summoners whose Favor is wearing off, by id: the effect is still on them during onEffectLose
local favorWearingOff = {}

m:addOverride('xi.job_utils.summoner.applyPerpetuationCost', function(caster, pet)
    super(caster, pet)

    if
        pet and
        not favorWearingOff[caster:getID()] and
        caster:hasStatusEffect(xi.effect.AVATARS_FAVOR) and
        isFavorAvatar(pet:getPetID())
    then
        local cost = xi.job_utils.summoner.getPerpetuationCost(pet)

        caster:setMod(xi.mod.AVATAR_PERPETUATION, math.max(0, version(pet:getPetID(), cost)))
    end
end)

local refreshPerpetuation = function(target)
    local pet = target:getPet()
    if pet then
        xi.job_utils.summoner.applyPerpetuationCost(target, pet)
    end
end

m:addOverride('xi.effects.avatars_favor.onEffectGain', function(target, effect)
    super(target, effect)

    refreshPerpetuation(target)
end)

m:addOverride('xi.effects.avatars_favor.onEffectLose', function(target, effect)
    super(target, effect)

    -- Only this summoner, and cleared even if the recalculation errors
    local id = target:getID()

    favorWearingOff[id] = true
    local ok, err = pcall(refreshPerpetuation, target)
    favorWearingOff[id] = nil

    if not ok then
        print(string.format('[avatars_favor_perpetuation] Error: %s', tostring(err)))
    end
end)

return m
