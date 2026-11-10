-- ZenithXI (modules/zenith-public/lua/4-additive/trusts/ajido_marujido_override.lua).
--

describe('Trust: AJIDO_MARUJIDO Integration Test #trusts #ajido', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, 'Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true')

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust spell check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(trustEntity:hasSpell(xi.magic.spell.CURE))
        assert(not trustEntity:hasSpell(xi.magic.spell.AERO_III))
        assert(not trustEntity:hasSpell(xi.magic.spell.DISPEL))

        player:clearTrusts()
        player:setLevel(60)
        trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 60, 'Must be lv 50')
        assert(trustEntity:hasSpell(xi.magic.spell.CURE))
        assert(trustEntity:hasSpell(xi.magic.spell.AERO_III))
        assert(not trustEntity:hasSpell(xi.magic.spell.DISPEL))

        player:clearTrusts()
        player:setLevel(64)
        trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 64, 'Must be lv 64')
        assert(trustEntity:hasSpell(xi.magic.spell.CURE))
        assert(trustEntity:hasSpell(xi.magic.spell.AERO_III))
        assert(trustEntity:hasSpell(xi.magic.spell.DISPEL))
    end)

    it('Trust trait check', function()
        local trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(trustEntity:getMod(xi.mod.FASTCAST) == 0)
    end)

    -- Test traits for ABYSEA
    describe('Trust: AJIDO_MARUJIDO Trait Test #abyssea #trusts', function()
        before_each(function()
            xi.settings.main = { RESTRICT_CONTENT = 1, ENABLE_ABYSSEA = 1 }
            assert(xi.pre(xi.expansion.ABYSSEA) == false, 'ABYSSEA must be on')
            player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
            player:setGMLevel(5)
        end)

        it('Trust trait check', function()
            player:setLevel(15)
            local trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
            assert(trustEntity ~= nil, 'Cannot be null')
            assert(trustEntity:getMainLvl() == 15, 'Must be lv 15')
            assert(trustEntity:getMod(xi.mod.CURE_POTENCY) == 10)

            player:clearTrusts()
            player:setLevel(35)
            trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
            assert(trustEntity ~= nil, 'Cannot be null')
            assert(trustEntity:getMainLvl() == 35, 'Must be lv 35')
            assert(trustEntity:getMod(xi.mod.FASTCAST) == 10)

            player:clearTrusts()
            player:setLevel(75)
            trustEntity = player:spawnTrust(xi.magic.spell.AJIDO_MARUJIDO)
            assert(trustEntity ~= nil, 'Cannot be null')
            assert(trustEntity:getMainLvl() == 75, 'Must be lv 75')
            assert(trustEntity:getMod(xi.mod.FASTCAST) == 15)
        end)
    end)
end)
