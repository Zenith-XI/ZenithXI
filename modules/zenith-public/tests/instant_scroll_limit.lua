-- ZenithXI daily Instant Warp and Instant Reraise limit (modules/zenith-public/lua/3-complete/instant_scroll_limit.lua).
--
-- One of each per character per day, shared between the conquest overseers and the Imperial Standing NPCs.
-- A player holds one of these scrolls at most, so each purchase uses up the scroll and says if it went through.

describe('Zenith Instant scroll daily limit', function()
    local warp    = { item = xi.item.SCROLL_OF_INSTANT_WARP,    conquest = 32929, imperial = 4097 }
    local reraise = { item = xi.item.SCROLL_OF_INSTANT_RERAISE, conquest = 32928, imperial = 1 }

    local function newPlayer()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
        local entity = GetPlayerByID(player:getID())

        entity:setCurrency('imperial_standing', 1000)
        entity:addCP(1000)

        return entity
    end

    local function received(entity, scroll)
        local gotScroll = entity:hasItem(scroll.item)

        if gotScroll then
            entity:delItem(scroll.item, 1)
        end

        return gotScroll
    end

    local function buyWithConquest(entity, scroll)
        entity:setLocalVar('boughtItemCP', scroll.item)
        xi.conquest.overseerOnEventFinish(entity, 0, scroll.conquest, entity:getNation(), xi.conquest.guard.CITY, 0)

        return received(entity, scroll)
    end

    local function buyWithImperial(entity, scroll)
        xi.besieged.onEventFinish(entity, 0, scroll.imperial, nil)

        return received(entity, scroll)
    end

    before_each(function()
        stub('xi.besieged.getMercenaryRank', 1)
    end)

    it('sells the first Instant Warp of the day', function()
        assert(buyWithConquest(newPlayer(), warp), 'no scroll')
    end)

    it('refuses a second Instant Warp from the same vendor without charging', function()
        local entity = newPlayer()

        buyWithConquest(entity, warp)

        local cp = entity:getCP()

        assert(not buyWithConquest(entity, warp), 'sold a second scroll')
        assert(entity:getCP() == cp, 'charged for a refused purchase')
    end)

    it('refuses a second Instant Warp with another currency', function()
        local entity = newPlayer()

        buyWithConquest(entity, warp)

        assert(not buyWithImperial(entity, warp), 'another currency sold a second scroll')
        assert(entity:getCurrency('imperial_standing') == 1000, 'charged for a refused purchase')
    end)

    it('refuses a second Instant Reraise, also the other way around', function()
        local entity = newPlayer()

        buyWithImperial(entity, reraise)

        assert(not buyWithConquest(entity, reraise), 'another currency sold a second scroll')
    end)

    it('counts the two scrolls apart', function()
        local entity = newPlayer()

        buyWithConquest(entity, warp)

        assert(buyWithConquest(entity, reraise), 'Instant Warp used up the Instant Reraise allowance')
    end)

    it('does not count a failed purchase', function()
        local entity = newPlayer()

        entity:setCurrency('imperial_standing', 0)
        entity:delCP(entity:getCP())

        assert(not buyWithImperial(entity, warp), 'precondition: bought without Imperial Standing')
        assert(not buyWithConquest(entity, warp), 'precondition: bought without conquest points')

        entity:addCP(1000)

        assert(buyWithConquest(entity, warp), 'a failed purchase used up the allowance')
    end)

    it('gives each character its own allowance', function()
        local first  = newPlayer()
        local second = newPlayer()

        buyWithConquest(first, warp)

        assert(buyWithConquest(second, warp), 'characters share the allowance')
    end)

    it('resets at JST midnight', function()
        local entity = newPlayer()

        buyWithConquest(entity, warp)
        xi.test.world:tick(xi.tick.JST_DAY)
        xi.test.world:skipTime(2)

        assert(buyWithConquest(entity, warp), 'no new allowance after JST midnight')
    end)

    it('keeps the allowance in a persistent char var', function()
        local entity = newPlayer()

        buyWithConquest(entity, warp)

        assert(entity:getCharVar('[Zenith]DailyInstantWarp') == 1, 'nothing was stored')
    end)
end)
