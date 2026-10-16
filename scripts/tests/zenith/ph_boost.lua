-- ZenithXI PH boost on spawn-slot lotteries (modules/zenith-public/lua/2-base/phOnMobDespawn.lua,
-- modules/zenith-public/cpp/spawn_slot_lua.cpp).
--
-- The module edits SpawnSlot entries through a const_cast, so it silently depends on how base rolls
-- a slot. The 'slot contract' cases fail if that changes, which is the point: run this after every LSB merge.

-- South Gustaberg slot from data/zones/south_gustaberg/mobs.yaml:
--   17215612: {}          # Ornery_Sheep
--   17215613: {chance: 8} # Carnero
--   17215626: {chance: 8} # Carnero
local ORNERY_SHEEP = 17215612
local CARNERO      = { 17215613, 17215626 }
local BASE_CHANCE  = 8

describe('Zenith PH boost', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local ph

    -- CLuaTestEntity does not see methods a C++ module adds to CBaseEntity, so bindings go through GetMobByID
    local function slotEntry(mobId)
        return GetMobByID(mobId):getSpawnSlotEntry()
    end

    local function clearRespawnVars()
        for _, nmId in ipairs(CARNERO) do
            SetServerVariable(zxi.mobHelpers.getRespawnVarName(GetMobByID(nmId)), 0)
        end
    end

    -- Kill the PH and put it straight back, so the slot never rolls and the 8% chance cannot make a case flaky
    local function killPh()
        player:claimAndKillMob(ph)
        for _ = 1, 3 do
            xi.test.world:skipTime(5)
            xi.test.world:tickEntity(ph)
        end

        SpawnMob(ORNERY_SHEEP)
        ph.assert:isSpawned()
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.SOUTH_GUSTABERG })
        ph     = player.entities:get(ORNERY_SHEEP)

        -- xi_test shares the database, so start from a clean module and server-var state every case
        clearRespawnVars()
        for _, nmId in ipairs(CARNERO) do
            local nm = GetMobByID(nmId)
            if nm:isSpawned() then
                -- a despawn takes a few ticks, and the module treats a still-spawned NM as up and resets its count
                DespawnMob(nmId)
                local nmEntity = player.entities:get(nmId)
                for _ = 1, 3 do
                    xi.test.world:skipTime(5)
                    xi.test.world:tickEntity(nmEntity)
                end

                nmEntity.assert.no:isSpawned()
            end

            nm:setSpawnSlotEntry({ chance = BASE_CHANCE, readyIn = 0 })
            nm:setLocalVar('phKills', 0)
            -- the module caches the base chance on the first PH kill it sees, and an earlier case may have forced it
            zxi.slotLottery.base[nmId]     = nil
            zxi.slotLottery.lastSet[nmId]  = nil
            zxi.slotLottery.restored[nmId] = true
        end

        if not ph:isSpawned() then
            SpawnMob(ORNERY_SHEEP)
        end
    end)

    after_each(function()
        clearRespawnVars()
    end)

    describe('slot contract', function()
        it('exposes the slot entry loaded from mobs.yaml', function()
            assert(GetMobByID(CARNERO[1]).getSpawnSlotEntry, 'cpp/spawn_slot_lua.cpp is not built into this binary')

            for _, nmId in ipairs(CARNERO) do
                local entry = slotEntry(nmId)
                assert(entry, string.format('mob %d has no spawn slot entry', nmId))
                assert(entry.chance == BASE_CHANCE, string.format('expected chance %d for %d, got %d', BASE_CHANCE, nmId, entry.chance))
            end

            local phEntry = slotEntry(ORNERY_SHEEP)
            assert(phEntry and phEntry.chance == 0, 'the placeholder should be a chance-less slot member')
        end)

        it('rolls the chance written through the module', function()
            for _, nmId in ipairs(CARNERO) do
                GetMobByID(nmId):setSpawnSlotEntry({ chance = 50 })
            end

            -- a slot respawn after a PH kill must read the chance we wrote: 50 + 50 always rolls an NM
            player:claimAndKillMob(ph)
            xi.test.world:skipTime(3600)
            xi.test.world:tick(xi.tick.SPAWN)

            local spawned = GetMobByID(CARNERO[1]):isSpawned() or GetMobByID(CARNERO[2]):isSpawned()
            assert(spawned, 'SpawnSlot did not roll the chance set through setSpawnSlotEntry')
            ph.assert.no:isSpawned()
        end)
    end)

    describe('boost', function()
        it('counts every PH kill on each NM of the slot', function()
            for kill = 1, 3 do
                killPh()

                for _, nmId in ipairs(CARNERO) do
                    local phKills = GetMobByID(nmId):getLocalVar('phKills')
                    assert(phKills == kill, string.format('after %d kills %d has phKills %d', kill, nmId, phKills))
                end
            end
        end)

        it('raises the slot chance along the phKills curve', function()
            -- 1 PH in the slot: kill n rolls with 8 * (2 - 10 / (n - 1 + 10)), rounded
            local expected = { 8, 9, 9, 10 }

            for kill, chance in ipairs(expected) do
                killPh()

                for _, nmId in ipairs(CARNERO) do
                    local entry = slotEntry(nmId)
                    assert(entry.chance == chance, string.format('after %d kills expected chance %d on %d, got %d', kill, chance, nmId, entry.chance))
                end
            end
        end)

        it('leaves a chance forced from elsewhere alone', function()
            -- the module learns the base chance on the first PH kill it sees; a chance forced before that is taken as the base
            killPh()
            GetMobByID(CARNERO[1]):setSpawnSlotEntry({ chance = 42 })

            killPh()
            killPh()

            assert(slotEntry(CARNERO[1]).chance == 42, 'the module overwrote a chance it did not set')
        end)

        it('stops counting while the NM is on cooldown', function()
            for _, nmId in ipairs(CARNERO) do
                GetMobByID(nmId):setSpawnSlotEntry({ readyIn = 600 })
            end

            killPh()

            for _, nmId in ipairs(CARNERO) do
                assert(GetMobByID(nmId):getLocalVar('phKills') == 0, 'phKills grew while the NM was on cooldown')
                assert(slotEntry(nmId).chance == BASE_CHANCE, 'chance was boosted while the NM was on cooldown')
            end
        end)
    end)

    describe('NM death', function()
        it('saves the cooldown to the respawn server var and drops the boost', function()
            killPh()
            killPh()
            assert(slotEntry(CARNERO[1]).chance > BASE_CHANCE, 'precondition: the chance is boosted')

            -- bring Carnero up in the PH's place directly, so the boosted chance is not touched
            local nmId = CARNERO[1]
            local nm   = player.entities:get(nmId)
            DespawnMob(ORNERY_SHEEP)
            for _ = 1, 3 do
                xi.test.world:skipTime(5)
                xi.test.world:tickEntity(ph)
            end

            SpawnMob(nmId)
            nm.assert:isSpawned()

            local before = GetSystemTime()
            player:claimAndKillMob(nm)

            local var = GetServerVariable(zxi.mobHelpers.getRespawnVarName(GetMobByID(nmId)))
            assert(var >= before, string.format('respawn server var not saved for %d (got %d)', nmId, var))
            assert(slotEntry(nmId).chance == BASE_CHANCE, 'chance was not put back to base after the NM died')
        end)
    end)
end)
