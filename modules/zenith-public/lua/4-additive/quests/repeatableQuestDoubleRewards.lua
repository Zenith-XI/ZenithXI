-----------------------------------
-- Repeatable Quest Double Gil Rewards Module
-- Doubles gil rewards for whitelisted repeatable quests
-- Limited to first 3 completions per day PER QUEST
--
-- REQUIRES: C++ patch addGil-module-hook.patch to be applied
-- The patch enables the xi.player.onPlayerAddGil() hook function
-- located in modules/zenith-public/git-patches/addGil-module-hook.patch
-----------------------------------

local m = Module:new('a-q_repQstDblRwds')

-----------------------------------
-- Configuration
-----------------------------------
local maxDailyBonuses = 3

-----------------------------------
-- LocalVar key names for quest context
-- Values stored +1 so 0 means "not set" (since areaId 0 = San d'Oria is valid)
-----------------------------------
local questContextAreaVar = 'RepQstDblRwds_AreaId'
local questContextQuestVar = 'RepQstDblRwds_QuestId'

-----------------------------------
-- Whitelist of repeatable quests
-- Using enums and set{} for type safety and clarity
-----------------------------------
local repeatableQuests =
{
    [xi.questLog.SANDORIA] =
    set{
        xi.quest.id.sandoria.FEAR_OF_THE_DARK,
        xi.quest.id.sandoria.A_DISCERNING_EYE,
        xi.quest.id.sandoria.A_JOB_FOR_THE_CONSORTIUM,
        xi.quest.id.sandoria.BLACKMAIL,
        xi.quest.id.sandoria.ECO_WARRIOR,
        xi.quest.id.sandoria.ESCORT_FOR_HIRE,
        xi.quest.id.sandoria.STARTING_A_FLAME,
        xi.quest.id.sandoria.THE_MERCHANTS_BIDDING,
        xi.quest.id.sandoria.THE_SWEETEST_THINGS,
        xi.quest.id.sandoria.THICK_SHELLS,
--        xi.quest.id.sandoria.TIGERS_TEETH, -- Removed by Lance
--        xi.quest.id.sandoria.TRIAL_BY_ICE, -- Removed by Lance
        xi.quest.id.sandoria.WARDING_VAMPIRES,
    },

    [xi.questLog.BASTOK] =
    set{
        xi.quest.id.bastok.A_DISCERNING_EYE,
        xi.quest.id.bastok.ALL_BY_MYSELF,
        xi.quest.id.bastok.BAIT_AND_SWITCH,
        xi.quest.id.bastok.BITE_THE_DUST,
        xi.quest.id.bastok.BREAKING_STONES,
        xi.quest.id.bastok.BUCKETS_OF_GOLD,
        xi.quest.id.bastok.ECO_WARRIOR,
        xi.quest.id.bastok.ESCORT_FOR_HIRE,
        xi.quest.id.bastok.FALLEN_COMRADES,
        xi.quest.id.bastok.GOURMET,
        xi.quest.id.bastok.MINESWEEPER,
        xi.quest.id.bastok.MOM_THE_ADVENTURER,
        xi.quest.id.bastok.SHADY_BUSINESS,
        xi.quest.id.bastok.SMOKE_ON_THE_MOUNTAIN,
        xi.quest.id.bastok.STARDUST,
        xi.quest.id.bastok.THE_COLD_LIGHT_OF_DAY,
--        xi.quest.id.bastok.THE_DARKSMITH, -- Removed by Lance
        xi.quest.id.bastok.THE_ELVAAN_GOLDSMITH,
        xi.quest.id.bastok.THE_NAMING_GAME,
        xi.quest.id.bastok.THE_SIRENS_TEAR,
--        xi.quest.id.bastok.TRIAL_BY_EARTH, -- Removed by Lance
        xi.quest.id.bastok.VENGEFUL_WRATH,
    },

    [xi.questLog.WINDURST] =
    set{
        xi.quest.id.windurst.A_CRISIS_IN_THE_MAKING,
        xi.quest.id.windurst.A_DISCERNING_EYE,
        xi.quest.id.windurst.A_FEATHER_IN_ONES_CAP,
        xi.quest.id.windurst.CAN_CARDIANS_CRY,
        xi.quest.id.windurst.CATCH_IT_IF_YOU_CAN,
        xi.quest.id.windurst.CREEPY_CRAWLIES,
        xi.quest.id.windurst.ECO_WARRIOR,
        xi.quest.id.windurst.ESCORT_FOR_HIRE,
        xi.quest.id.windurst.IN_A_PICKLE,
        xi.quest.id.windurst.IN_A_STEW,
        xi.quest.id.windurst.MANDRAGORA_MAD,
        xi.quest.id.windurst.MIHGOS_AMIGO,
        xi.quest.id.windurst.PAYING_LIP_SERVICE,
        xi.quest.id.windurst.REAP_WHAT_YOU_SOW,
        xi.quest.id.windurst.SAY_IT_WITH_FLOWERS,
        xi.quest.id.windurst.SOMETHING_FISHY,
        xi.quest.id.windurst.TEACHERS_PET,
        xi.quest.id.windurst.THE_ALL_NEW_C_3000,
        xi.quest.id.windurst.THE_MOONLIT_PATH,
        xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE,
        xi.quest.id.windurst.TORAIMARAI_TURMOIL,
        xi.quest.id.windurst.TWINSTONE_BONDING,
        xi.quest.id.windurst.WAKING_DREAMS,
        xi.quest.id.windurst.WATER_WAY_TO_GO,
    },

    [xi.questLog.JEUNO] =
    set{
        xi.quest.id.jeuno.ALL_IN_THE_CARDS,
        xi.quest.id.jeuno.DUCAL_HOSPITALITY,
    },

    [xi.questLog.OTHER_AREAS] =
    set{
        xi.quest.id.otherAreas.A_POTTERS_PREFERENCE,
        xi.quest.id.otherAreas.AN_EXPLORERS_FOOTSTEPS,
        xi.quest.id.otherAreas.CARGO,
        xi.quest.id.otherAreas.FISHERMANS_HEART,
        xi.quest.id.otherAreas.INSIDE_THE_BELLY,
        xi.quest.id.otherAreas.ONLY_THE_BEST,
        xi.quest.id.otherAreas.ORLANDOS_ANTIQUES,
        xi.quest.id.otherAreas.TEST_MY_METTLE,
--        xi.quest.id.otherAreas.TRIAL_BY_LIGHTNING, -- Removed by Lance
    },

    [xi.questLog.OUTLANDS] =
    set{
        xi.quest.id.outlands.A_DISCERNING_EYE,
        xi.quest.id.outlands.A_QUESTION_OF_TASTE,
        xi.quest.id.outlands.BLACK_MARKET,
        xi.quest.id.outlands.DONT_FORGET_THE_ANTIDOTE,
        xi.quest.id.outlands.GREETINGS_TO_THE_GUARDIAN,
        xi.quest.id.outlands.THE_FIREBLOOM_TREE,
--        xi.quest.id.outlands.TRIAL_BY_FIRE, -- Removed by Lance
--        xi.quest.id.outlands.TRIAL_BY_WATER, -- Removed by Lance
--        xi.quest.id.outlands.TRIAL_BY_WIND, -- Removed by Lance
    },

    [xi.questLog.ADOULIN] =
    set{
        xi.quest.id.adoulin.CAFETERIA,
        xi.quest.id.adoulin.EPIPHANY,
        xi.quest.id.adoulin.FLOWER_POWER,
        xi.quest.id.adoulin.GRANDDADDY_DEAREST,
        xi.quest.id.adoulin.IT_NEVER_GOES_OUT_OF_STYLE,
        xi.quest.id.adoulin.TREASURES_OF_THE_EARTH,
    },
}

-----------------------------------
-- Helper: Check if quest is in whitelist
-----------------------------------
local function isRepeatableQuest(areaId, questId)
    local areaQuests = repeatableQuests[areaId]
    if areaQuests == nil then
        return false
    end

    return areaQuests[questId] == true
end

-----------------------------------
-- Helper: Get daily bonus char var name
-----------------------------------
local function getDailyVarName(areaId, questId)
    return string.format('DailyGilBonus_%d_%d', areaId, questId)
end

-----------------------------------
-- Helper: Get log ID from area parameter
-----------------------------------
local function getLogId(area)
    if type(area) == 'number' then
        return area
    elseif area and area['quest_log'] then
        return area['quest_log']
    end

    return nil
end

-----------------------------------
-- Helper: Get daily completion count for a quest
-----------------------------------
local function getDailyCount(player, areaId, questId)
    return player:getCharVar(getDailyVarName(areaId, questId))
end

-----------------------------------
-- Helper: Increment and save daily count with midnight expiry
-----------------------------------
local function incrementDailyCount(player, areaId, questId)
    local currentCount = getDailyCount(player, areaId, questId)
    local newCount = currentCount + 1
    local nextMidnight = getVanaMidnight(0)
    player:setCharVar(getDailyVarName(areaId, questId), newCount, nextMidnight)
    return newCount
end

-----------------------------------
-- Helper: Set quest context for a player (using localVars)
-- Values stored +1 so 0 means "not set" (since areaId 0 = San d'Oria is valid)
-----------------------------------
local function setQuestContext(player, areaId, questId)
    player:setLocalVar(questContextAreaVar, areaId + 1)
    player:setLocalVar(questContextQuestVar, questId + 1)
end

-----------------------------------
-- Helper: Get and clear quest context for a player (using localVars)
-----------------------------------
local function getAndClearQuestContext(player)
    -- LocalVars default to 0, so we store values +1 to distinguish "not set" (0) from San d'Oria (areaId 0)
    local storedAreaId = player:getLocalVar(questContextAreaVar)
    local storedQuestId = player:getLocalVar(questContextQuestVar)

    -- Clear the context
    player:setLocalVar(questContextAreaVar, 0)
    player:setLocalVar(questContextQuestVar, 0)

    -- Values are stored +1, so 0 means "not set"
    if storedAreaId > 0 and storedQuestId > 0 then
        return storedAreaId - 1, storedQuestId - 1
    end

    return nil, nil
end

-----------------------------------
-- Helper: Apply bonus and show message
-----------------------------------
local function applyBonusAndMessage(player, areaId, questId, originalAmount)
    local dailyCount = getDailyCount(player, areaId, questId)

    if dailyCount < maxDailyBonuses then
        local newCount = incrementDailyCount(player, areaId, questId)
        local remaining = maxDailyBonuses - newCount
        local bonusGil = originalAmount

        -- Add bonus gil (re-enters addGil but context is already cleared so hook is a no-op)
        player:addGil(bonusGil)

        player:printToPlayer(
            string.format(
                'Bonus Gil Awarded: %d (%d/%d bonuses remaining for this quest)',
                bonusGil,
                remaining,
                maxDailyBonuses
            ),
            xi.msg.channel.SYSTEM_3
        )
    else
        player:printToPlayer(
            'Daily bonus limit reached for this quest. Normal reward given.',
            xi.msg.channel.SYSTEM_3
        )
    end
end

-----------------------------------
-- Hook for player:addGil (C++ hook from addGil-module-hook.patch)
-- The C++ patch calls this as a notification before adding gil.
-- We add bonus gil here; the original amount is always added by C++.
-----------------------------------

-- Ensure xi.player namespace and default hook exist for addOverride
xi.player = xi.player or {}
xi.player.onPlayerAddGil = xi.player.onPlayerAddGil or function()
end

m:addOverride('xi.player.onPlayerAddGil', function(player, amount)
    -- Check if we have quest context (cleared on read to prevent re-entry)
    local areaId, questId = getAndClearQuestContext(player)

    if areaId and questId and isRepeatableQuest(areaId, questId) then
        applyBonusAndMessage(player, areaId, questId, amount)
    end

    -- Continue the override chain for other modules
    super(player, amount)
end)

-----------------------------------
-- Reward Event ID to Quest mapping
-- Maps (zone, eventId) -> quest for precise context detection
-- This ensures the correct quest is identified even when multiple
-- repeatable quests are completed in the same zone
-----------------------------------
local rewardEventMapping =
{
    -- San d'Oria
    [xi.zone.SOUTHERN_SAN_DORIA] =
    {
        [535] = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.THE_SWEETEST_THINGS },
        [36]  = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.STARTING_A_FLAME },
        [89]  = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.THE_MERCHANTS_BIDDING },
        [681] = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.ECO_WARRIOR },
    },
    [xi.zone.NORTHERN_SAN_DORIA] =
    {
        [18]  = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.FEAR_OF_THE_DARK },
        [648] = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.BLACKMAIL },
        [23]  = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.WARDING_VAMPIRES },
    },
    [xi.zone.PORT_SAN_DORIA] =
    {
        [653] = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.A_JOB_FOR_THE_CONSORTIUM },
        [514] = { areaId = xi.questLog.SANDORIA, questId = xi.quest.id.sandoria.THICK_SHELLS },
    },

    -- Bastok
    [xi.zone.PORT_BASTOK] =
    {
        [193] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.BITE_THE_DUST },
        [91]  = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.SHADY_BUSINESS },
        [282] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.ECO_WARRIOR },
    },
    [xi.zone.BASTOK_MARKETS] =
    {
        [101] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.BREAKING_STONES },
        [272] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.BUCKETS_OF_GOLD },
        [201] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.GOURMET },
        [202] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.GOURMET },
        [203] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.GOURMET },
        [233] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.MOM_THE_ADVENTURER },
        [234] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.MOM_THE_ADVENTURER },
        [104] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.THE_COLD_LIGHT_OF_DAY },
        [216] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.THE_ELVAAN_GOLDSMITH },
    },
    [xi.zone.BASTOK_MINES] =
    {
        [91]  = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.FALLEN_COMRADES },
        [92]  = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.FALLEN_COMRADES },
        [109] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.MINESWEEPER },
        [82]  = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.THE_SIRENS_TEAR },
        [107] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.VENGEFUL_WRATH },
    },
    [xi.zone.METALWORKS] =
    {
        [429] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.SMOKE_ON_THE_MOUNTAIN },
        [555] = { areaId = xi.questLog.BASTOK, questId = xi.quest.id.bastok.STARDUST },
    },

    -- Windurst
    [xi.zone.WINDURST_WOODS] =
    {
        [239] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.IN_A_STEW },
        [88]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MIHGOS_AMIGO },
        [325] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.CAN_CARDIANS_CRY },
        [335] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.CREEPY_CRAWLIES },
        [479] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.PAYING_LIP_SERVICE },
        [490] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.TWINSTONE_BONDING },
        [657] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_ALL_NEW_C_3000 },
    },
    [xi.zone.WINDURST_WATERS] =
    {
        [520] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.SAY_IT_WITH_FLOWERS },
        [522] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.SAY_IT_WITH_FLOWERS },
        [525] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.SAY_IT_WITH_FLOWERS },
        [440] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.TEACHERS_PET },
        [791] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.TORAIMARAI_TURMOIL },
        [355] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.WATER_WAY_TO_GO },
        [79]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.A_FEATHER_IN_ONES_CAP },
        [267] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.A_CRISIS_IN_THE_MAKING },
        [268] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.A_CRISIS_IN_THE_MAKING },
        [475] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.REAP_WHAT_YOU_SOW },
        [477] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.REAP_WHAT_YOU_SOW },
        [659] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.IN_A_PICKLE },
        [662] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.IN_A_PICKLE },
        [822] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.ECO_WARRIOR },
        [846] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_MOONLIT_PATH },
        [850] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_MOONLIT_PATH },
        [920] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.WAKING_DREAMS },
    },
    [xi.zone.PORT_WINDURST] =
    {
        [210] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.SOMETHING_FISHY },
        [246] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.CATCH_IT_IF_YOU_CAN },
    },
    [xi.zone.WINDURST_WALLS] =
    {
        [251] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MANDRAGORA_MAD },
        [252] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MANDRAGORA_MAD },
        [253] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MANDRAGORA_MAD },
        [254] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MANDRAGORA_MAD },
        [255] = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.MANDRAGORA_MAD },
        [52]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [53]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [54]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [55]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [57]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [58]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [59]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
        [60]  = { areaId = xi.questLog.WINDURST, questId = xi.quest.id.windurst.THE_POSTMAN_ALWAYS_KOS_TWICE },
    },

    -- Jeuno
    [xi.zone.RULUDE_GARDENS] =
    {
        [10058] = { areaId = xi.questLog.JEUNO, questId = xi.quest.id.jeuno.DUCAL_HOSPITALITY },
    },
    [xi.zone.LOWER_JEUNO] =
    {
        [10114] = { areaId = xi.questLog.JEUNO, questId = xi.quest.id.jeuno.ALL_IN_THE_CARDS },
    },

    -- Other Areas
    [xi.zone.SELBINA] =
    {
        [47]  = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.AN_EXPLORERS_FOOTSTEPS },
        [166] = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.INSIDE_THE_BELLY },
        [167] = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.INSIDE_THE_BELLY },
        [122] = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.TEST_MY_METTLE },
        [52]  = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.CARGO },
        [62]  = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.ONLY_THE_BEST },
        [63]  = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.ONLY_THE_BEST },
        [64]  = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.ONLY_THE_BEST },
    },
    [xi.zone.MHAURA] =
    {
        [102] = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.ORLANDOS_ANTIQUES },
        [113] = { areaId = xi.questLog.OTHER_AREAS, questId = xi.quest.id.otherAreas.A_POTTERS_PREFERENCE },
    },

    -- Outlands
    [xi.zone.KAZHAM] =
    {
        [50] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.A_QUESTION_OF_TASTE },
        [71] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.GREETINGS_TO_THE_GUARDIAN },
    },
    [xi.zone.NORG] =
    {
        [17] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.BLACK_MARKET },
        [18] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.BLACK_MARKET },
        [19] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.BLACK_MARKET },
    },
    [xi.zone.RABAO] =
    {
        [4] = { areaId = xi.questLog.OUTLANDS, questId = xi.quest.id.outlands.DONT_FORGET_THE_ANTIDOTE },
    },
}

-----------------------------------
-- Helper: Get quest from event mapping
-----------------------------------
local function getQuestFromEvent(zoneId, eventId)
    local zoneEvents = rewardEventMapping[zoneId]
    if zoneEvents then
        return zoneEvents[eventId]
    end

    return nil
end

-----------------------------------
-- Override npcUtil.completeQuest to set quest context
-- This handles FIRST completions where quest:complete() is called
-----------------------------------
m:addOverride('npcUtil.completeQuest', function(player, area, quest, params)
    local logId = getLogId(area)
    if logId and isRepeatableQuest(logId, quest) then
        -- Set context so onPlayerAddGil hook knows which quest is completing
        setQuestContext(player, logId, quest)
    end

    -- Call the original function
    return super(player, area, quest, params)
end)

-----------------------------------
-- Override InteractionGlobal.onEventFinish to set context for completions
-- Uses event ID mapping for precise quest identification
-- This handles both first completions and repeats that give gil rewards
-----------------------------------
m:addOverride('InteractionGlobal.onEventFinish', function(player, csid, option, npc, fallbackFn)
    local zoneId = player:getZoneID()
    local questInfo = getQuestFromEvent(zoneId, csid)

    if questInfo then
        local questStatus = player:getQuestStatus(questInfo.areaId, questInfo.questId)
        -- Set context for quests that could be giving rewards
        if
            questStatus == xi.questStatus.QUEST_COMPLETED or
            questStatus == xi.questStatus.QUEST_ACCEPTED
        then
            setQuestContext(player, questInfo.areaId, questInfo.questId)
        end
    end

    -- Call original function
    return super(player, csid, option, npc, fallbackFn)
end)

return m
