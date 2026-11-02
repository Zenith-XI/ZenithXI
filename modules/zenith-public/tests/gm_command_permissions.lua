-- ZenithXI GM command permissions (modules/zenith-public/lua/2-base/gm_command_permissions.lua).
--
-- From xi.server.onServerStart, after every module file has loaded, the module rewrites
-- cmdprops.permission of every command in xi.commands (LSB's scripts/commands, LQS/commands and
-- the zenith-public / zenith-private module commands) from its own table, and makes any command
-- missing from that table admin only (level 5). Deltas used here, LSB -> Zenith:
--   geteffects 1 -> 0, checkinteraction 5 -> 1, gettp / getfamily / return 1 -> 5.
-- lfp and clearquestbonus are 4-additive module commands, registered after this 2-base module
-- loads, so their rows check that the table reaches module commands too. Their table levels equal
-- their own, so the cases that call the module's pass (applyCommandPermissions, found as an upvalue
-- of its onServerStart override) are what fail if the pass goes back to running at load time.
-- The end-to-end cases type the command the way a client does (0x0B5 chat starting with '!'),
-- so CCommandHandler::call does the permission check against the player's GM level.

local ffi = require('ffi')

-- ffi.cdef is global to the run and other Zenith command tests declare the same struct
if not pcall(ffi.typeof, 'ZENITH_GP_CLI_COMMAND_CHAT_STD') then
    ffi.cdef [[
        // 0x0B5 - say/shout/party chat; a message starting with '!' is a command
        typedef struct {
            uint16_t id : 9;
            uint16_t size : 7;
            uint16_t sync;
            uint8_t  Kind;
            uint8_t  unknown00;
            uint8_t  Str[128];
        } ZENITH_GP_CLI_COMMAND_CHAT_STD;
    ]]
end

describe('Zenith GM command permissions', function()
    ---@type CClientEntityPair
    local player

    -- Text of every 0x017 chat line (printToPlayer) the server sent since the last clear
    local function chatLines(who)
        local lines = {}
        for _, pkt in ipairs(who.packets:getIncoming()) do
            if pkt.type == 0x017 then
                local chars = {}
                for i = 23, pkt.size - 1 do
                    local byte = pkt.data[i]
                    if byte == nil or byte == 0 then
                        break
                    end

                    table.insert(chars, string.char(byte))
                end

                table.insert(lines, table.concat(chars))
            end
        end

        return lines
    end

    -- Type a chat line as the client would, and return what came back to the player
    local function say(who, text)
        who.packets:clear()

        local packet = ffi.new('ZENITH_GP_CLI_COMMAND_CHAT_STD')
        packet.Kind  = 0 -- say
        ffi.copy(packet.Str, text)
        who.packets:send(0x0B5, packet, ffi.sizeof(packet))

        return chatLines(who)
    end

    local function hasLine(lines, wanted)
        for _, line in ipairs(lines) do
            if line == wanted then
                return true
            end
        end

        return false
    end

    -- Upvalue 'wanted' of fn, or nil
    local function upvalue(fn, wanted)
        for i = 1, 60 do
            local name, value = debug.getupvalue(fn, i)
            if name == nil then
                return nil
            end

            if name == wanted then
                return value
            end
        end

        return nil
    end

    -- The module's permission pass, from its xi.server.onServerStart override in the override chain
    local function permissionPass()
        local fn = xi.server.onServerStart
        while type(fn) == 'function' do
            local pass = upvalue(fn, 'applyCommandPermissions')
            if pass then
                return pass
            end

            fn = rawget(getfenv(fn), 'super')
        end

        return nil
    end

    local noPassMessage = 'gm_command_permissions.lua has no applyCommandPermissions pass on xi.server.onServerStart, so commands registered after it loads keep their own level'

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
    end)

    it('lists every loaded command in its table', function()
        local pass = permissionPass()
        assert(pass, noPassMessage)

        local listed = upvalue(pass, 'commandPermissions')
        assert(type(listed) == 'table', 'precondition: applyCommandPermissions has no commandPermissions table')

        local missing = {}
        for cmdName, cmd in pairs(xi.commands) do
            if type(cmd) == 'table' and cmd.cmdprops and listed[cmdName] == nil then
                table.insert(missing, cmdName)
            end
        end

        table.sort(missing)
        assert(#missing == 0, string.format('commands missing from gm_command_permissions.lua (they fall back to level 5): %s', table.concat(missing, ', ')))
    end)

    it('applies its table to a command registered after it loads (!lfp, 4-additive)', function()
        local cmd = xi.commands['lfp']
        assert(cmd and cmd.cmdprops, 'precondition: !lfp is not a loaded command')

        local pass   = permissionPass()
        local before = cmd.cmdprops.permission

        cmd.cmdprops.permission = 3
        if pass then
            pass()
        end

        local after = cmd.cmdprops.permission
        cmd.cmdprops.permission = before

        assert(pass, noPassMessage)
        assert(after == 0, string.format('!lfp permission after the pass: expected 0, got %s', tostring(after)))
    end)

    it('makes a command missing from its table admin only', function()
        local probeName = 'zenithpermissionprobe'
        assert(xi.commands[probeName] == nil, 'precondition: the probe command name is already taken')

        local pass = permissionPass()
        xi.commands[probeName] =
        {
            cmdprops  = { permission = 0, parameters = '' },
            onTrigger = function()
            end,
        }

        if pass then
            pass()
        end

        local after = xi.commands[probeName].cmdprops.permission
        xi.commands[probeName] = nil

        assert(pass, noPassMessage)
        assert(after == 5, string.format('unlisted probe command permission: expected 5, got %s', tostring(after)))
    end)

    -- What the module's table says, compared with LSB's own cmdprops for the same command
    local expectedLevels =
    {
        { name = 'geteffects',       level = 0, lsb = 1 },
        { name = 'checkinteraction', level = 1, lsb = 5 },
        { name = 'gettp',            level = 5, lsb = 1 },
        { name = 'getfamily',        level = 5, lsb = 1 },
        { name = 'return',           level = 5, lsb = 1 },
        { name = 'lfp',              level = 0, lsb = 0 },
        { name = 'clearquestbonus',  level = 4, lsb = 4 },
    }

    for _, row in ipairs(expectedLevels) do
        it(string.format('sets !%s to GM level %d (LSB: %d)', row.name, row.level, row.lsb), function()
            local cmd = xi.commands[row.name]
            assert(cmd and cmd.cmdprops, string.format('precondition: !%s is not a loaded command', row.name))

            local actual = cmd.cmdprops.permission
            assert(actual == row.level, string.format('!%s permission: expected %d, got %s', row.name, row.level, tostring(actual)))
        end)
    end

    it('lets a level 0 player use !geteffects', function()
        player:setGMLevel(0)
        assert(#player:getStatusEffects() == 0, 'precondition: the new player already has status effects')

        local lines = say(player, '!geteffects')
        local reply = string.format('%s has no active effects.', player:getName())
        assert(hasLine(lines, reply), string.format('a level 0 player got no !geteffects reply (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('lets a level 1 GM use !checkinteraction', function()
        player:setGMLevel(1)

        local lines = say(player, '!checkinteraction')
        assert(hasLine(lines, 'No valid handler targeted or handler name given.'), string.format('a level 1 GM got no !checkinteraction reply (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('keeps an admin only command (!gettp) from a level 4 GM', function()
        player:setGMLevel(4)
        local lines = say(player, '!gettp')
        assert(not hasLine(lines, 'Player TP: 0'), 'a level 4 GM ran !gettp, which the module makes admin only')

        -- the same command does answer at level 5, so the silence above is the permission check
        player:setGMLevel(5)
        lines = say(player, '!gettp')
        assert(hasLine(lines, 'Player TP: 0'), string.format('precondition: !gettp did not answer a level 5 GM (lines: %s)', table.concat(lines, ' / ')))
    end)
end)
