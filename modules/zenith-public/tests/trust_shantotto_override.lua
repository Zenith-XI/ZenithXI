-- ZenithXI (modules/zenith-public/lua/4-additive/trusts/shantotto_override.lua).
--

describe('Trust: SHANTOTTO Integration Test #trusts #shantotto', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, 'Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true')

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust spell check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.SHANTOTTO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(not trustEntity:hasSpell(xi.magic.spell.FIRE))
        assert(not trustEntity:hasSpell(xi.magic.spell.AERO_IV))

        player:clearTrusts()
        player:setLevel(75)
        trustEntity = player:spawnTrust(xi.magic.spell.SHANTOTTO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 75, 'Must be lv 75')
        assert(trustEntity:hasSpell(xi.magic.spell.FIRE))
        assert(trustEntity:hasSpell(xi.magic.spell.AERO_IV))
    end)

    it('Trust trait check', function()
        local trustEntity = player:spawnTrust(xi.magic.spell.SHANTOTTO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(trustEntity:getMod(xi.mod.MATT) == 1)
        assert(trustEntity:getMod(xi.mod.MACC) == 1)
        assert(trustEntity:getMod(xi.mod.FASTCAST) == 10)
        assert(trustEntity:getMod(xi.mod.MPP) == 100)
        assert(trustEntity:getMod(xi.mod.HASTE_MAGIC) >= 1000)

        player:clearTrusts()
        player:setLevel(75)
        trustEntity = player:spawnTrust(xi.magic.spell.SHANTOTTO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 75, 'Must be lv 75')
        assert(trustEntity:getMod(xi.mod.MATT) >= 25)
        assert(trustEntity:getMod(xi.mod.MACC) >= 25)
    end)
end)
