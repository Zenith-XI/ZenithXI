-- ZenithXI (modules/zenith-public/lua/4-additive/trusts/ayame_override.lua).
--

describe('Trust: AYAME Integration Test #trusts #ayame', function()
    ---@type CClientEntityPair
    local player
    assert(xi.settings.map.TRUST_SKILLS_BY_LEVEL == true, "Zenith: TRUST_SKILLS_BY_LEVEL Must be set to true")
    before_each(function()
        xi.settings.main = { RESTRICT_CONTENT = 1, ENABLE_TOAU = 0 }
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        player:setGMLevel(5)
    end)

    it('Trust trait check', function()
            -- Lv 1 check
            local trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
            assert(trustEntity:getMod(xi.mod.ZANSHIN) == 0)

            player:clearTrusts()
            player:setLevel(20)
            trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 20, "Must be lv 20")
            assert(trustEntity:getMod(xi.mod.ZANSHIN) == 15)

            player:clearTrusts()
            player:setLevel(35)
            trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 35, "Must be lv 35")
            assert(trustEntity:getMod(xi.mod.ZANSHIN) == 25)

            player:clearTrusts()
            player:setLevel(50)
            trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 50, "Must be lv 50")
            assert(trustEntity:getMod(xi.mod.ZANSHIN) == 35)

            player:clearTrusts()
            player:setLevel(75)
            trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 75, "Must be lv 75")
            assert(trustEntity:getMod(xi.mod.ZANSHIN) == 45)
    end)


    it('Trust WS check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_ENPI))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KASHA))

        player:clearTrusts()
        player:setLevel(5)
        trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 5, "Must be lv 5")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_ENPI))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KASHA))

        player:clearTrusts()
        player:setLevel(69)
        trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 69, "Must be lv 69")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_ENPI))
        assert(not trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KASHA))

        player:clearTrusts()
        player:setLevel(71)
        trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 71, "Must be lv 70")
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_ENPI))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KASHA))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_HOBAKU))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_GOTEN))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KAGERO))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_JINPU))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_JINPU))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_KOKI))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_YUKIKAZE))
        assert(trustEntity:hasLearnedWeaponskill(xi.weaponskill.TACHI_GEKKO))
    end)

    it('Trust skill check', function()
        -- Lv 1 check
        local trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
        assert(not trustEntity:hasLearnedAbility(xi.ja.THIRD_EYE))
        assert(not trustEntity:hasLearnedAbility(xi.ja.MEDITATE))

        player:clearTrusts()
        player:setLevel(15)
        trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 15, "Must be lv 15")
        assert(trustEntity:hasLearnedAbility(xi.ja.THIRD_EYE))
        assert(not trustEntity:hasLearnedAbility(xi.ja.MEDITATE))

        player:clearTrusts()
        player:setLevel(50)
        trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
        assert(trustEntity ~= nil, "Cannot be null")
        assert(trustEntity:getMainLvl() == 50, "Must be lv 50")
        assert(trustEntity:hasLearnedAbility(xi.ja.THIRD_EYE))
        assert(trustEntity:hasLearnedAbility(xi.ja.MEDITATE))

    end)

     -- Test traits for TOAU
    describe('Trust: Ayame Trait Test #toau', function()
        local player
        before_each(function()
            xi.settings.main = { RESTRICT_CONTENT = 1, ENABLE_TOAU = 1 }
            assert(not xi.pre(xi.expansion.TOAU) == true, 'TOAU must be on')
            player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
            player:setGMLevel(5)
        end)

        it('Trust skill check', function()
             -- Lv 1 check
            local trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 1, "Must be lv 1")
            assert(not trustEntity:hasLearnedAbility(xi.ja.HASSO))

            player:clearTrusts()
            player:setLevel(50)
            trustEntity = player:spawnTrust(xi.magic.spell.AYAME)
            assert(trustEntity ~= nil, "Cannot be null")
            assert(trustEntity:getMainLvl() == 50, "Must be lv 50")
            assert(trustEntity:hasLearnedAbility(xi.ja.HASSO))
        end)
    end)
end)