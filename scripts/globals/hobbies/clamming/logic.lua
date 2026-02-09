-----------------------------------
-- Clamming Logic
-----------------------------------
xi = xi or {}
xi.clamming = xi.clamming or {}
-----------------------------------

local function emptyBucket(player)
    for itemId, _ in pairs(xi.clamming.itemData) do
        local varName = xi.clamming.itemData[itemId][2]
        player:setLocalVar(varName, 0)
    end
end

-----------------------------------
-- Clamming Point public functions.
-----------------------------------
xi.clamming.nodeOnTrigger = function(player, npc)
    if not player:hasKeyItem(xi.ki.CLAMMING_KIT) then
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.AREA_IS_LITTERED)
        return
    end

    if GetSystemTime() < player:getLocalVar('[Clam]Delay') then
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.IT_LOOKS_LIKE_SOMEONE)
        return
    end

    player:startEvent(xi.clamming.npcEvent[npc:getName()], 0, 0, 0, 0, 0, 0, 0, 0)
end

xi.clamming.nodeOnEventUpdate = function(player, csid, option, npc)
    -- Early return: Incorrect event ID.
    if csid ~= xi.clamming.npcEvent[npc:getName()] then
        return
    end

    -- Early return: No Clamming Kit.
    if not player:hasKeyItem(xi.ki.CLAMMING_KIT) then
        return
    end

    -- Early return: Clamming Kit is broken.
    if player:getLocalVar('[Clam]KitBroken') > 0 then
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.YOU_CANNOT_COLLECT)
        player:updateEvent(player:getLocalVar('[Clam]KitWeight'), player:getLocalVar('[Clam]KitSize'), 0)
        return
    end

    -- Check "Incidents"
    local kitSize        = player:getLocalVar('[Clam]KitSize')
    local kitWeight      = player:getLocalVar('[Clam]KitWeight')
    local incidentChance = player:getMod(xi.mod.CLAMMING_REDUCED_INCIDENTS) > 0 and 5 or 10
    if
        kitSize == 200 and
        math.random(1, 100) <= incidentChance
    then
        -- SE seems to add 10000 to the previous weight if Alraune had stolen your stuff.
        -- A weight higher than your capacity prevents the CS performing the clamming animation.
        player:setLocalVar('[Clam]KitBroken', 1)
        player:setLocalVar('[Clam]KitWeight', kitWeight + 10000)
        emptyBucket(player)
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.SOMETHING_JUMPS_INTO)
        player:updateEvent(kitWeight, kitSize, 1)
        return
    end

    local randomRoll = math.random(1, 10000)
    local rateColumn = player:getMod(xi.mod.CLAMMING_IMPROVED_RESULTS) > 0 and 1 or 0
    local lootList   = xi.clamming.lootTable[npc:getName()]
    local itemId     = 0
    for i = 1, #lootList do
        if lootList[i][2 + rateColumn] <= randomRoll then
            itemId = lootList[i][1]
            break
        end
    end

    -- Fetch clammed item data.
    local itemWeight = xi.clamming.itemData[itemId][1]
    local varName    = xi.clamming.itemData[itemId][2]

    -- Check weight limit.
    if kitWeight + itemWeight > kitSize then
        player:setLocalVar('[Clam]KitBroken', 1)
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.THE_WEIGHT_IS_TOO_MUCH, itemId)
        emptyBucket(player)

    -- Add item to bucket.
    else
        player:setLocalVar(varName, player:getLocalVar(varName) + 1)
        player:messageSpecial(zones[xi.zone.BIBIKI_BAY].text.YOU_FIND_ITEM, itemId)
    end

    -- Update delay and weight, no matter the result.
    player:setLocalVar('[Clam]KitWeight', kitWeight + itemWeight)
    player:setLocalVar('[Clam]Delay', GetSystemTime() + 10)
end

xi.clamming.nodeOnEventFinish = function(player, csid, option, npc)
end

-----------------------------------
-- Toh Zonikki NPC public functions.
-----------------------------------
