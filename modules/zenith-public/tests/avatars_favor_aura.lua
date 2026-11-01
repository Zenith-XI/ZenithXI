-- ZenithXI Avatar's Favor aura (modules/zenith-public/lua/3-complete/jobAbilities/avatars_favor_aura.lua).
--
-- LSB re-adds the avatar's Favor aura on every Avatar's Favor tick, restarting the aura's 3 s tick. With effect
-- checks landing 2.8 s and 3.2 s apart, a restart can delay the next aura tick to about 6 s, so the 4 s Ifrit's
-- Favor copy on the summoner wears off and comes back (ZXIALPHA-128). The module keeps the existing aura and
-- extends it instead, so the copy never lapses. Zone ticks (0.4 s) reproduce the live server's check spacing;
-- xi.tick.EFFECT would always land exactly 3 s apart and hide the gap.
--
-- ZXIALPHA-129 retest: a fresh aura could still skip its second check once (fixed with a 1 s aura tick), and
-- re-using Avatar's Favor while it was up kept the aura that was being removed, so the buff was gone until the
-- next Favor tick. The last two cases guard those; both fail on LSB and on the earlier module version.

describe('Zenith Avatar\'s Favor aura', function()
    ---@type CClientEntityPair
    local player

    local function addFavor()
        player:addStatusEffect(xi.effect.AVATARS_FAVOR, { power = 1, duration = 7200, origin = player, tick = 10 })
    end

    local function summonWithFavor(petId)
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        player:spawnPet(petId)
        assert(player:getPet(), 'precondition: the avatar is summoned')

        addFavor()
    end

    -- Runs zone ticks and reports how many of them the summoner spent without Ifrit's Favor after first getting it
    -- (from the start when alreadyUp is set). Returns seen, missing; with alreadyUp only missing.
    local function countLapses(zoneTicks, alreadyUp)
        local seen    = alreadyUp == true
        local missing = 0

        for _ = 1, zoneTicks do
            player:setMP(player:getMaxMP()) -- perpetuation must not despawn Ifrit
            xi.test.world:tick()

            if player:hasStatusEffect(xi.effect.IFRITS_FAVOR) then
                seen = true
            elseif seen then
                missing = missing + 1
            end
        end

        if alreadyUp then
            return missing
        end

        return seen, missing
    end

    it('keeps the aura\'s tick count when Favor is applied again', function()
        summonWithFavor(xi.petId.IFRIT)

        for _ = 1, 3 do
            xi.test.world:tick(xi.tick.EFFECT)
        end

        local pet = player:getPet()
        assert(pet:hasStatusEffect(xi.effect.IFRITS_FAVOR), 'precondition: Favor gives Ifrit its aura')

        local ticksBefore = pet:getStatusEffect(xi.effect.IFRITS_FAVOR):getTickCount()
        assert(ticksBefore > 0, string.format('precondition: the aura has ticked, tick count %d', ticksBefore))

        xi.avatarsFavor.applyAvatarsFavorAuraToPet(GetPlayerByID(player:getID()), player:getStatusEffect(xi.effect.AVATARS_FAVOR))

        local aura = pet:getStatusEffect(xi.effect.IFRITS_FAVOR)
        assert(aura, 'the avatar lost its aura')
        assert(aura:getTickCount() == ticksBefore, string.format('the aura was restarted: tick count %d, expected %d', aura:getTickCount(), ticksBefore))
        assert(aura:getTimeRemaining() > 14000, string.format('the aura was not extended: %d ms left', aura:getTimeRemaining()))
    end)

    it('keeps Ifrit\'s Favor on the summoner without a gap', function()
        summonWithFavor(xi.petId.IFRIT)

        local seen     = false
        local missing  = 0
        local firstGap = nil

        -- 60 s of 0.4 s zone ticks: six Favor ticks, four times the aura's own 15 s
        for zoneTick = 1, 150 do
            player:setMP(player:getMaxMP()) -- perpetuation must not despawn Ifrit
            xi.test.world:tick()

            if player:hasStatusEffect(xi.effect.IFRITS_FAVOR) then
                seen = true
            elseif seen then
                missing  = missing + 1
                firstGap = firstGap or zoneTick
            end
        end

        assert(seen, 'precondition: the summoner never got Ifrit\'s Favor')
        assert(missing == 0, string.format('Ifrit\'s Favor lapsed for %d zone ticks, first at zone tick %d', missing, firstGap or 0))
    end)

    -- Control: passes with or without the module, guards the power-change path the module hands back to LSB
    it('updates the aura\'s strength when the Favor power changes', function()
        summonWithFavor(xi.petId.CARBUNCLE)

        local pet  = player:getPet()
        local aura = pet:getStatusEffect(xi.effect.CARBUNCLES_FAVOR)
        assert(aura and aura:getSubPower() == 12, string.format('precondition: power 1 gives Regen 12, got %s', aura and aura:getSubPower() or 'no aura'))

        local favor = player:getStatusEffect(xi.effect.AVATARS_FAVOR)
        favor:setPower(2)
        xi.avatarsFavor.applyAvatarsFavorAuraToPet(GetPlayerByID(player:getID()), favor)

        aura = pet:getStatusEffect(xi.effect.CARBUNCLES_FAVOR)
        assert(aura and aura:getSubPower() == 14, string.format('power 2: expected Regen 14, got %s', aura and aura:getSubPower() or 'no aura'))
    end)

    -- Moves to a given zone tick after an effect check, then waits a moment: on the live server Favor lands a few ms
    -- after the zone tick's timestamp. A REFRESH probe with a 1 s tick advances on every check, showing the grid.
    local function startAfterCheck(offset)
        if not player:hasStatusEffect(xi.effect.REFRESH) then
            player:addStatusEffect(xi.effect.REFRESH, { power = 0, duration = 600, origin = player, tick = 1 })
        end

        local checks = player:getStatusEffect(xi.effect.REFRESH):getTickCount()

        for _ = 1, 10 do
            player:setMP(player:getMaxMP())
            xi.test.world:tick()

            if player:getStatusEffect(xi.effect.REFRESH):getTickCount() ~= checks then
                break
            end
        end

        assert(player:getStatusEffect(xi.effect.REFRESH):getTickCount() ~= checks, 'precondition: no effect check within 10 zone ticks')

        for _ = 1, offset do
            player:setMP(player:getMaxMP())
            xi.test.world:tick()
        end

        local deadline = os.clock() + 0.05
        while os.clock() < deadline do
        end
    end

    -- A new aura's first tick can land just past 3 s; if the next check is 2.8 s later the aura is not 6 s old yet,
    -- so it skips a check and the 4 s copy lapses once. Every start offset within the 6 s check cycle is tried.
    it('gives Ifrit\'s Favor without a gap whenever Favor starts', function()
        local lapsed = {}

        for offset = 0, 14 do
            player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
            player:spawnPet(xi.petId.IFRIT)
            assert(player:getPet(), 'precondition: the avatar is summoned')

            startAfterCheck(offset)
            addFavor()

            local seen, missing = countLapses(40) -- 16 s: past the aura's first three checks and the first Favor tick

            assert(seen, string.format('precondition: offset %d never gave the summoner Ifrit\'s Favor', offset))

            if missing > 0 then
                table.insert(lapsed, string.format('offset %d: %d zone ticks', offset, missing))
            end

            player:despawnPet()
        end

        assert(#lapsed == 0, 'Ifrit\'s Favor lapsed after Favor started at ' .. table.concat(lapsed, ', '))
    end)

    -- Re-using Favor replaces it: the old Favor's loss removes the aura, then the new Favor adds one while the
    -- summoner still carries the old aura's copy. Every re-use offset within the 6 s check cycle is tried.
    it('keeps Ifrit\'s Favor when Avatar\'s Favor is used again while it is up', function()
        local failures = {}

        for offset = 0, 14 do
            summonWithFavor(xi.petId.IFRIT)

            local seen = countLapses(32) -- 12.8 s: past the aura's start-up checks
            assert(seen, string.format('precondition: offset %d, the summoner got Ifrit\'s Favor', offset))

            startAfterCheck(offset)

            -- A 3 s aura tick can also skip a check later, when zone-tick jitter moves the check grid against it
            if not player:hasStatusEffect(xi.effect.IFRITS_FAVOR) then
                table.insert(failures, string.format('offset %d: lapsed before the re-use', offset))
            end

            addFavor() -- what the job ability does

            local missing = countLapses(1, true)
            local hasAura = player:getPet():hasStatusEffect(xi.effect.IFRITS_FAVOR)
            missing       = missing + countLapses(29, true) -- 12 s in all: longer than the 10 s until the next Favor tick

            if not hasAura then
                table.insert(failures, string.format('offset %d: Ifrit has no aura', offset))
            elseif missing > 0 then
                table.insert(failures, string.format('offset %d: lapsed %d zone ticks', offset, missing))
            end

            player:despawnPet()
        end

        assert(#failures == 0, 'after Favor was used again: ' .. table.concat(failures, ', '))
    end)
end)
