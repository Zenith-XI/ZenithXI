-- ZenithXI Avatar's Favor aura (modules/zenith-public/lua/3-complete/jobAbilities/avatars_favor_aura.lua).
--
-- LSB re-adds the avatar's Favor aura on every Avatar's Favor tick, restarting the aura's 3 s tick. With effect
-- checks landing 2.8 s and 3.2 s apart, a restart can delay the next aura tick to about 6 s, so the 4 s Ifrit's
-- Favor copy on the summoner wears off and comes back (ZXIALPHA-128). The module keeps the existing aura and
-- extends it instead, so the copy never lapses. Zone ticks (0.4 s) reproduce the live server's check spacing;
-- xi.tick.EFFECT would always land exactly 3 s apart and hide the gap.

describe('Zenith Avatar\'s Favor aura', function()
    ---@type CClientEntityPair
    local player

    local function summonWithFavor(petId)
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        player:spawnPet(petId)
        assert(player:getPet(), 'precondition: the avatar is summoned')

        player:addStatusEffect(xi.effect.AVATARS_FAVOR, { power = 1, duration = 7200, origin = player, tick = 10 })
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
end)
