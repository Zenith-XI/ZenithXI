-- ZenithXI claim shield (modules/zenith-public/lua/3-complete/claim_shield.lua).
--
-- The module hooks each NM's onMobInitialize. Some NMs only exist in mobs.yaml, with no
-- scripts/zones/<zone>/mobs/<name>.lua to hook, so the module builds their script table itself.
-- If these fail, those NMs spawn without a claim shield.
--
-- It also holds a fresh NM unkillable for the 30 s engage window, so a first blow that kills
-- it outright (LSB: dead before its AI tick ever engages, no lottery) leaves it at 1 HP, and it
-- restores every flag it changed when the NM despawns mid-lottery (LSB keeps m_unkillable and
-- mob mods across a respawn, which left the NM unkillable and unclaimable). ZXIALPHA-118.

describe('Zenith claim shield', function()
    local scriptlessNms =
    {
        { zone = xi.zone.BEAUCEDINE_GLACIER,  name = 'Nue' },
        { zone = xi.zone.KING_RANPERRES_TOMB, name = 'Crypt_Ghost' },
    }

    for _, nm in ipairs(scriptlessNms) do
        it(string.format('hooks %s, which has no mob script', nm.name), function()
            local player = xi.test.world:spawnPlayer({ zone = nm.zone })
            local mob    = player.entities:get(nm.name)

            mob:respawn()

            -- set by the SPAWN listener the module adds in onMobInitialize
            assert(mob:getLocalVar('CS_SpawnTime') > 0, string.format('%s spawned without the claim shield listeners', nm.name))
        end)
    end
end)

describe('Zenith claim shield engage window', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    -- skipTime ticks the world once per call, so the window timer gets its own tick after the
    -- clock has passed the 30 s window.
    local function passEngageWindow()
        xi.test.world:skipTime(31)
        xi.test.world:skipTime(1)
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTH_GUSTABERG, job = xi.job.WAR, level = 75 })
        mob    = player.entities:moveTo('Leaping_Lizzy')

        -- Mobs are shared by every case and these flags survive respawn(), so start from vanilla.
        -- Clearing CS_Guarded stops the DESPAWN listener inside respawn() from restoring an earlier
        -- case's record over them.
        mob:setLocalVar('CS_Guarded', 0)
        mob:setUnkillable(false)
        mob:setMobMod(xi.mobMod.CLAIM_TYPE, xi.claimType.EXCLUSIVE)
        mob:setCallForHelpBlocked(false)
        mob:respawn()
    end)

    it('holds a fresh NM unkillable for the engage window, then releases it', function()
        assert(mob:getUnkillable(), 'NM is killable right after spawning, so a one-shot skips the lottery')

        passEngageWindow()

        assert(not mob:getUnkillable(), 'NM is still unkillable after an engage window nobody engaged in')
    end)

    it('survives a killing first blow inside the engage window', function()
        local nm = GetMobByID(mob:getID())

        nm:takeDamage(nm:getMaxHP() * 10, GetPlayerByID(player:getID()), xi.attackType.PHYSICAL, xi.damageType.SLASHING)
        xi.test.world:skipTime(1)

        assert(mob:isAlive(), 'a killing first blow killed the NM before the lottery could start')
        assert(mob:getHP() == 1, string.format('expected the NM held at 1 HP, got %d', mob:getHP()))
    end)

    it('brings the NM back as a normal NM after a despawn during the lottery', function()
        GetMobByID(mob:getID()):updateEnmity(GetPlayerByID(player:getID()))
        xi.test.world:tickEntity(mob)
        xi.test.world:tickEntity(mob)

        assert(mob:getLocalVar('CS_Triggered') == 1, 'precondition: the engage did not start the claim shield')
        assert(mob:getMobMod(xi.mobMod.CLAIM_TYPE) == xi.claimType.UNCLAIMABLE, 'precondition: the claim shield is not up')

        -- Dies and despawns mid-lottery, then spawns again (Test 8 of the plan).
        mob:respawn()
        passEngageWindow()

        assert(not mob:getUnkillable(), 'NM came back unkillable after despawning mid-lottery')
        assert(not mob:getCallForHelpBlocked(), 'NM came back with call for help blocked after despawning mid-lottery')

        local claimType = mob:getMobMod(xi.mobMod.CLAIM_TYPE)
        assert(claimType == xi.claimType.EXCLUSIVE, string.format('NM came back with claim type %d, expected %d (exclusive)', claimType, xi.claimType.EXCLUSIVE))
    end)
end)
