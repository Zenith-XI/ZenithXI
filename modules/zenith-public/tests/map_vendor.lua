-- ZenithXI map vendors (modules/zenith-public/lua/3-complete/map_vendor.lua, ZXIALPHA-40).
--
-- The client's vanilla map menu prints every price from its own DATs, so LSB's menu showed
-- prices the server did not charge (Map of Qufim Island: shown 600, charged 3,000). The module
-- replaces that menu event with a custom menu (a GM prompt) built from xi.maps.mapInfo
-- (1-enum/xi/maps.lua): one '<name>: <price> gil' option per map the vendor's region sells and the
-- player does not own, split into pages that each fit the 150 byte chat packet. A choice is
-- checked again on the server, charges the mapInfo price, gives the key item and opens the menu
-- again. The player is frozen while the menu is open.
-- Vendors used: Ludwig (Mhaura, Kolshushu), Rusese (Upper Jeuno, Jeuno), Karine (Bastok Markets,
-- Bastok). Without the module every case fails on "started the vanilla menu event".
--
-- The client answers a custom menu with a 0x0B6 tell to _CUSTOM_MENU, and the test sends the same.
-- xi_test does not link the LQS module C++ (modules/LQS/cpp/lqs_util.cpp), so the LQS bindings the
-- greeting uses get no-op stand-ins for this file's run, as in lqs_bagotrix.lua.

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
    } ZENITH_MAP_VENDOR_MENU_REPLY;
]]

describe('Zenith map vendor', function()
    ---@type CClientEntityPair
    local player
    ---@type CSpy
    local menus

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

    before_each(function()
        menus = spy('CBaseEntity.customMenu')
    end)

    -- Answer the open menu the way the client does, then let the next menu arrive
    local function sendMenuReply(result)
        local packet = ffi.new('ZENITH_MAP_VENDOR_MENU_REPLY')
        packet.unknown04 = 3 -- the server rejects tells without it
        ffi.copy(packet.sName, '_CUSTOM_MENU')
        ffi.copy(packet.Mes, string.format('GMTELL(_CUSTOM_MENU): Question(menu): Result (%s)', result))
        player.packets:send(0x0B6, packet, ffi.sizeof(packet))
        xi.test.world:skipTime(1)
    end

    local function choose(label)
        sendMenuReply(label)
    end

    local function cancelMenu()
        sendMenuReply('Canceled.')
    end

    -- The menu table of the latest customMenu call
    local function lastMenu()
        local call = menus.calls[#menus.calls]
        if call == nil then
            return nil
        end

        for _, arg in pairs(call.args) do
            if type(arg) == 'table' and arg.options ~= nil then
                return arg
            end
        end

        return nil
    end

    local function labelsOf(menu)
        local labels = {}
        for _, option in ipairs(menu.options) do
            table.insert(labels, option[1])
        end

        return labels
    end

    local function hasLabel(menu, label)
        for _, text in ipairs(labelsOf(menu)) do
            if text == label then
                return true
            end
        end

        return false
    end

    -- Talk to the vendor and return the menu that opens
    local function openMenu(npcName)
        player.packets:clear()
        menus:clear()
        player.entities:gotoAndTrigger(npcName)

        for _, pkt in pairs(player.packets:getIncoming()) do
            assert(pkt.type ~= 0x034, string.format('%s started the vanilla menu event, whose prices come from the client', npcName))
        end

        local menu = lastMenu()
        assert(menu ~= nil, string.format('%s did not open the map menu', npcName))

        return menu
    end

    -- Every menu page the vendor shows, from the first, following (Next); the menu is left open
    local function allPages(npcName)
        local pages = { openMenu(npcName) }

        while hasLabel(pages[#pages], '(Next)') do
            local before = #menus.calls
            choose('(Next)')
            assert(#menus.calls > before, 'precondition: (Next) opened the next page')
            table.insert(pages, lastMenu())
        end

        return pages
    end

    local function anyPageHas(pages, label)
        for _, page in ipairs(pages) do
            if hasLabel(page, label) then
                return true
            end
        end

        return false
    end

    -- Open the vendor's menu and page forward to the one offering this label
    local function openMenuAt(npcName, label)
        for _, page in ipairs(allPages(npcName)) do
            if hasLabel(page, label) then
                -- The pages were followed to the end, so start again and stop on the right one
                local menu = openMenu(npcName)
                while not hasLabel(menu, label) do
                    choose('(Next)')
                    menu = lastMenu()
                end

                return menu
            end
        end

        assert(false, string.format('precondition: no page offers %s', label))
    end

    describe('in Mhaura (Ludwig)', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
            assert(GetPlayerByID(player:getID()):getZone():getRegionID() == xi.region.KOLSHUSHU, 'precondition: Mhaura is in Kolshushu')
        end)

        it('opens a server-built menu instead of the vanilla menu event', function()
            openMenu('Ludwig')
            cancelMenu()
        end)

        it('lists only the maps Kolshushu sells, with the server\'s price', function()
            local pages = allPages('Ludwig')
            cancelMenu()

            assert(anyPageHas(pages, 'San d\'Oria Area: 200 gil'), 'Ludwig does not offer the San d\'Oria Area map for 200 gil')
            assert(not anyPageHas(pages, 'Ordelle\'s Caves: 600 gil'), 'Ludwig offers Ordelle\'s Caves, which only San d\'Oria sells')
            assert(not anyPageHas(pages, 'Northlands Area: 3,000 gil'), 'Ludwig offers the Northlands Area map, which is not for sale')
        end)

        it('freezes the player while the menu is open and lets them go when it is closed', function()
            local freeze = spy('CBaseEntity.setFreezeFlag')

            openMenu('Ludwig')
            local opened = freeze.calls[#freeze.calls]
            assert(opened ~= nil and opened.args[#opened.args] == true, 'the player was not frozen while the menu is open')

            cancelMenu()
            local closed = freeze.calls[#freeze.calls]
            assert(closed.args[#closed.args] == false, 'the player stayed frozen after closing the menu')
        end)
    end)

    describe('in Upper Jeuno (Rusese)', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.UPPER_JEUNO })
            assert(GetPlayerByID(player:getID()):getZone():getRegionID() == xi.region.JEUNO, 'precondition: Upper Jeuno is in the Jeuno region')
        end)

        it('sells the three nation-area maps and charges 3,000 gil for Qufim Island', function()
            local pages = allPages('Rusese')
            cancelMenu()

            for _, label in ipairs({ 'San d\'Oria Area: 200 gil', 'Bastok Area: 200 gil', 'Windurst Area: 200 gil', 'Jeuno Area: 600 gil' }) do
                assert(anyPageHas(pages, label), string.format('Rusese does not offer "%s"', label))
            end

            -- The vanilla menu showed 600 gil for this map while the server charged 3,000
            assert(anyPageHas(pages, 'Qufim Island: 3,000 gil'), 'Rusese does not offer Qufim Island for 3,000 gil')
        end)

        it('fits every menu page in one chat packet', function()
            local pages = allPages('Rusese')
            cancelMenu()

            assert(#pages > 1, string.format('precondition: Rusese\'s maps span more than one page, got %d', #pages))

            for pageNum, page in ipairs(pages) do
                -- The title and every option are sent in quotes, in a 150 byte message
                local size = #page.title + 2
                for _, label in ipairs(labelsOf(page)) do
                    size = size + #label + 2
                end

                assert(size <= 150, string.format('page %d takes %d bytes, more than the 150 the packet holds', pageNum, size))
            end
        end)
    end)

    describe('in Bastok Markets (Karine)', function()
        local beadeaux = 'Beadeaux: 3,000 gil'

        before_each(function()
            player = xi.test.world:spawnPlayer()
            player:gotoZone(xi.zone.BASTOK_MARKETS)

            -- Zoning into Bastok Markets plays event 22 first
            player.events:finish(22)
        end)

        it('sells Map of Beadeaux for 3,000 gil and opens the menu again without it', function()
            player:setGil(5000)
            openMenuAt('Karine', beadeaux)

            local before = #menus.calls
            choose(beadeaux)

            assert(player:hasKeyItem(xi.keyItem.MAP_OF_BEADEAUX), 'the map was not given')
            assert(player:getGil() == 2000, string.format('expected 2000 gil left, got %d', player:getGil()))
            assert(#menus.calls > before, 'the menu did not open again after the purchase')
            assert(not hasLabel(lastMenu(), beadeaux), 'the menu still offers the map just bought')

            cancelMenu()
        end)

        it('does not offer a map the player owns', function()
            player:addKeyItem(xi.keyItem.MAP_OF_BEADEAUX)

            local pages = allPages('Karine')
            cancelMenu()

            assert(anyPageHas(pages, 'Bastok Area: 200 gil'), 'precondition: Karine offers the Bastok Area map')
            assert(not anyPageHas(pages, beadeaux), 'Karine offers the Beadeaux map the player owns')
        end)

        it('does not sell a map the player got after the menu opened', function()
            player:setGil(5000)
            openMenuAt('Karine', beadeaux)

            player:addKeyItem(xi.keyItem.MAP_OF_BEADEAUX)
            choose(beadeaux)

            assert(player:getGil() == 5000, string.format('Karine charged %d gil for a map the player already owns', 5000 - player:getGil()))
            cancelMenu()
        end)

        it('does not sell without enough gil', function()
            player:setGil(100)
            openMenuAt('Karine', beadeaux)

            choose(beadeaux)

            assert(not player:hasKeyItem(xi.keyItem.MAP_OF_BEADEAUX), 'the map was given without enough gil')
            assert(player:getGil() == 100, 'gil changed on a refused purchase')
            cancelMenu()
        end)

        it('does not offer a map priced -1', function()
            local palborough = xi.maps.mapInfo[9]
            local price      = palborough[2]

            palborough[2] = -1
            local pages = allPages('Karine')
            cancelMenu()
            palborough[2] = price

            assert(anyPageHas(pages, 'Bastok Area: 200 gil'), 'precondition: Karine offers the Bastok Area map')
            assert(not anyPageHas(pages, 'Palborough Mines: -1 gil'), 'Karine offers a map priced -1')
            assert(not anyPageHas(pages, 'Palborough Mines: 600 gil'), 'Karine offers the Palborough map while it is priced -1')
        end)
    end)
end)
