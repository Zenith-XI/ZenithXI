-- ZenithXI BCNM expansion gating (modules/zenith-public/lua/2-base/bcnm_expansion_gating.lua).
--
-- The module runs at content phase rotzEarly. It clears the menu bit of every battlefield whose fight
-- or orb belongs to a later phase from xi.battlefield.getBattlefieldOptions, and Shami in Port Jeuno
-- refuses to sell orbs from a later phase. LSB offers every fight and sells every orb.
--
-- Horlais Peak, Star Orb: Tails of Woe (index 1, baseGame) stays, Under Observation (rotzLate) goes.
-- Shami event 322: option 1 is the Cloudy Orb (rotzMid, 20 Beastmen's Seals), option 4 the Comet Orb
-- (rotzEarly, 50 seals).

describe('Zenith BCNM expansion gating', function()
    local beastmensSeal = 0 -- seal type of the Beastmen's Seal (player:getSeals)

    ---@type CClientEntityPair
    local player

    local function menuHas(options, battlefieldId)
        local content = xi.battlefield.contents[battlefieldId]

        return utils.mask.getBit(options, content.index)
    end

    describe('battlefield menu', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.HORLAIS_PEAK, job = xi.job.WAR, level = 75 })
        end)

        it('hides a late-phase fight from the Star Orb menu', function()
            player:addItem(xi.item.STAR_ORB)
            assert(player:hasItem(xi.item.STAR_ORB), 'precondition: the player has no Star Orb')

            player.entities:moveTo('BC_Entrance')
            player.actions:tradeNpc('BC_Entrance', { xi.item.STAR_ORB })

            local options = player:getLocalVar('[BCNM]MenuOptions')
            assert(menuHas(options, xi.battlefield.id.TAILS_OF_WOE), string.format('precondition: Tails of Woe missing from the Star Orb menu (options %d)', options))
            assert(not menuHas(options, xi.battlefield.id.UNDER_OBSERVATION), string.format('Under Observation (rotzLate) is offered at phase rotzEarly (options %d)', options))
        end)

        -- ZXIALPHA-45: Eye of the Tiger was missing from the fight table and fell back to the Comet
        -- Orb's phase, so it was offered at rotzEarly next to Hostile Herbivores.
        it('hides a late-phase fight from the Comet Orb menu', function()
            player:addItem(xi.item.COMET_ORB)
            assert(player:hasItem(xi.item.COMET_ORB), 'precondition: the player has no Comet Orb')

            player.entities:moveTo('BC_Entrance')
            player.actions:tradeNpc('BC_Entrance', { xi.item.COMET_ORB })

            local options = player:getLocalVar('[BCNM]MenuOptions')
            assert(menuHas(options, xi.battlefield.id.HOSTILE_HERBIVORES), string.format('precondition: Hostile Herbivores missing from the Comet Orb menu (options %d)', options))
            assert(not menuHas(options, xi.battlefield.id.EYE_OF_THE_TIGER), string.format('Eye of the Tiger (rotzLate) is offered at phase rotzEarly (options %d)', options))
        end)
    end)

    describe('Shami orb sales', function()
        before_each(function()
            player = xi.test.world:spawnPlayer({ zone = xi.zone.PORT_JEUNO })
        end)

        it('refuses to sell a Cloudy Orb before its phase', function()
            player:addSeals(20, beastmensSeal)
            assert(player:getSeals(beastmensSeal) == 20, 'precondition: the player should hold 20 Beastmen\'s Seals')

            player.entities:gotoAndTrigger('Shami', { eventId = 322, finishOption = 1 })

            assert(not player:hasItem(xi.item.CLOUDY_ORB), 'Shami sold a Cloudy Orb (rotzMid) at phase rotzEarly')
            assert(player:getSeals(beastmensSeal) == 20, string.format('expected 20 seals kept, got %d', player:getSeals(beastmensSeal)))
        end)

        -- Control: passes with or without the module. A current-phase orb still sells, so the case above
        -- fails for the gate and not because purchases are broken.
        it('still sells a Comet Orb in its phase', function()
            player:addSeals(50, beastmensSeal)
            assert(player:getSeals(beastmensSeal) == 50, 'precondition: the player should hold 50 Beastmen\'s Seals')

            player.entities:gotoAndTrigger('Shami', { eventId = 322, finishOption = 4 })

            assert(player:hasItem(xi.item.COMET_ORB), 'Shami did not sell a Comet Orb (rotzEarly)')
            assert(player:getSeals(beastmensSeal) == 0, string.format('expected the 50 seals spent, %d left', player:getSeals(beastmensSeal)))
        end)
    end)
end)
