-- ZenithXI (scripts\actions\spells\trust\naji.lua).
--

describe('Trust: NAJI Integration Test #trusts #naji', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, "Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true")
    
    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust skill check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
        assert(not trustEntity:hasLearnedAbility(xi.ja.PROVOKE))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 5, "Must be lv 5")
        assert(trustEntity:hasLearnedAbility(xi.ja.PROVOKE))
    end)

    it('Trust WS check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.FAST_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.BURNING_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.RED_LOTUS_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.VORPAL_BLADE))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 5, "Must be lv 5")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.FAST_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.BURNING_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.RED_LOTUS_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.VORPAL_BLADE))
        
        player:clearTrusts()
        player:setLevel(40)
        trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 40, "Must be lv 40")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.FAST_BLADE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.BURNING_BLADE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.RED_LOTUS_BLADE))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.VORPAL_BLADE))

        player:clearTrusts()
        player:setLevel(62)
        trustEntity = player:spawnTrust(xi.magic.spell.NAJI)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 62, "Must be lv 62")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.FAST_BLADE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.BURNING_BLADE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.RED_LOTUS_BLADE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.VORPAL_BLADE))
    end)
end)