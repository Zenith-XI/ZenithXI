-----------------------------------
-- Override Trust: Excenmille (configurable)
-- Adds the ticket's (ZENITHDEV-200) mods on top of LSB's onMobSpawn.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('a-t_excenmille_override')

m:addOverride('xi.actions.spells.trust.excenmille.onMobSpawn', function(trust)
    super(trust)

    trust:addMod(xi.mod.HPP, 10)
    trust:addMod(xi.mod.MPP, 20)
    trust:addMod(xi.mod.ENMITY, math.min(10, math.floor(trust:getMainLvl() / 10) * 5)) -- +5 enmity every 10 levels. Cap: 10
end)
