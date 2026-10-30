-- ZenithXI Protect and Shell rebalance (modules/zenith-public/lua/4-additive/traits/pld/protectShellRebalance.lua).
--
-- Protect and Protectra I-V give 10/25/40/55/65 defense instead of LSB's 20/50/90/140/220, and
-- Shield Barrier (PLD 71 trait) adds half the shield's defense instead of all of it.
-- Shell and Shellra I-IV use their values from before May 2019, tier V stays at LSB's value.
-- Shield cases use a Kite Shield; the expected bonus is read from getShieldDefense() at run time.

describe('Zenith Protect rebalance', function()
    local spellIds =
    {
        { name = 'Protect',       id = xi.magic.spell.PROTECT,       power = 10 },
        { name = 'Protect II',    id = xi.magic.spell.PROTECT_II,    power = 25 },
        { name = 'Protect III',   id = xi.magic.spell.PROTECT_III,   power = 40 },
        { name = 'Protect IV',    id = xi.magic.spell.PROTECT_IV,    power = 55 },
        { name = 'Protect V',     id = xi.magic.spell.PROTECT_V,     power = 65 },
        { name = 'Protectra',     id = xi.magic.spell.PROTECTRA,     power = 10 },
        { name = 'Protectra II',  id = xi.magic.spell.PROTECTRA_II,  power = 25 },
        { name = 'Protectra III', id = xi.magic.spell.PROTECTRA_III, power = 40 },
        { name = 'Protectra IV',  id = xi.magic.spell.PROTECTRA_IV,  power = 55 },
        { name = 'Protectra V',   id = xi.magic.spell.PROTECTRA_V,   power = 65 },
    }

    local shellIds =
    {
        { name = 'Shell',       id = xi.magic.spell.SHELL,       power = 937  },
        { name = 'Shell II',    id = xi.magic.spell.SHELL_II,    power = 1406 },
        { name = 'Shell III',   id = xi.magic.spell.SHELL_III,   power = 1875 },
        { name = 'Shell IV',    id = xi.magic.spell.SHELL_IV,    power = 2187 },
        { name = 'Shell V',     id = xi.magic.spell.SHELL_V,     power = 2930 },
        { name = 'Shellra',     id = xi.magic.spell.SHELLRA,     power = 937  },
        { name = 'Shellra II',  id = xi.magic.spell.SHELLRA_II,  power = 1406 },
        { name = 'Shellra III', id = xi.magic.spell.SHELLRA_III, power = 1875 },
        { name = 'Shellra IV',  id = xi.magic.spell.SHELLRA_IV,  power = 2187 },
        { name = 'Shellra V',   id = xi.magic.spell.SHELLRA_V,   power = 2930 },
    }

    for _, case in ipairs(shellIds) do
        it(string.format('gives %s a base power of %d', case.name, case.power), function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WHM, level = 75 })
            local caster = GetPlayerByID(player:getID())
            local power  = xi.spells.enhancing.calculateEnhancingBasePower(caster, caster, GetSpell(case.id), case.id, xi.effect.SHELL)

            assert(power == case.power, string.format('%s base power is %s', case.name, tostring(power)))
        end)
    end

    for _, case in ipairs(spellIds) do
        it(string.format('gives %s a base power of %d', case.name, case.power), function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WHM, level = 75 })
            local caster = GetPlayerByID(player:getID())
            local spell  = GetSpell(case.id)
            assert(spell, string.format('precondition: no spell %d', case.id))

            local power = xi.spells.enhancing.calculateEnhancingBasePower(caster, caster, spell, case.id, xi.effect.PROTECT)

            assert(power == case.power, string.format('%s base power: expected %d, got %s', case.name, case.power, tostring(power)))
        end)
    end

    -- Casts Protect on the player itself and returns the Protect effect's power.
    local function castProtect(player)
        player:addSpell(xi.magic.spell.PROTECT)
        player:setMP(player:getMaxMP())
        player.actions:useSpell(player, xi.magic.spell.PROTECT)
        for _ = 1, 5 do
            xi.test.world:skipTime(2)
        end

        local effect = player:getStatusEffect(xi.effect.PROTECT)
        assert(effect, 'Protect was not applied')

        return effect:getPower()
    end

    it('casts Protect for 10 defense', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WHM, level = 75 })

        local power = castProtect(player)

        assert(power == 10, string.format('Protect power: expected 10, got %d', power))
    end)

    it('adds half the shield defense when a PLD with Shield Barrier casts Protect', function()
        local player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.PLD, level = 75 })
        player:addItem(xi.item.KITE_SHIELD)
        player:equipItem(xi.item.KITE_SHIELD, nil, xi.slot.SUB)

        local shieldDefense = player:getShieldDefense()
        assert(player:getMod(xi.mod.SHIELD_BARRIER) > 0, 'precondition: PLD 75 has no Shield Barrier')
        assert(shieldDefense > 1, string.format('precondition: shield defense is %d, too small to halve', shieldDefense))

        local expected = 10 + math.floor(shieldDefense / 2)
        local power    = castProtect(player)

        assert(power == expected, string.format('Protect power: expected %d (10 + %d shield DEF / 2), got %d', expected, shieldDefense, power))
    end)
end)
