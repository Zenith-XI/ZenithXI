-----------------------------------
-- Updates to xi.mob.phOnDespawn:
-- When a PH despawns, this function is called
-- - the phList and other params are generated via local tables in the PH's lua file, but we can adjust before we send it through
-- - take care copying FULL TABLES as that may adjust the original (i.e. if you append to a table it may get appended everytime the function is called)
-- Functionality added:
-- - Generic incremental increase in PH chance to pop an NM
--   - If the NM is not up or already flagged to be up, a counter is attached to the NM and the chance variable is multiplied by a number between 1 and 2
--   - If the NM has spawned
-----------------------------------

local m = Module:new('b_phOnDespawn')

local nmParamChanges =
{
    ['Despot'] =
    {
        ['chance'] = 5,
        ['cooldown'] = 3600,
        ['params'] =
        {
            ['immediate'] = true,
        },
    },
}

local getMobLuaPathObject = function(mob)
    if not mob then
        return nil
    end

    return xi.zones[mob:getZoneName()].mobs[mob:getName()]
end

m:addOverride('xi.mob.phOnDespawn', function(ph, phNmId, chance, cooldown, params)
    --print(phList)
    local phId = ph:getID()
    local nmId = nil
    local nm = nil
    local phList = nil
    local mobEntityObj = getMobLuaPathObject(GetMobByID(phNmId))
    if mobEntityObj then
        phList = mobEntityObj.phList
        nmId   = phList and phList[phId]
        nm     = nmId and GetMobByID(nmId)
    end

    local respawnVarName = ''

    -- so these stay in scope for second half after call of super()
    -- All guaranteed to be non-nil if nm is not nil
    local phKills = nil
    local popTime = nil
    if nm then
        -- set server var so we can use it if we need it here and in DESPAWN listener below
        respawnVarName = zxi.mobHelpers.getRespawnVarName(nm)
        -- restore pop localvar if server rebooted
        if nm:getLocalVar('pop') == 0 then
            local serverPopTime = GetServerVariable(respawnVarName)
            -- so we don't query the server vars every ph kill
            nm:setLocalVar('pop', serverPopTime > 0 and serverPopTime or 2)

            -- when nm is chosen to spawn, we will set the server variable to 1, which implies it is primed to spawn on first PH kill after server startup
            if nm:getLocalVar('pop') == 1 then
                chance = 100
            end
        end

        phKills = nm:getLocalVar('phKills')
        popTime = nm:getLocalVar('pop')
        -- adjust values based on table above
        local nmParams = nmParamChanges[nm:getName()]
        if nmParams then
            for nmKey, nmValue in pairs(nmParams) do
                -- TODO create a way to adjust phList?
                if nmKey == 'chance' then
                    chance = nmValue
                elseif nmKey == 'cooldown' then
                    cooldown = nmValue
                elseif nmKey == 'params' then
                    -- set any param we have in the nmParamChanges table into that key for the params table
                    for paramKey, paramVal in pairs(nmValue) do
                        params[paramKey] = paramVal
                    end
                end
            end
        end

        -- calculate nm spawn chance on ph death based on # of kills this cycle
        -- the multiplier is based on number of PHs killed divided by the total number of PHs for the NM
        if phKills < 0 then
            phKills = 0
        end

        local phCount = 0
        for _, _ in pairs(phList) do
            phCount = phCount + 1
        end

        if phCount < 1 then
            phCount = 1
        end

        -- formula to translate ph kills to nm pop chance is -1/x shape with horizontal asymptote at y=2 that fits these two points
        -- full ph rounds: 0
        -- chance mult: 1
        -- full ph rounds: 20
        -- chance mult: 1.9
        -- Note: a "full ph round" is simplified in the code to just be "killed X number of PH" where X is the size of phList
        local phRounds = phKills / phCount
        local chanceMult = 2 - (10 / (phRounds + 10))

        chance = chance * chanceMult
        -- print(string.format('ph kills: %d # of ph: %d ph rounds: %f chance mult: %f new chance: %f', phKills, phCount, phRounds, chanceMult))
    end

    -- call the original function with adjusted values
    local superResults = super(ph, phNmId, chance, cooldown, params)

    -- reset counter if NM gets spawned
    if nm then
        -- PH successfully set the NM to spawn
        if superResults then
            -- if the server restarts between now and the NM dying, the first PH kill after restart will have 100% chance
            SetServerVariable(respawnVarName, 1)
            -- we set the local var just to be consistent and avoid confusion. As far as this xi.mob function is concerned, 'pop' is irrelevant now that the nm is primed
            nm:setLocalVar('pop', 1)

            -- NM was set to spawn, add listener to save pop time after NM dies
            nm:addListener('DESPAWN', 'PH_SAVE_COOLDOWN', function(mobArg)
                -- super adds a despawn listener, too. The stack should resolve the same order as it was added
                -- but if cooldowns aren't persisting properly we'll need to add a timer inside this listener
                SetServerVariable(respawnVarName, mobArg:getLocalVar('pop'))

                mobArg:removeListener('PH_SAVE_COOLDOWN')
            end)
        end

        if
            GetSystemTime() < popTime or -- NM is on cooldown, don't stack kill count until out of window
            nm:isAlive() or
            nm:getRespawnTime() > 0
        then
            -- NM is up or going to spawn, reset kill count (localvars are purged on spawn, but just in case... since we set it every PH kill)
            nm:setLocalVar('phKills', 0)
        else
            nm:setLocalVar('phKills', phKills + 1)
        end

        -- print(nm:getLocalVar('phKills'))
    end

    return superResults
end)

return m
