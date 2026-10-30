-- ZenithXI Eco-Warrior level restriction (modules/zenith-public/lua/3-complete/era_eco_warrior.lua).
--
-- Accepting the ointment restricts a player to level 20 in all three nations, instead of 25.
-- The modules change the quests on server start, which xi_test does not run by itself.

describe('Zenith Eco-Warrior level restriction', function()
    setup(function()
        xi.server.onServerStart()
    end)

    local cases =
    {
        { name = 'Bastok',    file = 'scripts/quests/bastok/Eco_Warrior',   zone = xi.zone.GUSGEN_MINES,      csid = 13 },
        { name = 'San dOria', file = 'scripts/quests/sandoria/Eco_Warrior', zone = xi.zone.ORDELLES_CAVES,    csid = 51 },
        { name = 'Windurst',  file = 'scripts/quests/windurst/Eco_Warrior', zone = xi.zone.MAZE_OF_SHAKHRAMI, csid = 62 },
    }

    for _, case in ipairs(cases) do
        it(string.format('restricts to level 20 in %s', case.name), function()
            local player = xi.test.world:spawnPlayer({ job = xi.job.WAR, level = 50 })
            local entity = GetPlayerByID(player:getID())
            local quest  = utils.prequire(case.file)

            quest.sections[2][case.zone].onEventFinish[case.csid](entity, case.csid, 1, nil)

            local effect = entity:getStatusEffect(xi.effect.LEVEL_RESTRICTION)
            assert(effect, 'the ointment added no level restriction')
            assert(effect:getPower() == 20, string.format('restricted to level %d', effect:getPower()))
        end)
    end
end)
