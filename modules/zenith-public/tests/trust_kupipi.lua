-- ZenithXI (scripts\actions\spells\trust\kupipi.lua).
-- Only tests lv 5 weaponskill since we don't override

describe('Trust: Kupipi Integration Test #trusts #kupipi', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, 'Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true')
    
    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust WS check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.KUPIPI)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.SHINING_STRIKE))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.SEMIH_LAFIHNA)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 5, 'Must be lv 5')
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.SHINING_STRIKE))
    end)
end)