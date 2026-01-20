-----------------------------------
-- Garrison Completion Tracking Module
-- Tracks garrison victories using char_vars with bitwise flags
-- Each char_var can track up to 32 garrisons (1 bit per garrison)
-----------------------------------
local m = Module:new('c_garrisonTracking')

-----------------------------------
-- Garrison Tracking Table
-- Structure: charvar name -> list of garrisons (max 32 per var)
-- Each garrison entry: { zoneId = xi.zone.ZONE_NAME }
-- Bit position is determined by array index (index 1 = bit 0, etc.)
-----------------------------------
local garrisonTracking =
{
    -- 16 garrison zones fit in one group
    ['WardrobeGarrison_Group1'] =
    {
        { zoneId = xi.zone.NORTH_GUSTABERG },
        { zoneId = xi.zone.WEST_RONFAURE },
        { zoneId = xi.zone.WEST_SARUTABARUTA },
        { zoneId = xi.zone.BUBURIMU_PENINSULA },
        { zoneId = xi.zone.JUGNER_FOREST },
        { zoneId = xi.zone.MERIPHATAUD_MOUNTAINS },
        { zoneId = xi.zone.PASHHOW_MARSHLANDS },
        { zoneId = xi.zone.QUFIM_ISLAND },
        { zoneId = xi.zone.VALKURM_DUNES },
        { zoneId = xi.zone.BEAUCEDINE_GLACIER },
        { zoneId = xi.zone.THE_SANCTUARY_OF_ZITAH },
        { zoneId = xi.zone.YUHTUNGA_JUNGLE },
        { zoneId = xi.zone.EASTERN_ALTEPA_DESERT },
        { zoneId = xi.zone.XARCABARD },
        { zoneId = xi.zone.YHOATOR_JUNGLE },
        { zoneId = xi.zone.CAPE_TERIGGAN },
    },
}

-----------------------------------
-- Zone ID to display name mapping
-----------------------------------
local zoneDisplayNames =
{
    [xi.zone.NORTH_GUSTABERG] = 'North Gustaberg',
    [xi.zone.WEST_RONFAURE] = 'West Ronfaure',
    [xi.zone.WEST_SARUTABARUTA] = 'West Sarutabaruta',
    [xi.zone.BUBURIMU_PENINSULA] = 'Buburimu Peninsula',
    [xi.zone.JUGNER_FOREST] = 'Jugner Forest',
    [xi.zone.MERIPHATAUD_MOUNTAINS] = 'Meriphataud Mountains',
    [xi.zone.PASHHOW_MARSHLANDS] = 'Pashhow Marshlands',
    [xi.zone.QUFIM_ISLAND] = 'Qufim Island',
    [xi.zone.VALKURM_DUNES] = 'Valkurm Dunes',
    [xi.zone.BEAUCEDINE_GLACIER] = 'Beaucedine Glacier',
    [xi.zone.THE_SANCTUARY_OF_ZITAH] = 'The Sanctuary of Zi\'Tah',
    [xi.zone.YUHTUNGA_JUNGLE] = 'Yuhtunga Jungle',
    [xi.zone.EASTERN_ALTEPA_DESERT] = 'Eastern Altepa Desert',
    [xi.zone.XARCABARD] = 'Xarcabard',
    [xi.zone.YHOATOR_JUNGLE] = 'Yhoator Jungle',
    [xi.zone.CAPE_TERIGGAN] = 'Cape Teriggan',
}

-----------------------------------
-- Helper: Find garrison in tracking table
-- @param zoneId number: The zone ID (xi.zone.*)
-- @return charVarName string|nil, bitPos number|nil
-----------------------------------
local function findTrackedGarrison(zoneId)
    for charVarName, garrList in pairs(garrisonTracking) do
        for bitPos, garrData in ipairs(garrList) do
            if garrData.zoneId == zoneId then
                return charVarName, bitPos - 1 -- 0-indexed bit position
            end
        end
    end

    return nil, nil
end

-----------------------------------
-- Helper: Track garrison completion for a single player
-- @param player CCharEntity: The player to track the completion for
-- @param zoneId number: The zone ID where garrison was completed
-----------------------------------
local function trackGarrisonForPlayer(player, zoneId)
    local charVarName, bitPos = findTrackedGarrison(zoneId)
    if charVarName == nil then
        return
    end

    local currentVar = player:getCharVar(charVarName)

    if not utils.mask.getBit(currentVar, bitPos) then
        local newVar = utils.mask.setBit(currentVar, bitPos, true)
        player:setCharVar(charVarName, newVar)

        -- Notify player of garrison tracked
        local displayName = zoneDisplayNames[zoneId] or 'Unknown Zone'
        player:printToPlayer(
            string.format('[Wardrobe] Garrison tracked: %s', displayName),
            xi.msg.channel.SYSTEM_3
        )
    end
end

-----------------------------------
-- Hook into garrison victory (handleGilPayout is called when garrison is won)
-----------------------------------
m:addOverride('xi.garrison.handleGilPayout', function(levelCap, players)
    super(levelCap, players)

    -- Validate players list
    if players == nil or #players == 0 then
        return
    end

    -- Get zone ID from first player (all players are in same zone)
    local zoneId = players[1]:getZoneID()

    -- Track garrison completion for all participating players
    for _, player in ipairs(players) do
        trackGarrisonForPlayer(player, zoneId)
    end
end)

-----------------------------------
-- Public API
-----------------------------------
xi = xi or {}
xi.garrisonTracking = xi.garrisonTracking or {}

-----------------------------------
-- Get the garrison tracking table (for external use)
-- @return table: The garrisonTracking table
-----------------------------------
xi.garrisonTracking.getTrackingTable = function()
    return garrisonTracking
end

-----------------------------------
-- Check if a specific garrison has been completed
-- @param player CCharEntity: The player to check
-- @param zoneId number: The zone ID (xi.zone.*)
-- @return boolean: True if the garrison has been completed
-----------------------------------
xi.garrisonTracking.hasCompletedGarrison = function(player, zoneId)
    local charVarName, bitPos = findTrackedGarrison(zoneId)
    if charVarName == nil then
        return false
    end

    return utils.mask.getBit(player:getCharVar(charVarName), bitPos)
end

-----------------------------------
-- Count how many garrisons have been completed
-- @param player CCharEntity: The player to check
-- @return number: Count of completed garrisons
-----------------------------------
xi.garrisonTracking.getCompletionCount = function(player)
    local count = 0
    for charVarName, garrList in pairs(garrisonTracking) do
        local mask = player:getCharVar(charVarName)
        count = count + utils.mask.countBits(mask, #garrList)
    end

    return count
end

-----------------------------------
-- Check if all garrisons have been completed
-- @param player CCharEntity: The player to check
-- @return boolean: True if all garrisons are completed
-----------------------------------
xi.garrisonTracking.hasCompletedAll = function(player)
    for charVarName, garrList in pairs(garrisonTracking) do
        local mask = player:getCharVar(charVarName)
        if not utils.mask.isFull(mask, #garrList) then
            return false
        end
    end

    return true
end

return m
