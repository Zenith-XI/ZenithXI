-- ZenithXI NM kill tracking (modules/zenith-public/lua/3-complete/nmKillTracking.lua).
--
-- LSB has no NM kill record. The module's xi.mob.onMobDeathEx override sets one bit per tracked NM
-- in a char var (NM_Kills_Base, WardrobeNM_Group1-4); wardrobe unlocks read those bits. A bit is the
-- entry's position in its group, and the masks are saved per character, so the bit-layout case pins
-- known positions: if one moves, existing players' kill history is silently rewritten.
-- Most cases call xi.nmTracking.trackKill with a stand-in mob; the first goes through a real kill
-- (Leaping Lizzy, NM_Kills_Base bit 0) to check the onMobDeathEx override still runs.

describe('Zenith NM kill tracking', function()
    ---@type CClientEntityPair
    local player

    local function tracking()
        assert(xi.nmTracking and xi.nmTracking.trackKill, 'xi.nmTracking is not loaded (nmKillTracking.lua)')

        return xi.nmTracking
    end

    -- Stand-in for a dead mob: only what trackKill reads
    local function fakeMob(name, zoneId, isNM)
        local mob = {}

        function mob:getName()
            return name
        end

        function mob:getZoneID()
            return zoneId
        end

        function mob:isNM()
            return isNM ~= false
        end

        return mob
    end

    local function bitOf(varName, bitPos)
        return utils.mask.getBit(player:getCharVar(varName), bitPos)
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTH_GUSTABERG })
    end)

    -- claim_shield holds a fresh NM unkillable for its 30 s engage window (ZXIALPHA-118). skipTime ticks
    -- once per call, so the window timer gets its own tick after the clock has passed it.
    local function passEngageWindow()
        xi.test.world:skipTime(31)
        xi.test.world:skipTime(1)
    end

    it('records a real kill of a tracked NM', function()
        local nm = player.entities:get('Leaping_Lizzy')
        nm:respawn()
        assert(nm:isNM(), 'precondition: Leaping_Lizzy is not an NM')
        assert(player:getCharVar('NM_Kills_Base') == 0, 'precondition: a new character already has NM kills')

        passEngageWindow()
        player:claimAndKillMob(nm)

        assert(bitOf('NM_Kills_Base', 0), string.format('killing Leaping Lizzy did not set NM_Kills_Base bit 0 (var %d)', player:getCharVar('NM_Kills_Base')))
    end)

    -- Bit positions as players already have them saved. Only appends to a group are safe.
    local bitLayout =
    {
        { var = 'NM_Kills_Base',     name = 'Valkurm_Emperor',    zone = xi.zone.VALKURM_DUNES,      bit = 1  },
        { var = 'WardrobeNM_Group1', name = 'Ouryu',              zone = xi.zone.RIVERNE_SITE_A01,   bit = 13 },
        { var = 'WardrobeNM_Group1', name = 'Long-Armed_Chariot', zone = xi.zone.SILVER_SEA_REMNANTS, bit = 31 },
        { var = 'WardrobeNM_Group2', name = 'Fungus_Beetle',      zone = xi.zone.WEST_RONFAURE,      bit = 16 },
        { var = 'WardrobeNM_Group3', name = 'Hellion',            zone = xi.zone.LABYRINTH_OF_ONZOZO, bit = 31 },
        { var = 'WardrobeNM_Group4', name = 'Oupire',             zone = xi.zone.ALZADAAL_UNDERSEA_RUINS, bit = 13 },
    }

    it('keeps every tracked NM on its saved bit', function()
        local plain = GetPlayerByID(player:getID())

        for _, entry in ipairs(bitLayout) do
            tracking().trackKill(plain, fakeMob(entry.name, entry.zone))

            local mask = player:getCharVar(entry.var)
            assert(utils.mask.getBit(mask, entry.bit), string.format('%s did not set %s bit %d (var %d)', entry.name, entry.var, entry.bit, mask))
            assert(utils.mask.countBits(mask, 32) == 1, string.format('%s set more than one bit in %s (var %d)', entry.name, entry.var, mask))

            player:setCharVar(entry.var, 0)
        end
    end)

    it('does not credit a tracked name killed in another zone', function()
        tracking().trackKill(GetPlayerByID(player:getID()), fakeMob('Fungus_Beetle', xi.zone.EAST_RONFAURE))

        assert(player:getCharVar('WardrobeNM_Group2') == 0, string.format('a Fungus_Beetle outside West Ronfaure was credited (var %d)', player:getCharVar('WardrobeNM_Group2')))
    end)

    it('credits a roaming ZNM in any zone', function()
        -- Yilbegan has no zoneId: WardrobeNM_Group1 bit 18
        tracking().trackKill(GetPlayerByID(player:getID()), fakeMob('Yilbegan', xi.zone.BIBIKI_BAY))

        assert(bitOf('WardrobeNM_Group1', 18), string.format('Yilbegan was not credited (var %d)', player:getCharVar('WardrobeNM_Group1')))
    end)

    it('does not credit a mob that is not an NM', function()
        tracking().trackKill(GetPlayerByID(player:getID()), fakeMob('Leaping_Lizzy', xi.zone.SOUTH_GUSTABERG, false))

        assert(player:getCharVar('NM_Kills_Base') == 0, 'a non-NM Leaping_Lizzy was credited')
    end)

    it('counts a group complete without its notCoded entries', function()
        local plain = GetPlayerByID(player:getID())

        -- every bit of WardrobeNM_Group1 except 11 and 12 (Proto-Omega / Proto-Ultima, notCoded)
        local allButProtos = bit.bnot(bit.bor(bit.lshift(1, 11), bit.lshift(1, 12)))
        player:setCharVar('WardrobeNM_Group1', allButProtos)
        assert(tracking().hasKilledAll(plain, 'WardrobeNM_Group1'), 'WardrobeNM_Group1 is not complete with only the notCoded bits missing')
        assert(tracking().getKillCount(plain, 'WardrobeNM_Group1') == 30,
            string.format('expected 30 kills in WardrobeNM_Group1, got %d', tracking().getKillCount(plain, 'WardrobeNM_Group1')))

        -- bit 31 (Long-Armed_Chariot) missing as well
        player:setCharVar('WardrobeNM_Group1', utils.mask.setBit(allButProtos, 31, false))
        assert(not tracking().hasKilledAll(plain, 'WardrobeNM_Group1'), 'WardrobeNM_Group1 is complete with Long-Armed_Chariot missing')
    end)

    it('answers whether a single NM was killed', function()
        local plain = GetPlayerByID(player:getID())

        assert(not tracking().hasKilledNM(plain, 'Fungus_Beetle', xi.zone.WEST_RONFAURE), 'a new character has killed Fungus_Beetle')

        player:setCharVar('WardrobeNM_Group2', bit.lshift(1, 16))
        assert(tracking().hasKilledNM(plain, 'Fungus_Beetle', xi.zone.WEST_RONFAURE), 'Fungus_Beetle kill not found with its zone')
        assert(tracking().hasKilledNM(plain, 'Fungus_Beetle'), 'Fungus_Beetle kill not found without a zone')
        assert(not tracking().hasKilledNM(plain, 'Fungus_Beetle', xi.zone.EAST_RONFAURE), 'Fungus_Beetle kill found in the wrong zone')
    end)
end)
