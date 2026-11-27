-- ZenithXI Trust overrides, ZENITHDEV-200 (modules/zenith-public/lua/4-additive/trusts/*_override.lua).
--
-- Balance values from the ticket, checked on the spawned Trust:
-- - Curilla: Shield Block Rate 20 (LSB 25), no ENHANCES_GUARDIAN (LSB 30), Shield Mastery TP 10/20/30,
--   Cure cast time -50, Cure Potency 25, Enmity +5/+10/+15/+20 at 15/30/45/60, DT -5%, HP +10%, MP +50%.
-- - Curilla's Sentinel lasts 40 s (LSB 30 s), its recast is 250 s (LSB 300 s, its listener's change came too
--   late to count) and her Guardian enmity retention (LSB subPower 95) is gone.
-- - Trion: Shield Block Rate 25 (LSB 35), keeps SIRD 30, Fast Cast 30, Enmity +5/+10/+15 at 30/45/60, DT -5%, HP/MP +10%.
-- - Semih Lafihna: Store TP +40 (LSB +86); her special message is on Stellar Arrow (3489), not Lux Arrow
--   (3490, which LSB checks).
-- - Shantotto: Magic Attack / Accuracy from modGrowthValMax(39) (about 25 at 75; LSB adds level / 10),
--   Fast Cast 10, MP +100%, Magic Haste 10%.
-- - LOWEST gambit (123-GambitLowestImplementation.patch): Shantotto and Ajido-Marujido cast their lowest
--   tier below 10% HP (LSB casts nothing there), and the selector honours its spell family.
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
            { 'DMG', -500 },
            { 'HPP', 10 },
            { 'MPP', 50 },
        }

        for _, row in ipairs({
            { 14,  0,  0 },
            { 15,  0,  5 },
            { 24,  0,  5 },
            { 25, 10,  5 },
            { 30, 10, 10 },
            { 45, 10, 15 },
            { 50, 20, 15 },
            { 60, 20, 20 },
            { 75, 30, 20 },
        }) do
            local expected =
            {
                { 'SHIELD_MASTERY_TP', row[2] },
                { 'ENMITY', row[3] },
            }

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

    it('applies Excenmille\'s reviewed mods', function()
        assertMods('EXCENMILLE', 75,
        {
            { 'HPP', 10 },
            { 'MPP', 20 },
            { 'ENMITY', 10 },
            { 'STORETP', 25 },
        })
    end)

    it('applies Halver\'s reviewed mods', function()
        assertMods('HALVER', 75,
        {
            { 'HPP', 10 },
            { 'MPP', 30 },
            { 'ENMITY', 10 },
        })
    end)

    it('scales tank Trust enmity bonuses by level', function()
        assertMods('TRION', 29, { { 'ENMITY', 0 } })
        assertMods('TRION', 30, { { 'ENMITY', 5 } })
        assertMods('TRION', 45, { { 'ENMITY', 10 } })

        assertMods('HALVER', 29, { { 'ENMITY', 0 } })
        assertMods('HALVER', 30, { { 'ENMITY', 5 } })
        assertMods('HALVER', 45, { { 'ENMITY', 10 } })

        assertMods('EXCENMILLE', 9, { { 'ENMITY', 0 } })
        assertMods('EXCENMILLE', 10, { { 'ENMITY', 5 } })
        assertMods('EXCENMILLE', 20, { { 'ENMITY', 10 } })
    end)

    it('applies Volker\'s reviewed mods', function()
        assertMods('VOLKER', 75,
        {
            { 'HPP', 15 },
            { 'ALL_WSDMG_ALL_HITS', 10 },
            -- Base 225 + 10 from added mod at 15
            { 'ACC', 235 },
        })
    end)

    it('applies Iron Eater\'s reviewed mods', function()
        assertMods('IRON_EATER', 10,
        {
            { 'STORETP', 10 },
        })
        assertMods('IRON_EATER', 30,
        {
            { 'STORETP', 15 }, { 'DOUBLE_ATTACK', 15 }
        })
        assertMods('IRON_EATER', 50,
        {
            { 'STORETP', 20 },
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

    -- Controls: standard job traits still come from the central trait data
    it('keeps standard traits and the other override mods', function()
        assertMods('AYAME', 75, { { 'ZANSHIN', 45 } })
        assertMods('EXCENMILLE', 5, { { 'UNDEAD_KILLER', 8 } })
        assertMods('NANAA_MIHGO', 15, { { 'GILFINDER', 1 }, { 'TREASURE_HUNTER', 1 } })
        assertMods('HALVER', 15, { { 'DOUBLE_ATTACK', 10 } })
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
        -- or the next player (who may reuse this character ID) cannot call a trust or inherits the engage type.
        after_each(function()
            player:clearTrusts()
            player:setCharVar('TrustEngageType', 0)
            mob:setUnkillable(false)
            mob:respawn()
        end)

        -- Summons a level 30 Curilla, engages the rabbit and waits for her first Sentinel.
        local function summonAndAwaitSentinel()
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

            return trust, sentinel
        end

        it('has a 250 second recast', function()
            local trust = summonAndAwaitSentinel()

            assert(trust:hasRecast(xi.recast.ABILITY, xi.jobAbility.SENTINEL), 'precondition: Sentinel started no recast')

            -- End the fight, so she cannot use Sentinel again once the recast is over
            player:disengage()
            mob:respawn()

            for _ = 1, 24 do
                xi.test.world:skipTime(10)
            end

            assert(trust:hasRecast(xi.recast.ABILITY, xi.jobAbility.SENTINEL), 'precondition: the Sentinel recast was gone after 240 s')

            for _ = 1, 2 do
                xi.test.world:skipTime(10)
            end

            assert(not trust:hasRecast(xi.recast.ABILITY, xi.jobAbility.SENTINEL), 'the Sentinel recast was still running after 260 s; expected 250 s')
        end)

        it('lasts 40 seconds and has no Guardian enmity retention', function()
            local trust, sentinel = summonAndAwaitSentinel()

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

    -- The LOWEST gambit selector (123-GambitLowestImplementation.patch; LSB casts nothing for it) and the
    -- Shantotto / Ajido-Marujido gambits that use it. Level 15 keeps the spell lists short and is below
    -- Conserve MP: Stone (1), Water (5), Aero (9), Fire (13) for both, plus Cure (1), Cure II (11) and
    -- Paralyze (12) for Ajido-Marujido. Casts are read from MAGIC_START, so no MP arithmetic is needed.
    describe('LOWEST gambit #gambits', function()
        ---@type CTestEntity
        local mob

        before_each(function()
            player:setCharVar('TrustEngageType', 1) -- engage with the master, no first swing needed

            mob = player.entities:moveTo('Wild_Rabbit')
            mob:respawn()
            mob:setUnkillable(true)
            mob:setMaxHP(100) -- so setHP(n) is n% HP
        end)

        -- Leave West Ronfaure as other tests expect it: no trusts out and a fresh rabbit with no enmity,
        -- or the next player (who may reuse this character ID) cannot call a trust or inherits the engage type.
        after_each(function()
            player:clearTrusts()
            player:setCharVar('TrustEngageType', 0)
            mob:setUnkillable(false)
            mob:respawn()
        end)

        -- Summons the trust and records every spell it starts to cast, with its target's HP% at the time.
        local function summonRecordingCasts(trustName)
            local trust = summon(trustName, 15)
            local casts = {}

            trust:addListener('MAGIC_START', 'ZENITH_TEST_CASTS', function(caster, target, spell)
                table.insert(casts, { id = spell:getID(), hpp = target:getHPP() })
            end)

            return trust, casts
        end

        local function assertCast(casts, n, spellId, spellName)
            local cast = casts[n]
            local got  = cast and string.format('spell %d at %d%% HP', cast.id, cast.hpp) or 'nothing'

            assert(cast and cast.id == spellId, string.format('cast %d: expected %s (%d), got %s', n, spellName, spellId, got))
        end

        -- Removes every gambit the trust's onMobSpawn added, so a test can add exactly one.
        -- Gambit ids are '<index>_<predicate groups>_<actions>' (CGambitsContainer::NewGambitIdentifier).
        local function clearGambits(trust)
            for index = 0, 15 do
                for predicates = 1, 4 do
                    for actions = 1, 4 do
                        trust:removeGambit(string.format('%d_%d_%d', index, predicates, actions))
                    end
                end
            end
        end

        local function fightUntil(casts, count)
            player.actions:engage(mob)

            for _ = 1, 20 do
                if #casts >= count then
                    return
                end

                xi.test.world:skipTime(1)
            end
        end

        local function setMobHPP(hpp)
            mob:setHP(hpp)
            assert(mob:getHPP() == hpp, string.format('precondition: rabbit at %d%% HP, expected %d%%', mob:getHPP(), hpp))
        end

        it('Shantotto casts Stone below 10% HP, then the next lowest tier while Stone recasts', function()
            setMobHPP(9)
            local _, casts = summonRecordingCasts('SHANTOTTO')

            fightUntil(casts, 2)

            assertCast(casts, 1, xi.magic.spell.STONE, 'Stone')
            assertCast(casts, 2, xi.magic.spell.WATER, 'Water')
        end)

        -- Controls for the other two bands, which pass without the patch too
        it('Shantotto casts her highest tier at exactly 40% HP', function()
            setMobHPP(40)
            local _, casts = summonRecordingCasts('SHANTOTTO')

            fightUntil(casts, 1)

            assertCast(casts, 1, xi.magic.spell.FIRE, 'Fire')
        end)

        it('Shantotto still casts in the 10-40% band at exactly 10% HP', function()
            setMobHPP(10)
            local _, casts = summonRecordingCasts('SHANTOTTO')

            fightUntil(casts, 1)

            assert(casts[1] ~= nil, 'Shantotto cast nothing at 10% HP')
            assert(casts[1].hpp >= 10 and casts[1].hpp < 40, string.format('precondition: cast at %d%% HP, outside the 10-40%% band', casts[1].hpp))
        end)

        it('Ajido-Marujido casts Stone below 10% HP', function()
            setMobHPP(9)
            local _, casts = summonRecordingCasts('AJIDO_MARUJIDO')

            fightUntil(casts, 1)

            assertCast(casts, 1, xi.magic.spell.STONE, 'Stone')
        end)

        it('honours its spell family', function()
            local trust, casts = summonRecordingCasts('SHANTOTTO')

            clearGambits(trust)
            trust:addGambit(ai.t.TARGET, { ai.c.ALWAYS, 0 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.WATER })
            fightUntil(casts, 1)

            assertCast(casts, 1, xi.magic.spell.WATER, 'Water, her only Water-family spell')
        end)

        it('finds a family outside the damage list, lowest tier first', function()
            local trust, casts = summonRecordingCasts('AJIDO_MARUJIDO')

            clearGambits(trust)
            trust:addGambit(ai.t.SELF, { ai.c.ALWAYS, 0 }, { ai.r.MA, ai.s.LOWEST, xi.magic.spellFamily.CURE })
            fightUntil(casts, 1)

            assertCast(casts, 1, xi.magic.spell.CURE, 'Cure, not Cure II')
        end)
    end)
end)
