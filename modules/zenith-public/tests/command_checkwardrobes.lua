-- ZenithXI !checkwardrobes command (modules/zenith-public/lua/4-additive/commands/checkwardrobes.lua).
--
-- A Zenith command (GM level 1) that LSB does not have: run the wardrobe unlock check of
-- 3-complete/wardrobeUnlocks.lua for self or a named player, award what is pending, and list the
-- unlocks per bag. The cases make "Reach Level 5" and "Reach Level 10" (Mog Wardrobe 2, one slot
-- each) pending by raising the level with setLevel, which does not run the level-up hook that
-- would award them, after shrinking the stock 80-slot bag so the award can show. They type the
-- command as a client does (0x0B5 chat starting with '!').

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

describe('Zenith checkwardrobes command', function()
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

    -- A level 1 character with nothing pending, then raised to 10 behind the unlock system's back
    local function spawnWithPendingLevelUnlocks()
        local who = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        assert(xi.wardrobeUnlocks and xi.wardrobeUnlocks.checkAllUnlocks, 'precondition: the wardrobe unlock system (wardrobeUnlocks.lua) is not loaded')

        who:setLevel(10)

        -- A test character starts with the stock 80-slot bags, which an award cannot grow past
        who:changeContainerSize(xi.inv.WARDROBE2, -10)

        local size = who:getContainerSize(xi.inv.WARDROBE2)
        assert(size + 2 <= 80, string.format('precondition: Mog Wardrobe 2 is too large (%d) to grow by 2', size))

        return who, size
    end

    it('awards pending unlocks on self and lists them', function()
        local size
        player, size = spawnWithPendingLevelUnlocks()
        player:setGMLevel(1)

        local lines = say(player, '!checkwardrobes')

        local newSize = player:getContainerSize(xi.inv.WARDROBE2)
        assert(newSize == size + 2, string.format('Mog Wardrobe 2: expected %d slots after the check, got %d (lines: %s)', size + 2, newSize, table.concat(lines, ' / ')))

        local expected =
        {
            string.format('Wardrobe Unlocks for %s', player:getName()),
            '  * Reach Level 5 (+1)',
            '  * Reach Level 10 (+1)',
            'Newly awarded: 2',
        }

        for _, line in ipairs(expected) do
            assert(hasLine(lines, line), string.format('missing line "%s" (lines: %s)', line, table.concat(lines, ' / ')))
        end

        assert(not hasLine(lines, '  * Reach Level 15 (+1)'), 'listed "Reach Level 15" as completed at level 10')
    end)

    it('awards nothing new the second time', function()
        local size
        player, size = spawnWithPendingLevelUnlocks()
        player:setGMLevel(1)

        say(player, '!checkwardrobes')
        local lines = say(player, '!checkwardrobes')

        local newSize = player:getContainerSize(xi.inv.WARDROBE2)
        assert(newSize == size + 2, string.format('Mog Wardrobe 2: expected %d slots after two checks, got %d', size + 2, newSize))
        assert(hasLine(lines, '  * Reach Level 10 (+1)'), string.format('the second check no longer lists "Reach Level 10" (lines: %s)', table.concat(lines, ' / ')))
        assert(not hasLine(lines, 'Newly awarded: 2'), 'the second check awarded the same unlocks again')
    end)

    it('checks a named player', function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setGMLevel(1)

        local other, size = spawnWithPendingLevelUnlocks()
        local gmSize = player:getContainerSize(xi.inv.WARDROBE2)

        local lines = say(player, string.format('!checkwardrobes %s', other:getName()))

        assert(other:getContainerSize(xi.inv.WARDROBE2) == size + 2, string.format('the named player\'s Mog Wardrobe 2 did not grow by 2 (lines: %s)', table.concat(lines, ' / ')))
        assert(player:getContainerSize(xi.inv.WARDROBE2) == gmSize, 'the GM\'s own Mog Wardrobe 2 changed')

        local header = string.format('Wardrobe Unlocks for %s', other:getName())
        assert(hasLine(lines, header), string.format('missing header "%s" (lines: %s)', header, table.concat(lines, ' / ')))
    end)

    it('reports a player name that is not online', function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        player:setGMLevel(1)

        local lines = say(player, '!checkwardrobes Nobodyhere')

        assert(hasLine(lines, 'Player named "Nobodyhere" not found!'), string.format('missing the not-found error (lines: %s)', table.concat(lines, ' / ')))
        assert(hasLine(lines, '!checkwardrobes (player)'), string.format('missing the usage line (lines: %s)', table.concat(lines, ' / ')))
    end)

    it('is refused to a regular player', function()
        assert(xi.commands.checkwardrobes, 'the !checkwardrobes command is not registered')
        local size
        player, size = spawnWithPendingLevelUnlocks()
        player:setGMLevel(0)

        say(player, '!checkwardrobes')
        assert(player:getContainerSize(xi.inv.WARDROBE2) == size, 'a level 0 player ran the level 1 command')

        -- the same line works at level 1, so the refusal above is the permission check
        player:setGMLevel(1)
        say(player, '!checkwardrobes')
        assert(player:getContainerSize(xi.inv.WARDROBE2) == size + 2, 'precondition: !checkwardrobes did nothing at GM level 1')
    end)
end)
