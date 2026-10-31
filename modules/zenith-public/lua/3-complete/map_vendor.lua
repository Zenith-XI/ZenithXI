-- -----------------------------------
-- Map Vendor Module
--
-- The client's vanilla map menu prints each price from its own DATs (a number the event script
-- fills in), and the server cannot change it, so players were shown one price and charged
-- another (ZXIALPHA-40). This module replaces that menu with one the server builds: the vendor
-- turns to the player and greets them (LQS.event), then a menu lists every map the vendor sells
-- that the player does not own yet, with the price from xi.maps.mapInfo (1-enum/xi/maps.lua).
-- After a choice the menu opens again, as the vanilla menu stays open after a purchase.
-- A purchase is checked again on the server when it is chosen.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('c_map_vendor')

-- The whole menu (the title and every option, each in quotes) is sent in one chat packet with
-- room for 150 bytes (GP_SERV_COMMAND_CHAT_STD Mes[150]). Anything past that is cut off.
local menuBytes = 150
local menuTitle = 'Buy a map?'
local prevLabel = '(Prev)'
local nextLabel = '(Next)'

-- Bytes one menu text takes in the packet, quotes included
local function quotedSize(text)
    return #text + 2
end

-- Room left for maps on a page: the longest title and both page buttons are always kept free
local mapBytesPerPage = menuBytes -
    quotedSize(menuTitle .. ' (99/99)') -
    quotedSize(prevLabel) -
    quotedSize(nextLabel)

-- 3000 -> '3,000'
local function formatGil(amount)
    local text = tostring(amount):reverse():gsub('(%d%d%d)', '%1,'):reverse()

    return (text:gsub('^,', ''))
end

-- True when the region is in the map entry's list of regions that sell it
local function isSoldInRegion(mapEntry, region)
    if mapEntry[3] == nil then
        return false
    end

    for _, soldRegion in ipairs(mapEntry[3]) do
        if soldRegion == region then
            return true
        end
    end

    return false
end

-- True when this vendor offers the map to the player: it exists, is for sale (cost above 0),
-- is sold in the vendor's region and the player does not already have its key item.
local function isMapOffered(player, mapEntry, region)
    return mapEntry ~= nil and
        mapEntry[2] > 0 and
        isSoldInRegion(mapEntry, region) and
        not player:hasKeyItem(mapEntry[1])
end

-- The maps this vendor offers the player, in menu index order, each with its menu label
local function getOfferedMaps(player, region)
    local offered = {}

    for mapId = 0, #xi.maps.mapInfo do
        local mapEntry = xi.maps.mapInfo[mapId]

        if isMapOffered(player, mapEntry, region) then
            table.insert(offered, {
                id    = mapId,
                label = string.format('%s: %s gil', mapEntry.name, formatGil(mapEntry[2])),
            })
        end
    end

    return offered
end

-- Split the maps into pages that each fit in one menu packet
local function getPages(offered)
    local pages = { {} }
    local used  = 0

    for _, map in ipairs(offered) do
        local size = quotedSize(map.label)

        if
            used + size > mapBytesPerPage and
            #pages[#pages] > 0
        then
            table.insert(pages, {})
            used = 0
        end

        table.insert(pages[#pages], map)
        used = used + size
    end

    return pages
end

local function buyMap(player, region, mapId)
    local mapEntry = xi.maps.mapInfo[mapId]

    -- Anything the menu would not offer now is ignored: no gil taken, no key item given
    if not isMapOffered(player, mapEntry, region) then
        return
    end

    local mapCost = mapEntry[2]

    if player:getGil() < mapCost then
        player:messageSpecial(zones[player:getZoneID()].text.NOT_HAVE_ENOUGH_GIL)
    elseif player:delGil(mapCost) then
        npcUtil.giveKeyItem(player, mapEntry[1])
    end
end

local showMenu

-- A page is a new menu, sent after a short delay so the answered one is cleared first.
-- A player who has left the zone since the menu opened gets nothing.
local function showMenuDelayed(player, zoneId, region, pageNum)
    player:timer(100, function(playerArg)
        if playerArg:getZoneID() == zoneId then
            showMenu(playerArg, zoneId, region, pageNum)
        end
    end)
end

showMenu = function(player, zoneId, region, pageNum)
    local offered = getOfferedMaps(player, region)

    -- Nothing left to sell, e.g. after buying the last map
    if #offered == 0 then
        return
    end

    local pages   = getPages(offered)
    local page    = math.min(pageNum, #pages)
    local options = {}

    if page > 1 then
        table.insert(options, {
            prevLabel,
            function(playerArg)
                showMenuDelayed(playerArg, zoneId, region, page - 1)
            end,
        })
    end

    for _, map in ipairs(pages[page]) do
        local mapId = map.id

        table.insert(options, {
            map.label,
            function(playerArg)
                if playerArg:getZoneID() == zoneId then
                    buyMap(playerArg, region, mapId)
                    showMenuDelayed(playerArg, zoneId, region, page)
                end
            end,
        })
    end

    if page < #pages then
        table.insert(options, {
            nextLabel,
            function(playerArg)
                showMenuDelayed(playerArg, zoneId, region, page + 1)
            end,
        })
    end

    local title = menuTitle
    if #pages > 1 then
        title = string.format('%s (%d/%d)', menuTitle, page, #pages)
    end

    -- Hold the player like a vanilla vendor menu does. The menu is a GM prompt, not an event, so
    -- nothing else keeps them in place. onEnd runs after every answer and after a cancel; a
    -- choice that opens the next menu freezes them again when it arrives.
    player:setFreezeFlag(true)
    player:customMenu({
        title   = title,
        options = options,
        onEnd   = function(playerArg)
            playerArg:setFreezeFlag(false)
        end,
    })
end

m:addOverride('xi.maps.onTrigger', function(player, npc)
    -- A map vendor this module does not know keeps base's menu
    if xi.maps.mapVendors[npc:getName()] == nil then
        return super(player, npc)
    end

    local region = player:getZone():getRegionID()

    if #getOfferedMaps(player, region) == 0 then
        LQS.event(player, npc, { 'I have no maps left that you need.' })

        return
    end

    LQS.event(player, npc, { 'Interested in a map?' })
    showMenu(player, player:getZoneID(), region, 1)
end)

-- The vanilla menu event is no longer started for these vendors. Ignore any update for it, so
-- base's own price table (scripts/globals/maps.lua) can never sell a map.
m:addOverride('xi.maps.onEventUpdate', function(player, csid, option, npc)
    if xi.maps.mapVendors[npc:getName()] == nil then
        return super(player, csid, option, npc)
    end
end)

return m
