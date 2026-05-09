-----------------------------------
-- func: outpost <action> [player] [outpost_name] [nation]
-- desc: Manages outpost teleport unlocks for a player.
--
--       Actions:
--         add    -> unlock outpost(s)             (aliases: unlock)
--         reset  -> lock outpost(s)               (aliases: clear, lock)
--         check  -> list current unlocks          (aliases: list, verify, show)
--
--       Optional tokens after the action can appear in any order:
--         player       any online player name
--         outpost_name any of the regions listed by an unknown name
--         nation       sandoria | bastok | windurst (aliases: sandy, windy)
--
--       Defaults:
--         player  -> cursor target if PC, else self
--         outpost -> ALL outposts
--         nation  -> ALL three nations
--
--       Examples:
--         !outpost add                              Unlock all outposts, all nations, cursor/self
--         !outpost add sandoria                     Unlock all outposts for Sandoria, cursor/self
--         !outpost add ronfaure sandoria            Unlock ronfaure for Sandoria, cursor/self
--         !outpost add Bob bastok                   Unlock all outposts for Bastok for Bob
--         !outpost add Bob ronfaure windy           Unlock ronfaure for Windurst for Bob
--         !outpost reset Bob sandoria               Lock all Sandoria outposts for Bob
--         !outpost reset ronfaure                   Lock ronfaure across all nations, cursor/self
--         !outpost check Bob                        Check Bob across all nations
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = 'ssss',
}

local outpostRegions =
{
    ronfaure          = xi.region.RONFAURE,
    zulkheim          = xi.region.ZULKHEIM,
    norvallen         = xi.region.NORVALLEN,
    gustaberg         = xi.region.GUSTABERG,
    derfland          = xi.region.DERFLAND,
    sarutabaruta      = xi.region.SARUTABARUTA,
    kolshushu         = xi.region.KOLSHUSHU,
    aragoneu          = xi.region.ARAGONEU,
    fauregandi        = xi.region.FAUREGANDI,
    valdeaunia        = xi.region.VALDEAUNIA,
    qufim             = xi.region.QUFIMISLAND,
    litelor           = xi.region.LITELOR,
    kuzotz            = xi.region.KUZOTZ,
    vollbow           = xi.region.VOLLBOW,
    elshimo_lowlands  = xi.region.ELSHIMO_LOWLANDS,
    elshimo_uplands   = xi.region.ELSHIMO_UPLANDS,
    tulia             = xi.region.TULIA,
    movalpolos        = xi.region.MOVALPOLOS,
    tavnazia          = xi.region.TAVNAZIANARCH,
}

local nationTeleports =
{
    { name = 'Sandoria', type = xi.teleport.type.OUTPOST_SANDORIA },
    { name = 'Bastok',   type = xi.teleport.type.OUTPOST_BASTOK   },
    { name = 'Windurst', type = xi.teleport.type.OUTPOST_WINDURST },
}

-- Map common aliases (lowercase) to the index in nationTeleports.
local nationAliases =
{
    sandoria   = 1,
    sandy      = 1,
    sandy_oria = 1,
    sandoria_  = 1,
    san_doria  = 1,
    bastok     = 2,
    bas        = 2,
    windurst   = 3,
    windy      = 3,
    windie     = 3,
}

local actions =
{
    add    = 'add',
    unlock = 'add',
    reset  = 'reset',
    clear  = 'reset',
    lock   = 'reset',
    check  = 'check',
    list   = 'check',
    verify = 'check',
    show   = 'check',
}

local function showUsage(player, msg)
    if msg then
        player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
    end

    player:printToPlayer('Usage: !outpost <add|reset|check> [player] [outpost_name] [nation]', xi.msg.channel.SYSTEM_3)
end

local function listOutposts(player)
    local names = {}
    for name, _ in pairs(outpostRegions) do
        table.insert(names, name)
    end

    table.sort(names)
    player:printToPlayer('Valid outpost names: ' .. table.concat(names, ', '), xi.msg.channel.SYSTEM_3)
end

local function listNations(player)
    player:printToPlayer('Valid nations: sandoria, bastok, windurst', xi.msg.channel.SYSTEM_3)
end

local function resolveNations(nationFilter)
    if nationFilter == nil then
        return nationTeleports
    end

    return { nationTeleports[nationFilter] }
end

local function nationLabel(nationFilter)
    if nationFilter == nil then
        return 'all nations'
    end

    return nationTeleports[nationFilter].name
end

local function reportUnlocks(player, target, nationFilter)
    local sortedNames = {}
    for name, _ in pairs(outpostRegions) do
        table.insert(sortedNames, name)
    end

    table.sort(sortedNames)

    player:printToPlayer(
        string.format('Outpost unlocks for %s (%s):', target:getName(), nationLabel(nationFilter)),
        xi.msg.channel.SYSTEM_3
    )

    for _, nation in ipairs(resolveNations(nationFilter)) do
        local unlocked = {}
        for _, name in ipairs(sortedNames) do
            local bitOffset = outpostRegions[name] + 5 -- Region bits start at 5th bit
            if target:hasTeleport(nation.type, bitOffset) then
                table.insert(unlocked, name)
            end
        end

        local list = #unlocked > 0 and table.concat(unlocked, ', ') or '(none)'
        player:printToPlayer(
            string.format('  %s: %s', nation.name, list),
            xi.msg.channel.SYSTEM_3
        )
    end
end

-- Classify a single token as outpost, nation, or player.
-- Returns one of: 'outpost', 'nation', 'player', or nil with an error string.
local function classifyToken(token, state)
    local lowered = string.lower(token)

    if outpostRegions[lowered] then
        if state.outpostName ~= nil then
            return nil, string.format('Two outposts given ("%s" and "%s").', state.outpostName, lowered)
        end

        state.outpostName = lowered
        return 'outpost'
    end

    if nationAliases[lowered] then
        if state.nationFilter ~= nil then
            return nil, string.format(
                'Two nations given ("%s" and "%s").',
                nationTeleports[state.nationFilter].name,
                nationTeleports[nationAliases[lowered]].name
            )
        end

        state.nationFilter = nationAliases[lowered]
        return 'nation'
    end

    if state.target ~= nil then
        return nil, string.format('Unknown token "%s".', token)
    end

    local found = GetPlayerByName(token)
    if found == nil then
        return nil, string.format('Player "%s" not found or not online.', token)
    end

    state.target = found
    return 'player'
end

-- Walk over the optional argument list and classify each non-empty token.
local function resolveArgs(player, ...)
    local state = {}

    for _, raw in ipairs({ ... }) do
        if raw ~= nil and raw ~= '' then
            local _, err = classifyToken(raw, state)
            if err then
                return nil, nil, nil, err
            end
        end
    end

    if state.target == nil then
        local cursorTarget = player:getCursorTarget()
        if cursorTarget and cursorTarget:isPC() then
            state.target = cursorTarget
        else
            state.target = player
        end
    end

    return state.target, state.outpostName, state.nationFilter, nil
end

local function doAdd(player, target, outpostName, nationFilter)
    local nations = resolveNations(nationFilter)
    local scope   = nationLabel(nationFilter)

    if outpostName then
        local region    = outpostRegions[outpostName]
        local bitOffset = region + 5

        for _, nation in ipairs(nations) do
            target:addTeleport(nation.type, bitOffset)
        end

        player:printToPlayer(
            string.format(
                'Unlocked outpost "%s" (region %d) for %s (%s).',
                outpostName,
                region,
                target:getName(),
                scope
            ),
            xi.msg.channel.SYSTEM_3
        )
    else
        for _, nation in ipairs(nations) do
            for _, region in pairs(outpostRegions) do
                target:addTeleport(nation.type, region + 5)
            end
        end

        player:printToPlayer(
            string.format('Unlocked ALL outposts for %s (%s).', target:getName(), scope),
            xi.msg.channel.SYSTEM_3
        )
    end
end

local function doReset(player, target, outpostName, nationFilter)
    local nations = resolveNations(nationFilter)
    local scope   = nationLabel(nationFilter)

    if outpostName then
        local region    = outpostRegions[outpostName]
        local bitOffset = region + 5

        for _, nation in ipairs(nations) do
            target:clearTeleport(nation.type, bitOffset)
        end

        player:printToPlayer(
            string.format(
                'Locked outpost "%s" (region %d) for %s (%s).',
                outpostName,
                region,
                target:getName(),
                scope
            ),
            xi.msg.channel.SYSTEM_3
        )
    else
        for _, nation in ipairs(nations) do
            target:clearTeleport(nation.type)
        end

        player:printToPlayer(
            string.format('Reset ALL outpost unlocks for %s (%s).', target:getName(), scope),
            xi.msg.channel.SYSTEM_3
        )
    end
end

commandObj.onTrigger = function(player, action, arg1, arg2, arg3)
    if action == nil or action == '' then
        showUsage(player, 'No action specified.')
        return
    end

    local resolvedAction = actions[string.lower(action)]
    if not resolvedAction then
        showUsage(player, string.format('Unknown action "%s".', action))
        return
    end

    local target, outpostName, nationFilter, err = resolveArgs(player, arg1, arg2, arg3)
    if err then
        showUsage(player, err)

        local lowered = string.lower(err)
        if string.find(lowered, 'outpost', 1, true) then
            listOutposts(player)
        elseif string.find(lowered, 'nation', 1, true) then
            listNations(player)
        end

        return
    end

    if resolvedAction == 'check' then
        reportUnlocks(player, target, nationFilter)
        return
    end

    if resolvedAction == 'add' then
        doAdd(player, target, outpostName, nationFilter)
    else
        doReset(player, target, outpostName, nationFilter)
    end

    if target:getID() ~= player:getID() then
        target:printToPlayer(
            'Your outpost teleport unlocks have been updated by a GM.',
            xi.msg.channel.SYSTEM_3
        )
    end
end

return commandObj
