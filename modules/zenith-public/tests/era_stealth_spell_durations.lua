-- ZenithXI era Sneak, Invisible and Deodorize durations
-- (modules/zenith-public/lua/3-complete/era_stealth_spell_durations.lua).
--
-- The base duration is a random 30 to 300 seconds instead of 420 plus 0, 60 or 120.

describe('Zenith era stealth spell durations', function()
    local spells =
    {
        { name = 'Sneak',     id = xi.magic.spell.SNEAK,     effect = xi.effect.SNEAK     },
        { name = 'Invisible', id = xi.magic.spell.INVISIBLE, effect = xi.effect.INVISIBLE },
        { name = 'Deodorize', id = xi.magic.spell.DEODORIZE, effect = xi.effect.DEODORIZE },
    }

    local caster

    local function duration(entry)
        local spell = GetSpell(entry.id)

        return xi.spells.enhancing.calculateEnhancingDuration(caster, caster, spell, entry.id, spell:getSpellGroup(), entry.effect)
    end

    before_each(function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WHM, level = 75 })
        caster = GetPlayerByID(player:getID())
    end)

    for _, entry in ipairs(spells) do
        describe(entry.name, function()
            it('rolls between 30 and 300 seconds', function()
                local low, high

                stub('math.randomInt', function(minimum, maximum)
                    low, high = minimum, maximum

                    return minimum
                end)

                assert(duration(entry) == 30, 'the lowest roll is not 30 seconds')
                assert(low == 30 and high == 300, 'the roll is not 30 to 300')
            end)

            it('allows the highest roll of 300 seconds', function()
                stub('math.randomInt', function(_, maximum)
                    return maximum
                end)

                assert(duration(entry) == 300, 'the highest roll is not 300 seconds')
            end)

            it('varies between casts', function()
                local seen = {}

                for _ = 1, 20 do
                    seen[duration(entry)] = true
                end

                local count = 0
                for _ in pairs(seen) do
                    count = count + 1
                end

                assert(count > 1, 'every cast rolled the same duration')
            end)

            it('still triples with Composure on yourself', function()
                stub('math.randomInt', 100)
                caster:addStatusEffect(xi.effect.COMPOSURE, { power = 1, duration = 60, origin = caster })

                assert(duration(entry) == 300, 'Composure no longer applies')
            end)

            it('still adds enhancing duration gear', function()
                stub('math.randomInt', 100)
                caster:addMod(xi.mod.ENH_MAGIC_DURATION, 50)

                assert(duration(entry) == 150, 'enhancing duration gear no longer applies')
            end)
        end)
    end

    it('still adds Sneak and Invisible duration gear to their own spell only', function()
        stub('math.randomInt', 100)
        caster:addMod(xi.mod.SNEAK_DURATION, 20)
        caster:addMod(xi.mod.INVISIBLE_DURATION, 40)

        assert(duration(spells[1]) == 120, 'Sneak duration gear no longer applies')
        assert(duration(spells[2]) == 140, 'Invisible duration gear no longer applies')
        assert(duration(spells[3]) == 100, 'Deodorize picked up duration gear')
    end)

    it('leaves other enhancing spells alone', function()
        local spell = GetSpell(xi.magic.spell.PROTECT)

        local result = xi.spells.enhancing.calculateEnhancingDuration(caster, caster, spell, xi.magic.spell.PROTECT, spell:getSpellGroup(), xi.effect.PROTECT)

        assert(result == 1800, string.format('Protect lasts %s', tostring(result)))
    end)
end)
