-----------------------------------
-- Various helpers to manipulate npcs
-----------------------------------
local m = Module:new('e_z-npcHelpers')

zxi = zxi or {}
zxi.npcHelpers = zxi.npcHelpers or {}

-- InteractionGlobal table stacks actions on an NPC based on the player's mission/quest status
-- the zone's DefaultActions.lua inserts the default actions for an npc to avoid having to define trivial NPC files all over
-- Modules that attempt to set an onTrigger function run into trouble with playing round-robin with the default actions (though we still want the rest of the interaction framework to function properly)
-- This helper simply removes the entry in the InteractionGlobal.lookup.data table, but this is only populated after zone start
zxi.npcHelpers.removeDefaultHandler = function(zoneId, npcName)
    table.insert(zxi.npcHelpers.removeDefaultHandlerList, { zoneId, npcName })
end

-- Will be populated by the above function
zxi.npcHelpers.removeDefaultHandlerList = {}

-- the function to run after interaction framework is loaded
-- stripped-down version of the function called by InteractionLookup:removeDefaultHandlers
local removeDefaultHandler = function(zoneId, npcName)
    -- hard-code the type of action we search for in the InteractionGlobal.lookup.data table
    local secondLevelKey = 'onTrigger'
    local actionPrio = Action.Priority.Default

    local foundAction = false
    local secondLevel = InteractionGlobal.lookup.data[zoneId][npcName]
    if secondLevel then
        if secondLevel[secondLevelKey] then
            local entries = secondLevel[secondLevelKey]
            if entries then
                for i = 1, #entries do
                    if
                        entries[i] and
                        entries[i].handler and
                        entries[i].handler.priority == actionPrio
                    then
                        if foundAction then
                            print(fmt('ERROR: Multiple default actions found for {} in zoneid {}???', npcName, zoneId))
                        else
                            table.remove(entries, i)
                            foundAction = true
                        end
                    end
                end
            end
        end
    end

    if foundAction then
        print(fmt('Default action removed for {} in zoneid {}', npcName, zoneId))
    else
        print(fmt('No default action found for {} in zoneid {}', npcName, zoneId))
    end
end

m:addOverride('xi.server.onServerStart', function()
    super()

    for _, npcData in pairs(zxi.npcHelpers.removeDefaultHandlerList) do
        removeDefaultHandler(npcData[1], npcData[2])
    end
end)

return m
