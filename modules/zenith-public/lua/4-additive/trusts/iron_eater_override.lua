-----------------------------------
-- Override Trust: Iron Eater (configurable)
-- Adds the ticket's (ZENITHDEV-200) Berserk gambit and mods on top of LSB's onMobSpawn.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('a-t_iron_eater_override')

m:addOverride('xi.actions.spells.trust.iron_eater.onMobSpawn', function(trust)
    super(trust)

    trust:addGambit(ai.t.SELF, { ai.c.NOT_STATUS, xi.effect.BERSERK }, { ai.r.JA, ai.s.SPECIFIC, xi.ja.BERSERK  })

    local lvl = trust:getMainLvl()

    if lvl >= 50 then
        trust:addMod(xi.mod.STORETP, 20)
    elseif lvl >= 30 then
        trust:addMod(xi.mod.STORETP, 15)
    elseif lvl >= 10 then
        trust:addMod(xi.mod.STORETP, 10)
    end

    if lvl >= 25 then
        trust:addMod(xi.mod.DOUBLE_ATTACK, 5) -- Native 5% higher DA rate
    end
end)
