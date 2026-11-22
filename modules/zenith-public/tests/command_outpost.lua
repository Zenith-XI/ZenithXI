-- ZenithXI !outpost command (modules/zenith-public/lua/4-additive/commands/outpost.lua).
--
-- A Zenith command (GM level 1) that LSB does not have: add / reset / check a player's outpost
-- teleport unlocks per nation. An outpost is bit (region + 5) of the nation's outpost teleport
-- type, the same bit conquest.lua reads.
-- reset calls target:clearTeleport(type[, bit]), a binding added by cpp/clear_teleport_binding.cpp.
-- xi_test does not link module C++ (only xi_map does), so the reset cases record the calls through
-- a Lua stand-in and check those; the bits themselves are checked only when the binding exists.
-- The cases type the command as a client does (0x0B5 chat starting with '!') and read the
-- printToPlayer replies (0x017) back.

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

describe('Zenith outpost command', function()
    ---@type CClientEntityPair
    local player

    local realClearTeleport
    local clearCalls

    local sandoria = xi.teleport.type.OUTPOST_SANDORIA
    local bastok   = xi.teleport.type.OUTPOST_BASTOK
    local windurst = xi.teleport.type.OUTPOST_WINDURST

    -- Every region with an outpost, as the command names them
    local outposts =
    {
        { name = 'ronfaure',         region = xi.region.RONFAURE },
        { name = 'zulkheim',         region = xi.region.ZULKHEIM },
        { name = 'norvallen',        region = xi.region.NORVALLEN },
        { name = 'gustaberg',        region = xi.region.GUSTABERG },
        { name = 'derfland',         region = xi.region.DERFLAND },
        { name = 'sarutabaruta',     region = xi.region.SARUTABARUTA },
        { name = 'kolshushu',        region = xi.region.KOLSHUSHU },
        { name = 'aragoneu',         region = xi.region.ARAGONEU },
        { name = 'fauregandi',       region = xi.region.FAUREGANDI },
        { name = 'valdeaunia',       region = xi.region.VALDEAUNIA },
        { name = 'qufim',            region = xi.region.QUFIM_ISLAND },
        { name = 'litelor',          region = xi.region.LITELOR },
        { name = 'kuzotz',           region = xi.region.KUZOTZ },
        { name = 'vollbow',          region = xi.region.VOLLBOW },
        { name = 'elshimo_lowlands', region = xi.region.ELSHIMO_LOWLANDS },
        { name = 'elshimo_uplands',  region = xi.region.ELSHIMO_UPLANDS },
        { name = 'tulia',            region = xi.region.TULIA },
        { name = 'movalpolos',       region = xi.region.MOVALPOLOS },
        { name = 'tavnazia',         region = xi.region.TAVNAZIAN_ARCHIPELAGO },
    }

    local function hasOutpost(who, nationType, region)
        assert(region ~= nil, 'precondition: an xi.region name this test uses is nil, LSB renamed a region enum again')

        return who:hasTeleport(nationType, region + 5)
    end

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
        xi.test.world:skipTime(1) -- clear LSB's 200 ms chat rate limit, or a second command is dropped unread
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

    local function hasLineStarting(lines, prefix)
        for _, line in ipairs(lines) do
            if string.sub(line, 1, #prefix) == prefix then
                return true
            end
        end

        return false
    end

    -- Calls of clearTeleport on this player
    local function clearsOf(who)
        local calls = {}
        for _, call in ipairs(clearCalls) do
            if call.id == who:getID() then
                table.insert(calls, call)
            end
        end

        return calls
    end

    before_each(function()
        -- Record clearTeleport, passing through to the C++ binding when this binary has it
        realClearTeleport = _G.CBaseEntity.clearTeleport
        clearCalls        = {}
        _G.CBaseEntity.clearTeleport = function(self, teleType, bitval)
            table.insert(clearCalls, { id = self:getID(), type = teleType, bit = bitval })
            if realClearTeleport then
                realClearTeleport(self, teleType, bitval)
            end
        end

        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setGMLevel(1)

        for _, nationType in ipairs({ sandoria, bastok, windurst }) do
            for _, outpost in ipairs(outposts) do
                assert(not hasOutpost(player, nationType, outpost.region), string.format('precondition: a new player already has outpost %s', outpost.name))
            end
        end
    end)

    after_each(function()
        _G.CBaseEntity.clearTeleport = realClearTeleport
    end)

    it('is registered as a GM level 1 command', function()
        local cmd = xi.commands.outpost
        assert(cmd and cmd.cmdprops, 'the !outpost command is not registered')
        assert(cmd.cmdprops.permission == 1, string.format('!outpost permission: expected 1, got %s', tostring(cmd.cmdprops.permission)))
    end)

    it('unlocks one outpost for one nation', function()
        local lines = say(player, '!outpost add ronfaure sandoria')

        assert(hasOutpost(player, sandoria, xi.region.RONFAURE), string.format('!outpost add ronfaure sandoria did not unlock Ronfaure for San d\'Oria (lines: %s)', table.concat(lines, ' / ')))
        assert(not hasOutpost(player, bastok, xi.region.RONFAURE), 'the San d\'Oria-only unlock also unlocked Ronfaure for Bastok')
        assert(not hasOutpost(player, windurst, xi.region.RONFAURE), 'the San d\'Oria-only unlock also unlocked Ronfaure for Windurst')
        assert(not hasOutpost(player, sandoria, xi.region.ZULKHEIM), 'the Ronfaure-only unlock also unlocked Zulkheim')

        local reply = string.format('Unlocked outpost "ronfaure" (region %d) for %s (Sandoria).', xi.region.RONFAURE, player:getName())
        assert(hasLine(lines, reply), string.format('missing confirmation "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    it('unlocks every outpost for all three nations by default', function()
        local lines = say(player, '!outpost add')

        for _, nationType in ipairs({ sandoria, bastok, windurst }) do
            for _, outpost in ipairs(outposts) do
                assert(hasOutpost(player, nationType, outpost.region), string.format('!outpost add left %s locked for teleport type %d (lines: %s)', outpost.name, nationType, table.concat(lines, ' / ')))
            end
        end

        local reply = string.format('Unlocked ALL outposts for %s (all nations).', player:getName())
        assert(hasLine(lines, reply), string.format('missing confirmation "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    -- LSB renamed xi.region.QUFIMISLAND / TAVNAZIANARCH to QUFIM_ISLAND / TAVNAZIAN_ARCHIPELAGO
    -- ("Port Region to YAML based enum"); the command's table must follow the new names.
    it('knows the Qufim and Tavnazia outposts', function()
        assert(xi.region.QUFIM_ISLAND and xi.region.TAVNAZIAN_ARCHIPELAGO, 'precondition: LSB renamed the Qufim/Tavnazia region enums again')

        local lines = say(player, '!outpost add qufim bastok')
        assert(hasOutpost(player, bastok, xi.region.QUFIM_ISLAND), string.format('!outpost add qufim bastok did not unlock Qufim (lines: %s)', table.concat(lines, ' / ')))

        lines = say(player, '!outpost add tavnazia bastok')
        assert(hasOutpost(player, bastok, xi.region.TAVNAZIAN_ARCHIPELAGO), string.format('!outpost add tavnazia bastok did not unlock Tavnazia (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('locks one outpost across all nations and keeps the rest', function()
        say(player, '!outpost add')
        assert(hasOutpost(player, windurst, xi.region.RONFAURE), 'precondition: !outpost add did not unlock Ronfaure')

        local lines = say(player, '!outpost reset ronfaure')

        -- one single-bit clear per nation, for Ronfaure's bit
        local calls = clearsOf(player)
        assert(#calls == 3, string.format('expected 3 clearTeleport calls, got %d (lines: %s)', #calls, table.concat(lines, ' / ')))
        for i, nationType in ipairs({ sandoria, bastok, windurst }) do
            assert(calls[i].type == nationType and calls[i].bit == xi.region.RONFAURE + 5, string.format('clearTeleport call %d: expected (%d, %d), got (%s, %s)', i, nationType, xi.region.RONFAURE + 5, tostring(calls[i].type), tostring(calls[i].bit)))
        end

        if realClearTeleport then
            for _, nationType in ipairs({ sandoria, bastok, windurst }) do
                assert(not hasOutpost(player, nationType, xi.region.RONFAURE), string.format('!outpost reset ronfaure left Ronfaure unlocked for teleport type %d', nationType))
                assert(hasOutpost(player, nationType, xi.region.ZULKHEIM), string.format('!outpost reset ronfaure also locked Zulkheim for teleport type %d', nationType))
            end
        end

        local reply = string.format('Locked outpost "ronfaure" (region %d) for %s (all nations).', xi.region.RONFAURE, player:getName())
        assert(hasLine(lines, reply), string.format('missing confirmation "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    it('resets every outpost of one nation only', function()
        say(player, '!outpost add')

        local lines = say(player, '!outpost reset windy')

        -- one whole-field clear (no bit) of Windurst's outpost type only
        local calls = clearsOf(player)
        assert(#calls == 1, string.format('expected 1 clearTeleport call, got %d (lines: %s)', #calls, table.concat(lines, ' / ')))
        assert(calls[1].type == windurst and calls[1].bit == nil, string.format('clearTeleport: expected (%d, nil), got (%s, %s)', windurst, tostring(calls[1].type), tostring(calls[1].bit)))

        if realClearTeleport then
            for _, outpost in ipairs(outposts) do
                assert(not hasOutpost(player, windurst, outpost.region), string.format('!outpost reset windy left %s unlocked for Windurst', outpost.name))
                assert(hasOutpost(player, sandoria, outpost.region), string.format('!outpost reset windy also locked %s for Sandoria', outpost.name))
            end
        end

        local reply = string.format('Reset ALL outpost unlocks for %s (Windurst).', player:getName())
        assert(hasLine(lines, reply), string.format('missing confirmation "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    it('lists the unlocked outposts per nation', function()
        say(player, '!outpost add derfland bastok')
        say(player, '!outpost add ronfaure bastok')

        local lines = say(player, '!outpost check bastok')

        local header = string.format('Outpost unlocks for %s (Bastok):', player:getName())
        assert(hasLine(lines, header), string.format('missing header "%s" (lines: %s)', header, table.concat(lines, ' / ')))
        assert(hasLine(lines, '  Bastok: derfland, ronfaure'), string.format('!outpost check bastok did not list "derfland, ronfaure" (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('changes another player by name and tells them', function()
        local other = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        other.packets:clear()

        local lines = say(player, string.format('!outpost add %s gustaberg', other:getName()))

        assert(hasOutpost(other, bastok, xi.region.GUSTABERG), string.format('the named player did not get Gustaberg (lines: %s)', table.concat(lines, ' / ')))
        assert(not hasOutpost(player, bastok, xi.region.GUSTABERG), 'the GM got the unlock meant for the named player')
        assert(hasLine(chatLines(other), 'Your outpost teleport unlocks have been updated by a GM.'), 'the named player was not told about the change')
    end)

    it('rejects two outpost names and lists the valid ones', function()
        local lines = say(player, '!outpost add ronfaure zulkheim')

        assert(not hasOutpost(player, sandoria, xi.region.RONFAURE), 'a rejected command still unlocked Ronfaure')
        assert(hasLine(lines, 'Two outposts given ("ronfaure" and "zulkheim").'), string.format('missing the two-outposts error (lines: %s)', table.concat(lines, ' / ')))
        assert(hasLineStarting(lines, 'Valid outpost names: '), string.format('the error did not list the valid outposts (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('rejects an unknown action with the usage line', function()
        local lines = say(player, '!outpost frobnicate')

        assert(hasLine(lines, 'Unknown action "frobnicate".'), string.format('missing the unknown-action error (lines: %s)', table.concat(lines, ' / ')))
        assert(hasLine(lines, 'Usage: !outpost <add|reset|check> [player] [outpost_name] [nation]'), string.format('missing the usage line (lines: %s)', table.concat(lines, ' / ')))
    end)
end)
