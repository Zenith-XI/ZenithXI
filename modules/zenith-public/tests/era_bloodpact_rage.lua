-- ZenithXI Blood Pact: Rage era adjustments (modules/zenith-public/lua/3-complete/era_bloodpact_rage.lua, which
-- loads LSB's modules/era/lua/actions/abilities/pets/bloodpact_rage.lua without its ROV condition).
--
-- Every case runs the era override and LSB's own script from underneath it, with the damage and status effect
-- functions stubbed, and compares what each one passes on:
-- - Multi-hit skills use an fTP of 1.0 after the first hit. LSB repeats the first hit's fTP.
-- - Crescent Fang, Eclipse Bite, Mountain Buster and Rock Buster use their 1000 TP fTP at any TP. LSB scales it.
-- - Chaotic Strike, Claw, Predator Claws and Shock Strike can crit, at a rate that does not vary with TP.
--   LSB passes a TP-based criticalChance table.
-- - Mountain Buster applies Bind for 13 to 60 seconds, as LSB's script does.
--
-- The checks on LSB's side are pins: they fail when LSB changes the value the era override replaces.
-- The Bind case passes without the module, on purpose: Bind is LSB's behaviour, and the case fails when the era
-- override drops it.
--
-- Pending upstream: canCrit comes from LandSandBoat/server#11921 and the Mountain Buster Bind from
-- LandSandBoat/server#11946. Until an LSB sync brings both to testing, the critical hit and Bind cases fail.

-- LSB's version, from underneath the override. Follows the chain when several modules override the path.
local function lsbVersionOf(fn)
    while type(fn) == 'function' and rawget(getfenv(fn), 'super') do
        fn = rawget(getfenv(fn), 'super')
    end

    return fn
end

describe('Zenith Blood Pact: Rage era adjustments', function()
    local captured

    -- Call once per case: stubs are restored after it.
    local function stubDamage()
        local function move(_, _, _, _, params)
            captured.params = params

            return { damage = 1, hybridDamage = 0, attackType = params.attackType, damageType = params.damageType }
        end

        stub('xi.job_utils.summoner.onUseBloodPact', function()
        end)

        stub('xi.mobskills.mobPhysicalMove', move)
        stub('xi.mobskills.mobRangedMove', move)
        stub('xi.mobskills.processDamage', true)
        stub('xi.combat.action.executeMobskillStatusEffect', function(_, _, _, effectTable)
            for _, effect in ipairs(effectTable) do
                table.insert(captured.effects, effect)
            end
        end)
    end

    local function run(onPetAbility, name)
        captured = { effects = {} }

        local target =
        {
            takeDamage = function()
            end,

            getHP = function()
                return 1000
            end,
        }

        local pet =
        {
            getWeaponDmg = function()
                return 10
            end,

            getRangedDmg = function()
                return 10
            end,
        }

        onPetAbility(target, pet, {}, {}, {})
        assert(captured.params, string.format('precondition: %s never called mobPhysicalMove or mobRangedMove', name))

        return captured
    end

    -- The era override and LSB's script for one skill.
    local function runBoth(name)
        stubDamage()

        local override = xi.actions.abilities.pets[name].onPetAbility
        local era      = run(override, name)
        local lsb      = run(lsbVersionOf(override), name .. ' (LSB)')

        return era, lsb
    end

    for _, name in ipairs({ 'chaotic_strike', 'double_punch', 'double_slap', 'eclipse_bite', 'predator_claws', 'rush' }) do
        it(string.format('%s uses an fTP of 1.0 after the first hit', name), function()
            local era, lsb = runBoth(name)

            assert(era.params.numHits > 1, string.format('precondition: %s hits %d time(s)', name, era.params.numHits))

            for tier = 1, 3 do
                local fTP = era.params.fTPSubsequentHits[tier]

                assert(fTP == 1.0, string.format('tier %d: expected an fTP of 1.0 after the first hit, got %s', tier, tostring(fTP)))
            end

            local lsbfTP = lsb.params.fTPSubsequentHits and lsb.params.fTPSubsequentHits[1]

            assert(lsbfTP ~= 1.0, string.format('LSB now uses %s after the first hit, re-check the era module', tostring(lsbfTP)))
        end)
    end

    for _, name in ipairs({ 'crescent_fang', 'eclipse_bite', 'mountain_buster', 'rock_buster' }) do
        it(string.format('%s deals its 1000 TP damage at any TP', name), function()
            local era, lsb = runBoth(name)
            local base     = lsb.params.fTP[1]

            for tier = 1, 3 do
                local fTP = era.params.fTP[tier]

                assert(fTP == base, string.format('tier %d: expected the 1000 TP fTP %s, got %s', tier, tostring(base), tostring(fTP)))
            end

            assert(lsb.params.fTP[3] > base, string.format('LSB no longer scales the fTP with TP (%s at 3000 TP), re-check the era module', tostring(lsb.params.fTP[3])))
        end)
    end

    for _, name in ipairs({ 'chaotic_strike', 'claw', 'predator_claws', 'shock_strike' }) do
        it(string.format('%s can crit, at a rate that does not vary with TP', name), function()
            local era, lsb = runBoth(name)

            assert(era.params.canCrit == true, 'expected canCrit (LandSandBoat/server#11921, pending the next LSB sync)')
            assert(era.params.criticalChance == nil, 'expected no TP-based critical hit rate')
            assert(lsb.params.criticalChance ~= nil, 'LSB no longer scales the critical hit rate with TP, re-check the era module')
        end)
    end

    it('mountain_buster applies Bind for 13 to 60 seconds', function()
        local era, lsb = runBoth('mountain_buster')

        for label, result in pairs({ era = era, LSB = lsb }) do
            local bind = result.effects[1]

            assert(bind and bind.effectId == xi.effect.BIND, string.format('%s: expected Bind (LandSandBoat/server#11946), got %s', label, tostring(bind and bind.effectId)))
            assert(bind.power == 1, string.format('%s: expected power 1, got %s', label, tostring(bind.power)))
            assert(bind.duration >= 13 and bind.duration <= 60, string.format('%s: expected 13 to 60 seconds, got %s', label, tostring(bind.duration)))
        end
    end)
end)
