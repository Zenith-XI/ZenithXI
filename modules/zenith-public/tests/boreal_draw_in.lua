-- ZenithXI Boreal NM draw-in (modules/zenith-public/lua/3-complete/mobs/boreal_draw_in.lua).
--
-- Boreal Coeurl, Hound and Tiger stop at the edge of their tunnel and draw in a target that left it,
-- however far away that target is. Base disengages the mob when the target is more than 10 away.

describe('Zenith Boreal NM draw-in', function()
    local cases =
    {
        { name = 'Boreal_Coeurl', inside = { x = 0,   z = 260  }, outside = { x = 0,   z = 259  } },
        { name = 'Boreal_Hound',  inside = { x = -11, z = -464 }, outside = { x = -10, z = -464 } },
        { name = 'Boreal_Tiger',  inside = { x = 0,   z = 335  }, outside = { x = 0,   z = 334  } },
    }

    local function fakeTarget(pos)
        return
        {
            getXPos = function() return pos.x end,
            getZPos = function() return pos.z end,
        }
    end

    local function fakeMob(engaged)
        local mob = { noMove = -1, disengaged = false, speedSet = false }

        mob.isEngaged = function() return engaged end
        mob.getPos = function() return { x = 0, y = 0, z = 0, rot = 0 } end
        mob.checkDistance = function() return 100 end
        mob.disengage = function(self) self.disengaged = true end
        mob.timer = function() end
        mob.setBaseSpeed = function(self) self.speedSet = true end
        mob.setMobMod = function(self, mod, value)
            if mod == xi.mobMod.NO_MOVE then
                self.noMove = value
            end
        end

        return mob
    end

    for _, case in ipairs(cases) do
        describe(case.name, function()
            local entity
            local drawIn

            before_each(function()
                xi.test.world:spawnPlayer({ zone = xi.zone.XARCABARD })
                entity = xi.zones.Xarcabard.mobs[case.name]
                drawIn = {}
                stub('utils.drawIn', function(_, params)
                    table.insert(drawIn, params)
                end)
            end)

            it('stops and draws in a far away target that left the tunnel, without disengaging', function()
                local mob = fakeMob(true)

                entity.onMobFight(mob, fakeTarget(case.outside))

                assert(mob.noMove == 1, 'NO_MOVE is not set')
                assert(not mob.disengaged, 'the mob disengaged')
                assert(#drawIn == 1 and drawIn[1].conditions[1] == true, 'the draw-in condition is not met')
                assert(drawIn[1].offset == 5 and drawIn[1].degrees == 180 and drawIn[1].wait == 2, 'wrong draw-in parameters')
            end)

            it('moves again once the target is back in the tunnel', function()
                local mob = fakeMob(true)

                entity.onMobFight(mob, fakeTarget(case.outside))
                entity.onMobFight(mob, fakeTarget(case.inside))

                assert(mob.noMove == 0, 'NO_MOVE is still set')
                assert(drawIn[2].conditions[1] == false, 'the target is drawn in from inside the tunnel')
            end)

            it('keeps its path point logic only while not engaged', function()
                stub('math.randomInt', 1)

                local engaged = fakeMob(true)
                entity.onPathPoint(engaged)
                assert(not engaged.speedSet, 'path point logic ran while engaged')

                local roaming = fakeMob(false)
                entity.onPathPoint(roaming)
                assert(roaming.speedSet, 'path point logic did not run while roaming')
            end)
        end)
    end
end)
