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

local m = Module:new('phOnDespawn')

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

m:addOverride('xi.mob.phOnDespawn', function(ph, phList, chance, cooldown, params)
    --print(phList)
    local phId = ph:getID()
    local nmId = phList[phId]

    -- so these stay in scope for second half after call of super()
    -- All guaranteed to be non-nil if nm is not nil
    local nm = nil
    local phKills = nil
    local popTime = nil
    if nmId and chance then
        nm = GetMobByID(nmId)

        if nm then
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
    end

    -- call the original function with adjusted values
    local superResults = super(ph, phList, chance, cooldown, params)

    -- reset counter if NM gets spawned
    if nm then
        if
            GetSystemTime() < popTime or -- NM is on cooldown, don't stack kill count until out of window
            nm:isAlive() or
            nm:getRespawnTime() > 0
        then
            -- NM is up or going to spawn, reset kill count (localvars are purged on spawn, but just in case... we set it every PH kill)
            nm:setLocalVar('phKills', 0)
        else
            nm:setLocalVar('phKills', phKills + 1)
        end

        -- print(nm:getLocalVar('phKills'))
    end

    return superResults
end)

return m
