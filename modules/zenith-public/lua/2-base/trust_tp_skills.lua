-----------------------------------
-- Trust TP skill eligibility (ZENITHDEV-200)
--
-- When a Trust is summoned, the engine asks xi.trust.canUseTpSkill(trust, skillId) for each skill in
-- its TP list and drops the ones that return false. The Trust's level does not change while it is out.
-- Requires git patch: 122-TrustLevelRestrictionsAndTesting.patch (the hook, and hasLearnedWeaponskill /
-- hasLearnedAbility answering for Trusts). Use in tandem with sql/add_weaponskills_trusts.sql.
-----------------------------------
require('modules/module_utils')

local m = Module:new('b_trust_tp_skills')

-- No Trust weaponskill or TP skill below this level
local minimumLevel = 5

-- Mob-skill copies of player weaponskills follow that weaponskill's normal skill requirement
local copiesOfWeaponskill =
{
    [xi.mobSkill.TRION_RED_LOTUS_BLADE] = xi.weaponskill.RED_LOTUS_BLADE,
    [xi.mobSkill.TRION_FLAT_BLADE]      = xi.weaponskill.FLAT_BLADE,
    [xi.mobSkill.TRION_SAVAGE_BLADE]    = xi.weaponskill.SAVAGE_BLADE,
    [xi.mobSkill.SEMIH_SIDEWINDER]      = xi.weaponskill.SIDEWINDER,
    [xi.mobSkill.SEMIH_ARCHING_ARROW]   = xi.weaponskill.ARCHING_ARROW,
    [xi.mobSkill.MAAT_COMBO]            = xi.weaponskill.COMBO,
    [xi.mobSkill.MAAT_ONE_INCH_PUNCH]   = xi.weaponskill.ONE_INCH_PUNCH,
    [xi.mobSkill.MAAT_HOWLING_FIST]     = xi.weaponskill.HOWLING_FIST,
    [xi.mobSkill.MAAT_DRAGON_KICK]      = xi.weaponskill.DRAGON_KICK,
    [xi.mobSkill.MAAT_ASURAN_FISTS]     = xi.weaponskill.ASURAN_FISTS,
}

-- Unique Trust skills that copy a job ability follow that ability's normal level
local copiesOfAbility =
{
    [xi.mobSkill.ROYAL_BASH_TRUST]   = xi.jobAbility.SHIELD_BASH,
    [xi.mobSkill.ROYAL_SAVIOR_TRUST] = xi.jobAbility.SENTINEL,
}

-- Zenith level gates on unique Trust skills. Every other unique skill opens at minimumLevel.
local levelGates =
{
    [xi.mobSkill.STELLAR_ARROW]    = 60,
    [xi.mobSkill.LUX_ARROW]        = 50,
    [xi.mobSkill.KING_COBRA_CLAMP] = 30,
    [xi.mobSkill.BEAR_KILLER]      = 24, -- with One Inch Punch
    [xi.mobSkill.VOLKER_BERSERK]   = 40,
}

-- Fallback skills, used from minimumLevel only until the Trust can use the replacement
local fallbacks =
{
    [xi.magic.spell.KUPIPI]        = { [xi.weaponskill.SHINING_STRIKE] = xi.weaponskill.STARLIGHT },
    [xi.magic.spell.CURILLA]       = { [xi.weaponskill.BURNING_BLADE] = xi.weaponskill.RED_LOTUS_BLADE },
    [xi.magic.spell.SEMIH_LAFIHNA] = { [xi.mobSkill.FLAME_ARROW] = xi.mobSkill.SEMIH_SIDEWINDER },
    [xi.magic.spell.VOLKER]        = { [xi.weaponskill.FAST_BLADE] = xi.weaponskill.RED_LOTUS_BLADE },
    [xi.magic.spell.TRION]         = { [xi.weaponskill.BURNING_BLADE] = xi.mobSkill.TRION_RED_LOTUS_BLADE },
}

local function canUseTpSkill(trust, skillId)
    if trust:getMainLvl() < minimumLevel then
        return false
    end

    local trustFallbacks = fallbacks[trust:getTrustID()]
    if trustFallbacks and trustFallbacks[skillId] then
        return not canUseTpSkill(trust, trustFallbacks[skillId])
    end

    -- Player weaponskills are IDs up to 255; the rest are mob skills
    if skillId <= 255 then
        return trust:hasLearnedWeaponskill(skillId)
    end

    if copiesOfWeaponskill[skillId] then
        return trust:hasLearnedWeaponskill(copiesOfWeaponskill[skillId])
    end

    if copiesOfAbility[skillId] then
        return trust:hasLearnedAbility(copiesOfAbility[skillId])
    end

    return trust:getMainLvl() >= (levelGates[skillId] or minimumLevel)
end

-- The engine calls this hook only when it exists; LSB has no default
xi.trust.canUseTpSkill = xi.trust.canUseTpSkill or function(trust, skillId)
    return true
end

m:addOverride('xi.trust.canUseTpSkill', function(trust, skillId)
    return canUseTpSkill(trust, skillId)
end)

return m
