-----------------------------------
-- ZenithXI FOV/GOV Regime Restrictions
--
-- Removes food items, Circumspection, and Haste from regime services.
--
-- Requires git patch: 101-RegimeRestrictions.patch
-- (disables prowess buffs and reduces tabs to 1/3 of normal)
-----------------------------------

local m = Module:new('b_regime_restrictions')

-- Blocked options by regime type
local blockedOptions =
{
    [xi.regime.type.FIELDS] =
    {
        [36]  = true, -- ELITE_INTRO
        [52]  = true, -- ELITE_CHAP1
        [68]  = true, -- ELITE_CHAP2
        [84]  = true, -- ELITE_CHAP3
        [100] = true, -- ELITE_CHAP4
        [116] = true, -- ELITE_CHAP5
        [117] = true, -- DRIED_MEAT
        [132] = true, -- ELITE_CHAP6
        [133] = true, -- SALTED_FISH
        [148] = true, -- ELITE_CHAP7
        [149] = true, -- HARD_COOKIE
        [165] = true, -- INSTANT_NOODLES
    },
    [xi.regime.type.GROUNDS] =
    {
        [36]  = true, -- CIRCUMSPECTION
        [180] = true, -- HASTE
        [196] = true, -- DRIED_MEAT
        [212] = true, -- SALTED_FISH
        [228] = true, -- HARD_COOKIE
        [244] = true, -- INSTANT_NOODLES
        [260] = true, -- DRIED_AGARICUS
        [276] = true, -- INSTANT_RICE
    },
}

m:addOverride('xi.regime.bookOnEventFinish', function(player, option, regimeType)
    local cleanOption = bit.band(option, 0x7FFFFFFF)

    -- Check if option is blocked
    local blocked = blockedOptions[regimeType]
    if blocked and blocked[cleanOption] then
        player:printToPlayer('This Option has been disabled in ZenithXI. Effects have not been applied and tabs have not been deducted')
        return
    end

    -- Call original for all other options
    super(player, option, regimeType)
end)

return m
