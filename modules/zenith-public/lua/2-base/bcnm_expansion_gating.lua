-----------------------------------
-- BCNM Expansion Content Gating Module
--
-- This module gates BCNM orbs and fights based on content phase,
-- supporting multi-phase release matching historical retail timeline.
--
-- Phase Timeline:
-- Phase 0 - baseGame:  Original 6 fights (Star/Moon Orbs)
-- Phase 1 - rotzEarly: Comet, Atropos, Lachesis, Clotho Orbs + Moon expansion
-- Phase 2 - rotzMid:   Cloudy/Sky Orbs introduced
-- Phase 3 - rotzLate:  Major expansion of all orb fights
-- Phase 4 - rotzEnd:   Themis Orb (KS99 alliance battles)
--
-- To change the content phase, edit the 'currentContentPhase' variable below.
-----------------------------------

require('modules/module_utils')

local m = Module:new('b_bcnm_expansion_gating')

-----------------------------------
-- Content Phase Constants
-----------------------------------
local contentPhase =
{
    baseGame  = 0, -- Base: Star/Moon Orbs original 6 fights
    rotzEarly = 1, -- Early ROTZ: Comet, Atropos, Lachesis, Clotho Orbs
    rotzMid   = 2, -- Mid ROTZ: Cloudy/Sky Orbs introduced
    rotzLate  = 3, -- Late ROTZ: Major expansion of all orb fights
    rotzEnd   = 4, -- End ROTZ: Themis Orb (KS99 alliance battles)
}

-----------------------------------
-- CURRENT CONTENT PHASE SETTING
-- Change this value to control which BCNM content is available
-----------------------------------
local currentContentPhase = contentPhase.rotzEarly

-----------------------------------
-- Orb Phase Requirements
-- Maps orb item IDs to the phase they were introduced
-- Orbs not listed here are always available (Star/Moon Orbs)
-----------------------------------
local orbPhaseRequirements =
{
    -- rotzEarly orbs
    [xi.item.COMET_ORB]    = contentPhase.rotzEarly,
    [xi.item.ATROPOS_ORB]  = contentPhase.rotzEarly,
    [xi.item.LACHESIS_ORB] = contentPhase.rotzEarly,
    [xi.item.CLOTHO_ORB]   = contentPhase.rotzEarly,

    -- rotzMid orbs
    [xi.item.CLOUDY_ORB]   = contentPhase.rotzMid,
    [xi.item.SKY_ORB]      = contentPhase.rotzMid,

    -- rotzEnd orbs
    [xi.item.THEMIS_ORB]   = contentPhase.rotzEnd,
}

-----------------------------------
-- Shami Option-to-Orb Mapping
-- Maps Shami's menu option numbers to orb item IDs
-----------------------------------
local optionToOrb =
{
    [1]  = xi.item.CLOUDY_ORB,
    [2]  = xi.item.SKY_ORB,
    [3]  = xi.item.STAR_ORB,
    [4]  = xi.item.COMET_ORB,
    [5]  = xi.item.MOON_ORB,
    [6]  = xi.item.CLOTHO_ORB,
    [7]  = xi.item.LACHESIS_ORB,
    [8]  = xi.item.ATROPOS_ORB,
    [9]  = xi.item.THEMIS_ORB,
    [10] = xi.item.PHOBOS_ORB,
    [11] = xi.item.DEIMOS_ORB,
    [12] = xi.item.ZELOS_ORB,
    [13] = xi.item.BIA_ORB,
    [14] = xi.item.MICROCOSMIC_ORB,
    [15] = xi.item.MACROCOSMIC_ORB,
}

-----------------------------------
-- Fight Phase Requirements
-- Maps battlefield IDs to the phase they become available
-- Fights not listed here use their orb's phase requirement
-----------------------------------
local fightPhaseRequirements =
{
    -- Base Game fights (Phase 0) - Star Orb
    [xi.battlefield.id.TAILS_OF_WOE]            = contentPhase.baseGame,
    [xi.battlefield.id.WORMS_TURN]              = contentPhase.baseGame,
    [xi.battlefield.id.STEAMED_SPROUTS]         = contentPhase.baseGame,

    -- Base Game fights (Phase 0) - Moon Orb
    [xi.battlefield.id.DISMEMBERMENT_BRIGADE]   = contentPhase.baseGame,
    [xi.battlefield.id.GRIMSHELL_SHOCKTROOPERS] = contentPhase.baseGame,
    [xi.battlefield.id.DIVINE_PUNISHERS]        = contentPhase.baseGame,

    -- Early ROTZ fights (Phase 1) - Comet Orb
    [xi.battlefield.id.HOSTILE_HERBIVORES]      = contentPhase.rotzEarly,
    [xi.battlefield.id.THREE_TWO_ONE]           = contentPhase.rotzEarly,
    [xi.battlefield.id.TREASURE_AND_TRIBULATIONS] = contentPhase.rotzEarly,

    -- Early ROTZ fights (Phase 1) - Moon Orb expansion
    [xi.battlefield.id.DEMOLITION_SQUAD]        = contentPhase.rotzEarly,
    [xi.battlefield.id.LEGION_XI_COMITATENSIS]  = contentPhase.rotzEarly,
    [xi.battlefield.id.AMPHIBIAN_ASSAULT]       = contentPhase.rotzEarly,
    [xi.battlefield.id.JUNGLE_BOOGYMEN]         = contentPhase.rotzEarly,

    -- Early ROTZ fights (Phase 1) - KS Orbs
    [xi.battlefield.id.INFERNAL_SWARM]          = contentPhase.rotzEarly,
    [xi.battlefield.id.E_VASE_IVE_ACTION]       = contentPhase.rotzEarly,
    [xi.battlefield.id.COME_INTO_MY_PARLOR]     = contentPhase.rotzEarly,

    -- Mid ROTZ fights (Phase 2) - Cloudy Orb
    [xi.battlefield.id.WINGS_OF_FURY]           = contentPhase.rotzMid,

    -- Mid ROTZ fights (Phase 2) - Sky Orb
    [xi.battlefield.id.PETRIFYING_PAIR]         = contentPhase.rotzMid,
    [xi.battlefield.id.CARAPACE_COMBATANTS]     = contentPhase.rotzMid,
    [xi.battlefield.id.BIRDS_OF_A_FEATHER]      = contentPhase.rotzMid,
    [xi.battlefield.id.CREEPING_DOOM]           = contentPhase.rotzMid,

    -- Late ROTZ fights (Phase 3) - Cloudy Orb expansion
    [xi.battlefield.id.SHOOTING_FISH]           = contentPhase.rotzLate,
    [xi.battlefield.id.CRUSTACEAN_CONUNDRUM]    = contentPhase.rotzLate,
    [xi.battlefield.id.CHARMING_TRIO]           = contentPhase.rotzLate,

    -- Late ROTZ fights (Phase 3) - Sky Orb expansion
    [xi.battlefield.id.TOADAL_RECALL]           = contentPhase.rotzLate,
    [xi.battlefield.id.DROPPING_LIKE_FLIES]     = contentPhase.rotzLate,
    [xi.battlefield.id.GROVE_GUARDIANS]         = contentPhase.rotzLate,
    [xi.battlefield.id.HAREM_SCAREM]            = contentPhase.rotzLate,
    [xi.battlefield.id.DIE_BY_THE_SWORD]        = contentPhase.rotzLate,
    [xi.battlefield.id.LET_SLEEPING_DOGS_DIE]   = contentPhase.rotzLate,

    -- Late ROTZ fights (Phase 3) - Star Orb expansion
    [xi.battlefield.id.UNDER_OBSERVATION]       = contentPhase.rotzLate,
    [xi.battlefield.id.ROYAL_JELLY]             = contentPhase.rotzLate,
    [xi.battlefield.id.ROYAL_SUCCESSION]        = contentPhase.rotzLate,
    [xi.battlefield.id.UNDYING_PROMISE]         = contentPhase.rotzLate,
    [xi.battlefield.id.FACTORY_REJECTS]         = contentPhase.rotzLate,

    -- Late ROTZ fights (Phase 3) - Comet Orb expansion
    [xi.battlefield.id.IDOL_THOUGHTS]           = contentPhase.rotzLate,

    -- Late ROTZ fights (Phase 3) - Moon Orb expansion
    [xi.battlefield.id.BROTHERS_D_AURPHE]       = contentPhase.rotzLate,
    [xi.battlefield.id.KINDRED_SPIRITS]         = contentPhase.rotzLate,

    -- Late ROTZ fights (Phase 3) - KS Orb expansion
    [xi.battlefield.id.SCARLET_KING]            = contentPhase.rotzLate,
    [xi.battlefield.id.EYE_OF_THE_STORM]        = contentPhase.rotzLate,
    [xi.battlefield.id.CACTUAR_SUAVE]           = contentPhase.rotzLate,

    -- End ROTZ fights (Phase 4) - Themis Orb
    [xi.battlefield.id.EARLY_BIRD_CATCHES_THE_WYRM] = contentPhase.rotzEnd,
}

-----------------------------------
-- HELPER FUNCTIONS
-----------------------------------

-- Check if a specific fight is available based on content phase
local function isFightAvailable(content)
    -- Get the required orb from battlefield content
    local orbId = content.requiredItems and content.requiredItems[1] or nil

    -- If no orb required, allow (mission BCNMs, etc.)
    if orbId == nil then
        return true
    end

    -- Check if the orb itself is available
    local orbPhase = orbPhaseRequirements[orbId]
    if orbPhase ~= nil and orbPhase > currentContentPhase then
        return false
    end

    -- Check if this specific fight has a phase requirement
    local fightPhase = fightPhaseRequirements[content.battlefieldId]
    if fightPhase ~= nil then
        return fightPhase <= currentContentPhase
    end

    -- If fight has no specific phase requirement, use orb's phase (or allow if orb has no requirement)
    return orbPhase == nil or orbPhase <= currentContentPhase
end

-- Check if a specific orb is available for purchase based on content phase
local function isOrbAvailable(orbItemId)
    if orbItemId == nil then
        return true
    end

    local orbPhase = orbPhaseRequirements[orbItemId]
    return orbPhase == nil or orbPhase <= currentContentPhase
end

-----------------------------------
-- OVERRIDE: getBattlefieldOptions
-- Filters available battlefields based on expansion/phase settings
-----------------------------------
m:addOverride('xi.battlefield.getBattlefieldOptions', function(player, npc, trade)
    local result = super(player, npc, trade)

    if result == 0 then
        return result
    end

    local contents = xi.battlefield.contentsByZone[player:getZoneID()]
    if contents == nil then
        return result
    end

    -- Filter out disabled battlefields
    for _, content in ipairs(contents) do
        if not isFightAvailable(content) then
            result = utils.mask.setBit(result, content.index, false)
        end
    end

    return result
end)

-----------------------------------
-- OVERRIDE: Shami Orb Purchases
-- Prevents purchasing gated orbs from Shami NPC in Port Jeuno
-----------------------------------
m:addOverride('xi.zones.Port_Jeuno.npcs.Shami.onEventFinish', function(player, csid, option, npc)
    -- Only intercept orb purchase event (csid 322)
    if csid == 322 then
        local orbItemId = optionToOrb[option]
        if orbItemId and not isOrbAvailable(orbItemId) then
            player:printToPlayer('This orb is not yet available on ZenithXI. It will be unlocked in a future content update.', xi.msg.channel.SYSTEM_3)
            return -- Block the purchase (seals are not deducted since super() is not called)
        end
    end

    -- Call original function for all other cases
    super(player, csid, option, npc)
end)

-----------------------------------
-- SERVER START: Log current phase
-----------------------------------
m:addOverride('xi.server.onServerStart', function()
    super()

    local phaseNames =
    {
        [contentPhase.baseGame]  = 'baseGame',
        [contentPhase.rotzEarly] = 'rotzEarly',
        [contentPhase.rotzMid]   = 'rotzMid',
        [contentPhase.rotzLate]  = 'rotzLate',
        [contentPhase.rotzEnd]   = 'rotzEnd',
    }

    local phaseName = phaseNames[currentContentPhase] or 'UNKNOWN'
    printf('[bcnm_expansion_gating] Content phase: %d (%s)', currentContentPhase, phaseName)
end)

return m
