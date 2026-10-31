-----------------------------------
-- Boreal NM draw-in (ZENITHDEV-268)
-- Boreal Coeurl, Hound and Tiger (Limit Break 2) stay in their tunnel and draw a target that leaves it back
-- in, however far away the target is. LSB instead disengages the mob when the target is more than 10 away.
-- While the mob is engaged it does not run its path point logic, which changes its speed.
-- Based on Phoenix's modules/phoenix/lua/zones/Xarcabard/mobs/boreal_draw_in.lua
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_borealDrawIn')

local tunnelBoundaries =
{
    Boreal_Coeurl = function(target)
        return target:getZPos() < 260
    end,

    Boreal_Hound = function(target)
        return target:getXPos() > -11 and target:getZPos() > -465
    end,

    Boreal_Tiger = function(target)
        return target:getZPos() < 335
    end,
}

for mobName, isOutsideTunnel in pairs(tunnelBoundaries) do
    m:addOverride(string.format('xi.zones.Xarcabard.mobs.%s.onPathPoint', mobName), function(mob)
        if not mob:isEngaged() then
            super(mob)
        end
    end)

    m:addOverride(string.format('xi.zones.Xarcabard.mobs.%s.onMobFight', mobName), function(mob, target)
        local outsideTunnel = isOutsideTunnel(target)

        mob:setMobMod(xi.mobMod.NO_MOVE, outsideTunnel and 1 or 0)
        utils.drawIn(target,
        {
            conditions = { outsideTunnel },
            position   = mob:getPos(),
            offset     = 5,
            degrees    = 180,
            wait       = 2,
        })
    end)
end

return m
