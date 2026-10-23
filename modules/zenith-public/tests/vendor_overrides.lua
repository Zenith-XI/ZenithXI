-- ZenithXI vendor overrides (modules/zenith-public/lua/3-complete/vendorOverrides.lua).

describe('Zenith vendor overrides', function()
    describe('Macchi Gazlitah', function()
        -- Kid Mithra shop: at level 3 it sells everything it ever does
        local function stockAtLevel(level)
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.RULUDE_GARDENS })
            local stock  = {}

            SetServerVariable('[Macchi]Level', level, JstMidnight())
            SetServerVariable('[Macchi]Sales', 0, JstMidnight())

            stub('xi.shop.general', function(shopPlayer, shopStock)
                for _, entry in ipairs(shopStock) do
                    stock[entry[1]] = entry[2]
                end
            end)

            player.entities:gotoAndTrigger('Macchi_Gazlitah')

            return stock
        end

        after_each(function()
            SetServerVariable('[Macchi]Level', 0)
            SetServerVariable('[Macchi]Sales', 0)
        end)

        it('does not sell Refresh II', function()
            local stock = stockAtLevel(3)

            assert(stock[xi.item.SCROLL_OF_ENFIRE_II] == 31878, 'precondition: the level 3 stock should be on sale')
            assert(stock[xi.item.SCROLL_OF_REFRESH_II] == nil, 'Refresh II is still for sale')
        end)

        it('keeps the cheaper milk as the shop levels up', function()
            assert(stockAtLevel(1)[xi.item.JUG_OF_ULEGUERAND_MILK] == 300, 'level 1 milk price')
            assert(stockAtLevel(3)[xi.item.JUG_OF_ULEGUERAND_MILK] == 100, 'level 3 milk price')
        end)
    end)
end)
