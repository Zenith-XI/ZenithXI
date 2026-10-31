-- ZenithXI map tables (modules/zenith-public/lua/1-enum/xi/maps.lua).
--
-- Base keeps its map vendor tables local to scripts/globals/maps.lua. The enum module publishes
-- them as xi.maps.mapVendors (vendor name -> vanilla menu event) and xi.maps.mapInfo (menu index
-- -> key item, cost, regions sold in, menu name), with -1 marking a map that is not for sale. The
-- menu index is the client's bit position, so each index must keep base's key item. c_map_vendor
-- (3-complete/map_vendor.lua) builds its menu from these tables; tests/map_vendor.lua covers that.

describe('Zenith map tables', function()
    local function requireTables()
        assert(xi.maps.mapVendors ~= nil, 'xi.maps.mapVendors is not defined: 1-enum/xi/maps.lua did not load')
        assert(xi.maps.mapInfo ~= nil, 'xi.maps.mapInfo is not defined: 1-enum/xi/maps.lua did not load')
    end

    local function soldIn(entry, region)
        for _, r in ipairs(entry[3] or {}) do
            if r == region then
                return true
            end
        end

        return false
    end

    it('lists the menu event of each map vendor', function()
        requireTables()

        local expected = { Ludwig = 500, Karine = 210, Rex = 115, Riyadahf = 563, Promurouve = 10000 }
        for name, eventId in pairs(expected) do
            local actual = xi.maps.mapVendors[name]
            assert(actual == eventId, string.format('expected xi.maps.mapVendors.%s = %d, got %s', name, eventId, tostring(actual)))
        end
    end)

    it('keeps base\'s key item at each menu index, from 0 to 71', function()
        requireTables()

        assert(#xi.maps.mapInfo == 71, string.format('expected menu indexes up to 71, got %d', #xi.maps.mapInfo))

        local expected =
        {
            [0]  = xi.keyItem.MAP_OF_THE_SAN_DORIA_AREA,
            [4]  = xi.keyItem.MAP_OF_ORDELLES_CAVES,
            [20] = xi.keyItem.MAP_OF_THE_NORTHLANDS_AREA,
            [33] = xi.keyItem.MAP_OF_THE_RUAUN_GARDENS,
            [58] = xi.keyItem.MAP_OF_AL_ZAHBI,
            [71] = xi.keyItem.MAP_OF_FORT_KARUGO_NARUGO,
        }
        for index, keyItem in pairs(expected) do
            local entry = xi.maps.mapInfo[index]
            assert(entry ~= nil and entry[1] == keyItem, string.format('xi.maps.mapInfo[%d] is not key item %d', index, keyItem))
        end
    end)

    it('prices maps and limits them to the regions that sell them', function()
        requireTables()

        local sandoria = xi.maps.mapInfo[0]
        assert(sandoria[2] == 200, string.format('expected the San d\'Oria Area map at 200 gil, got %d', sandoria[2]))
        assert(soldIn(sandoria, xi.region.KOLSHUSHU), 'the San d\'Oria Area map is not sold in Kolshushu')
        assert(not soldIn(xi.maps.mapInfo[4], xi.region.KOLSHUSHU), 'the Ordelle\'s Caves map is sold in Kolshushu')
        assert(xi.maps.mapInfo[20][2] == -1, 'the Northlands Area map is for sale; expected cost -1')

        -- Expansion maps follow the setting the server started with
        local alZahbi = xi.settings.main.ENABLE_TOAU == 1 and 600 or -1
        assert(xi.maps.mapInfo[58][2] == alZahbi, string.format('expected the Al Zahbi map at %d, got %d', alZahbi, xi.maps.mapInfo[58][2]))
    end)

    it('sells the three nation-area maps in Jeuno', function()
        requireTables()

        for index = 0, 2 do
            assert(soldIn(xi.maps.mapInfo[index], xi.region.JEUNO), string.format('xi.maps.mapInfo[%d] is not sold in Jeuno', index))
        end
    end)

    it('gives every map a menu name', function()
        requireTables()

        for index = 0, #xi.maps.mapInfo do
            local name = xi.maps.mapInfo[index].name
            assert(type(name) == 'string' and #name > 0, string.format('xi.maps.mapInfo[%d] has no menu name', index))
        end

        assert(xi.maps.mapInfo[10].name == 'Beadeaux', string.format('expected index 10 named Beadeaux, got %s', tostring(xi.maps.mapInfo[10].name)))
    end)
end)
