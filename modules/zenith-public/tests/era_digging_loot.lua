-- ZenithXI era chocobo digging loot (modules/zenith-public/lua/3-complete/era_digging_loot.lua, through the
-- xi.chocoboDig.rollLayer accessor added by git-patches/118-ChocoboDigLayerHook.patch).
--
-- The regular layer rolls Phoenix's weighted pool and the treasure layer drops nothing. Burrow, Bore and everything
-- outside the two layers stay LSB's.
--
-- LSB's own scripts/tests/systems/chocobo_raising/digging.lua fails while the module is loaded, as intended: it swaps
-- in its own East Ronfaure rows, and the module rolls Phoenix's pool there instead (ZENITHDEV-273).

describe('Zenith era chocobo digging loot', function()
    local layer = xi.chocoboDig.layer
    local rank
    local weather
    local hour
    local moonCycle
    local accuracyRoll
    local selected

    -- Out-of-era finds that LSB keeps on its treasure layers. None of them is in a Phoenix pool.
    local outOfEraItems =
    {
        xi.item.PLATE_OF_HEAVY_METAL,
        xi.item.COIN_OF_BIRTH,
        xi.item.COIN_OF_GLORY,
        xi.item.COIN_OF_DECAY,
        xi.item.COIN_OF_ADVANCEMENT,
        xi.item.ONE_BYNE_BILL,
        xi.item.ORDELLE_BRONZEPIECE,
        xi.item.TUKUKU_WHITESHELL,
        xi.item.ALEXANDRITE,
    }

    local player =
    {
        getSkillRank = function()
            return rank
        end,

        getWeather = function()
            return weather
        end,

        getName = function()
            return 'Digger'
        end,

        getMod = function()
            return 0
        end,
    }

    local function weightOf(itemId)
        for _, entry in ipairs(selected) do
            if entry.itemId == itemId then
                return entry.weight
            end
        end

        return 0
    end

    before_each(function()
        rank         = xi.craftRank.AMATEUR
        weather      = xi.weather.NONE
        hour         = 12
        moonCycle    = xi.moonCycle.FULL_MOON
        accuracyRoll = 1
        selected     = nil

        stub('VanadielHour', function()
            return hour
        end)

        stub('getVanadielMoonCycle', function()
            return moonCycle
        end)

        stub('VanadielDayOfTheWeek', xi.day.FIRESDAY)

        stub('math.randomInt', function(low, high)
            if high == 100 then
                return accuracyRoll
            end

            return low
        end)

        local selectFromLootGroups = utils.selectFromLootGroups

        stub('utils.selectFromLootGroups', function(actor, groups)
            selected = groups[1]

            return selectFromLootGroups(actor, groups)
        end)
    end)

    it('has an item and eleven weights in every row', function()
        for zoneId, rows in pairs(xi.chocoboDig.zoneTable) do
            for index, row in ipairs(rows) do
                assert(#row == 12 and type(row[1]) == 'number', string.format('zone %d row %d is broken', zoneId, index))
            end
        end
    end)

    it('uses the weights of the digging rank', function()
        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.CHUNK_OF_IRON_ORE) == 145, 'wrong Iron Ore weight at Amateur')

        rank = xi.craftRank.EXPERT
        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.CHUNK_OF_IRON_ORE) == 365, 'wrong Iron Ore weight at Expert')
    end)

    it('picks by weight', function()
        assert(xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.PEBBLE, 'the first roll should pick the first row')
    end)

    it('finds nothing when the accuracy roll fails', function()
        accuracyRoll = xi.chocoboDig.accuracy[rank] + 1

        assert(xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR) == 0, 'found an item')
        assert(selected == nil, 'rolled the pool')
    end)

    it('finds an item when the accuracy roll matches the rank', function()
        accuracyRoll = xi.chocoboDig.accuracy[rank]

        assert(xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR) > 0, 'found nothing')
    end)

    it('drops nothing from the treasure layer', function()
        rank = xi.craftRank.EXPERT -- LSB's treasure rows need Adept, so a lower rank finds nothing either way

        assert(xi.chocoboDig.rollLayer(player, xi.zone.BIBIKI_BAY, layer.TREASURE) == 0, 'the treasure layer dropped an item')
        assert(selected == nil, 'rolled a pool')
    end)

    it('only digs up seeds at night', function()
        xi.chocoboDig.rollLayer(player, xi.zone.EAST_RONFAURE, layer.REGULAR)
        assert(weightOf(xi.item.BAG_OF_FRUIT_SEEDS) == 0, 'seeds were in the daytime pool')

        hour = 22
        xi.chocoboDig.rollLayer(player, xi.zone.EAST_RONFAURE, layer.REGULAR)
        assert(weightOf(xi.item.BAG_OF_FRUIT_SEEDS) == 25, 'seeds were not in the night pool')
    end)

    it('adds crystals and clusters from the weather', function()
        weather = xi.weather.HOT_SPELL
        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.FIRE_CRYSTAL) == 440, 'wrong crystal weight')

        weather = xi.weather.HEAT_WAVE
        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.FIRE_CLUSTER) == 80, 'wrong cluster weight')
    end)

    it('adds the elemental ore under active weather on a waxing crescent', function()
        rank    = xi.craftRank.EXPERT
        weather = xi.weather.HOT_SPELL

        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.CHUNK_OF_FIRE_ORE) == 0, 'ore was in the pool under the wrong moon')

        moonCycle = xi.moonCycle.LESSER_WAXING_CRESCENT
        xi.chocoboDig.rollLayer(player, xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(weightOf(xi.item.CHUNK_OF_FIRE_ORE) == 80, 'wrong ore weight')
    end)

    it('keeps the out-of-era finds out of every zone', function()
        assert(xi.chocoboDig.zoneTable, 'precondition: no Phoenix pools, so the module is not loaded')
        rank = xi.craftRank.EXPERT

        for zoneId, rows in pairs(xi.chocoboDig.zoneTable) do
            local found = xi.chocoboDig.rollLayer(player, zoneId, layer.TREASURE)
            assert(found == 0, string.format('zone %d: the treasure layer dropped item %d', zoneId, found))

            for _, row in ipairs(rows) do
                for _, itemId in ipairs(outOfEraItems) do
                    assert(row[1] ~= itemId, string.format('zone %d: out-of-era item %d is in the pool', zoneId, itemId))
                end
            end
        end
    end)

    -- Pin case: it passes with or without the module. It fails if the module stops handing Burrow and Bore to LSB.
    it('leaves the Burrow and Bore layers to LSB', function()
        local zoneTable = xi.chocoboDig.digInfo[xi.zone.EAST_RONFAURE]
        rank            = xi.craftRank.EXPERT

        for _, digLayer in ipairs({ layer.BURROW, layer.BORE }) do
            local expected = zoneTable[digLayer][1][1]
            local found    = xi.chocoboDig.rollLayer(player, xi.zone.EAST_RONFAURE, digLayer)

            assert(found == expected, string.format('layer %d: expected LSB item %d, got %d', digLayer, expected, found))
            assert(selected == nil, string.format('layer %d rolled a Phoenix pool', digLayer))
        end
    end)

    -- Goes in through xi.chocoboDig.start, so it fails if LSB stops calling the rollLayer hook.
    -- Every roll is its lowest value: LSB would give its first East Ronfaure row (Little Worm), Phoenix gives Acorn.
    it('gives a real dig from the Phoenix pool', function()
        xi.test.world:setSetting('main.DIG_FATIGUE', 100)

        local digger = xi.test.world:spawnPlayer({ zone = xi.zone.EAST_RONFAURE })
        digger:setLocalVar('ZoneInTime', 0)
        digger:setLocalVar('[DIG]LastDigTime', 0)
        digger:setLocalVar('[DIG]LastXPos', 5000)
        digger:setLocalVar('[DIG]LastXPosSign', 0)
        xi.chocoboDig.updateFatigue(digger, 0)

        local entity = GetPlayerByID(digger:getID())
        assert(entity, 'precondition: the digger is not in the zone')
        assert(xi.chocoboDig.start(entity), 'the dig did not go ahead')

        assert(digger:hasItem(xi.item.ACORN), 'expected Acorn from the Phoenix pool')
        assert(not digger:hasItem(xi.item.LITTLE_WORM), 'got Little Worm from LSB\'s rows')
        assert(xi.chocoboDig.fetchFatigue(digger) == 1, string.format('expected one dig counted, got %d', xi.chocoboDig.fetchFatigue(digger)))
    end)
end)
