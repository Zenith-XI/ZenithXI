-- ZenithXI Bagotrix, Mog Satchel vendor (modules/zenith-public/lua/4-additive/npc/jeuno/[LQS]bagotrix.lua).
--
-- An LQS NPC in Upper Jeuno (dynamic entity DE_Bagotrix; LSB has no such NPC) sells the 80 slot
-- Mog Satchel for 1,000,000 gil minus 37,000 per nation rank above 1, never below 1,000.
-- Triggering him plays about 10.5 s of timed LQS dialog, then opens a custom menu, which the
-- test answers with the 0x0B6 tell the client sends. LQS blocks a second dialog for 3 s after
-- the first one ends, so a case that triggers twice waits that out.
--
-- That same 3 s lock ([LQS]BLOCKING) is still held when the menu opens, and LQS.event drops any
-- dialog started under it, so a player who answered at once used to get no reply (the sale still
-- went through, silently, and a refusal said nothing). The module releases the lock when the
-- menu is answered; the "answered at once" cases answer while the lock is held and check the
-- reply's first line reaches LQS's chat output (player:fmt).
--
-- LQS dialog is timed chat lines, so the server used to release the player (0x052) the moment
-- they talked to him and they could walk off mid-pitch (ZXIALPHA-89). The module holds them in an
-- NPC sequence until the menu opens or the "already have one" answer ends, then freezes them
-- while the menu is open and until his answer to it ends. A talk dropped under the LQS lock must
-- still be released at once, or the player would be held with nothing to let them go.
--
-- xi_test links xi_map_core but not the module C++ (modules/LQS/cpp/lqs_util.cpp is built into
-- xi_map only), so LQS's entity bindings (fmt, sys, ceFace, ceReset, ...) do not exist here and
-- LQS.event stops at its first npc:ceFace(). They only print dialog and turn the NPC, so the file
-- gives the missing ones no-op stand-ins for its own run and removes them afterwards.

local ffi = require('ffi')

ffi.cdef [[
    // 0x0B6 - tell, which is also how the client answers a custom menu (recipient _CUSTOM_MENU)
    typedef struct {
        uint16_t id : 9;
        uint16_t size : 7;
        uint16_t sync;
        uint8_t  unknown04;
        uint8_t  unknown05;
        uint8_t  sName[15];
        uint8_t  Mes[128];
    } ZENITH_BAGOTRIX_MENU_REPLY;
]]

describe('Zenith Bagotrix Mog Satchel vendor', function()
    ---@type CClientEntityPair
    local player

    local npcName = 'DE_Bagotrix'
    local buy     = 'Yes, purchase Mog Satchel'

    local lqsBindings = { 'fmt', 'sys', 'ceFace', 'ceReset' }
    local standIns    = {}

    setup(function()
        for _, name in ipairs(lqsBindings) do
            if _G.CBaseEntity[name] == nil then
                _G.CBaseEntity[name] = function()
                end

                table.insert(standIns, name)
            end
        end
    end)

    teardown(function()
        for _, name in ipairs(standIns) do
            _G.CBaseEntity[name] = nil
        end
    end)

    -- Pick a menu option by its label, the way the client reports the choice
    local function answerMenu(choice)
        local packet = ffi.new('ZENITH_BAGOTRIX_MENU_REPLY')
        packet.unknown04 = 3 -- the server rejects tells without it
        ffi.copy(packet.sName, '_CUSTOM_MENU')
        ffi.copy(packet.Mes, string.format('GMTELL(_CUSTOM_MENU): Question(menu): Result (%s)', choice))
        player.packets:send(0x0B6, packet, ffi.sizeof(packet))
        xi.test.world:skipTime(1)
    end

    local function waitSeconds(seconds)
        for _ = 1, math.ceil(seconds / 2) do
            xi.test.world:skipTime(2)
        end
    end

    -- Trigger Bagotrix and wait for his dialog to reach the purchase menu
    local function talkToBagotrix()
        player.entities:gotoAndTrigger(npcName)
        waitSeconds(12)
    end

    -- Trigger Bagotrix and step time only until the purchase menu opens, so the answer comes at once
    local function talkUntilMenu()
        local menu = spy('CBaseEntity.customMenu')

        player.entities:gotoAndTrigger(npcName)

        for _ = 1, 15 do
            if #menu.calls > 0 then
                break
            end

            xi.test.world:skipTime(1)
        end

        assert(#menu.calls > 0, 'precondition: the purchase menu never opened')
        assert(player:getLocalVar('[LQS]BLOCKING') == 1, 'precondition: the menu should open while LQS still holds its dialog lock')
    end

    -- Did LQS print a chat line containing this text?
    local function said(chat, text)
        for _, call in ipairs(chat.calls) do
            for _, arg in pairs(call.args) do
                if
                    type(arg) == 'string' and
                    string.find(arg, text, 1, true)
                then
                    return true
                end
            end
        end

        return false
    end

    -- Has the server sent the 0x052 that lets the client go after talking to an NPC?
    local function released()
        for _, pkt in ipairs(player.packets:getIncoming()) do
            if pkt.type == 0x052 then
                return true
            end
        end

        return false
    end

    -- The value of the latest setFreezeFlag call, or nil if there was none
    local function frozen(freeze)
        local last = freeze.calls[#freeze.calls]

        return last and last.args[2]
    end

    local function setRanks(sandoria, bastok, windurst)
        for nation, rank in pairs({ [xi.nation.SANDORIA] = sandoria, [xi.nation.BASTOK] = bastok, [xi.nation.WINDURST] = windurst }) do
            player:setNation(nation)
            player:setRank(rank)
        end

        assert(player:getRank(xi.nation.SANDORIA) == sandoria and player:getRank(xi.nation.BASTOK) == bastok and player:getRank(xi.nation.WINDURST) == windurst, 'precondition: nation ranks set')
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })
        player.events:expectNotInEvent()

        local found = GetZone(xi.zone.UPPER_JEUNO):queryEntitiesByName(npcName)
        assert(found ~= nil and #found > 0, 'Bagotrix (DE_Bagotrix) is not in Upper Jeuno: the LQS vendor module did not load')
        assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 0, string.format('precondition: no Mog Satchel, size is %d', player:getContainerSize(xi.inv.MOGSATCHEL)))
    end)

    local prices =
    {
        -- 1,000,000 - 37,000 * ((S - 1) + (B - 1) + (W - 1))
        { ranks = { 1, 1, 1 },    price = 1000000 },
        { ranks = { 10, 5, 1 },   price = 519000 }, -- 13 ranks above 1
        { ranks = { 10, 10, 10 }, price = 1000 },   -- 27 ranks, 1,000,000 - 999,000
    }

    for _, case in ipairs(prices) do
        it(string.format('sells the Mog Satchel for %d gil at ranks %d/%d/%d', case.price, case.ranks[1], case.ranks[2], case.ranks[3]), function()
            setRanks(case.ranks[1], case.ranks[2], case.ranks[3])
            player:setGil(1000000)

            talkToBagotrix()
            answerMenu(buy)

            local paid = 1000000 - player:getGil()
            assert(paid == case.price, string.format('expected to pay %d gil, paid %d', case.price, paid))
            assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 80, string.format('expected an 80 slot Mog Satchel, size is %d', player:getContainerSize(xi.inv.MOGSATCHEL)))
        end)
    end

    it('refuses the sale without enough gil and sells once the gil is there', function()
        setRanks(10, 5, 1) -- price 519,000
        player:setGil(518999)

        talkToBagotrix()
        answerMenu(buy)

        assert(player:getGil() == 518999, string.format('gil changed without a sale: %d', player:getGil()))
        assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 0, 'the Mog Satchel was granted without enough gil')

        -- Let LQS release the dialog lock, then buy for real so the refusal above is not just "nothing happened"
        waitSeconds(4)
        player:setGil(519000)

        talkToBagotrix()
        answerMenu(buy)

        assert(player:getGil() == 0, string.format('expected 519000 gil to be taken, %d left', player:getGil()))
        assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 80, string.format('expected an 80 slot Mog Satchel, size is %d', player:getContainerSize(xi.inv.MOGSATCHEL)))
    end)

    it('thanks the player for a purchase answered as soon as the menu opens', function()
        setRanks(10, 5, 1) -- price 519,000
        player:setGil(519000)

        talkUntilMenu()

        local chat = spy('CBaseEntity.fmt')
        answerMenu(buy)
        xi.test.world:skipTime(1)

        assert(player:getGil() == 0, string.format('expected 519000 gil to be taken, %d left', player:getGil()))
        assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 80, string.format('expected an 80 slot Mog Satchel, size is %d', player:getContainerSize(xi.inv.MOGSATCHEL)))
        assert(said(chat, 'Good business with uplander'), string.format('no follow-up dialog after a quick purchase: LQS dropped the thank-you (%d chat lines)', #chat.calls))
    end)

    it('tells the player he lacks gil when the menu is answered as soon as it opens', function()
        setRanks(10, 5, 1) -- price 519,000
        player:setGil(518999)

        talkUntilMenu()

        local chat = spy('CBaseEntity.fmt')
        answerMenu(buy)
        xi.test.world:skipTime(1)

        assert(player:getGil() == 518999, string.format('gil changed without a sale: %d', player:getGil()))
        assert(player:getContainerSize(xi.inv.MOGSATCHEL) == 0, 'the Mog Satchel was granted without enough gil')
        assert(said(chat, 'pockets empty'), string.format('no follow-up dialog after a quick answer: LQS dropped the "not enough gil" refusal (%d chat lines)', #chat.calls))
    end)

    it('holds the player through his pitch and keeps them frozen until he answers the menu', function()
        setRanks(1, 1, 1)
        local menu   = spy('CBaseEntity.customMenu')
        local freeze = spy('CBaseEntity.setFreezeFlag')

        player.packets:clear()
        player.entities:gotoAndTrigger(npcName)
        assert(not released(), 'the player was let go as soon as they talked to Bagotrix, so they can walk off mid-pitch')

        for _ = 1, 15 do
            if #menu.calls > 0 then
                break
            end

            assert(not released(), 'the player was let go before the purchase menu opened')
            xi.test.world:skipTime(1)
        end

        assert(#menu.calls > 0, 'precondition: the purchase menu never opened')
        assert(released(), 'the player was still held in the NPC talk when the menu opened, and the client drops a menu sent during an event')
        assert(frozen(freeze) == true, 'the player was not frozen while the purchase menu is open')

        answerMenu('No thanks')
        assert(frozen(freeze) == true, 'the player was unfrozen before Bagotrix finished answering "No thanks"')

        waitSeconds(6)
        assert(frozen(freeze) == false, 'the player was still frozen after Bagotrix finished answering "No thanks"')
    end)

    it('holds the player through his "already have a satchel" answer, then lets go', function()
        player:changeContainerSize(xi.inv.MOGSATCHEL, 80)

        player.packets:clear()
        player.entities:gotoAndTrigger(npcName)
        assert(not released(), 'the player was let go as soon as they talked to Bagotrix, so they can walk off mid-answer')

        waitSeconds(6)
        assert(released(), 'the player was never let go after the "already have a satchel" answer')
    end)

    it('unfreezes a player who closes the menu and lets go at once of a talk LQS drops', function()
        setRanks(1, 1, 1)
        local freeze = spy('CBaseEntity.setFreezeFlag')

        talkUntilMenu()
        answerMenu('Canceled.')
        assert(frozen(freeze) == false, 'the player stayed frozen after closing the purchase menu')
        assert(player:getLocalVar('[LQS]BLOCKING') == 1, 'precondition: LQS still holds its dialog lock after the menu was closed')

        -- LQS plays nothing for this talk, so nothing would ever release a sequence started for it
        player.packets:clear()
        player.entities:gotoAndTrigger(npcName)
        assert(released(), 'talking to Bagotrix under the LQS dialog lock left the player held with nothing to let them go')
    end)
end)
