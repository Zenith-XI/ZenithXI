-- ZenithXI Absorb-STAT potency decay (modules/zenith-public/lua/3-complete/eraSpellPotency.lua, ZENITHDEV-253).
--
-- A player's Absorb-STAT lasts 90 seconds and the boost and the down each lose 1 point every 10 second tick.
-- Gear still changes duration and potency. Absorb spells cast by monsters keep base's behaviour.
-- The helper is called directly so cast time and resist rolls do not make the cases flaky.

describe('Zenith Absorb-STAT decay', function()
    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    local function absorbStr(caster, target)
        local spell = GetSpell(xi.magic.spell.ABSORB_STR)
        assert(spell, 'Absorb-STR spell not found')
        return xi.spells.absorb.doAbsorbStatSpell(caster, target, spell)
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.DRK, level = 75 })
        mob    = player.entities:moveTo('Wild_Rabbit')

        -- land every cast in both directions
        player:addMod(xi.mod.MACC, 2000)
        mob:setMod(xi.mod.MACC, 2000)
    end)

    it('gives a player a 90 second boost and down that decay every 10 seconds', function()
        local str = player:getStat(xi.mod.STR)
        absorbStr(player, mob)

        local boost = player:getStatusEffect(xi.effect.STR_BOOST)
        local down  = mob:getStatusEffect(xi.effect.STR_DOWN)
        assert(boost and down, 'Absorb-STR did not land')

        -- level 75: 3 + floor(75 / 5) = 18
        assert(boost:getPower() == 18, string.format('expected power 18, got %d', boost:getPower()))
        for label, effect in pairs({ boost = boost, down = down }) do
            assert(effect:getDuration() == 90000, string.format('%s lasts %d ms, expected 90000', label, effect:getDuration()))
            assert(effect:getTick() == 10000, string.format('%s ticks every %d ms, expected 10000', label, effect:getTick()))
        end

        xi.test.world:skipTime(10)

        boost = player:getStatusEffect(xi.effect.STR_BOOST)
        assert(boost:getPower() == 17, string.format('the boost did not decay: power %d', boost:getPower()))
        assert(player:getStat(xi.mod.STR) - str == 17, string.format('expected +17 STR after one tick, got +%d', player:getStat(xi.mod.STR) - str))
    end)

    it('still applies duration and potency gear', function()
        player:addMod(xi.mod.DARK_MAGIC_DURATION, 20)
        player:addMod(xi.mod.ABSORB_EFFECT_DURATION, 50)
        player:addMod(xi.mod.ENHANCES_ABSORB_EFFECTS, 5)
        player:addMod(xi.mod.AUGMENTS_ABSORB, 50)

        absorbStr(player, mob)

        local boost = player:getStatusEffect(xi.effect.STR_BOOST)
        assert(boost, 'Absorb-STR did not land')
        -- floor(90 * 1.2 * 1.5) + 5 = 167 seconds, floor(18 * 1.5) = 27
        assert(boost:getDuration() == 167000, string.format('expected 167000 ms with gear, got %d', boost:getDuration()))
        assert(boost:getPower() == 27, string.format('expected power 27 with Augments "Absorb", got %d', boost:getPower()))
        assert(boost:getTick() == 10000, 'gear changed the decay tick')
    end)

    it('leaves Absorb-STAT cast by monsters as in base', function()
        absorbStr(mob, player)

        local down = player:getStatusEffect(xi.effect.STR_DOWN)
        assert(down, 'the monster\'s Absorb-STR did not land')
        assert(down:getTick() == 0, string.format('a monster\'s Absorb-STR decays (tick %d)', down:getTick()))
    end)
end)
