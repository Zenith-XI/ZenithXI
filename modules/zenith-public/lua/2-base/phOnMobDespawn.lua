-----------------------------------
-- Zenith placeholder (PH) lottery boost
-- Generic incremental increase in an NM's chance to pop from its PHs:
-- - Every PH kill while the NM is not up, not primed and not on cooldown adds to a counter (phKills localvar on the NM)
-- - The NM's chance is multiplied by a number between 1 and 2 based on that counter (see getChanceMult)
-- - The counter resets when the NM is up, primed or on cooldown (and localvars are purged when the NM spawns)
-- - The NM's cooldown is kept in a server var so a reboot does not reset it
--
-- Base runs two lottery systems, and both are covered here:
-- 1. Lua: zone scripts that still call xi.mob.phOnDespawn from the PH's onMobDespawn, with a phList on the NM's script.
--    Handled by the xi.mob.phOnDespawn override below.
-- 2. Spawn slots: since LSB fb1a23fd82 most PHs are declared in the `slots:` section of data/zones/<zone>/mobs.yaml
--    ({chance: n, cooldown: s} on the NM member) and rolled in C++ (SpawnSlot::TrySpawn) when the slot respawns.
--    This never goes through xi.mob.phOnDespawn. The PH kill is caught in xi.mob.onMobDeathEx and the NM's slot chance
--    is raised before the roll, through mob:getSpawnSlotEntry()/setSpawnSlotEntry() from cpp/spawn_slot_lua.cpp.
-- Take care copying FULL TABLES as that may adjust the original (i.e. if you append to a table it may get appended everytime the function is called)
-----------------------------------

local m = Module:new('b_phOnDespawn')

-- Per-NM adjustments, by NM name.
-- chance and cooldown apply to both systems, params (phOnDespawn params) only to the Lua system.
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

-- Survives a Lua reload so the slot chance read back after a boost is never cached as the base chance
zxi.slotLottery = zxi.slotLottery or
{
    base     = {}, -- [nmId] = { chance, cooldown } as loaded from mobs.yaml, after nmParamChanges
    lastSet  = {}, -- [nmId] = chance this module last gave the NM
    restored = {}, -- [nmId] = true once the cooldown server var has been applied this boot
}

local getMobLuaPathObject = function(mob)
    if not mob then
        return nil
    end

    return xi.zones[mob:getZoneName()].mobs[mob:getName()]
end

-- NM ids in phLists and ID tables are either a single id or a table of ids (GetTableOfIDs), same as in base
local toIdList = function(ids)
    if type(ids) == 'number' then
        return { ids }
    elseif type(ids) == 'table' then
        return ids
    end

    return {}
end

-- formula to translate ph kills to nm pop chance is -1/x shape with horizontal asymptote at y=2 that fits these two points
-- full ph rounds: 0
-- chance mult: 1
-- full ph rounds: 20
-- chance mult: 1.9
-- Note: a "full ph round" is simplified in the code to just be "killed X number of PH" where X is the number of PHs for the NM
local getChanceMult = function(phKills, phCount)
    local phRounds = math.max(phKills, 0) / math.max(phCount, 1)

    return 2 - (10 / (phRounds + 10))
end

-----------------------------------
-- 1. Lua lottery (xi.mob.phOnDespawn)
-----------------------------------
m:addOverride('xi.mob.phOnDespawn', function(ph, phNmId, chance, cooldown, params)
    params = params or {}

    local phId   = ph:getID()
    local nms    = {}
    local phList = nil
    -- every id in a table belongs to the same NM name, so any of them finds the NM's script
    local firstNmId    = toIdList(phNmId)[1]
    local mobEntityObj = firstNmId and getMobLuaPathObject(GetMobByID(firstNmId))
    if mobEntityObj then
        phList = mobEntityObj.phList
        for _, nmId in ipairs(toIdList(phList and phList[phId])) do
            local nm = GetMobByID(nmId)
            if nm then
                table.insert(nms, nm)
            end
        end
    end

    -- so these stay in scope for second half after call of super()
    -- base picks one of the NM's ids at random, so the counter and cooldown are kept on all of them
    local phKills = 0
    local popTime = 0
    for _, nm in ipairs(nms) do
        -- restore pop localvar if server rebooted
        if nm:getLocalVar('pop') == 0 then
            local serverPopTime = GetServerVariable(zxi.mobHelpers.getRespawnVarName(nm))
            -- so we don't query the server vars every ph kill
            nm:setLocalVar('pop', serverPopTime > 0 and serverPopTime or 2)

            -- when nm is chosen to spawn, we will set the server variable to 1, which implies it is primed to spawn on first PH kill after server startup
            if nm:getLocalVar('pop') == 1 then
                chance = 100
            end
        end

        phKills = math.max(phKills, nm:getLocalVar('phKills'))
        popTime = math.max(popTime, nm:getLocalVar('pop'))
    end

    if #nms > 0 then
        -- adjust values based on table above
        local nmParams = nmParamChanges[nms[1]:getName()]
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
        local phCount = 0
        for _, _ in pairs(phList) do
            phCount = phCount + 1
        end

        chance = chance * getChanceMult(phKills, phCount)
        -- print(string.format('ph kills: %d # of ph: %d new chance: %f', phKills, phCount, chance))
    end

    -- call the original function with adjusted values
    local superResults = super(ph, phNmId, chance, cooldown, params)

    local nmUp = false
    for _, nm in ipairs(nms) do
        local primed = nm:isAlive() or nm:getRespawnTime() > 0

        -- PH successfully set this NM to spawn
        if superResults and primed then
            local respawnVarName = zxi.mobHelpers.getRespawnVarName(nm)

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

        nmUp = nmUp or primed
    end

    for _, nm in ipairs(nms) do
        if
            GetSystemTime() < popTime or -- NM is on cooldown, don't stack kill count until out of window
            nmUp
        then
            -- NM is up or going to spawn, reset kill count (localvars are purged on spawn, but just in case... since we set it every PH kill)
            nm:setLocalVar('phKills', 0)
        else
            nm:setLocalVar('phKills', phKills + 1)
        end
    end

    return superResults
end)

-----------------------------------
-- 2. Spawn slot lottery (mobs.yaml `slots:`)
-----------------------------------

-- Chance and cooldown of an NM slot member before any boost
local getSlotBase = function(nm, entry)
    local nmId = nm:getID()
    local base = zxi.slotLottery.base[nmId]
    if not base then
        base = { chance = entry.chance, cooldown = entry.cooldown }

        local nmParams = nmParamChanges[nm:getName()]
        if nmParams then
            base.chance   = nmParams.chance or base.chance
            base.cooldown = nmParams.cooldown or base.cooldown
            nm:setSpawnSlotEntry({ chance = base.chance, cooldown = base.cooldown })
            entry.chance = base.chance
        end

        zxi.slotLottery.base[nmId] = base
    end

    return base
end

-- Only touch a chance this module set, so one forced from elsewhere (a GM, a test, another script) is left alone
local setSlotChance = function(nm, entry, base, chance)
    local nmId = nm:getID()
    if entry.chance ~= (zxi.slotLottery.lastSet[nmId] or base.chance) then
        return
    end

    zxi.slotLottery.lastSet[nmId] = chance
    nm:setSpawnSlotEntry({ chance = chance })
end

-- First time an NM is seen after a reboot, put back the cooldown its last death left in the server var
local restoreSlotCooldown = function(nm, entry, now)
    local nmId = nm:getID()
    if zxi.slotLottery.restored[nmId] then
        return
    end

    zxi.slotLottery.restored[nmId] = true

    local popTime = GetServerVariable(zxi.mobHelpers.getRespawnVarName(nm))
    if popTime > now and entry.readyIn < popTime - now then
        entry.readyIn = popTime - now
        nm:setSpawnSlotEntry({ readyIn = entry.readyIn })
    end
end

local onSlotMemberKilled = function(mob)
    local entry = mob:getSpawnSlotEntry()
    if not entry then
        return
    end

    local now = GetSystemTime()

    -- An NM of a slot died. SpawnSlot::OnKill already started its cooldown, persist it and drop the boost.
    if entry.chance > 0 then
        local base = getSlotBase(mob, entry)
        zxi.slotLottery.restored[mob:getID()] = true
        SetServerVariable(zxi.mobHelpers.getRespawnVarName(mob), now + base.cooldown)
        setSlotChance(mob, entry, base, base.chance)

        return
    end

    -- A PH died. The slot rolls its NMs when it respawns, so raise their chance now.
    local nmEntries = {}
    local phCount   = 0
    for _, memberId in ipairs(mob:getSpawnSlotMobs()) do
        local member      = GetMobByID(memberId)
        local memberEntry = member and member:getSpawnSlotEntry()
        if memberEntry then
            if memberEntry.chance > 0 then
                table.insert(nmEntries, { nm = member, entry = memberEntry })
            else
                phCount = phCount + 1
            end
        end
    end

    for _, nmEntry in ipairs(nmEntries) do
        local nm      = nmEntry.nm
        local base    = getSlotBase(nm, nmEntry.entry)
        local phKills = math.max(nm:getLocalVar('phKills'), 0)

        restoreSlotCooldown(nm, nmEntry.entry, now)

        if
            nmEntry.entry.readyIn > 0 or -- NM is on cooldown, don't stack kill count until out of window
            nm:isSpawned()
        then
            setSlotChance(nm, nmEntry.entry, base, base.chance)
            nm:setLocalVar('phKills', 0)
        else
            -- slot chances are whole percents
            local chance = math.floor(base.chance * getChanceMult(phKills, phCount) + 0.5)
            setSlotChance(nm, nmEntry.entry, base, utils.clamp(chance, 1, 100))
            nm:setLocalVar('phKills', phKills + 1)
            -- print(string.format('[phBoost] %s ph kills: %d # of ph: %d chance: %d -> %d', nm:getName(), phKills, phCount, base.chance, chance))
        end
    end
end

-- Called once per in-zone alliance member for every claimed mob kill; isKiller marks the member who landed the kill.
m:addOverride('xi.mob.onMobDeathEx', function(mob, player, isKiller, isWeaponSkillKill)
    super(mob, player, isKiller, isWeaponSkillKill)

    -- getSpawnSlotEntry is missing when cpp/spawn_slot_lua.cpp is not built in
    if isKiller and mob.getSpawnSlotEntry then
        onSlotMemberKilled(mob)
    end
end)

return m
