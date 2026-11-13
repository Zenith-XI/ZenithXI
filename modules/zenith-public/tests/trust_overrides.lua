-- ZenithXI Trust overrides, ZENITHDEV-200 (modules/zenith-public/lua/4-additive/trusts/*_override.lua).
--
-- Balance values from the ticket, checked on the spawned Trust:
-- - Curilla: Shield Block Rate 20 (LSB 25), no ENHANCES_GUARDIAN (LSB 30), Shield Mastery TP 10/20/30,
--   Cure cast time -50, Cure Potency 25, Enmity 15, DT -5%, HP +10%, MP +30%.
-- - Curilla's Sentinel lasts 40 s (LSB 30 s) and her Guardian enmity retention (LSB subPower 95) is gone.
-- - Trion: Shield Block Rate 25 (LSB 35), keeps SIRD 30, Fast Cast 30, Enmity 15, DT -5%, HP/MP +10%.
-- - Semih Lafihna: Store TP +40 (LSB +86); her special message is on Stellar Arrow (3489), not Lux Arrow
--   (3490, which LSB checks).
-- - Shantotto: Magic Attack / Accuracy from modGrowthValMax(39) (about 25 at 75; LSB adds level / 10),
--   Fast Cast 10, MP +100%, Magic Haste 10%.
-- The other overrides' gambits and mods are still under review and are only covered as controls below.

describe('Zenith trust overrides #trusts', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
    end)

    local function summon(trustName, level)
        player:clearTrusts()
        player:setLevel(level)

        local trust = player:spawnTrust(xi.magic.spell[trustName])
        assert(trust ~= nil, string.format('precondition: %s did not spawn', trustName))
        assert(trust:getMainLvl() == level, string.format('precondition: %s is level %d, expected %d', trustName, trust:getMainLvl(), level))

        return trust
    end

    local function assertMods(trustName, level, expected)
        local trust = summon(trustName, level)

        for _, entry in ipairs(expected) do
            local modName, value = entry[1], entry[2]
            local actual         = trust:getMod(xi.mod[modName])

            assert(actual == value, string.format('%s level %d: expected %s %d, got %d', trustName, level, modName, value, actual))
        end
    end

    it('applies Curilla\'s reviewed mods', function()
        local common =
        {
            { 'SHIELDBLOCKRATE', 20 },
            { 'ENHANCES_GUARDIAN', 0 },
            { 'CURE_CAST_TIME', 50 },
            { 'CURE_POTENCY', 25 },
            { 'ENMITY', 15 },
            { 'DMG', -500 },
            { 'HPP', 10 },
            { 'MPP', 30 },
        }

        for _, row in ipairs({ { 24, 0 }, { 25, 10 }, { 50, 20 }, { 75, 30 } }) do
            local expected = { { 'SHIELD_MASTERY_TP', row[2] } }
            for _, entry in ipairs(common) do
                table.insert(expected, entry)
            end

            assertMods('CURILLA', row[1], expected)
        end
    end)

    it('applies Trion\'s reviewed mods', function()
        assertMods('TRION', 75,
        {
            { 'SHIELDBLOCKRATE', 25 },
            { 'SHIELD_MASTERY_TP', 30 },
            { 'SPELLINTERRUPT', 30 },
            { 'FASTCAST', 30 },
            { 'ENMITY', 15 },
            { 'DMG', -500 },
            { 'HPP', 10 },
            { 'MPP', 10 },
        })
    end)

    it('gives Semih Lafihna Store TP +40', function()
        assertMods('SEMIH_LAFIHNA', 75, { { 'STORETP', 40 } })
    end)

    it('scales Shantotto\'s Magic Attack and Accuracy with modGrowthValMax(39)', function()
        local trust  = summon('SHANTOTTO', 75)
        local growth = xi.trust.modGrowthValMax(trust, 39)

        assert(growth == 25, string.format('precondition: modGrowthValMax(39) at 75 is %d, the ticket expects about 25', growth))

        -- BLM Magic Atk. Bonus trait at 70 is +32; BLM has no Magic Accuracy trait
        assertMods('SHANTOTTO', 75,
        {
            { 'MATT', 32 + growth },
            { 'MACC', growth },
            { 'FASTCAST', 10 },
            { 'MPP', 100 },
            { 'HASTE_MAGIC', 1000 },
        })
    end)

    -- Controls: standard job traits still come from the central trait data, and the remaining override
    -- mods that ZENITHDEV-200 did not ask for (Halver Double Attack, Iron Eater Store TP) are unchanged.
    it('keeps standard traits and the other override mods', function()
        assertMods('AYAME', 75, { { 'ZANSHIN', 45 } })
        assertMods('EXCENMILLE', 5, { { 'UNDEAD_KILLER', 8 } })
        assertMods('NANAA_MIHGO', 15, { { 'GILFINDER', 1 }, { 'TREASURE_HUNTER', 1 } })
        assertMods('HALVER', 15, { { 'DOUBLE_ATTACK', 10 } })
        assertMods('IRON_EATER', 10, { { 'STORETP', 10 } })
    end)

    it('shows Semih Lafihna\'s special message on Stellar Arrow, not Lux Arrow', function()
        local trust   = summon('SEMIH_LAFIHNA', 75)
        local message = spy('xi.trust.message')

        local function useSkill(skillId)
            local skill = { getID = function()
                return skillId
            end }

            trust:triggerListener('WEAPONSKILL_USE', trust, trust, skill, 1000, nil, 0)
        end

        useSkill(xi.mobSkill.LUX_ARROW)
        assert(#message.calls == 0, 'Lux Arrow (3490) showed the Stellar Arrow message')

        useSkill(xi.mobSkill.STELLAR_ARROW)
        assert(#message.calls == 1, string.format('Stellar Arrow (3489) showed %d messages, expected 1', #message.calls))
        assert(message.calls[1].args[2] == xi.trust.messageOffset.SPECIAL_MOVE_1, 'Stellar Arrow showed the wrong message')
    end)

    describe('Curilla\'s Sentinel', function()
        ---@type CTestEntity
        local mob

        before_each(function()
            player:setCharVar('TrustEngageType', 1) -- engage with the master, no first swing needed

            mob = player.entities:moveTo('Wild_Rabbit')
            mob:respawn()
            mob:setUnkillable(true)
        end)

        -- Leave West Ronfaure as other tests expect it: no trusts out and a fresh rabbit with no enmity,
        -- or the next player (who may reuse this character ID) cannot call a trust.
        after_each(function()
            player:clearTrusts()
            mob:setUnkillable(false)
            mob:respawn()
        end)

        it('lasts 40 seconds and has no Guardian enmity retention', function()
            local trust = summon('CURILLA', 30)

            player.actions:engage(mob)

            local sentinel = nil
            for _ = 1, 20 do
                xi.test.world:skipTime(1)
                sentinel = trust:getStatusEffect(xi.effect.SENTINEL)
                if sentinel then
                    break
                end
            end

            assert(sentinel ~= nil, 'precondition: Curilla did not use Sentinel within 20 s of engaging')
            assert(sentinel:getDuration() == 40000, string.format('expected a 40000 ms Sentinel, got %d', sentinel:getDuration()))

            -- A few combat ticks, where LSB's Curilla raises subPower to 95
            for _ = 1, 3 do
                player:setHP(player:getMaxHP())
                xi.test.world:skipTime(1)
            end

            sentinel = trust:getStatusEffect(xi.effect.SENTINEL)
            assert(sentinel ~= nil, 'precondition: Sentinel wore off within 4 s')
            assert(sentinel:getSubPower() == 0, string.format('expected no Guardian enmity retention (subPower 0), got %d', sentinel:getSubPower()))
        end)
    end)
end)
