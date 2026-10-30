-- ZenithXI era Bard song potency (modules/zenith-public/lua/3-complete/era_song_potency.lua).
--
-- Each song is checked at the skill it starts scaling from, just above it, and far past its cap.
-- calculateSongPower only asks the caster for its skills and merits, so a plain table stands in for it.

describe('Zenith era Bard song potency', function()
    local function power(spellId, skill, instrumentBoost, merit)
        local caster =
        {
            isPC = function() return true end,
            getSkillLevel = function() return skill end,
            getWeaponSkillType = function() return 0 end,
            getMerit = function() return merit or 0 end,
            getJobPointLevel = function() return 0 end,
            getStatusEffect = function() return nil end,
            hasStatusEffect = function() return false end,
        }

        return xi.spells.enhancing.calculateSongPower(caster, nil, nil, spellId, 1, 0, instrumentBoost or 0, false)
    end

    local spell = xi.magic.spell
    local songs =
    {
        { name = 'Fire Carol',       id = spell.FIRE_CAROL,        skill = 200, base = 20, above = 21, step = 10,    cap = 40, multiplier = 5   },
        { name = 'Dark Carol',       id = spell.DARK_CAROL,        skill = 200, base = 20, above = 21, step = 10,    cap = 40, multiplier = 5   },
        { name = 'Sword Madrigal',   id = spell.SWORD_MADRIGAL,    skill = 40,  base = 5,  above = 6,  step = 23.25, cap = 15, multiplier = 2   },
        { name = 'Blade Madrigal',   id = spell.BLADE_MADRIGAL,    skill = 130, base = 9,  above = 10, step = 18,    cap = 30, multiplier = 2   },
        { name = 'Sheepfoe Mambo',   id = spell.SHEEPFOE_MAMBO,    skill = 85,  base = 5,  above = 6,  step = 18,    cap = 15, multiplier = 2.5 },
        { name = 'Dragonfoe Mambo',  id = spell.DRAGONFOE_MAMBO,   skill = 130, base = 9,  above = 10, step = 18,    cap = 23, multiplier = 2.5 },
        { name = 'Advancing March',  id = spell.ADVANCING_MARCH,   skill = 200, base = 35, above = 36, step = 7,     cap = 64, multiplier = 16  },
        { name = 'Victory March',    id = spell.VICTORY_MARCH,     skill = 300, base = 53, above = 54, step = 7,     cap = 96, multiplier = 16  },
        { name = 'Knight\'s Minne',  id = spell.KNIGHTS_MINNE,     skill = 0,   base = 5,  above = 6,  step = 15,    cap = 13, multiplier = 2.5 },
        { name = 'Minne II',         id = spell.KNIGHTS_MINNE_II,  skill = 0,   base = 6,  above = 7,  step = 15,    cap = 27, multiplier = 2.5 },
        { name = 'Minne III',        id = spell.KNIGHTS_MINNE_III, skill = 0,   base = 10, above = 11, step = 15,    cap = 40, multiplier = 2.5 },
        { name = 'Minne IV',         id = spell.KNIGHTS_MINNE_IV,  skill = 0,   base = 12, above = 13, step = 15,    cap = 48, multiplier = 2.5 },
        { name = 'Valor Minuet',     id = spell.VALOR_MINUET,      skill = 50,  base = 5,  above = 6,  step = 6,     cap = 16, multiplier = 2.5 },
        { name = 'Valor Minuet II',  id = spell.VALOR_MINUET_II,   skill = 85,  base = 10, above = 11, step = 6,     cap = 32, multiplier = 2.5 },
        { name = 'Valor Minuet III', id = spell.VALOR_MINUET_III,  skill = 200, base = 24, above = 25, step = 6,     cap = 48, multiplier = 2.5 },
        { name = 'Valor Minuet IV',  id = spell.VALOR_MINUET_IV,   skill = 300, base = 29, above = 30, step = 6,     cap = 56, multiplier = 2.5 },
        { name = 'Hunter\'s Prelude', id = spell.HUNTERS_PRELUDE,  skill = 85,  base = 10, above = 11, step = 18,    cap = 15, multiplier = 2   },
        { name = 'Archer\'s Prelude', id = spell.ARCHERS_PRELUDE,  skill = 130, base = 20, above = 21, step = 18,    cap = 30, multiplier = 2   },
    }

    for _, song in ipairs(songs) do
        describe(song.name, function()
            it('has its base power at its skill threshold', function()
                local result = power(song.id, song.skill)

                assert(result == song.base, string.format('power is %d', result))
            end)

            it('scales with skill above the threshold', function()
                local result = power(song.id, song.skill + math.ceil(song.step))

                assert(result == song.above, string.format('power is %d', result))
            end)

            it('stops at its cap', function()
                local result = power(song.id, 2000)

                assert(result == song.cap, string.format('power is %d', result))
            end)

            it('adds instrument power on top of the cap', function()
                local result = power(song.id, 2000, 1)

                assert(result == math.floor(song.cap + song.multiplier), string.format('power is %d', result))
            end)
        end)
    end

    it('still adds merits', function()
        assert(power(spell.VALOR_MINUET_IV, 2000, 0, 5) == 61, 'merits no longer apply')
    end)

    it('leaves other songs alone', function()
        assert(power(spell.MAGES_BALLAD, 2000) == 1, 'Mage\'s Ballad changed')
    end)
end)
