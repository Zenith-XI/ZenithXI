-- ZenithXI (modules\zenith-public\lua\4-additive\trusts\NANAA_MIHGO_override.lua).
--

describe('Trust: NANAA_MIHGO Integration Test #trusts #nanaa_mihgo', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, 'Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true')
    
    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust skill check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(not trustEntity:hasLearnedAbility(xi.ja.DESPOIL))

        player:clearTrusts()
        player:setLevel(60)
        trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 60, 'Must be lv 60')
        assert(trustEntity:hasLearnedAbility(xi.ja.DESPOIL))
    end)

    it('Trust trait check', function()
        local trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(trustEntity:getMod(xi.mod.GILFINDER) == 0)
        assert(trustEntity:getMod(xi.mod.TREASURE_HUNTER) == 0)

        player:clearTrusts()
        player:setLevel(15)
        trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 15, 'Must be lv 15')
        assert(trustEntity:getMod(xi.mod.GILFINDER) == 1)
        assert(trustEntity:getMod(xi.mod.TREASURE_HUNTER) == 1)
    end)

    local kingCobraClampId = 3189

    it('Trust WS check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.WASP_STING))
        assert(not trustEntity:hasLearnedWeaponskill(kingCobraClampId))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.DANCING_EDGE))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 5, 'Must be lv 5')
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.WASP_STING))
        assert(not trustEntity:hasLearnedWeaponskill(kingCobraClampId))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.DANCING_EDGE))
        
        player:clearTrusts()
        player:setLevel(30)
        trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 30, 'Must be lv 30')
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.WASP_STING))
        assert(trustEntity:hasLearnedWeaponskill(kingCobraClampId))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.DANCING_EDGE))

        player:clearTrusts()
        player:setLevel(60)
        trustEntity = player:spawnTrust(xi.magic.spell.NANAA_MIHGO)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 60, 'Must be lv 60')
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.WASP_STING))
        assert(trustEntity:hasLearnedWeaponskill(kingCobraClampId))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.DANCING_EDGE))
    end)
end)