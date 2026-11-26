-- ZenithXI !clearquestbonus command (modules/zenith-public/lua/4-additive/commands/clearquestbonus.lua).
--
-- A Zenith command (GM level 4) that LSB does not have: zero every DailyGilBonus_* char var
-- (the daily double-gil counters of quests/repeatableQuestDoubleRewards.lua) on self or a named
-- player, leaving other char vars alone. The cases type the command as a client does (0x0B5
-- chat starting with '!') and read the printToPlayer replies (0x017) back.

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

describe('Zenith clearquestbonus command', function()
    ---@type CClientEntityPair
    local player

    -- Counter names as repeatableQuestDoubleRewards.lua builds them: DailyGilBonus_<area>_<quest>
    local counterA = 'DailyGilBonus_0_3'
    local counterB = 'DailyGilBonus_1_12'
    local unrelated = 'ZenithTestUnrelatedVar'

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

    local function setCounters(who)
        who:setCharVar(counterA, 1)
        who:setCharVar(counterB, 2)
        who:setCharVar(unrelated, 7)

        assert(who:getCharVar(counterA) == 1 and who:getCharVar(counterB) == 2, 'precondition: the bonus counters were not set')
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setGMLevel(4)
    end)

    it('clears every daily bonus counter on self and nothing else', function()
        setCounters(player)

        local lines = say(player, '!clearquestbonus')

        assert(player:getCharVar(counterA) == 0, string.format('%s: expected 0, got %d', counterA, player:getCharVar(counterA)))
        assert(player:getCharVar(counterB) == 0, string.format('%s: expected 0, got %d', counterB, player:getCharVar(counterB)))
        assert(player:getCharVar(unrelated) == 7, string.format('an unrelated char var was touched: expected 7, got %d', player:getCharVar(unrelated)))

        local reply = string.format('Cleared 2 daily quest bonus counter(s) for %s.', player:getName())
        assert(hasLine(lines, reply), string.format('missing confirmation "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    it('says so when there is nothing to clear', function()
        local lines = say(player, '!clearquestbonus')

        local reply = string.format('No daily quest bonus counters found for %s.', player:getName())
        assert(hasLine(lines, reply), string.format('missing reply "%s" (lines: %s)', reply, table.concat(lines, ' / ')))
    end)

    it('clears a named player and tells them', function()
        local other = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        setCounters(other)
        player:setCharVar(counterA, 1)
        other.packets:clear()

        local lines = say(player, string.format('!clearquestbonus %s', other:getName()))

        assert(other:getCharVar(counterA) == 0 and other:getCharVar(counterB) == 0, string.format('the named player kept their counters (lines: %s)', table.concat(lines, ' / ')))
        assert(player:getCharVar(counterA) == 1, 'the GM\'s own counter was cleared instead of only the named player\'s')
        assert(hasLine(chatLines(other), 'Your daily repeatable quest bonus counters have been reset by a GM.'), 'the named player was not told about the reset')
    end)

    it('reports a player name that is not online', function()
        local lines = say(player, '!clearquestbonus Nobodyhere')

        assert(hasLine(lines, 'Player "Nobodyhere" not found or not online.'), string.format('missing the not-found error (lines: %s)', table.concat(lines, ' / ')))
        assert(hasLine(lines, 'Usage: !clearquestbonus [player]'), string.format('missing the usage line (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('is refused below GM level 4', function()
        assert(xi.commands.clearquestbonus, 'the !clearquestbonus command is not registered')
        setCounters(player)
        player:setGMLevel(3)

        say(player, '!clearquestbonus')
        assert(player:getCharVar(counterA) == 1, 'a level 3 GM cleared the counters of a level 4 command')

        -- the same line works at level 4, so the refusal above is the permission check
        player:setGMLevel(4)
        say(player, '!clearquestbonus')
        assert(player:getCharVar(counterA) == 0, 'precondition: !clearquestbonus did nothing at GM level 4')
    end)
end)
