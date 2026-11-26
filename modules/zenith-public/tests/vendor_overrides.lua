-- ZenithXI vendor overrides (modules/zenith-public/lua/3-complete/vendorOverrides.lua).
--
-- Replaces the stock and prices of many NPC shops. A spot check of each way the module does it,
-- through the real NPC trigger (or LSB's caller), reading the stock handed to xi.shop.*:
--   Pikini-Mikini (Mhaura), table-driven general shop: Eye Drops 1362 (base 2595), Dish of Salsa 306
--     (base 148), no Mhaura Waystone, Windurst fame.
--   Olwyn (Bastok Markets), table-driven nation shop: Ether 1658 (base 4786).
--   xi.shop.outpost, a whole-function override reached through xi.conquest.vendorOnEventFinish:
--     Ether 1575 (base 4832), pet food added, and rank-6 bonus wares such as Pineapple Juice 650.
--   Macchi Gazlitah (Ru'Lude Gardens), leveling Kid Mithra shop: no Refresh II, cheaper milk as it levels.

describe('Zenith vendor overrides', function()
    ---@type CClientEntityPair
    local player

    -- Price of an item in a { itemId, price, ... } stock list, or nil when it is not stocked
    local function priceOf(stock, itemId)
        for _, row in ipairs(stock) do
            if row[1] == itemId then
                return row[2]
            end
        end
    end

    -- The stock list of the only call a spy recorded
    local function stockOf(shopSpy, what)
        assert(#shopSpy.calls == 1, string.format('expected %s to open one shop, got %d', what, #shopSpy.calls))

        return shopSpy.calls[1].args[2]
    end

    local function assertPrice(stock, itemId, expected, label)
        local price = priceOf(stock, itemId)
        assert(price == expected, string.format('expected %s at %d, got %s', label, expected, tostring(price)))
    end

    describe('in Mhaura', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.MHAURA })
        end)

        it('Pikini-Mikini sells the Zenith stock with Windurst fame', function()
            local shop = spy('xi.shop.general')

            player.entities:gotoAndTrigger('Pikini-Mikini')

            local stock = stockOf(shop, 'Pikini-Mikini')
            assertPrice(stock, xi.item.FLASK_OF_EYE_DROPS, 1362, 'Eye Drops (base 2595)')
            assertPrice(stock, xi.item.DISH_OF_SALSA, 306, 'Dish of Salsa (base 148)')
            assert(priceOf(stock, xi.item.MHAURA_WAYSTONE) == nil, 'Pikini-Mikini still sells the Mhaura Waystone')
            assert(shop.calls[1].args[3] == xi.fameArea.WINDURST, 'Pikini-Mikini\'s shop does not use Windurst fame')
        end)
    end)

    describe('in Bastok Markets', function()
        before_each(function()
            player = xi.test.world:spawnPlayer()
            player:gotoZone(xi.zone.BASTOK_MARKETS)

            -- Zoning into Bastok Markets plays event 22 first
            player.events:finish(22)
        end)

        it('Olwyn sells the Zenith stock as a Bastok nation shop', function()
            local shop = spy('xi.shop.nation')

            player.entities:gotoAndTrigger('Olwyn')

            local stock = stockOf(shop, 'Olwyn')
            assertPrice(stock, xi.item.ETHER, 1658, 'Ether (base 4786)')
            assertPrice(stock, xi.item.FLASK_OF_EYE_DROPS, 1362, 'Eye Drops (base 2595)')
            assert(shop.calls[1].args[3] == xi.nation.BASTOK, 'Olwyn\'s shop is not a Bastok nation shop')
        end)
    end)

    describe('outpost vendors', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE })
            player:setNation(xi.nation.SANDORIA)
        end)

        -- Option 1 of the outpost vendor event is "shop", which LSB sends to xi.shop.outpost
        local function openOutpostShop()
            local shop = spy('xi.shop.general')
            xi.conquest.vendorOnEventFinish(GetPlayerByID(player:getID()), 1, xi.region.RONFAURE)

            return stockOf(shop, 'the outpost vendor')
        end

        it('sell the Zenith outpost stock', function()
            player:setRank(1)

            local stock = openOutpostShop()

            assertPrice(stock, xi.item.ETHER, 1575, 'Ether (base 4832)')
            assertPrice(stock, xi.item.PET_FOOD_ALPHA_BISCUIT, 20, 'Pet Food Alpha Biscuit (base does not stock it)')
            assert(priceOf(stock, xi.item.BOTTLE_OF_PINEAPPLE_JUICE) == nil, 'rank 1 sees the rank 6 bonus wares')
        end)

        it('add bonus wares from rank 6', function()
            player:setRank(6)

            local stock = openOutpostShop()

            assertPrice(stock, xi.item.BOTTLE_OF_PINEAPPLE_JUICE, 650, 'Pineapple Juice at rank 6')
            assertPrice(stock, xi.item.PET_FOOD_EPSILON_BISCUIT, 1160, 'Pet Food Epsilon Biscuit at rank 6')
        end)
    end)

    describe('Macchi Gazlitah', function()
        local stock

        -- One shop stub per case, even when a case opens the shop twice: a second stub on the same path is
        -- restored in install order, which leaves xi.shop.general pointing at the first, already freed, stub.
        before_each(function()
            stub('xi.shop.general', function(shopPlayer, shopStock)
                for _, entry in ipairs(shopStock) do
                    stock[entry[1]] = entry[2]
                end
            end)
        end)

        -- Kid Mithra shop: at level 3 it sells everything it ever does
        local function stockAtLevel(level)
            player = xi.test.world:spawnPlayer({ zone = xi.zone.RULUDE_GARDENS })
            stock  = {}

            SetServerVariable('[Macchi]Level', level, JstMidnight())
            SetServerVariable('[Macchi]Sales', 0, JstMidnight())

            player.entities:gotoAndTrigger('Macchi_Gazlitah')

            return stock
        end

        after_each(function()
            SetServerVariable('[Macchi]Level', 0)
            SetServerVariable('[Macchi]Sales', 0)
        end)

        it('does not sell Refresh II', function()
            local onSale = stockAtLevel(3)

            assert(onSale[xi.item.SCROLL_OF_ENFIRE_II] == 31878, 'precondition: the level 3 stock should be on sale')
            assert(onSale[xi.item.SCROLL_OF_REFRESH_II] == nil, 'Refresh II is still for sale')
        end)

        it('keeps the cheaper milk as the shop levels up', function()
            assert(stockAtLevel(1)[xi.item.JUG_OF_ULEGUERAND_MILK] == 300, 'level 1 milk price')
            assert(stockAtLevel(3)[xi.item.JUG_OF_ULEGUERAND_MILK] == 100, 'level 3 milk price')
        end)
    end)
end)
