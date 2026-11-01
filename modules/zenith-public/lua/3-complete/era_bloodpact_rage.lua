-----------------------------------
-- Blood Pact: Rage era adjustments (ZENITHDEV-251)
-- Runs LSB's modules/era/lua/actions/abilities/pets/bloodpact_rage.lua without its xi.pre(xi.expansion.ROV)
-- condition: hits after the first of a multi-hit Blood Pact use an fTP of 1.0.
-- The module loader registers every module a file declares, so nothing is duplicated here.
-----------------------------------
local isPre = xi.pre

xi.pre = function()
    return true
end

local ok, err = pcall(dofile, 'modules/era/lua/actions/abilities/pets/bloodpact_rage.lua')
xi.pre = isPre

if not ok then
    error(err)
end
