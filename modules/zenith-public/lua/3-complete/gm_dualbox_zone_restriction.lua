-----------------------------------
-- GM Dual-Box Zone Restriction (Account-Based)
-- Prevents characters from linked accounts from being in the same zone
-- Bindings are managed via the web admin panel (gm_account_bindings table)
-- This is a security measure to prevent GMs from abusing powers to benefit personal characters
-----------------------------------
require('modules/module_utils')
-----------------------------------
-- luacheck: globals GetLinkedAccountIds
-- GetLinkedAccountIds is registered by modules/zenith-public/cpp/gm_account_bindings.cpp
-----------------------------------
local m = Module:new('c_gm_dualbox_zone_restriction')

-- Configuration
local config =
{
    -- Safe zone to teleport conflicting players to (Ru'Lude Gardens)
    safeZone = xi.zone.RULUDE_GARDENS,
    safePos =
    {
        x = 48.930,
        y = 10.002,
        z = -71.032,
        rot = 195,
    },

    -- Delay before teleport (milliseconds)
    teleportDelay = 500,

    -- Enable console logging
    enableLogging = true,
}

-----------------------------------
-- Helper Functions
-----------------------------------

-- Check if any player from a linked account is in the specified zone
-- @param linkedAccountIds table: Array of linked account IDs
-- @param targetZoneId number: The zone to check
-- @param excludePlayerId number: Player ID to exclude from the check (the zoning player)
-- @return CBaseEntity|nil: The first conflicting player found in zone, nil otherwise
local function getLinkedAccountPlayerInZone(linkedAccountIds, targetZoneId, excludePlayerId)
    if #linkedAccountIds == 0 then
        return nil
    end

    -- Get all players in the target zone
    local zone = GetZone(targetZoneId)
    if zone == nil then
        return nil
    end

    -- Iterate through zone players to find any from linked accounts
    local zonePlayers = zone:getPlayers()
    for _, zonePlayer in ipairs(zonePlayers) do
        if zonePlayer ~= nil and zonePlayer:getID() ~= excludePlayerId then
            local zonePlayerAccountId = zonePlayer:getAccountId()
            if zonePlayerAccountId ~= 0 then
                for _, linkedAccountId in ipairs(linkedAccountIds) do
                    if zonePlayerAccountId == linkedAccountId then
                        return zonePlayer
                    end
                end
            end
        end
    end

    return nil
end

-- Handle zone conflict by teleporting player to safe zone
-- @param zoningPlayer CBaseEntity: The player to redirect (the one zoning in)
-- @param conflictPlayer CBaseEntity: The player already in the zone (receives the notification)
local function handleZoneConflict(zoningPlayer, conflictPlayer)
    local zoningPlayerName = zoningPlayer:getName()
    local conflictPlayerName = conflictPlayer:getName()
    local zoneId = conflictPlayer:getZoneID()

    -- Send message to the player already in the zone (they're fully loaded)
    conflictPlayer:printToPlayer(
        string.format(
            '[GM Zone Restriction] A character from your linked account (%s) attempted to enter this zone and was redirected.',
            zoningPlayerName
        ),
        xi.msg.channel.SYSTEM_3
    )

    -- Teleport the zoning player to safe zone after a brief delay
    zoningPlayer:timer(config.teleportDelay, function(playerArg)
        playerArg:setPos(
            config.safePos.x,
            config.safePos.y,
            config.safePos.z,
            config.safePos.rot,
            config.safeZone
        )
    end)

    if config.enableLogging then
        printf('[GM Zone Restriction] %s (account-based) blocked from zone %d - linked account char %s present',
            zoningPlayerName,
            zoneId,
            conflictPlayerName
        )
    end
end

-----------------------------------
-- Zone Entry Override
-----------------------------------

m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)

    -- Only check for conflicts during zone transitions (not initial login)
    if not zoning then
        return
    end

    -- Don't check if player is in the safe zone (they just got redirected here)
    local targetZoneId = player:getZoneID()
    if targetZoneId == config.safeZone then
        return
    end

    -- Get the player's account ID using the C++ binding
    local accountId = player:getAccountId()
    if accountId == 0 then
        return
    end

    -- Get linked accounts from the database via C++ binding
    -- This returns accounts linked in either direction (GM->Personal or Personal->GM)
    local linkedAccountIds = GetLinkedAccountIds(accountId)
    if linkedAccountIds == nil or #linkedAccountIds == 0 then
        return
    end

    -- Check if any player from a linked account is in the target zone
    local conflictPlayer = getLinkedAccountPlayerInZone(linkedAccountIds, targetZoneId, player:getID())
    if conflictPlayer ~= nil then
        handleZoneConflict(player, conflictPlayer)
    end
end)

return m
