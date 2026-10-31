-- ZenithXI Blood Pact: Rage era adjustments (modules/zenith-public/lua/3-complete/era_bloodpact_rage.lua).
--
-- Hits after the first of a multi-hit Blood Pact use an fTP of 1.0, instead of repeating the first hit's fTP.

describe('Zenith Blood Pact: Rage era adjustments', function()
    local function firstParams(name)
        local params

        stub('xi.job_utils.summoner.onUseBloodPact', function()
        end)

        stub('xi.mobskills.processDamage', false)
        stub('xi.mobskills.mobPhysicalMove', function(_, _, _, _, moveParams)
            params = moveParams

            return { damage = 0 }
        end)

        local pet =
        {
            getWeaponDmg = function()
                return 10
            end,
        }

        xi.actions.abilities.pets[name].onPetAbility({}, pet, {}, {}, {})

        return params
    end

    for _, name in ipairs({ 'axe_kick', 'double_punch', 'chaotic_strike' }) do
        it(string.format('%s uses an fTP of 1.0 after the first hit', name), function()
            local params = firstParams(name)

            for tier = 1, 3 do
                assert(params.fTPSubsequentHits[tier] == 1.0, string.format('fTP is %s', tostring(params.fTPSubsequentHits[tier])))
            end
        end)
    end
end)
