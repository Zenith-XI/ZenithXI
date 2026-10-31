-- ZenithXI era chocobo digging loot (modules/zenith-public/lua/3-complete/era_digging_loot.lua).
--
-- The regular digging pools swap items to match the historical pools. Everything else stays LSB's.

describe('Zenith era chocobo digging loot', function()
    local function regularPool(zoneId)
        local items = {}

        for _, row in ipairs(xi.chocoboDig.digInfo[zoneId][xi.chocoboDig.layer.REGULAR]) do
            items[row[1]] = row
        end

        return items
    end

    it('removes items from a pool', function()
        local pool = regularPool(xi.zone.NORTH_GUSTABERG)

        assert(not pool[xi.item.CHUNK_OF_MYTHRIL_ORE], 'Mythril Ore is in the pool')
        assert(not pool[xi.item.BAG_OF_CACTUS_STEMS], 'Cactus Stems are in the pool')
    end)

    it('adds items to a pool', function()
        local row = regularPool(xi.zone.CARPENTERS_LANDING)[xi.item.KING_TRUFFLE]

        assert(row, 'King Truffle is not in the pool')
    end)

    it('keeps the chance and rank of an item in both pools', function()
        local row = regularPool(xi.zone.CARPENTERS_LANDING)[xi.item.LITTLE_WORM]

        assert(row[2] == 100, 'the chance changed')
        assert(row[3] == xi.craftRank.AMATEUR, 'the rank changed')
    end)

    it('leaves a zone that needs no changes alone', function()
        assert(next(regularPool(xi.zone.LA_THEINE_PLATEAU)), 'La Theine Plateau lost its pool')
    end)

    it('leaves the treasure layer alone', function()
        local layer = xi.chocoboDig.digInfo[xi.zone.CARPENTERS_LANDING][xi.chocoboDig.layer.TREASURE]

        assert(layer[1][1] == xi.item.KING_TRUFFLE, 'the treasure layer changed')
    end)
end)
