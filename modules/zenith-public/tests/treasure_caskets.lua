-- ZenithXI treasure caskets (modules/zenith-public/lua/2-base/treasure_caskets.lua and the loot table
-- in modules/zenith-public/lua/1-enum/xi/casket_loot.lua).
--
-- treasure_caskets.lua: a locked (brown) casket gets one more guess than LSB rolls (4..6, so 5..7).
--   Rolls are stubbed: math.randomFloat 0 always drops a casket, math.randomInt returning its low end
--   makes it brown with 4 attempts (5 with the module), returning its high end makes it blue.
-- casket_loot.lua: replaces xi.casket_loot.casketItems. Prism Powder and Silent Oil are taken out of
--   every temporary-item table (Deodorizer takes their weight), and the item tables are reweighted.
--   West Ronfaure is spot-checked: Deodorizer 1200 and Rabbit Hide 3500, neither of which LSB has.
--   Coeurl Whisker and Leather Pouch come from 1-enum/xi/item.lua, which loads after casket_loot.lua, so
--   the table is built in xi.server.onServerStart; built at load time those entries had a nil itemId.
--
-- The 'attempts' cases guard treasure_caskets.lua and the 'loot' cases guard casket_loot.lua; each
-- group passes when only the other module is switched off.
--
-- Caskets are zone NPCs and keep their local vars and timers between cases, so every case starts
-- and ends with all of West Ronfaure's caskets despawned and cleared.

describe('Zenith treasure caskets', function()
    local spawnedClosed = 1 -- casketInfo.spawnStatus.SPAWNED_CLOSED in scripts/globals/caskets.lua

    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    local function caskets()
        return GetPlayerByID(player:getID()):getZone():queryEntitiesByName('Treasure_Casket')
    end

    local function resetCaskets()
        for _, casket in ipairs(caskets()) do
            casket:clearTimerQueue()
            casket:resetLocalVars()
            casket:setStatus(xi.status.DISAPPEAR)
        end
    end

    local function spawnedCaskets()
        local result = {}
        for _, casket in ipairs(caskets()) do
            if casket:getLocalVar('[caskets]SPAWNSTATUS') == spawnedClosed then
                table.insert(result, casket)
            end
        end

        return result
    end

    -- Drop a casket from the rabbit, as the spawn_casket mixin does on its death
    local function dropCasket()
        local pos = mob:getPos()
        xi.caskets.spawnCasket(GetPlayerByID(player:getID()), GetMobByID(mob:getID()), pos.x, pos.y, pos.z, pos.rot)
    end

    local function rollLow()
        stub('math.randomFloat', 0)
        stub('math.randomInt', function(low, _)
            return low
        end)
    end

    local function rollHigh()
        stub('math.randomFloat', 0)
        stub('math.randomInt', function(_, high)
            return high
        end)
    end

    local function hasItem(entries, itemId)
        for _, entry in ipairs(entries or {}) do
            if entry.itemId == itemId then
                return true
            end
        end

        return false
    end

    local function weightOf(entries, itemId)
        for _, entry in ipairs(entries or {}) do
            if entry.itemId == itemId then
                return entry.weight
            end
        end

        return 0
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
        mob    = player.entities:moveTo('Wild_Rabbit')
        mob:respawn()
        mob:setUnkillable(false) -- other files leave the shared rabbit unkillable, and respawn() keeps it
        resetCaskets()
    end)

    after_each(function()
        resetCaskets()
    end)

    describe('attempts', function()
        it('gives a locked casket one extra attempt', function()
            rollLow()
            dropCasket()

            local spawned = spawnedCaskets()
            assert(#spawned == 1, string.format('precondition: expected one casket to drop, got %d', #spawned))
            assert(spawned[1]:getLocalVar('[caskets]LOCKED') == 1, 'precondition: a low type roll should drop a locked casket')

            local attempts = spawned[1]:getLocalVar('[caskets]ATTEMPTS')
            assert(attempts == 5, string.format('expected 5 attempts (LSB rolled 4, +1), got %d', attempts))
        end)

        it('adds the extra attempt to the new casket only', function()
            rollLow()
            dropCasket()
            local first = spawnedCaskets()[1]
            assert(first ~= nil, 'precondition: the first casket did not drop')

            dropCasket()
            local spawned = spawnedCaskets()
            assert(#spawned == 2, string.format('precondition: expected two caskets, got %d', #spawned))

            for _, casket in ipairs(spawned) do
                local attempts = casket:getLocalVar('[caskets]ATTEMPTS')
                assert(attempts == 5, string.format('casket %d: expected 5 attempts after a second drop, got %d', casket:getID(), attempts))
            end
        end)

        -- The real path: the spawn_casket mixin calls xi.caskets.spawnCasket when the rabbit dies.
        it('gives the extra attempt to a casket from a real kill', function()
            local spawnSpy = spy('xi.caskets.spawnCasket')
            rollLow()

            player:claimAndKillMob(mob)

            assert(#spawnSpy.calls >= 1, 'precondition: killing the rabbit did not call xi.caskets.spawnCasket')

            local spawned = spawnedCaskets()
            assert(#spawned == 1, string.format('precondition: expected one casket from the kill, got %d', #spawned))

            local attempts = spawned[1]:getLocalVar('[caskets]ATTEMPTS')
            assert(attempts == 5, string.format('expected 5 attempts on the dropped casket, got %d', attempts))
        end)
    end)

    describe('loot', function()
        it('keeps Prism Powder and Silent Oil out of every temporary-item table', function()
            for zoneId, zoneLoot in pairs(xi.casket_loot.casketItems) do
                for _, key in ipairs({ 'temps', 'tempsHi', 'tempsLow' }) do
                    assert(not hasItem(zoneLoot[key], xi.item.PINCH_OF_PRISM_POWDER), string.format('zone %d %s still holds Prism Powder', zoneId, key))
                    assert(not hasItem(zoneLoot[key], xi.item.POT_OF_SILENT_OIL), string.format('zone %d %s still holds Silent Oil', zoneId, key))
                end
            end
        end)

        it('uses the reweighted West Ronfaure tables', function()
            local zoneLoot = xi.casket_loot.casketItems[xi.zone.WEST_RONFAURE]

            assert(weightOf(zoneLoot.temps, xi.item.FLASK_OF_DEODORIZER) == 1200, string.format('expected Deodorizer at 1200 in temps, got %d', weightOf(zoneLoot.temps, xi.item.FLASK_OF_DEODORIZER)))
            assert(weightOf(zoneLoot.items, xi.item.RABBIT_HIDE) == 3500, string.format('expected Rabbit Hide at 3500 in items, got %d', weightOf(zoneLoot.items, xi.item.RABBIT_HIDE)))
        end)

        it('gives every entry an item ID', function()
            for zoneId, zoneLoot in pairs(xi.casket_loot.casketItems) do
                for key, entries in pairs(zoneLoot) do
                    if key ~= 'regionalItems' then
                        for i, entry in ipairs(entries) do
                            assert(entry.itemId ~= nil, string.format('zone %d %s entry %d has a nil itemId', zoneId, key, i))
                        end
                    end
                end
            end
        end)

        it('holds the items that only the module item enum adds', function()
            local ranguemont = xi.casket_loot.casketItems[xi.zone.RANGUEMONT_PASS].items
            local yuhtunga   = xi.casket_loot.casketItems[xi.zone.YUHTUNGA_JUNGLE].items

            assert(hasItem(ranguemont, xi.item.LEATHER_POUCH), 'Ranguemont Pass items lost Leather Pouch')
            assert(hasItem(yuhtunga, xi.item.COEURL_WHISKER), 'Yuhtunga Jungle items lost Coeurl Whisker')
        end)

        -- The real path: opening a blue casket rolls its contents from xi.casket_loot.casketItems.
        it('rolls an opened casket from the module table', function()
            rollHigh()
            dropCasket()

            local spawned = spawnedCaskets()
            assert(#spawned == 1, string.format('precondition: expected one casket to drop, got %d', #spawned))
            assert(spawned[1]:getLocalVar('[caskets]LOCKED') == 0, 'precondition: a high type roll should drop an unlocked casket')

            local pickSpy = spy('xi.itemUtils.pickItemRandom')
            player.entities:gotoAndTrigger(spawned[1]:getID())
            player.events:finish()

            assert(#pickSpy.calls >= 1, 'precondition: opening the casket rolled no items')

            local rolledFrom = pickSpy.calls[1].args[1]
            assert(hasItem(rolledFrom, xi.item.FLASK_OF_DEODORIZER), 'the casket rolled from a table without Deodorizer')
            assert(not hasItem(rolledFrom, xi.item.PINCH_OF_PRISM_POWDER), 'the casket rolled from a table that still holds Prism Powder')
        end)
    end)
end)
