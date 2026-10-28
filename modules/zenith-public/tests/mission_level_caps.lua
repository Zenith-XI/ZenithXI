-- ZenithXI mission battlefield level caps (modules/zenith-public/lua/3-complete/mission_level_caps.lua, ZENITHDEV-258).
--
-- With LV_CAP_MISSION_BCNM on, entering a mission battlefield applies its historical cap as Level Restriction:
-- Rank 2 missions 25, Rank 5-1 50, the CoP Spires 30. A level 75 player registers each one directly.
-- The module sets the caps on server start, which xi_test does not run by itself.

describe('Zenith mission battlefield level caps', function()
    setup(function()
        xi.server.onServerStart()
    end)

    local function levelRestriction(battlefieldId)
        local content = xi.battlefield.contents[battlefieldId]
        assert(content, string.format('precondition: battlefield %d is loaded', battlefieldId))

        local player = xi.test.world:spawnPlayer({ zone = content.zoneId, job = xi.job.WAR, level = 75 })
        xi.test.world:setSetting('map.LV_CAP_MISSION_BCNM', true)

        player:registerBattlefield(content.battlefieldId, 1, player:getID(), content)
        assert(player:getBattlefield(), 'precondition: the player is in the battlefield')

        local effect = player:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
        return effect and effect:getPower() or 0
    end

    local cases =
    {
        { id = xi.battlefield.id.RANK_2_MISSION,                       name = 'Rank 2 mission',      cap = 25 },
        { id = xi.battlefield.id.RANK_5_MISSION,                       name = 'Rank 5-1 mission',    cap = 50 },
        { id = xi.battlefield.id.ANCIENT_FLAMES_BECKON_SPIRE_OF_HOLLA, name = 'Spire of Holla (CoP)', cap = 30 },
    }

    for _, case in ipairs(cases) do
        it(string.format('caps the %s at level %d', case.name, case.cap), function()
            local cap = levelRestriction(case.id)
            assert(cap == case.cap, string.format('%s is capped at %d, expected %d', case.name, cap, case.cap))
        end)
    end
end)
