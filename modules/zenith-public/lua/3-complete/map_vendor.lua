-- -----------------------------------
-- Map Vendor Module
--
-- This module overrides the default behaviour of map vendors.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('map_vendor')

local function getMapEventParams(player)
    local paramTable = { 0, 0, 0 }
    local currentRegion = player:getZone():getRegionID()

    for mapId = 0, #xi.maps.mapInfo do
        local mapEntry = xi.maps.mapInfo[mapId]
        local paramPos = math.floor((mapId) / 32) + 1
        local displayMap = true

        -- Remove all maps that should not be sold
        if mapEntry[2] == -1 then
            displayMap = false

        -- Check if the player has the key item for this map
        -- remove from the vendor if player already has it
        elseif player:hasKeyItem(mapEntry[1]) then
            displayMap = false

        -- Check if the current region is allowed to sell this map
        else
            local regionAllowed = false
            if mapEntry[3] ~= nil then
                -- If the map entry has a region list, check if the current region is in that list
                for _, region in ipairs(mapEntry[3]) do
                    if region == currentRegion then
                        regionAllowed = true
                        break
                    end
                end
            end

            -- If the region is not allowed, remove from the vendor
            if not regionAllowed then
                displayMap = false
            end
        end

        if not displayMap then
            paramTable[paramPos] = bit.bor(paramTable[paramPos], bit.lshift(1, mapId))
        end
    end

    return paramTable
end

m:addOverride('xi.maps.onTrigger', function(player, npc)
    local eventParams = getMapEventParams(player)

    player:startEvent(xi.maps.mapVendors[npc:getName()], eventParams[1], eventParams[2], eventParams[3])
end)

m:addOverride('xi.maps.onEventUpdate', function(player, csid, option, npc)
    if csid ~= xi.maps.mapVendors[npc:getName()] then
        return
    end

    local mapId = bit.rshift(option, 16)

    if
        mapId >= 0 and
        mapId <= #xi.maps.mapInfo and
        bit.band(option, 0xF) == 1
    then
        local mapCost = xi.maps.mapInfo[mapId][2]

        if mapCost <= player:getGil() then
            player:delGil(mapCost)
            npcUtil.giveKeyItem(player, xi.maps.mapInfo[mapId][1])
        else
            player:messageSpecial(zones[player:getZoneID()].text.NOT_HAVE_ENOUGH_GIL)
        end
    end

    player:updateEvent(unpack(getMapEventParams(player)))
end)

return m
