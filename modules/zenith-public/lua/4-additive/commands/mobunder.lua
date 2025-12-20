-----------------------------------
-- func: mobunder
-- desc: Spawns a mob underground at a specific position to detect claim bots
--       GM Level 4 required
-- usage: !mobunder <mobId> [offsetY] [timer]
--        !mobunder <mobId> <playerName> [offsetY] [timer]
--        !mobunder <mobId> <x> <y> <z> [offsetY] [timer]
--        !mobunder name <mobName> [offsetY] [timer]
--        !mobunder name <mobName> <playerName> [offsetY] [timer]
-----------------------------------
Module:new('a-c_mobunder')

---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 4,
    parameters = 'ssdddd',
}

local defaultOffset = -5

-----------------------------------
-- Helper Functions
-----------------------------------

local function showUsage(player)
    player:printToPlayer('Usage: !mobunder <mobId|name> [arguments]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('  By ID at your position:', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('    !mobunder <mobId> [offsetY] [timer]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('  By ID at player position:', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('    !mobunder <mobId> <playerName> [offsetY] [timer]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('  By ID at coordinates:', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('    !mobunder <mobId> <x> <y> <z> [offsetY] [timer]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('  By name at your position:', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('    !mobunder name <mobName> [offsetY] [timer]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('  By name at player position:', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('    !mobunder name <mobName> <playerName> [offsetY] [timer]', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('offsetY: Y-axis offset (default: -5, negative = underground)', xi.msg.channel.SYSTEM_3)
    player:printToPlayer('timer: Auto-despawn timer in seconds (0 or omit = no timer)', xi.msg.channel.SYSTEM_3)
end

local function printError(player, msg)
    player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
end

local function getPlayerPosition(player)
    return player:getXPos(), player:getYPos(), player:getZPos()
end

local function findTargetPlayer(player, targetName)
    local targetPlayer = GetPlayerByName(targetName)

    if targetPlayer == nil then
        printError(player, string.format('Error: Player "%s" not found or offline.', targetName))
        return nil
    end

    if targetPlayer:getZoneID() ~= player:getZoneID() then
        printError(player, string.format('Error: Player "%s" must be in the same zone as you.', targetName))
        return nil
    end

    return targetPlayer
end

local function getMobByIdInZone(mobId, zone, player)
    if zone:getTypeMask() == xi.zoneType.INSTANCED then
        local instance = player:getInstance()
        return GetMobByID(mobId, instance)
    end

    return GetMobByID(mobId)
end

local function spawnMobInZone(mobId, zone, player)
    if zone:getTypeMask() == xi.zoneType.INSTANCED then
        local instance = player:getInstance()
        SpawnMob(mobId, instance)
    else
        SpawnMob(mobId)
    end
end

local function parseNameBasedArgs(player, zone, arg2, arg3, arg4, arg5)
    if arg2 == nil or arg2 == '' then
        printError(player, 'Error: You must specify a mob name.')
        showUsage(player)
        return nil
    end

    local mobName = tostring(arg2)
    local entities = zone:queryEntitiesByName(mobName)

    if #entities == 0 then
        printError(player, string.format('Error: Mob "%s" not found in current zone.', mobName))
        return nil
    end

    local mob = entities[1]
    local mobId = mob:getID()
    local targetX, targetY, targetZ = getPlayerPosition(player)
    local offsetY = defaultOffset
    local timer = 0

    if arg3 ~= nil then
        local arg3Num = tonumber(arg3)
        if arg3Num ~= nil then
            offsetY = arg3Num
            timer = tonumber(arg4) or 0
        else
            local targetPlayer = findTargetPlayer(player, tostring(arg3))
            if targetPlayer == nil then
                return nil
            end

            targetX, targetY, targetZ = getPlayerPosition(targetPlayer)
            offsetY = tonumber(arg4) or defaultOffset
            timer = tonumber(arg5) or 0
        end
    end

    return { mob = mob, mobId = mobId, x = targetX, y = targetY, z = targetZ, offsetY = offsetY, timer = timer }
end

local function parseIdBasedArgs(player, zone, arg1, arg2, arg3, arg4, arg5, arg6)
    local mobId = tonumber(arg1)

    if mobId == nil then
        printError(player, 'Error: Invalid mob ID. Must be a number or use "name" for name lookup.')
        showUsage(player)
        return nil
    end

    local targetX, targetY, targetZ = getPlayerPosition(player)
    local offsetY = defaultOffset
    local timer = 0

    if arg2 == nil then
        offsetY = tonumber(arg3) or defaultOffset
        timer = tonumber(arg4) or 0
    else
        local arg2Num = tonumber(arg2)
        if arg2Num ~= nil then
            if arg3 ~= nil and arg4 ~= nil then
                targetX = arg2Num
                targetY = tonumber(arg3)
                targetZ = tonumber(arg4)

                if targetY == nil or targetZ == nil then
                    printError(player, 'Error: Invalid coordinates. All X, Y, Z values must be numbers.')
                    showUsage(player)
                    return nil
                end

                offsetY = tonumber(arg5) or defaultOffset
                timer = tonumber(arg6) or 0
            else
                offsetY = arg2Num
                timer = tonumber(arg3) or 0
            end
        else
            local targetPlayer = findTargetPlayer(player, tostring(arg2))
            if targetPlayer == nil then
                return nil
            end

            targetX, targetY, targetZ = getPlayerPosition(targetPlayer)
            offsetY = tonumber(arg3) or defaultOffset
            timer = tonumber(arg4) or 0
        end
    end

    local mob = getMobByIdInZone(mobId, zone, player)
    if mob == nil then
        printError(player, string.format('Error: Invalid mob ID %d.', mobId))
        return nil
    end

    return { mob = mob, mobId = mobId, x = targetX, y = targetY, z = targetZ, offsetY = offsetY, timer = timer }
end

local function positionMobUnderground(player, zone, parsed)
    if parsed.timer < 0 then
        printError(player, 'Error: Timer cannot be negative.')
        return
    end

    local finalY = parsed.y + parsed.offsetY
    local wasSpawned = parsed.mob:isSpawned()

    if not wasSpawned then
        spawnMobInZone(parsed.mobId, zone, player)
        player:printToPlayer(string.format('Mob %s (ID: %d) spawned.', parsed.mob:getName(), parsed.mobId), xi.msg.channel.SYSTEM_3)
    else
        player:printToPlayer(string.format('Mob %s (ID: %d) was already spawned. Moving to new position.', parsed.mob:getName(), parsed.mobId), xi.msg.channel.SYSTEM_3)
    end

    parsed.mob:setMobMod(xi.mobMod.NO_DESPAWN, 1)
    parsed.mob:setSpawn(parsed.x, finalY, parsed.z, player:getRotPos())
    parsed.mob:setPos(parsed.x, finalY, parsed.z, player:getRotPos())

    player:printToPlayer(
        string.format('Positioned %s (ID: %d) underground at (%.2f, %.2f, %.2f) [offset: %.1f]',
            parsed.mob:getName(),
            parsed.mobId,
            parsed.x,
            finalY,
            parsed.z,
            parsed.offsetY
        ),
        xi.msg.channel.SYSTEM_3
    )

    if parsed.timer > 0 then
        parsed.mob:timer(parsed.timer * 1000, function(mobArg)
            DespawnMob(mobArg:getID())
        end)

        player:printToPlayer(string.format('Mob will auto-despawn in %d seconds.', parsed.timer), xi.msg.channel.SYSTEM_3)
    else
        player:printToPlayer('No auto-despawn timer set. Use !despawn to remove manually.', xi.msg.channel.SYSTEM_3)
    end
end

-----------------------------------
-- Main Command Handler
-----------------------------------

commandObj.onTrigger = function(player, arg1, arg2, arg3, arg4, arg5, arg6)
    if player:getGMLevel() < 4 then
        printError(player, 'Error: This command requires GM level 4.')
        return
    end

    local zone = player:getZone()
    if not zone then
        printError(player, 'Error: Invalid zone.')
        return
    end

    if arg1 == nil or arg1 == '' then
        showUsage(player)
        return
    end

    local parsed

    if string.lower(tostring(arg1)) == 'name' then
        parsed = parseNameBasedArgs(player, zone, arg2, arg3, arg4, arg5)
    else
        parsed = parseIdBasedArgs(player, zone, arg1, arg2, arg3, arg4, arg5, arg6)
    end

    if parsed == nil then
        return
    end

    positionMobUnderground(player, zone, parsed)
end

return commandObj
