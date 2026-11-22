-- ZenithXI !erascalingtest command (modules/zenith-public/lua/4-additive/commands/erascalingtest.lua).
--
-- A Zenith diagnostic command (GM level 5) that LSB does not have: it recomputes DEF, ATT and ACC
-- from the era stat-scaling formulas of the C++ era scaling patch and prints a PASS/FAIL report
-- for self or a named player. Kept light: the cases check the report reaches the GM, names the
-- right target and level, and that an unarmed level 75 player's DEF matches the era formula
-- (the ATT/ACC checks are skipped without a weapon). The cases type the command as a client
-- does (0x0B5 chat starting with '!').

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

describe('Zenith erascalingtest command', function()
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
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
        player:setGMLevel(5)
    end)

    it('reports the era scaling checks for an unarmed level 75 player', function()
        assert(player:getEquippedItem(xi.slot.MAIN) == nil, 'precondition: the new player has a main weapon')

        local lines = say(player, '!erascalingtest')

        local expected =
        {
            '============ Era Scaling Test (C++) ============',
            string.format('Target: %s | Level: 75', player:getName()),
            '  [PASS] DEF matches exactly!',
            '  [SKIP] No main weapon equipped',
            'SUMMARY: 3/3 tests PASSED (ALL PASSED)',
            -- VIT -> DEF scales 0.50 below level 37 to 1.00 at 75
            '  VIT->DEF: 1.000 (0.50 @ L<37, 1.00 @ L75+)',
        }

        for _, line in ipairs(expected) do
            assert(hasLine(lines, line), string.format('missing line "%s" (lines: %s)', line, table.concat(lines, ' / ')))
        end
    end)

    it('reports on a named player', function()
        local other = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 30 })

        local lines = say(player, string.format('!erascalingtest %s', other:getName()))

        local header = string.format('Target: %s | Level: 30', other:getName())
        assert(hasLine(lines, header), string.format('missing line "%s" (lines: %s)', header, table.concat(lines, ' / ')))
        assert(hasLine(lines, '  VIT->DEF: 0.500 (0.50 @ L<37, 1.00 @ L75+)'), string.format('missing the level 30 VIT->DEF multiplier (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('is refused below GM level 5', function()
        assert(xi.commands.erascalingtest, 'the !erascalingtest command is not registered')
        player:setGMLevel(4)
        local lines = say(player, '!erascalingtest')
        assert(not hasLine(lines, '============ Era Scaling Test (C++) ============'), 'a level 4 GM ran the level 5 command')

        -- the same line works at level 5, so the refusal above is the permission check
        player:setGMLevel(5)
        lines = say(player, '!erascalingtest')
        assert(hasLine(lines, '============ Era Scaling Test (C++) ============'), 'precondition: !erascalingtest printed nothing at GM level 5')
    end)
end)
