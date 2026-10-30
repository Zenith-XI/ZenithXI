-----------------------------------
-- Historical mission battlefield level caps (ZENITHDEV-258)
-- Loads LSB's modules/era/lua/battlefields/mission_level_caps.lua without its xi.pre(xi.expansion.ABYSSEA)
-- condition, so its list of 18 nation mission and Chains of Promathia battlefields (Rank 2 at 25, Rank 5-1 at 50,
-- CoP at 30 to 75) is reused rather than copied. It sets the caps on server start, before any battlefield
-- is registered.
--
-- The caps are only enforced on mission battlefields with the map setting LV_CAP_MISSION_BCNM = true
-- (settings/map.lua); otherwise the engine caps missions at MAX_LEVEL.
-----------------------------------
require('modules/module_utils')
-----------------------------------

-- The era file declares its module with xi.pre(...) as the condition. Open that gate for this one load:
-- the module then registers, enabled, as part of this file (the loader registers every module a file declares).
local isPre = xi.pre
xi.pre = function()
    return true
end

local ok, err = pcall(dofile, 'modules/era/lua/battlefields/mission_level_caps.lua')
xi.pre = isPre

if not ok then
    error(err)
end
