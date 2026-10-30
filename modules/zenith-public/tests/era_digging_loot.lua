-- ZenithXI era chocobo digging loot (modules/zenith-public/lua/3-complete/era_digging_loot.lua).
--
-- The regular digging layer of the zones with historical data uses the historical items, the other layers and
-- the zones without data keep LSB's. Seeds are only in the pool at night.

describe('Zenith era chocobo digging loot', function()
    local function regularPool(zoneId)
        local items = {}

        for _, row in ipairs(xi.chocoboDig.digInfo[zoneId][xi.chocoboDig.layer.REGULAR]) do
            items[row[1]] = row
        end

        return items
    end

    it('uses the historical pool in Batallia Downs', function()
        local pool = regularPool(xi.zone.BATALLIA_DOWNS)

        assert(pool[xi.item.PEBBLE], 'Pebble is not in the pool')
        assert(pool[xi.item.PEBBLE][2] == 100, 'Pebble has the wrong chance')
        assert(pool[xi.item.REISHI_MUSHROOM], 'Reishi Mushroom is not in the pool')
        assert(pool[xi.item.REISHI_MUSHROOM][3] == xi.craftRank.VETERAN, 'Reishi Mushroom has the wrong rank')
    end)

    it('uses the historical pool in Carpenters\' Landing', function()
        assert(regularPool(xi.zone.CARPENTERS_LANDING)[xi.item.LITTLE_WORM], 'Little Worm is not in the pool')
    end)

    it('leaves items out of the pool that the historical data does not have', function()
        assert(not regularPool(xi.zone.BATALLIA_DOWNS)[xi.item.SCREAM_FUNGUS], 'Scream Fungus is in the pool')
    end)

    it('leaves a zone without historical data alone', function()
        assert(next(regularPool(xi.zone.XARCABARD)) == nil, 'Xarcabard got a regular pool')
    end)

    it('leaves the treasure layer alone', function()
        local layer = xi.chocoboDig.digInfo[xi.zone.CARPENTERS_LANDING][xi.chocoboDig.layer.TREASURE]

        assert(layer[1][1] == xi.item.KING_TRUFFLE, 'the treasure layer changed')
    end)

    describe('seeds in East Ronfaure', function()
        local function fruitSeedChance(hour)
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.EAST_RONFAURE })

            stub('VanadielHour', hour)
            stub('xi.chocoboDig.fetchFatigue', 1000000)
            xi.chocoboDig.start(GetPlayerByID(player:getID()))

            return regularPool(xi.zone.EAST_RONFAURE)[xi.item.BAG_OF_FRUIT_SEEDS][2]
        end

        it('are out of the pool by day', function()
            assert(fruitSeedChance(12) == 0, 'seeds can be dug up by day')
        end)

        it('are in the pool at night', function()
            assert(fruitSeedChance(22) > 0, 'seeds cannot be dug up at night')
        end)
    end)
end)
