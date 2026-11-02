-- ZenithXI era Tonko and Monomi durations (modules/zenith-public/lua/3-complete/era_tonko_monomi_durations.lua).
--
-- Tonko: Ichi and Monomi: Ichi last 180 seconds and Tonko: Ni 300, with no expansion check.

describe('Zenith era Tonko and Monomi durations', function()
    local spells =
    {
        { name = 'Tonko: Ichi',  id = xi.magic.spell.TONKO_ICHI,  effect = xi.effect.INVISIBLE, ms = 180000 },
        { name = 'Tonko: Ni',    id = xi.magic.spell.TONKO_NI,    effect = xi.effect.INVISIBLE, ms = 300000 },
        { name = 'Monomi: Ichi', id = xi.magic.spell.MONOMI_ICHI, effect = xi.effect.SNEAK,     ms = 180000 },
    }

    local player
    local caster

    local function cast(spellId)
        local spell = GetSpell(spellId)

        return xi.spells.enhancing.useEnhancingNinjutsu(caster, caster, spell)
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.NIN, level = 75 })
        caster = GetPlayerByID(player:getID())
    end)

    for _, entry in ipairs(spells) do
        describe(entry.name, function()
            it('lasts its era duration', function()
                assert(cast(entry.id) == entry.effect, 'the wrong effect came back')

                local effect = caster:getStatusEffect(entry.effect)

                assert(effect, 'the effect did not land')
                assert(effect:getDuration() == entry.ms, string.format('lasts %d ms, expected %d', effect:getDuration(), entry.ms))
                assert(effect:getTick() == 10000, string.format('ticks every %d ms, expected 10000', effect:getTick()))
            end)

            it('lasts its era duration with Seekers of Adoulin enabled', function()
                xi.test.world:setSetting('main.ENABLE_SOA', 1)
                cast(entry.id)

                assert(caster:getStatusEffect(entry.effect):getDuration() == entry.ms, 'the duration depends on the expansion')
            end)
        end)
    end

    it('does not overwrite a stronger Invisible', function()
        cast(xi.magic.spell.TONKO_NI)

        cast(xi.magic.spell.TONKO_ICHI)

        assert(caster:getStatusEffect(xi.effect.INVISIBLE):getDuration() == 300000, 'Tonko: Ichi replaced Tonko: Ni')
    end)

    it('wears off when the player attacks', function()
        cast(xi.magic.spell.TONKO_ICHI)
        caster:delStatusEffectsByFlag(xi.effectFlag.DETECTABLE)

        assert(not caster:hasStatusEffect(xi.effect.INVISIBLE), 'Invisible did not wear off')
    end)

    it('leaves other ninjutsu durations alone', function()
        cast(xi.magic.spell.YAIN_ICHI)

        assert(caster:getStatusEffect(xi.effect.PAX):getDuration() == 300000, 'Yain: Ichi changed')
    end)
end)
