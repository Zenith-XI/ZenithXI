-- ZenithXI Impetus (modules/zenith-public/lua/3-complete/jobAbilities/impetus.lua).
--
-- Each landed hit adds +1 attack, and every second one +1% critical rate (half of base), up to 30 stacks.
-- With the body augment, each hit also adds +1 accuracy, and every second one its critical damage bonus.
-- A miss removes everything.

describe('Zenith Impetus', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.MNK, level = 99 })
        mob    = player.entities:moveTo('Wild_Rabbit')

        player.actions:useAbility(player, xi.jobAbility.IMPETUS)
        xi.test.world:tick()
        assert(player:hasStatusEffect(xi.effect.IMPETUS), 'Impetus was not applied')
    end)

    local function hit(times)
        for _ = 1, times do
            player:triggerListener('MELEE_SWING_HIT', player, mob, nil)
        end
    end

    local function miss()
        player:triggerListener('MELEE_SWING_MISS', player, mob, nil)
    end

    local function assertGain(mod, before, expected, what)
        local gain = player:getMod(mod) - before
        assert(gain == expected, string.format('expected +%d %s, got +%d', expected, what, gain))
    end

    it('stacks half the bonus per hit and resets on a miss', function()
        -- 2-base/abilities.lua shortens it to 120 seconds
        assert(player:getStatusEffect(xi.effect.IMPETUS):getDuration() == 120000, 'Impetus lost the 120 second duration from abilities.lua')

        local att  = player:getMod(xi.mod.ATT)
        local crit = player:getMod(xi.mod.CRITHITRATE)

        hit(3)
        assertGain(xi.mod.ATT, att, 3, 'attack after 3 hits')
        assertGain(xi.mod.CRITHITRATE, crit, 1, 'crit after 3 hits')

        miss()
        assertGain(xi.mod.ATT, att, 0, 'attack after a miss')
        assertGain(xi.mod.CRITHITRATE, crit, 0, 'crit after a miss')
    end)

    it('adds the augment critical damage every second hit and resets it on a miss', function()
        -- the body augment sets the sub power when Impetus is used; 10 gives 5 critical damage per step
        player:getStatusEffect(xi.effect.IMPETUS):setSubPower(10)

        local acc     = player:getMod(xi.mod.ACC)
        local critDmg = player:getMod(xi.mod.CRIT_DMG_INCREASE)

        hit(3)
        assertGain(xi.mod.CRIT_DMG_INCREASE, critDmg, 5, 'critical damage after 3 hits')
        assertGain(xi.mod.ACC, acc, 3, 'accuracy after 3 hits')

        hit(1)
        assertGain(xi.mod.CRIT_DMG_INCREASE, critDmg, 10, 'critical damage after 4 hits')

        miss()
        assertGain(xi.mod.CRIT_DMG_INCREASE, critDmg, 0, 'critical damage after a miss')
        assertGain(xi.mod.ACC, acc, 0, 'accuracy after a miss')
    end)

    it('stops stacking at 30 hits', function()
        player:getStatusEffect(xi.effect.IMPETUS):setSubPower(10)

        local att     = player:getMod(xi.mod.ATT)
        local crit    = player:getMod(xi.mod.CRITHITRATE)
        local acc     = player:getMod(xi.mod.ACC)
        local critDmg = player:getMod(xi.mod.CRIT_DMG_INCREASE)

        hit(35)
        assertGain(xi.mod.ATT, att, 30, 'attack after 35 hits')
        assertGain(xi.mod.CRITHITRATE, crit, 15, 'crit after 35 hits')
        assertGain(xi.mod.ACC, acc, 30, 'accuracy after 35 hits')
        assertGain(xi.mod.CRIT_DMG_INCREASE, critDmg, 75, 'critical damage after 35 hits')

        miss()
        assertGain(xi.mod.ATT, att, 0, 'attack after a miss at the cap')
        assertGain(xi.mod.CRIT_DMG_INCREASE, critDmg, 0, 'critical damage after a miss at the cap')
    end)
end)
