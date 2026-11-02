-----------------------------------
-- Devil Manta (Kuftal Tunnel) Fishing Respawn
--
-- The fishing pool only blocks a fished NM while lastTOD + respawnTime is in the future
-- (fishingutils.cpp), and the engine sets lastTOD only when the line is lost. After a
-- catch and kill lastTOD stays 0, so the NM could be hooked again at once. Stamping
-- lastTOD on despawn (kill or 3 minute idle despawn) makes the respawnTime from
-- fishing_mob (960 s) apply between catches. Local vars persist until the next Spawn(),
-- so the stamp survives until the NM is hooked again; a map restart clears it.
-- Public module for ZenithXI
-- Use in tandem with sql/devil_manta_respawn.sql
-----------------------------------

require('modules/module_utils')
local m = Module:new('c-m_devil_manta_respawn')

local mobPath = 'xi.zones.Kuftal_Tunnel.mobs.Devil_Manta'

-- No base script exists for this mob. Never pre-create the table when one does: the engine
-- would then discard the real script (update_if_empty).
local scriptFile = io.open('./scripts/zones/Kuftal_Tunnel/mobs/Devil_Manta.lua', 'r')
if scriptFile then
    io.close(scriptFile)
else
    xi.module.ensureTable(mobPath)
end

m:addOverride(mobPath .. '.onMobDespawn', function(mob)
    super(mob)

    mob:setLocalVar('lastTOD', GetSystemTime())
end)

return m
