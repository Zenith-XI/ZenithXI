-- ZenithXI disabled NMs (modules/zenith-public/lua/3-complete/mobs/nmsDisable.lua).
--
-- The module takes 33 NMs out of circulation from Zone.onInitialize: it switches their respawn off
-- (setRespawnTime(0), or DisallowRespawn for spawn-slot NMs), despawns the one that is up at boot, and
-- adds a DESPAWN listener that switches respawn off again after every despawn. The listener is the fix
-- for NMs whose LSB onMobDespawn re-arms their own timer (Aqrabuamelu: setRespawnTime(7200-7800)),
-- which brought them back about two hours after every boot or kill.
--
-- One case per NM in each of these:
--   * 'after boot': down, nothing pending, still down 25 hours later. Bites without the module for the
--     15 normal-spawn NMs (LSB has them up at boot). The lottery and scripted NMs are down at boot in
--     LSB too, so those rows pass either way and only guard against LSB starting to spawn them.
--   * 'after a GM spawn and kill': !spawnmob works, and after the kill the NM does not come back.
--     Bites without the module for the 15 normal-spawn NMs, and with the pre-listener version of the
--     module for the 10 whose onMobDespawn re-arms the timer (marked rearms below). Scripted NMs have no
--     respawn timer in LSB, and a slot NM's pending respawn belongs to its slot, so those rows pass
--     either way.
--   * 'in its spawn slot': the lottery NMs, with their slot chance forced to 100 and the placeholder
--     killed. LSB pops the NM; with the module the placeholder comes back instead.
--
-- Harvestman re-arms for 21-24 hours, hence the 25-hour wait.

describe('Zenith disabled NMs', function()
    local longWait = 25 * 60 * 60

    local auto     = 'normal spawn'
    local lottery  = 'lottery'
    local scripted = 'scripted'

    local disabledNms =
    {
        { zone = xi.zone.ATTOHWA_CHASM,            name = 'Sargas',               kind = auto,     rearms = true },
        { zone = xi.zone.BEAUCEDINE_GLACIER_S,     name = 'Came-cruse',           kind = scripted },
        { zone = xi.zone.BHAFLAU_THICKETS,         name = 'Harvestman',           kind = auto,     rearms = true },
        { zone = xi.zone.CAPE_TERIGGAN,            name = 'Tegmine',              kind = auto,     rearms = true },
        { zone = xi.zone.CAPE_TERIGGAN,            name = 'Zmey_Gorynych',        kind = auto,     rearms = true },
        { zone = xi.zone.CRAWLERS_NEST,            name = 'Aqrabuamelu',          kind = auto,     rearms = true },
        { zone = xi.zone.CRAWLERS_NEST_S,          name = 'Abatwa',               kind = scripted },
        { zone = xi.zone.EASTERN_ALTEPA_DESERT,    name = 'Sabotender_Corrido',   kind = auto },
        { zone = xi.zone.FEIYIN,                   name = 'Jenglot',              kind = auto },
        { zone = xi.zone.FORT_KARUGO_NARUGO_S,     name = 'Demoiselle_Desolee',   kind = lottery },
        { zone = xi.zone.GARLAIGE_CITADEL_S,       name = 'Citadel_Pipistrelles', kind = scripted },
        { zone = xi.zone.JUGNER_FOREST_S,          name = 'Drumskull_Zogdregg',   kind = lottery },
        { zone = xi.zone.MAMOOK,                   name = 'Venomfang',            kind = scripted },
        { zone = xi.zone.MERIPHATAUD_MOUNTAINS_S,  name = 'Muq_Shabeel',          kind = auto },
        { zone = xi.zone.MOUNT_ZHAYOLM,            name = 'Chary_Apkallu',        kind = auto,     rearms = true },
        { zone = xi.zone.PASHHOW_MARSHLANDS_S,     name = 'Croque-mitaine',       kind = scripted },
        { zone = xi.zone.QUFIM_ISLAND,             name = 'Atkorkamuy',           kind = auto },
        { zone = xi.zone.ROMAEVE,                  name = 'Fired_Urn',            kind = scripted },
        { zone = xi.zone.ROMAEVE,                  name = 'Lode_Golem',           kind = scripted },
        { zone = xi.zone.ROMAEVE,                  name = 'Martinet',             kind = auto,     rearms = true },
        { zone = xi.zone.ROMAEVE,                  name = 'Nargun',               kind = auto,     rearms = true },
        { zone = xi.zone.ROMAEVE,                  name = 'Steely_Weapon',        kind = scripted },
        { zone = xi.zone.THE_ELDIEME_NECROPOLIS_S, name = 'Laelaps',              kind = auto },
        { zone = xi.zone.THE_SANCTUARY_OF_ZITAH,   name = 'Blest_Bones',          kind = scripted },
        { zone = xi.zone.THE_SANCTUARY_OF_ZITAH,   name = 'Holey_Horror',         kind = scripted },
        { zone = xi.zone.THE_SANCTUARY_OF_ZITAH,   name = 'Skeleton_Scuffler',    kind = scripted },
        { zone = xi.zone.TORAIMARAI_CANAL,         name = 'Canal_Moocher',        kind = lottery },
        { zone = xi.zone.TORAIMARAI_CANAL,         name = 'Konjac',               kind = lottery },
        { zone = xi.zone.ULEGUERAND_RANGE,         name = 'Frost_Flambeau',       kind = auto,     rearms = true },
        { zone = xi.zone.ULEGUERAND_RANGE,         name = 'Skvader',              kind = lottery },
        { zone = xi.zone.VUNKERL_INLET_S,          name = 'Big_Bang',             kind = lottery },
        { zone = xi.zone.VUNKERL_INLET_S,          name = 'Warabouc',             kind = auto,     rearms = true },
        { zone = xi.zone.WAJAOM_WOODLANDS,         name = 'Chelicerata',          kind = scripted },
    }

    local function caseName(nm)
        return string.format('%s (%s%s)', nm.name, nm.kind, nm.rearms and ', rearms' or '')
    end

    -- Every instance of the NM in the player's zone, as test entities.
    ---@return CTestEntity[]
    local function instancesOf(player, nm)
        local found = {}

        for _, entity in ipairs(player:getZone():queryEntitiesByName(nm.name)) do
            if entity:getObjType() == xi.objType.MOB then
                table.insert(found, player.entities:get(entity:getID()))
            end
        end

        assert(#found > 0, string.format('precondition: no %s mob in zone %d', nm.name, nm.zone))

        return found
    end

    local function isSlotted(mob)
        return #GetMobByID(mob:getID()):getSpawnSlotMobs() > 0
    end

    -- DespawnMob only starts a despawn; onMobDespawn runs a few seconds later.
    local function settle(mobs)
        for _ = 1, 3 do
            xi.test.world:skipTime(5)
            for _, mob in ipairs(mobs) do
                xi.test.world:tickEntity(mob)
            end
        end
    end

    local function waitLong()
        xi.test.world:skipTime(longWait)
        xi.test.world:tick(xi.tick.SPAWN)
    end

    -- claim_shield holds a fresh NM unkillable for its 30 s engage window (ZXIALPHA-118). skipTime ticks
    -- once per call, so the window timer gets its own tick after the clock has passed it.
    local function passEngageWindow()
        xi.test.world:skipTime(31)
        xi.test.world:skipTime(1)
    end

    local function assertDown(nm, mob, when)
        assert(not mob:isSpawned(), string.format('%s (%d) is spawned %s', nm.name, mob:getID(), when))

        -- A slot NM reports its slot's pending respawn, which belongs to the placeholder as well.
        if not isSlotted(mob) then
            local respawn = mob:getRespawnTime()
            assert(respawn == 0, string.format('%s (%d) respawns in %ds %s', nm.name, mob:getID(), respawn, when))
        end
    end

    local function assertStillDown(nm, mob)
        assert(not mob:isSpawned(), string.format('%s (%d) came back within %d hours', nm.name, mob:getID(), longWait / 3600))
    end

    local function assertKind(nm, mob)
        assert(isSlotted(mob) == (nm.kind == lottery),
            string.format('precondition: %s is listed as %s but is %sin a spawn slot', nm.name, nm.kind, isSlotted(mob) and '' or 'not '))
    end

    describe('after boot', function()
        for _, nm in ipairs(disabledNms) do
            it(string.format('keeps %s down', caseName(nm)), function()
                local player = xi.test.world:spawnPlayer({ zone = nm.zone })
                local mobs   = instancesOf(player, nm)
                assertKind(nm, mobs[1])

                settle(mobs)
                for _, mob in ipairs(mobs) do
                    assertDown(nm, mob, 'after zone init')
                end

                waitLong()
                for _, mob in ipairs(mobs) do
                    assertStillDown(nm, mob)
                end
            end)
        end
    end)

    describe('after a GM spawn and kill', function()
        for _, nm in ipairs(disabledNms) do
            it(string.format('keeps %s down', caseName(nm)), function()
                local player = xi.test.world:spawnPlayer({ zone = nm.zone })
                local mob    = instancesOf(player, nm)[1]
                settle({ mob })

                SpawnMob(mob:getID()) -- what !spawnmob does
                assert(mob:isSpawned(), string.format('a GM spawn of %s (%d) did not spawn it', nm.name, mob:getID()))

                passEngageWindow()
                player:claimAndKillMob(mob) -- waits for the full despawn, so onMobDespawn has run
                assertDown(nm, mob, 'after it was killed')

                waitLong()
                assertStillDown(nm, mob)
            end)
        end
    end)

    describe('in its spawn slot', function()
        for _, nm in ipairs(disabledNms) do
            if nm.kind == lottery then
                it(string.format('never picks %s', nm.name), function()
                    local player = xi.test.world:spawnPlayer({ zone = nm.zone })
                    local mob    = instancesOf(player, nm)[1]
                    assertKind(nm, mob)
                    settle({ mob })

                    ---@type CTestEntity[]
                    local placeholders = {}
                    ---@type CTestEntity?
                    local livePh       = nil
                    for _, id in ipairs(GetMobByID(mob:getID()):getSpawnSlotMobs()) do
                        if id ~= mob:getID() then
                            local ph = player.entities:get(id)
                            table.insert(placeholders, ph)
                            if ph:isSpawned() then
                                livePh = ph
                            end
                        end
                    end

                    assert(not mob:isSpawned(), string.format('precondition: %s is up before its placeholder dies', nm.name))
                    assert(livePh, string.format('precondition: no placeholder of %s is up', nm.name))

                    -- A chance of 100 wins every roll that follows a kill, if the NM is allowed to take part.
                    xi.test.world:setSlotChance(mob, 100)
                    player:claimAndKillMob(livePh)
                    waitLong()
                    xi.test.world:setSlotChance(mob, 15)

                    assert(not mob:isSpawned(), string.format('%s won its slot roll after the placeholder died', nm.name))

                    local phUp = false
                    for _, ph in ipairs(placeholders) do
                        phUp = phUp or ph:isSpawned()
                    end

                    assert(phUp, string.format('no placeholder of %s came back: the slot stopped respawning', nm.name))
                end)
            end
        end
    end)
end)
