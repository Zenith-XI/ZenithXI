-- ZenithXI /yell restrictions (git-patches/119-YellLevelRequirement.patch).
--
-- /yell needs a job at level 10, and the cooldown char var holds the time the cooldown ends, so the
-- player is told how long is left. The cooldown length is map.YELL_COOLDOWN, the town-only zone check is LSB's.
-- The cases yell as a client does (0x0B5 chat, kind 0x1A).

local ffi = require('ffi')

-- ffi.cdef is global to the run and other Zenith chat tests declare the same struct
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

describe('Zenith yell restrictions', function()
    local cooldownVar = '[YELL]Cooldown'
    local levelLine   = 'You must reach level 10 on a job before you can yell.'

    -- Text of every 0x017 chat line the server sent since the last clear
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

    local function yell(who, text)
        who.packets:clear()

        local packet = ffi.new('ZENITH_GP_CLI_COMMAND_CHAT_STD')
        packet.Kind  = 0x1A
        ffi.copy(packet.Str, text or 'Selling Rolanberries')
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

    local function waitLine(seconds)
        return string.format('You must wait %d more seconds before you can yell again.', seconds)
    end

    local function spawn(zoneId, level)
        local who = xi.test.world:spawnPlayer({ zone = zoneId, job = xi.job.WAR, level = level })
        who:setGMLevel(0)
        who:setCharVar(cooldownVar, 0)

        return who
    end

    before_each(function()
        xi.test.world:setSetting('map.YELL_COOLDOWN', 300)
    end)

    describe('minimum level', function()
        it('refuses a character whose highest job is level 9', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 9)
            local lines  = yell(player)

            assert(hasLine(lines, levelLine), 'no level explanation')
            assert(player:getCharVar(cooldownVar) == 0, 'a refused yell started the cooldown')
        end)

        it('lets a character with a job at level 10 yell', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 10)
            local lines  = yell(player)

            assert(not hasLine(lines, levelLine), 'a level 10 character was refused')
            assert(player:getCharVar(cooldownVar) == GetSystemTime() + 300, 'the yell did not start a 300 second cooldown')
        end)

        it('counts a job the character is not on', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 10)
            player:changeJob(xi.job.WHM)
            player:setLevel(1)
            assert(player:getMainLvl() == 1, 'precondition: the character is not on a level 1 job')

            yell(player)

            assert(player:getCharVar(cooldownVar) > 0, 'the level 10 Warrior did not count')
        end)
    end)

    describe('cooldown', function()
        it('refuses a second yell and does not extend the cooldown', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 75)
            yell(player)

            local cooldownEnd = player:getCharVar(cooldownVar)
            local lines       = yell(player)

            assert(hasLine(lines, waitLine(cooldownEnd - GetSystemTime())), 'no remaining time message')
            assert(player:getCharVar(cooldownVar) == cooldownEnd, 'the refused yell moved the cooldown')
        end)

        it('refuses a yell after 299 seconds', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 75)
            local now    = GetSystemTime()
            player:setCharVar(cooldownVar, now + 1, now + 1)

            assert(hasLine(yell(player), waitLine(1)), 'a yell at 299 seconds was not refused')
            assert(player:getCharVar(cooldownVar) == now + 1, 'the refused yell moved the cooldown')
        end)

        it('accepts a yell after 300 seconds', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 75)
            local now    = GetSystemTime()
            player:setCharVar(cooldownVar, now, now + 1)

            yell(player)

            assert(player:getCharVar(cooldownVar) == now + 300, 'a yell at 300 seconds was refused')
        end)

        it('keeps the cooldown of each character apart', function()
            local first  = spawn(xi.zone.BASTOK_MARKETS, 75)
            local second = spawn(xi.zone.BASTOK_MARKETS, 75)
            yell(first)

            yell(second)

            assert(second:getCharVar(cooldownVar) > 0, 'one character blocked the other')
        end)

        it('keeps the cooldown after zoning between towns', function()
            local player = spawn(xi.zone.BASTOK_MARKETS, 75)
            yell(player)

            local cooldownEnd = player:getCharVar(cooldownVar)

            -- The first visit to Bastok Markets plays an opening cutscene
            player.events:finish()
            player:gotoZone(xi.zone.BASTOK_MINES)
            assert(player:getZoneID() == xi.zone.BASTOK_MINES, 'precondition: the player did not zone')

            assert(hasLine(yell(player), waitLine(cooldownEnd - GetSystemTime())), 'zoning reset the cooldown')
        end)
    end)

    describe('town-only zones', function()
        it('refuses a yell outside the yell zones', function()
            local player = spawn(xi.zone.WEST_RONFAURE, 75)
            local lines  = yell(player)

            assert(not hasLine(lines, levelLine), 'the level check ran before the zone check')
            assert(player:getCharVar(cooldownVar) == 0, 'a yell outside town started the cooldown')
        end)

        it('allows a yell in another yell zone', function()
            local player = spawn(xi.zone.BASTOK_MINES, 75)
            yell(player)

            assert(player:getCharVar(cooldownVar) > 0, 'Bastok Mines refused the yell')
        end)
    end)
end)
