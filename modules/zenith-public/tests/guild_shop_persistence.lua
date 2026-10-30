-- ZenithXI guild shop persistence (modules/zenith-public/lua/3-complete/guild_shop_persistence.lua).
--
-- The C++ module reads and writes guild_shop_state. This covers the Lua side it calls: which rows change, and
-- what comes back into the shops. Amulya and Vicious Eye share one stock (eraGuildShops.lua).

describe('Zenith guild shop persistence', function()
    local shopName = 'Amulya'

    local function npc(name)
        return { getName = function() return name end }
    end

    local function persistence()
        return xi.guildShops.persistence
    end

    -- Rows as the database would give them back for every item Amulya carries
    local function savedRows(stock, lastRoll)
        local rows = {}

        for _, cfg in ipairs(xi.data.guildShops[shopName].stock) do
            rows[#rows + 1] =
            {
                shop      = shopName,
                itemId    = cfg.id,
                stock     = stock,
                buyPrice  = 111,
                sellPrice = 22,
                offered   = 1,
                lastRoll  = lastRoll,
            }
        end

        return rows
    end

    local function firstItem()
        return xi.data.guildShops[shopName].stock[1].id
    end

    before_each(function()
        xi.guildShops.state[shopName] = nil
    end)

    it('saves a shop once it has rolled, and only changes after that', function()
        xi.guildShops.onBuyList(nil, npc(shopName))

        assert(#persistence().collect() > 0, 'a rolled shop was not saved')
        assert(#persistence().collect() == 0, 'an unchanged shop was saved again')

        local state = xi.guildShops.state[shopName]
        state.items[firstItem()].stock = state.items[firstItem()].stock + 1

        local deltas = persistence().collect()

        assert(#deltas == 1 and deltas[1].itemId == firstItem(), 'expected one changed row')
        assert(deltas[1].stock == state.items[firstItem()].stock, 'saved the wrong stock')
    end)

    it('gives stock, prices and availability back', function()
        local summary = persistence().restore(savedRows(7, VanadielUniqueDay()))
        local item    = xi.guildShops.state[shopName].items[firstItem()]

        assert(summary.restored == 1, 'the shop was not restored')
        assert(item.stock == 7, 'stock did not come back')
        assert(item.buyPrice == 111 and item.sellPrice == 22, 'prices did not come back')
        assert(item.offered, 'availability did not come back')
    end)

    it('does not restock or reprice on a restart', function()
        persistence().restore(savedRows(7, VanadielUniqueDay()))

        local list = xi.guildShops.onBuyList(nil, npc(shopName))

        assert(list[1].count == 7, 'the restart changed the stock')
        assert(list[1].price == 111, 'the restart changed the price')
    end)

    it('keeps the stock shared with the other NPC', function()
        persistence().restore(savedRows(7, VanadielUniqueDay()))

        local list = xi.guildShops.onBuyList(nil, npc('Vicious_Eye'))

        assert(list[1].count == 7, 'Vicious Eye does not see the restored stock')
    end)

    it('keeps the daily roll going', function()
        persistence().restore(savedRows(7, VanadielUniqueDay() - 1))

        xi.guildShops.onBuyList(nil, npc(shopName))

        assert(xi.guildShops.state[shopName].lastRoll == VanadielUniqueDay(), 'the day was not rolled')
    end)

    it('starts a missing row from the configured stock', function()
        local rows = savedRows(7, VanadielUniqueDay())

        table.remove(rows, 1)

        local summary = persistence().restore(rows)
        local state   = xi.guildShops.state[shopName]
        local cfg     = xi.data.guildShops[shopName].stock

        assert(summary.reRolled == 1, 'the incomplete shop was not re-rolled')
        assert(state.lastRoll == VanadielUniqueDay(), 'the incomplete shop was not rolled')
        assert(state.items[cfg[1].id].stock == cfg[1].initial, 'the missing item did not start from its config')
        assert(state.items[cfg[2].id].stock == 7, 'the other items lost their stock')
    end)

    it('deletes rows for items the shop no longer carries', function()
        local rows = savedRows(7, VanadielUniqueDay())

        rows[#rows + 1] = { shop = shopName, itemId = 1, stock = 1, buyPrice = 1, sellPrice = 1, offered = 1, lastRoll = 1 }

        local summary = persistence().restore(rows)

        assert(#summary.deletes == 1 and summary.deletes[1].itemId == 1, 'the obsolete row was not deleted')
    end)

    it('starts up with rows for a shop that no longer exists', function()
        local summary = persistence().restore({
            { shop = 'Not_A_Shop', itemId = 1, stock = 1, buyPrice = 1, sellPrice = 1, offered = 1, lastRoll = 1 },
        })

        assert(summary.restored == 0, 'restored a shop that does not exist')
    end)

    it('does not trust a saved day in the future', function()
        local summary = persistence().restore(savedRows(7, VanadielUniqueDay() + 5))

        assert(summary.reRolled == 1, 'kept a roll from the future')
        assert(xi.guildShops.state[shopName].lastRoll == VanadielUniqueDay(), 'the shop was not rolled')
    end)
end)
