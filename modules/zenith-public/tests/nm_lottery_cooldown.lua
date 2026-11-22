-- ZenithXI NM lottery cooldown persistence (modules/zenith-public/lua/2-base/nm_lottery_cooldown.lua).
--
-- Base keeps a Lua-lottery NM's cooldown in a localvar, which a reboot wipes. The module keeps it in a
-- server var. A reboot is simulated by clearing the NM's 'pop' localvar.
--
-- Konschtat Highlands: Tremor Ram is a PH for Rampaging Ram (scripts/zones/Konschtat_Highlands/mobs).

describe('Zenith NM lottery cooldown', function()
    local ID = zones[xi.zone.KONSCHTAT_HIGHLANDS]
    local cooldown = 1200

    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local ph
    ---@type CTestEntity
    local nm
    local varName

    local function simulateReboot()
        nm:setLocalVar('pop', 0)
    end

    -- claim_shield holds a fresh NM unkillable for its 30 s engage window (ZXIALPHA-118). skipTime ticks
    -- once per call, so the window timer gets its own tick after the clock has passed it.
    local function passEngageWindow()
        xi.test.world:skipTime(31)
        xi.test.world:skipTime(1)
    end

    before_each(function()
        player  = xi.test.world:spawnPlayer({ zone = xi.zone.KONSCHTAT_HIGHLANDS })
        ph      = player.entities:get(ID.mob.TREMOR_RAM[1])
        nm      = player.entities:get(ID.mob.RAMPAGING_RAM)
        varName = zxi.mobHelpers.getRespawnVarName(GetMobByID(ID.mob.RAMPAGING_RAM))

        -- xi_test shares the database, so start every case from a clean server var
        SetServerVariable(varName, 0)
        nm:setRespawnTime(0)
        simulateReboot()
    end)

    after_each(function()
        SetServerVariable(varName, 0)
    end)

    it('keeps the cooldown across a reboot', function()
        SetServerVariable(varName, GetSystemTime() + cooldown)

        local popped = xi.mob.phOnDespawn(GetMobByID(ph:getID()), ID.mob.RAMPAGING_RAM, 100, cooldown)

        assert(not popped, 'the NM popped while its saved cooldown was running')
        assert(nm:getLocalVar('pop') > GetSystemTime(), 'the saved cooldown was not restored into pop')
    end)

    it('keeps a primed NM primed across a reboot', function()
        SetServerVariable(varName, 1)

        local popped = xi.mob.phOnDespawn(GetMobByID(ph:getID()), ID.mob.RAMPAGING_RAM, 0, cooldown)

        assert(popped, 'the NM primed before the reboot did not pop on the first PH kill')
    end)

    it('saves the cooldown when the NM dies', function()
        local popped = xi.mob.phOnDespawn(GetMobByID(ph:getID()), ID.mob.RAMPAGING_RAM, 100, cooldown, { immediate = true })
        assert(popped, 'precondition: a 100% chance should pop the NM')
        assert(GetServerVariable(varName) == 1, 'priming the NM did not save it')

        nm.assert:isSpawned()
        passEngageWindow()
        player:claimAndKillMob(nm)
        for _ = 1, 3 do
            xi.test.world:skipTime(5)
            xi.test.world:tickEntity(nm)
        end

        local saved = GetServerVariable(varName)
        assert(saved > GetSystemTime(), string.format('expected a cooldown end time, got %d', saved))
        assert(saved <= GetSystemTime() + cooldown, string.format('saved cooldown %d is past the %ds cooldown', saved, cooldown))
    end)
end)
