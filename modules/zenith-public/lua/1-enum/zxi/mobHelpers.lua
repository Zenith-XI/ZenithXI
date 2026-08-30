-----------------------------------
-- Various helpers to manipulate mobs
-----------------------------------
zxi = zxi or {}
zxi.mobHelpers = zxi.mobHelpers or {}

local m = Module:new('e_z-mobHelpers')
m:addOverride('xi.dummyFunc', function()
end)

zxi.mobHelpers.getRespawnVarName = function(mob, mobId)
    if not mob then
        print('zxi.mobHelpers.getRespawnVarName got nil mob')

        return nil
    end

    local template = '[Respawn]{}_{}'
    if mobId then
        -- passing direct name and ids as params
        return fmt(template, mob, mobId)
    end

    return fmt(template, mob:getName(), mob:getID())
end

zxi.mobHelpers.zoneInitReposition = function(zone, mobList)
    if not zone or type(mobList) ~= 'table' then
        print('zxi.mobHelpers.zoneInitReposition: invalid parameters specified')
        print('Zone:', zone)
        print('Mob List:', mobList)
        return
    end

    for mobName, cfg in pairs(mobList) do
        -- query all spawns of this mob in the zone
        local entities = zone:queryEntitiesByName(mobName)

        if #entities > 0 then
            -- if limit is zero disable all spawns for given mobName
            if cfg.limit and cfg.limit == 0 then
                for _, mob in ipairs(entities) do
                    DespawnMob(mob:getID())
                    DisallowRespawn(mob:getID(), true)
                end

            -- check if limit is a number or table of indices
            -- build a set with the indices to keep
            else
                local keepSet = {}
                -- if limit is a number build a set of the first n indices
                if type(cfg.limit) == 'number' then
                    for i = 1, cfg.limit do
                        keepSet[i] = true
                    end
                -- if limit is a table of indices, build a set of those indices
                elseif type(cfg.limit) == 'table' then
                    for _, idx in ipairs(cfg.limit) do
                        if idx >= 1 and idx <= #entities then
                            keepSet[idx] = true
                        end
                    end
                end

                for idx, mob in ipairs(entities) do
                    local posOverride = cfg.pos and cfg.pos[idx]

                    if posOverride then
                        -- if pos is given for a mob index outside the limit values
                        if not keepSet[idx] then
                            print(
                                fmt('Pos override provided for {} {} at index: {}, which is not in the mobList limit', mobName, mob:getID(), idx)
                            )
                        end

                        -- allow excluding rotation in spawn positions
                        posOverride.rot = posOverride.rot or math.random(0, 255)

                        -- reposition only those entries for which positions are provided
                        mob:setPos(posOverride.x, posOverride.y, posOverride.z, posOverride.rot)
                        mob:setSpawn(posOverride.x, posOverride.y, posOverride.z, posOverride.rot)
                    elseif not keepSet[idx] then
                        DespawnMob(mob:getID())
                        DisallowRespawn(mob:getID(), true)
                    end
                end
            end
        end
    end
end

zxi.mobHelpers.mobOnInitSpawnGroups = function(mob, rangeCheck, maxmobs)
    if mob:getSpawnGroupID() then
        return
    end

    maxmobs = maxmobs or 1
    -- typical hearing range is 8, so this makes it mostly possible to pull from any type of dense groups
    rangeCheck = rangeCheck or 8
    local targetTypeFlag = 3 -- self and party (even though parties aren't built during onMobInit)
    -- find all dead entities in range, including self
    local mobsInRange = mob:getEntitiesInRange(mob, xi.aoeType.ROUND, 0, rangeCheck, xi.findFlag.HIT_ALL + xi.findFlag.DEAD, targetTypeFlag)

    local spawnGroupID = mob:getID()
    local nonGroupedMobs = {}
    for _, entity in ipairs(mobsInRange) do
        -- TODO more conditions to auto-include mobs in range in the same spawn group?
        if
            not entity:getSpawnGroupID() and
            mob:isNM() == entity:isNM()
        then
            table.insert(nonGroupedMobs, entity)
        end
    end

    -- if this table is more than just the original mob
    if #nonGroupedMobs > 1 then
        for _, entity in ipairs(nonGroupedMobs) do
            entity:setSpawnGroup(spawnGroupID, maxmobs)
        end
    end
end

return m
