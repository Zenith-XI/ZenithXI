-----------------------------------
-- Eco-Warrior level restriction (ZENITHDEV-232)
-- Runs LSB's three modules/era/lua/quests/*/eco_warrior.lua without their xi.pre(xi.expansion.ROV) condition:
-- the ointment restricts players to level 20 rather than 25.
-- The module loader registers every module a file declares, so nothing is duplicated here.
-----------------------------------
local nations = { 'bastok', 'sandoria', 'windurst' }
local isPre   = xi.pre

xi.pre = function()
    return true
end

for _, nation in ipairs(nations) do
    local ok, err = pcall(dofile, string.format('modules/era/lua/quests/%s/eco_warrior.lua', nation))

    if not ok then
        xi.pre = isPre
        error(err)
    end
end

xi.pre = isPre
