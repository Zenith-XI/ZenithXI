-- ZenithXI (scripts\actions\spells\trust\maat.lua).
-- Quick Maat Test

describe('Trust: Maat Integration Test #trusts #maat', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, 'Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true')

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust Maat', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.MAAT)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 1, 'Must be lv 1')
        assert(not trustEntity:hasLearnedWeaponskill(xi.trustskills.id.COMBO))
        assert(not trustEntity:hasLearnedAbility(xi.ja.MANTRA))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.MAAT)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 5, 'Must be lv 5')
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.COMBO))
        assert(not trustEntity:hasLearnedAbility(xi.ja.MANTRA))

        player:clearTrusts()
        player:setLevel(24)
        trustEntity = player:spawnTrust(xi.magic.spell.MAAT)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 24, 'Must be lv 24')
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.BEAR_KILLER))
        assert(not trustEntity:hasLearnedAbility(xi.ja.MANTRA))

        player:clearTrusts()
        player:setLevel(75)
        trustEntity = player:spawnTrust(xi.magic.spell.MAAT)
        assert(trustEntity ~= nil, 'Cannot be null')
        assert(trustEntity:getMainLvl() == 75, 'Must be lv 75')
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.BEAR_KILLER))
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.COMBO))
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.ONE_INCH_PUNCH))
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.HOWLING_FIST))
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.DRAGON_KICK))
        assert(trustEntity:hasLearnedWeaponskill(xi.trustskills.id.ASURAN_FISTS))
        assert(trustEntity:hasLearnedAbility(xi.ja.MANTRA))
    end)
end)
