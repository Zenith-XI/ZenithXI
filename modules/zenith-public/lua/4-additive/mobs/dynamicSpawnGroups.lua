-----------------------------------
-- Various helpers to manipulate mobs
-----------------------------------

local m = Module:new('a_m-spawnGroups')

local zoneMobs =
{
    [xi.zone.MONASTIC_CAVERN] =
    {
        zoneName = 'Monastic_Cavern',
        rangeCheck = 8,
        maxmobs = 1,
        mobNames =
        {
            'Orcish_Bowshooter',
            'Orcish_Footsoldier',
            'Orcish_Gladiator',
            'Orcish_Trooper',
            'Orcish_Veteran',
            'Orcish_Predator',
            'Orcish_Zerker',
            'Orcish_Warchief',
            'Orcish_Farkiller',
            'Orcish_Dreadnought',
            'Orcish_Champion',
            'Orcish_Dragoon',
            'Orcish_Warlord',
            'Orcish_Protector',
            'Orcish_Hexspinner',
            'Orcish_Overlord',
        },
    },
}

for zoneID, zoneData in pairs(zoneMobs) do
    local rangeCheck = zoneData.rangeCheck
    local maxmobs = zoneData.maxmobs
    local zoneName = zoneData.zoneName -- zxi.zoneName[zoneID] -- TODO fix this when OOE vendor PR gets merged
    for _, mobName in ipairs(zoneData.mobNames) do
        local mobLuaPath = fmt('xi.zones.{}.mobs.{}', zoneName, mobName)
        xi.module.ensureTable(mobLuaPath)
        -- TODO remove this workaround due to custom bindings being unavailable during mob init
        m:addOverride(fmt('{}.onMobInitialize', mobLuaPath), function(mob)
            super(mob)

            -- set respawn time so the mobs don't spawn immediately
            mob:setLocalVar('origRespawn', GetMobRespawnTime(mob:getID()))
            mob:setRespawnTime(1)
        end)

        m:addOverride(fmt('{}.onMobSpawnCheck', mobLuaPath), function(mob)
            local result = super(mob)

            -- Gross, all this can be removed with just a call to zxi.mobHelpers.mobOnInitSpawnGroups if it can be put into onMobInitialize
            local origRespawnTime = mob:getLocalVar('origRespawn')
            if origRespawnTime > 0 then
                mob:setLocalVar('origRespawn', 0)
                mob:setRespawnTime(1)
                -- setting spawngroup updates respawn params immediately, so any mobs in the spawn group after this ID will not hit this block until the next time they're chosen to spawn
                -- using a timer instead of spawn listener instead
                zxi.mobHelpers.mobOnInitSpawnGroups(mob, rangeCheck, maxmobs)

                -- no rng on zone startup, but no way around that with this workaround, I think
                mob:timer(1000, function(mobArg)
                    mobArg:setRespawnTime(origRespawnTime)
                    local spawnGroup = mobArg:getSpawnGroupID()
                    -- relies on mobs iterating in order
                    if spawnGroup and spawnGroup ~= mobArg:getID() then
                        DespawnMob(mobArg:getID(), 2)
                    end
                end)
            end

            return result
        end)
    end
end

return m
