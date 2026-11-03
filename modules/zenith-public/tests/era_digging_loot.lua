-- ZenithXI era chocobo digging loot (modules/zenith-public/lua/3-complete/era_digging_loot.lua, plus the elemental
-- ore rate in git-patches/118-ChocoboDigLayerHook.patch).
--
-- The module puts Phoenix's historical regular pools into LSB's digInfo rows and empties the treasure layer in those
-- zones. LSB still rolls every row on its own (moon, Receptivity, rank), so the cases below go through LSB's roll
-- via xi.chocoboDig.rollLayer, and one real dig goes through xi.chocoboDig.start.
--
-- Rolls: (1, 1000) is a layer roll, (1, 100) a percent roll, anything else is the pick among the rows that passed.
-- Moon 25 is a roll multiplier of 1; moon 20 is 0.9.

describe('Zenith era chocobo digging loot', function()
    local layer = xi.chocoboDig.layer
    local rank
    local weather
    local zone
    local layerRoll
    local pick

    local historicalZones =
    {
        xi.zone.BATALLIA_DOWNS,        xi.zone.BUBURIMU_PENINSULA,     xi.zone.EAST_RONFAURE,
        xi.zone.EAST_SARUTABARUTA,     xi.zone.JUGNER_FOREST,          xi.zone.KONSCHTAT_HIGHLANDS,
        xi.zone.LA_THEINE_PLATEAU,     xi.zone.MERIPHATAUD_MOUNTAINS,  xi.zone.NORTH_GUSTABERG,
        xi.zone.PASHHOW_MARSHLANDS,    xi.zone.ROLANBERRY_FIELDS,      xi.zone.SAUROMUGUE_CHAMPAIGN,
        xi.zone.SOUTH_GUSTABERG,       xi.zone.TAHRONGI_CANYON,        xi.zone.VALKURM_DUNES,
        xi.zone.WEST_RONFAURE,         xi.zone.WEST_SARUTABARUTA,      xi.zone.EASTERN_ALTEPA_DESERT,
        xi.zone.THE_SANCTUARY_OF_ZITAH, xi.zone.WESTERN_ALTEPA_DESERT, xi.zone.YHOATOR_JUNGLE,
        xi.zone.YUHTUNGA_JUNGLE,       xi.zone.BIBIKI_BAY,             xi.zone.CARPENTERS_LANDING,
        xi.zone.BHAFLAU_THICKETS,      xi.zone.WAJAOM_WOODLANDS,
    }

    -- Out-of-era finds that stock LSB keeps on its treasure layers.
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

        getZoneID = function()
            return zone
        end,

        getMod = function()
            return 0
        end,

        getName = function()
            return 'Digger'
        end,
    }

    local function dig(zoneId, digLayer, chocobo)
        zone = zoneId

        return xi.chocoboDig.rollLayer(player, zoneId, digLayer, chocobo)
    end

    before_each(function()
        rank      = xi.craftRank.EXPERT
        weather   = xi.weather.NONE
        zone      = xi.zone.BATALLIA_DOWNS
        layerRoll = 1
        pick      = 'first'

        stub('VanadielMoonPhase', 25)
        stub('VanadielDayOfTheWeek', xi.day.FIRESDAY)

        stub('math.randomInt', function(low, high)
            if low == 1 and high == 1000 then
                return layerRoll
            end

            if low == 1 and high == 100 then
                return 100
            end

            if pick == 'last' then
                return high
            elseif type(pick) == 'number' then
                return pick
            end

            return low
        end)
    end)

    it('uses the translated Phoenix rows for Batallia Downs', function()
        local expected =
        {
            { xi.item.PEBBLE,                94, xi.craftRank.AMATEUR    },
            { xi.item.FLINT_STONE,           69, xi.craftRank.AMATEUR    },
            { xi.item.BONE_CHIP,             61, xi.craftRank.AMATEUR    },
            { xi.item.CHUNK_OF_COPPER_ORE,   40, xi.craftRank.INITIATE   },
            { xi.item.CHUNK_OF_IRON_ORE,     28, xi.craftRank.APPRENTICE },
            { xi.item.BIRD_FEATHER,          25, xi.craftRank.APPRENTICE },
            { xi.item.RED_JAR,               19, xi.craftRank.JOURNEYMAN },
            { xi.item.PURPLE_ROCK,           15, xi.craftRank.JOURNEYMAN },
            { xi.item.BLACK_CHOCOBO_FEATHER,  4, xi.craftRank.ADEPT      },
            { xi.item.REISHI_MUSHROOM,        2, xi.craftRank.VETERAN    },
        }

        local rows = xi.chocoboDig.digInfo[xi.zone.BATALLIA_DOWNS][layer.REGULAR]
        assert(#rows == #expected, string.format('expected %d rows, got %d', #expected, #rows))

        for index, row in ipairs(expected) do
            local actual = rows[index]
            assert(
                actual[1] == row[1] and actual[2] == row[2] and actual[3] == row[3],
                string.format('row %d: expected { %d, %d, %d }, got { %d, %d, %d }', index, row[1], row[2], row[3], actual[1], actual[2], actual[3])
            )
        end
    end)

    it('gives every historical zone LSB-format rows and an empty treasure layer', function()
        for _, zoneId in ipairs(historicalZones) do
            local zoneTable = xi.chocoboDig.digInfo[zoneId]

            assert(#zoneTable[layer.TREASURE] == 0, string.format('zone %d: the treasure layer has rows', zoneId))
            assert(dig(zoneId, layer.TREASURE) == 0, string.format('zone %d: the treasure layer dropped an item', zoneId))

            for index, row in ipairs(zoneTable[layer.REGULAR]) do
                assert(
                    type(row[1]) == 'number' and row[2] >= 1 and row[2] <= 1000 and row[3] >= xi.craftRank.AMATEUR and row[3] <= xi.craftRank.EXPERT,
                    string.format('zone %d row %d is not an LSB row', zoneId, index)
                )

                for _, itemId in ipairs(outOfEraItems) do
                    assert(row[1] ~= itemId, string.format('zone %d: out-of-era item %d is in the pool', zoneId, itemId))
                end
            end
        end
    end)

    -- Phoenix picked one weighted item after a 30-55% accuracy roll. LSB rolls every row against its own rate, so a
    -- high roll finds nothing however many rows there are. Initiate has no day rock, and the percent roll is 100.
    it('rolls each row against its own rate', function()
        rank = xi.craftRank.INITIATE
        pick = 'last'

        layerRoll = 61
        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.BONE_CHIP, 'a roll of 61 should pass Bone Chip (61)')

        layerRoll = 62
        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.FLINT_STONE, 'a roll of 62 should stop at Flint Stone (69)')

        layerRoll = 95
        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == 0, 'a roll above every rate should find nothing')
    end)

    it('lets the moon change the roll', function()
        rank      = xi.craftRank.INITIATE
        pick      = 'last'
        layerRoll = 60

        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.BONE_CHIP, 'moon 25: 60 should pass Bone Chip (61)')

        stub('VanadielMoonPhase', 50) -- multiplier 1.5: the roll becomes 90
        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.PEBBLE, 'moon 50: 90 should pass Pebble (94) only')
    end)

    it('lets chocobo Receptivity raise the rates', function()
        rank      = xi.craftRank.INITIATE
        pick      = 'last'
        layerRoll = 70

        assert(dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR) == xi.item.PEBBLE, 'without RCP 70 should pass Pebble (94) only')

        -- RCP 255 is rank 7, x1.35: Flint Stone 69 -> 93, Bone Chip 61 -> 82, Copper Ore 40 -> 54.
        local found = dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR, { receptivity = 255 })
        assert(found == xi.item.BONE_CHIP, string.format('with RCP 255 70 should pass Bone Chip, got %s', tostring(found)))
    end)

    -- No night-only rule: Bag of Fruit Seeds (rate 11) comes up at noon. The 9th passer is the seeds; the 10th is
    -- the day rock, and Sprig of Mistletoe (7) fails.
    it('digs up seeds by day', function()
        stub('VanadielHour', 12)
        layerRoll = 11
        pick      = 9

        local found = dig(xi.zone.EAST_RONFAURE, layer.REGULAR)
        assert(found == xi.item.BAG_OF_FRUIT_SEEDS, string.format('expected Bag of Fruit Seeds at noon, got %s', tostring(found)))
    end)

    -- Batallia Downs is an ore zone. With Hot Spell, Firesday, Expert and moon 20 (x0.9), the candidates are the rows,
    -- the Fire Crystal, the Red Rock and, last, the Fire Ore. A layer roll of 17 becomes 15, and 18 becomes 16.
    it('awards elemental ore at a roll of 15 and no higher', function()
        weather = xi.weather.HOT_SPELL
        pick    = 'last'
        stub('VanadielMoonPhase', 20)

        layerRoll = 17
        local found = dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(found == xi.item.CHUNK_OF_FIRE_ORE, string.format('a roll of 15 should give Fire Ore, got %s', tostring(found)))

        layerRoll = 18
        found = dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(found == xi.item.RED_ROCK, string.format('a roll of 16 should not give ore (LSB allows up to 100), got %s', tostring(found)))
    end)

    -- Pin case: passes with or without the module. LSB's ore rules still apply: moon 22 (x0.94) is outside 7-21.
    it('keeps LSB\'s ore moon window', function()
        weather   = xi.weather.HOT_SPELL
        pick      = 'last'
        layerRoll = 16 -- becomes 15
        stub('VanadielMoonPhase', 22)

        local found = dig(xi.zone.BATALLIA_DOWNS, layer.REGULAR)
        assert(found == xi.item.RED_ROCK, string.format('moon 22 should give no ore, got %s', tostring(found)))
    end)

    -- Pin case: passes with or without the module. It fails if the module starts changing Burrow or Bore.
    it('leaves the Burrow and Bore layers to LSB', function()
        local zoneTable = xi.chocoboDig.digInfo[xi.zone.EAST_RONFAURE]

        for _, digLayer in ipairs({ layer.BURROW, layer.BORE }) do
            local expected = zoneTable[digLayer][1][1]
            local found    = dig(xi.zone.EAST_RONFAURE, digLayer)

            assert(found == expected, string.format('layer %d: expected LSB item %d, got %d', digLayer, expected, found))
        end
    end)

    -- Goes in through xi.chocoboDig.start, so it checks the rows LSB really digs from. Every roll is its lowest and
    -- the pick takes the first passer: Phoenix's first East Ronfaure row is Acorn, LSB's stock first row Little Worm.
    it('gives a real dig from the Phoenix rows', function()
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

        assert(digger:hasItem(xi.item.ACORN), 'expected Acorn from the Phoenix rows')
        assert(not digger:hasItem(xi.item.LITTLE_WORM), 'got Little Worm from LSB\'s stock rows')
        assert(xi.chocoboDig.fetchFatigue(digger) == 1, string.format('expected one dig counted, got %d', xi.chocoboDig.fetchFatigue(digger)))
    end)
end)
