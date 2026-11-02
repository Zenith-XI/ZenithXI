-- ZenithXI era chocobo digging loot (modules/zenith-public/lua/3-complete/era_digging_loot.lua, through the
-- xi.chocoboDig.rollLayer accessor added by git-patches/118-ChocoboDigLayerHook.patch).
--
-- The treasure and regular layers use Phoenix's weighted pools. Everything else stays LSB's.

describe('Zenith era chocobo digging loot', function()
    local layer = xi.chocoboDig.layer
    local rank
    local weather
    local hour
    local moonCycle
    local accuracyRoll
    local selected

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
end)
