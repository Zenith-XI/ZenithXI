-- ZenithXI !lfp command (modules/zenith-public/lua/4-additive/commands/lfp.lua).
--
-- A Zenith command open to every player (level 0) that toggles the Looking for Party flag. The
-- retail client refuses /seekparty while trusts are out; the command sets the flag server side
-- through player:setSeekingParty(value), a binding added by cpp/lfp_with_trusts.cpp.
-- xi_test does not link module C++ (only xi_map does), so when the binding is missing the cases
-- stand it in with the client's own /seekparty packet (0x0DC, player.actions:setSeekingParty).
-- That covers the Lua command (level, toggle direction, replies), not the C++ binding itself.
-- The cases type the command as a client does (0x0B5 chat starting with '!').

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

describe('Zenith lfp command', function()
    ---@type CClientEntityPair
    local player

    local realSetSeekingParty
    local seekCalls

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

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setGMLevel(0)
        assert(not player:isSeekingParty(), 'precondition: a new player is already seeking a party')

        -- Record setSeekingParty; use the C++ binding when this binary has it
        realSetSeekingParty = _G.CBaseEntity.setSeekingParty
        seekCalls           = {}
        _G.CBaseEntity.setSeekingParty = function(self, value)
            table.insert(seekCalls, value)
            if realSetSeekingParty then
                return realSetSeekingParty(self, value)
            end

            player.actions:setSeekingParty(value)
            return true
        end
    end)

    after_each(function()
        _G.CBaseEntity.setSeekingParty = realSetSeekingParty
    end)

    it('is registered for every player', function()
        local cmd = xi.commands.lfp
        assert(cmd and cmd.cmdprops, 'the !lfp command is not registered')
        assert(cmd.cmdprops.permission == 0, string.format('!lfp permission: expected 0, got %s', tostring(cmd.cmdprops.permission)))
    end)

    it('toggles seeking a party on and off for a regular player', function()
        local lines = say(player, '!lfp')
        assert(seekCalls[1] == true, string.format('the first !lfp did not ask for setSeekingParty(true) (lines: %s)', table.concat(lines, ' / ')))
        assert(player:isSeekingParty(), 'the first !lfp did not turn the LFP flag on')
        assert(hasLine(lines, 'You are now seeking a party.'), string.format('missing the "now seeking" reply (lines: %s)', table.concat(lines, ' / ')))

        lines = say(player, '!lfp')
        assert(seekCalls[2] == false, string.format('the second !lfp did not ask for setSeekingParty(false) (lines: %s)', table.concat(lines, ' / ')))
        assert(not player:isSeekingParty(), 'the second !lfp did not turn the LFP flag off')
        assert(hasLine(lines, 'You are no longer seeking a party.'), string.format('missing the "no longer seeking" reply (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('says so when the flag cannot be changed', function()
        _G.CBaseEntity.setSeekingParty = function()
            return false
        end

        local lines = say(player, '!lfp')
        assert(hasLine(lines, 'Failed to change party status.'), string.format('missing the failure reply (lines: %s)', table.concat(lines, ' / ')))
        assert(not hasLine(lines, 'You are now seeking a party.'), 'reported success although setSeekingParty refused')
    end)
end)
