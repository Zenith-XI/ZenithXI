-----------------------------------
-- Wardrobe/Inventory Unlock System
-- Unlocks additional slots for Mog Case and Wardrobes 1-8
-- based on various player achievements
-----------------------------------
local m = Module:new('c_wardrobeUnlocks')

-----------------------------------
-- Bag display names for notifications
-----------------------------------
local bagDisplayNames =
{
    [xi.inv.MOGCASE]   = 'Mog Case',
    [xi.inv.WARDROBE]  = 'Mog Wardrobe 1',
    [xi.inv.WARDROBE2] = 'Mog Wardrobe 2',
    [xi.inv.WARDROBE3] = 'Mog Wardrobe 3',
    [xi.inv.WARDROBE4] = 'Mog Wardrobe 4',
    [xi.inv.WARDROBE5] = 'Mog Wardrobe 5',
    [xi.inv.WARDROBE6] = 'Mog Wardrobe 6',
    [xi.inv.WARDROBE7] = 'Mog Wardrobe 7',
    [xi.inv.WARDROBE8] = 'Mog Wardrobe 8',
}

-----------------------------------
-- Main crafting skills (excludes fishing/synergy)
-----------------------------------
local mainCraftSkills =
{
    xi.skill.WOODWORKING,
    xi.skill.SMITHING,
    xi.skill.GOLDSMITHING,
    xi.skill.CLOTHCRAFT,
    xi.skill.LEATHERCRAFT,
    xi.skill.BONECRAFT,
    xi.skill.ALCHEMY,
    xi.skill.COOKING,
}

-----------------------------------
-- Check type constants
-----------------------------------
local checkCraft      = 'craft'
local checkMainCraft  = 'mainCraft'
local checkAllCrafts  = 'allCrafts'
local checkMission    = 'mission'
local checkQuest      = 'quest'
local checkKi         = 'ki'
local checkNm         = 'nm'
local checkGarrison   = 'garrison'
local checkJob        = 'job'
local checkLevel      = 'level'
local checkAllNations = 'allNations'
local checkMaatJob    = 'maatJob'

-----------------------------------
-- Helper: Get crafting skill level (real level / 10)
-----------------------------------
local function getCraftLevel(player, skillId)
    return math.floor(player:getCharSkillLevel(skillId) / 10)
end

-----------------------------------
-- Helper: Get highest craft level among main crafts
-----------------------------------
local function getHighestCraftLevel(player)
    local highest = 0
    for _, skillId in ipairs(mainCraftSkills) do
        local level = getCraftLevel(player, skillId)
        if level > highest then
            highest = level
        end
    end

    return highest
end

-----------------------------------
-- Helper: Check if all main crafts are at or above level
-----------------------------------
local function allCraftsAtLevel(player, level)
    for _, skillId in ipairs(mainCraftSkills) do
        if getCraftLevel(player, skillId) < level then
            return false
        end
    end

    return true
end

-----------------------------------
-- Helper: Check if player has defeated an NM
-----------------------------------
local function hasDefeatedNM(player, mobName)
    if xi.nmTracking and xi.nmTracking.hasKilledNM then
        -- Check if NM is placeholder (not coded)
        if xi.nmTracking.isNMNotCoded and xi.nmTracking.isNMNotCoded(mobName) then
            return false
        end

        return xi.nmTracking.hasKilledNM(player, mobName)
    end

    return false
end

-----------------------------------
-- Helper: Check if player has completed a garrison
-----------------------------------
local function hasCompletedGarrison(player, zoneId)
    if xi.garrisonTracking and xi.garrisonTracking.hasCompletedGarrison then
        return xi.garrisonTracking.hasCompletedGarrison(player, zoneId)
    end

    return false
end

-----------------------------------
-- Helper: Check if player has unlocked a job
-----------------------------------
local function hasJobUnlocked(player, jobId)
    -- Job 0 is subjob
    if jobId == 0 then
        local hasSubjob = player:getCharVar('UnlockedSubjob') == 1
        if hasSubjob then
            return true
        end

        local oldLadyDone = player:hasCompletedQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_OLD_LADY)
        local elderDone = player:hasCompletedQuest(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.ELDER_MEMORIES)
        return oldLadyDone or elderDone
    end

    -- Check if job level is > 0
    return player:getJobLevel(jobId) > 0
end

-----------------------------------
-- Evaluate a check based on its type and parameters
-- @param player CCharEntity: The player to check
-- @param checkType string: The type of check
-- @param params table: Parameters for the check
-- @return boolean: True if check passes
-----------------------------------
local function evaluateCheck(player, checkType, params)
    if checkType == checkCraft then
        return getCraftLevel(player, params[1]) >= params[2]
    elseif checkType == checkMainCraft then
        return getHighestCraftLevel(player) >= params[1]
    elseif checkType == checkAllCrafts then
        return allCraftsAtLevel(player, params[1])
    elseif checkType == checkMission then
        return player:hasCompletedMission(params[1], params[2])
    elseif checkType == checkQuest then
        return player:hasCompletedQuest(params[1], params[2])
    elseif checkType == checkKi then
        return player:hasKeyItem(params[1])
    elseif checkType == checkNm then
        return hasDefeatedNM(player, params[1])
    elseif checkType == checkGarrison then
        return hasCompletedGarrison(player, params[1])
    elseif checkType == checkJob then
        return hasJobUnlocked(player, params[1])
    elseif checkType == checkLevel then
        return player:getMainLvl() >= params[1]
    elseif checkType == checkAllNations then
        local bastokComplete = player:hasCompletedMission(xi.mission.log_id.BASTOK, xi.mission.id.bastok.WHERE_TWO_PATHS_CONVERGE)
        local sandoriaComplete = player:hasCompletedMission(xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_HEIR_TO_THE_LIGHT)
        local windurstComplete = player:hasCompletedMission(xi.mission.log_id.WINDURST, xi.mission.id.windurst.MOON_READING)
        return bastokComplete and sandoriaComplete and windurstComplete
    elseif checkType == checkMaatJob then
        local maatsCapMask = player:getCharVar('maatsCap')
        return utils.mask.getBit(maatsCapMask, params[1] - 1)
    end

    return false
end

-----------------------------------
-- Unlock Data Tables
-- Structure: { slots = N, checkType = 'type', params = {...}, name = 'Display Name' }
-- Multiple char_vars used for bags with >32 unlocks
-----------------------------------
local unlockData =
{
    -- Mog Case unlocks (crafting-based)
    [xi.inv.MOGCASE] =
    {
        {
            -- Alchemy
            { slots = 1, checkType = checkCraft, params = { xi.skill.ALCHEMY, 10 }, name = 'Alchemy 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.ALCHEMY, 20 }, name = 'Alchemy 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.ALCHEMY, 30 }, name = 'Alchemy 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.ALCHEMY, 40 }, name = 'Alchemy 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.ALCHEMY, 50 }, name = 'Alchemy 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.ALCHEMY, 60 }, name = 'Alchemy 60' },
            -- Bonecraft
            { slots = 1, checkType = checkCraft, params = { xi.skill.BONECRAFT, 10 }, name = 'Bonecraft 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.BONECRAFT, 20 }, name = 'Bonecraft 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.BONECRAFT, 30 }, name = 'Bonecraft 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.BONECRAFT, 40 }, name = 'Bonecraft 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.BONECRAFT, 50 }, name = 'Bonecraft 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.BONECRAFT, 60 }, name = 'Bonecraft 60' },
            -- Clothcraft
            { slots = 1, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 10 }, name = 'Clothcraft 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 20 }, name = 'Clothcraft 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 30 }, name = 'Clothcraft 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 40 }, name = 'Clothcraft 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 50 }, name = 'Clothcraft 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.CLOTHCRAFT, 60 }, name = 'Clothcraft 60' },
            -- Cooking
            { slots = 1, checkType = checkCraft, params = { xi.skill.COOKING, 10 }, name = 'Cooking 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.COOKING, 20 }, name = 'Cooking 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.COOKING, 30 }, name = 'Cooking 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.COOKING, 40 }, name = 'Cooking 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.COOKING, 50 }, name = 'Cooking 50' },
            -- Goldsmithing
            { slots = 1, checkType = checkCraft, params = { xi.skill.GOLDSMITHING, 40 }, name = 'Goldsmithing 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.GOLDSMITHING, 50 }, name = 'Goldsmithing 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.GOLDSMITHING, 60 }, name = 'Goldsmithing 60' },
            -- Leathercraft
            { slots = 1, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 10 }, name = 'Leathercraft 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 20 }, name = 'Leathercraft 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 30 }, name = 'Leathercraft 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 40 }, name = 'Leathercraft 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 50 }, name = 'Leathercraft 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.LEATHERCRAFT, 60 }, name = 'Leathercraft 60' },
            -- Smithing
            { slots = 1, checkType = checkCraft, params = { xi.skill.SMITHING, 10 }, name = 'Smithing 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.SMITHING, 20 }, name = 'Smithing 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.SMITHING, 30 }, name = 'Smithing 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.SMITHING, 40 }, name = 'Smithing 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.SMITHING, 50 }, name = 'Smithing 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.SMITHING, 60 }, name = 'Smithing 60' },
            -- Woodworking
            { slots = 1, checkType = checkCraft, params = { xi.skill.WOODWORKING, 10 }, name = 'Woodworking 10' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.WOODWORKING, 20 }, name = 'Woodworking 20' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.WOODWORKING, 30 }, name = 'Woodworking 30' },
            { slots = 1, checkType = checkCraft, params = { xi.skill.WOODWORKING, 40 }, name = 'Woodworking 40' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.WOODWORKING, 50 }, name = 'Woodworking 50' },
            { slots = 2, checkType = checkCraft, params = { xi.skill.WOODWORKING, 60 }, name = 'Woodworking 60' },
            -- Main Craft milestones (highest craft)
            { slots = 3, checkType = checkMainCraft, params = { 70 }, name = 'Main Craft 70' },
            { slots = 3, checkType = checkMainCraft, params = { 80 }, name = 'Main Craft 80' },
            { slots = 3, checkType = checkMainCraft, params = { 90 }, name = 'Main Craft 90' },
            { slots = 5, checkType = checkMainCraft, params = { 100 }, name = 'Main Craft 100' },
            -- All crafts 60
            { slots = 2, checkType = checkAllCrafts, params = { 60 }, name = 'All Crafts 60' },
        },
    },

    -- Wardrobe 1 unlocks (nation missions)
    [xi.inv.WARDROBE] =
    {
        {
            -- Bastok Missions
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_ZERUHN_REPORT }, name = 'Bastok Mission 1-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.GEOLOGICAL_SURVEY }, name = 'Bastok Mission 1-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.FETICHISM }, name = 'Bastok Mission 1-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_CRYSTAL_LINE }, name = 'Bastok Mission 2-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.WADING_BEASTS }, name = 'Bastok Mission 2-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_EMISSARY }, name = 'Bastok Mission 2-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_FOUR_MUSKETEERS }, name = 'Bastok Mission 3-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.TO_THE_FORSAKEN_MINES }, name = 'Bastok Mission 3-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.JEUNO }, name = 'Bastok Mission 3-3' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.MAGICITE }, name = 'Bastok Mission 4-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.DARKNESS_RISING }, name = 'Bastok Mission 5-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.XARCABARD_LAND_OF_TRUTHS }, name = 'Bastok Mission 5-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.RETURN_OF_THE_TALEKEEPER }, name = 'Bastok Mission 6-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_PIRATES_COVE }, name = 'Bastok Mission 6-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_FINAL_IMAGE }, name = 'Bastok Mission 7-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.ON_MY_WAY }, name = 'Bastok Mission 7-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_CHAINS_THAT_BIND_US }, name = 'Bastok Mission 8-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.ENTER_THE_TALEKEEPER }, name = 'Bastok Mission 8-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.THE_SALT_OF_THE_EARTH }, name = 'Bastok Mission 9-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.BASTOK, xi.mission.id.bastok.WHERE_TWO_PATHS_CONVERGE }, name = 'Bastok Mission 9-2' },
            -- San d'Oria Missions
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.SMASH_THE_ORCISH_SCOUTS }, name = 'San d\'Oria Mission 1-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.BAT_HUNT }, name = 'San d\'Oria Mission 1-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.SAVE_THE_CHILDREN }, name = 'San d\'Oria Mission 1-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_RESCUE_DRILL }, name = 'San d\'Oria Mission 2-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_DAVOI_REPORT }, name = 'San d\'Oria Mission 2-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.JOURNEY_ABROAD }, name = 'San d\'Oria Mission 2-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.INFILTRATE_DAVOI }, name = 'San d\'Oria Mission 3-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_CRYSTAL_SPRING }, name = 'San d\'Oria Mission 3-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.APPOINTMENT_TO_JEUNO }, name = 'San d\'Oria Mission 3-3' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.MAGICITE }, name = 'San d\'Oria Mission 4-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_RUINS_OF_FEI_YIN }, name = 'San d\'Oria Mission 5-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_SHADOW_LORD }, name = 'San d\'Oria Mission 5-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.LEAUTES_LAST_WISHES }, name = 'San d\'Oria Mission 6-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.RANPERRES_FINAL_REST }, name = 'San d\'Oria Mission 6-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.PRESTIGE_OF_THE_PAPSQUE }, name = 'San d\'Oria Mission 7-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_SECRET_WEAPON }, name = 'San d\'Oria Mission 7-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.COMING_OF_AGE }, name = 'San d\'Oria Mission 8-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.LIGHTBRINGER }, name = 'San d\'Oria Mission 8-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.BREAKING_BARRIERS }, name = 'San d\'Oria Mission 9-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.SANDORIA, xi.mission.id.sandoria.THE_HEIR_TO_THE_LIGHT }, name = 'San d\'Oria Mission 9-2' },
            -- Windurst Missions
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_HORUTOTO_RUINS_EXPERIMENT }, name = 'Windurst Mission 1-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_HEART_OF_THE_MATTER }, name = 'Windurst Mission 1-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_PRICE_OF_PEACE }, name = 'Windurst Mission 1-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.LOST_FOR_WORDS }, name = 'Windurst Mission 2-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.A_TESTING_TIME }, name = 'Windurst Mission 2-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_THREE_KINGDOMS }, name = 'Windurst Mission 2-3' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.TO_EACH_HIS_OWN_RIGHT }, name = 'Windurst Mission 3-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.WRITTEN_IN_THE_STARS }, name = 'Windurst Mission 3-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.A_NEW_JOURNEY }, name = 'Windurst Mission 3-3' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.MAGICITE }, name = 'Windurst Mission 4-1' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_FINAL_SEAL }, name = 'Windurst Mission 5-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_SHADOW_AWAITS }, name = 'Windurst Mission 5-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.FULL_MOON_FOUNTAIN }, name = 'Windurst Mission 6-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.SAINTLY_INVITATION }, name = 'Windurst Mission 6-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_SIXTH_MINISTRY }, name = 'Windurst Mission 7-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.AWAKENING_OF_THE_GODS }, name = 'Windurst Mission 7-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.VAIN }, name = 'Windurst Mission 8-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.THE_JESTER_WHOD_BE_KING }, name = 'Windurst Mission 8-2' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.DOLL_OF_THE_DEAD }, name = 'Windurst Mission 9-1' },
            { slots = 2, checkType = checkMission, params = { xi.mission.log_id.WINDURST, xi.mission.id.windurst.MOON_READING }, name = 'Windurst Mission 9-2' },
            -- All Nation Missions Complete bonus
            { slots = 2, checkType = checkAllNations, params = {}, name = 'All Nation Missions Complete' },
        },
    },

    -- Wardrobe 2 unlocks (various achievements)
    [xi.inv.WARDROBE2] =
    {
        {
            -- Trust quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.TRUST_BASTOK }, name = 'Complete: Trust: Bastok' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.TRUST_SANDORIA }, name = 'Complete: Trust: San d\'Oria' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.TRUST_WINDURST }, name = 'Complete: Trust: Windurst' },
            -- Subjob unlock
            { slots = 1, checkType = checkJob, params = { 0 }, name = 'Unlock Subjob' },
            -- Chocobo quest
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.CHOCOBOS_WOUNDS }, name = 'Quest: Chocobo\'s Wounds' },
            -- Tenshodo Membership
            { slots = 1, checkType = checkKi, params = { xi.ki.TENSHODO_MEMBERS_CARD }, name = 'Obtain: Tenshodo Member\'s Card' },
            -- Kazham Airship Pass
            { slots = 1, checkType = checkKi, params = { xi.ki.AIRSHIP_PASS_FOR_KAZHAM }, name = 'Obtain: Airship pass for Kazham' },
            -- Road to Aht Urhgan
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_ROAD_TO_AHT_URHGAN }, name = 'Quest: The Road to Aht Urhgan' },
            -- Job unlocks
            { slots = 1, checkType = checkJob, params = { xi.job.PLD }, name = 'Unlock PLD' },
            { slots = 1, checkType = checkJob, params = { xi.job.DRK }, name = 'Unlock DRK' },
            { slots = 1, checkType = checkJob, params = { xi.job.BST }, name = 'Unlock BST' },
            { slots = 1, checkType = checkJob, params = { xi.job.BRD }, name = 'Unlock BRD' },
            { slots = 1, checkType = checkJob, params = { xi.job.RNG }, name = 'Unlock RNG' },
            { slots = 1, checkType = checkJob, params = { xi.job.SMN }, name = 'Unlock SMN' },
            { slots = 1, checkType = checkJob, params = { xi.job.SAM }, name = 'Unlock SAM' },
            { slots = 1, checkType = checkJob, params = { xi.job.NIN }, name = 'Unlock NIN' },
            { slots = 1, checkType = checkJob, params = { xi.job.DRG }, name = 'Unlock DRG' },
            { slots = 1, checkType = checkJob, params = { xi.job.BLU }, name = 'Unlock BLU' },
            { slots = 1, checkType = checkJob, params = { xi.job.COR }, name = 'Unlock COR' },
            { slots = 1, checkType = checkJob, params = { xi.job.PUP }, name = 'Unlock PUP' },
            { slots = 1, checkType = checkJob, params = { xi.job.DNC }, name = 'Unlock DNC' },
            { slots = 1, checkType = checkJob, params = { xi.job.SCH }, name = 'Unlock SCH' },
            { slots = 1, checkType = checkJob, params = { xi.job.GEO }, name = 'Unlock GEO' },
            { slots = 1, checkType = checkJob, params = { xi.job.RUN }, name = 'Unlock RUN' },
            -- Limit breaks
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.IN_DEFIANT_CHALLENGE }, name = 'Limit Break 1' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.ATOP_THE_HIGHEST_MOUNTAINS }, name = 'Limit Break 2' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.WHENCE_BLOWS_THE_WIND }, name = 'Limit Break 3' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.RIDING_ON_THE_CLOUDS }, name = 'Limit Break 4' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.SHATTERING_STARS }, name = 'Limit Break 5' },
            -- Gobbiebag quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_I }, name = 'The Gobbiebag Part I' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_II }, name = 'The Gobbiebag Part II' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_III }, name = 'The Gobbiebag Part III' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_IV }, name = 'The Gobbiebag Part IV' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_V }, name = 'The Gobbiebag Part V' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VI }, name = 'The Gobbiebag Part VI' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VII }, name = 'The Gobbiebag Part VII' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_VIII }, name = 'The Gobbiebag Part VIII' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_IX }, name = 'The Gobbiebag Part IX' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_GOBBIEBAG_PART_X }, name = 'The Gobbiebag Part X' },
            -- Moogle quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.GIVE_A_MOOGLE_A_BREAK }, name = 'Give a Moogle a Break' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_MOOGLE_PICNIC }, name = 'The Moogle\'s Picnic!' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.MOOGLES_IN_THE_WILD }, name = 'Moogles in the Wild' },
            -- Shattering Stars (job-specific Maat completions)
            { slots = 1, checkType = checkMaatJob, params = { xi.job.WAR }, name = 'Shattering Stars: WAR' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.MNK }, name = 'Shattering Stars: MNK' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.WHM }, name = 'Shattering Stars: WHM' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.BLM }, name = 'Shattering Stars: BLM' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.RDM }, name = 'Shattering Stars: RDM' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.THF }, name = 'Shattering Stars: THF' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.PLD }, name = 'Shattering Stars: PLD' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.DRK }, name = 'Shattering Stars: DRK' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.BST }, name = 'Shattering Stars: BST' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.BRD }, name = 'Shattering Stars: BRD' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.RNG }, name = 'Shattering Stars: RNG' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.SMN }, name = 'Shattering Stars: SMN' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.SAM }, name = 'Shattering Stars: SAM' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.NIN }, name = 'Shattering Stars: NIN' },
            { slots = 1, checkType = checkMaatJob, params = { xi.job.DRG }, name = 'Shattering Stars: DRG' },
            -- Trust enhancement quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.BEYOND_THE_SUN }, name = 'Complete: Beyond the Sun' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.THE_BEAST_WITHIN }, name = 'The Beast Within: Raubahn' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.BREAKING_THE_BONDS_OF_FATE }, name = 'Breaking the Bonds of Fate: Qultada' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.ACHIEVING_TRUE_POWER }, name = 'Achieving True Power: Shamarhaan' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.A_FURIOUS_FINALE }, name = 'A Furious Finale: Laila' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.SURVIVAL_OF_THE_WISEST }, name = 'Survival of the Wisest: Schultz' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.ELEMENTARY_MY_DEAR_SYLVIE }, name = 'Elementary, My Dear Sylvie: Sylvie' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.ENDEAVORING_TO_AWAKEN }, name = 'Endeavoring to Awaken: Octavien' },
            -- Level-based unlocks
            { slots = 1, checkType = checkLevel, params = { 5 }, name = 'Reach Level 5' },
            { slots = 1, checkType = checkLevel, params = { 10 }, name = 'Reach Level 10' },
            { slots = 1, checkType = checkLevel, params = { 15 }, name = 'Reach Level 15' },
            { slots = 1, checkType = checkLevel, params = { 20 }, name = 'Reach Level 20' },
            { slots = 1, checkType = checkLevel, params = { 25 }, name = 'Reach Level 25' },
            { slots = 1, checkType = checkLevel, params = { 30 }, name = 'Reach Level 30' },
            { slots = 1, checkType = checkLevel, params = { 35 }, name = 'Reach Level 35' },
            { slots = 1, checkType = checkLevel, params = { 40 }, name = 'Reach Level 40' },
            { slots = 1, checkType = checkLevel, params = { 45 }, name = 'Reach Level 45' },
            { slots = 1, checkType = checkLevel, params = { 50 }, name = 'Reach Level 50' },
            { slots = 1, checkType = checkLevel, params = { 55 }, name = 'Reach Level 55' },
            { slots = 1, checkType = checkLevel, params = { 60 }, name = 'Reach Level 60' },
            { slots = 1, checkType = checkLevel, params = { 65 }, name = 'Reach Level 65' },
            { slots = 1, checkType = checkLevel, params = { 70 }, name = 'Reach Level 70' },
            { slots = 1, checkType = checkLevel, params = { 75 }, name = 'Reach Level 75' },
        },
    },

    -- Wardrobe 3 unlocks (expansion missions)
    [xi.inv.WARDROBE3] =
    {
        {
            -- Zilart
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_TEMPLE_OF_UGGALEPIH }, name = 'Zilart: The Temple of Uggalepih' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.HEADSTONE_PILGRIMAGE }, name = 'Zilart: Headstone Pilgrimage' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.THROUGH_THE_QUICKSAND_CAVES }, name = 'Zilart: Through the Quicksand Caves' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.RETURN_TO_DELKFUTTS_TOWER }, name = 'Zilart: Return to Delkfutt\'s Tower' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_MITHRA_AND_THE_CRYSTAL }, name = 'Zilart: The Mithra and the Crystal' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.ARK_ANGELS }, name = 'Zilart: Divine Might' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_CELESTIAL_NEXUS }, name = 'Zilart: The Celestial Nexus' },
            -- Promathia missions
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS }, name = 'Promathia: The Mothercrystals' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.DISTANT_BELIEFS }, name = 'Promathia: Distant Beliefs' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.ANCIENT_VOWS }, name = 'Promathia: Ancient Vows' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THE_ROAD_FORKS }, name = 'Promathia: The Road Forks' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED }, name = 'Promathia: Darkness Named' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THE_SAVAGE }, name = 'Promathia: The Savage' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THE_SECRETS_OF_WORSHIP }, name = 'Promathia: The Secrets of Worship' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.DESIRES_OF_EMPTINESS }, name = 'Promathia: Desires of Emptiness' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THREE_PATHS }, name = 'Promathia: Three Paths' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.ONE_TO_BE_FEARED }, name = 'Promathia: One to be Feared' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.THE_WARRIORS_PATH }, name = 'Promathia: The Warrior\'s Path' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.GARDEN_OF_ANTIQUITY }, name = 'Promathia: Garden of Antiquity' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.A_FATE_DECIDED }, name = 'Promathia: A Fate Decided' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.WHEN_ANGELS_FALL }, name = 'Promathia: When Angels Fall' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.COP, xi.mission.id.cop.DAWN }, name = 'Promathia: Dawn' },
            -- Promathia quests (JEUNO quest log)
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.STORMS_OF_FATE }, name = 'Promathia: Storms of Fate' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.APOCALYPSE_NIGH }, name = 'Promathia: Apocalypse Nigh' },
            -- Treasures of Aht Urhgan missions
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.THE_BLACK_COFFIN }, name = 'Treasures: The Black Coffin' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.SHIELD_OF_DIPLOMACY }, name = 'Treasures: Shield of Diplomacy' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.PUPPET_IN_PERIL }, name = 'Treasures: Puppet in Peril' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.LEGACY_OF_THE_LOST }, name = 'Treasures: Legacy of the Lost' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.PATH_OF_DARKNESS }, name = 'Treasures: Path of Darkness' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.TOAU, xi.mission.id.toau.NASHMEIRAS_PLEA }, name = 'Treasures: Nashmeira\'s Plea' },
            -- Treasures quests (AHT_URHGAN quest log)
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.THE_RIDER_COMETH }, name = 'Treasures: The Rider Cometh' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.WAKING_THE_COLOSSUS }, name = 'Treasures: Waking the Colossus' },
            -- Promotion
            { slots = 3, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.PROMOTION_CAPTAIN }, name = 'Promotion: Captain' },
            -- Wings of the Goddess missions
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BURDEN_OF_SUSPICION }, name = 'Wings: Burden of Suspicion' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.WRATH_OF_THE_GRIFFON }, name = 'Wings: Wrath of the Griffon' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.A_MANIFEST_PROBLEM }, name = 'Wings: A Manifest Problem' }, -- Not implemented
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.PURPLE_THE_NEW_BLACK }, name = 'Wings: Purple, The New Black' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.FIRE_IN_THE_HOLE }, name = 'Wings: Fire in the Hole' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.IN_A_HAZE_OF_GLORY }, name = 'Wings: In a Haze of Glory' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.A_FEAST_FOR_GNATS }, name = 'Wings: A Feast for Gnats' }, -- Not implemented
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.A_NATION_ON_THE_BRINK }, name = 'Wings: A Nation on the Brink' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.HONOR_UNDER_FIRE }, name = 'Wings: Honor Under Fire' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BONDS_THAT_NEVER_DIE }, name = 'Wings: Bonds That Never Die' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_FORBIDDEN_PATH }, name = 'Wings: The Forbidden Path' }, -- Not implemented
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.DISTORTER_OF_TIME }, name = 'Wings: Distorter of Time' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.WHAT_PRICE_LOYALTY }, name = 'Wings: What Price Loyalty' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BLOOD_OF_HEROES }, name = 'Wings: Blood of Heroes' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.HOWL_FROM_THE_HEAVENS }, name = 'Wings: Howl from the Heavens' }, -- Not implemented
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.DARKNESS_DESCENDS }, name = 'Wings: Darkness Descends' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BONDS_OF_MYTHRIL }, name = 'Wings: Bonds of Mythril' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.FACE_OF_THE_FUTURE }, name = 'Wings: Face of the Future' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.AT_JOURNEYS_END }, name = 'Wings: At Journey\'s End' }, -- Not implemented
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.HER_MEMORIES }, name = 'Wings: Her Memories' },
            { slots = 1, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.WHEN_WILLS_COLLIDE }, name = 'Wings: When Wills Collide' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.WOTG, xi.mission.id.wotg.MAIDEN_OF_THE_DUSK }, name = 'Wings: Maiden of the Dusk' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.CHAMPION_OF_THE_DAWN }, name = 'Wings: Champion of the Dawn' },
            -- Mini-expansion missions
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.ACP, xi.mission.id.acp.A_CRYSTALLINE_PROPHECY_FIN }, name = 'A Crystalline Prophecy' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.AMK, xi.mission.id.amk.A_MOOGLE_KUPO_DETAT_FIN }, name = 'A Moogle Kupo d\'Etat' },
            { slots = 3, checkType = checkMission, params = { xi.mission.log_id.ASA, xi.mission.id.asa.A_SHANTOTTO_ASCENSION_FIN }, name = 'A Shantotto Ascension' },
            -- Abyssea
            { slots = 3, checkType = checkQuest, params = { xi.questLog.ABYSSEA, xi.quest.id.abyssea.A_MOONLIGHT_REQUITE }, name = 'Abyssea: A Moonlight Requite' },
        },
    },

    -- Wardrobe 4 unlocks (NM defeats - Sky Gods, Jailers, etc.)
    [xi.inv.WARDROBE4] =
    {
        {
            -- Garrisons (tracked via garrisonTracking.lua)
            { slots = 1, checkType = checkGarrison, params = { xi.zone.NORTH_GUSTABERG }, name = 'Garrison: North Gustaberg' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.WEST_RONFAURE }, name = 'Garrison: West Ronfaure' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.WEST_SARUTABARUTA }, name = 'Garrison: West Sarutabaruta' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.BUBURIMU_PENINSULA }, name = 'Garrison: Buburimu Peninsula' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.JUGNER_FOREST }, name = 'Garrison: Jugner Forest' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.MERIPHATAUD_MOUNTAINS }, name = 'Garrison: Meriphataud Mountains' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.PASHHOW_MARSHLANDS }, name = 'Garrison: Pashhow Marshlands' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.QUFIM_ISLAND }, name = 'Garrison: Qufim Island' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.VALKURM_DUNES }, name = 'Garrison: Valkurm Dunes' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.BEAUCEDINE_GLACIER }, name = 'Garrison: Beaucedine Glacier' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.THE_SANCTUARY_OF_ZITAH }, name = 'Garrison: The Sanctuary of Zi\'Tah' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.YUHTUNGA_JUNGLE }, name = 'Garrison: Yuhtunga Jungle' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.EASTERN_ALTEPA_DESERT }, name = 'Garrison: Eastern Altepa Desert' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.XARCABARD }, name = 'Garrison: Xarcabard' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.YHOATOR_JUNGLE }, name = 'Garrison: Yhoator Jungle' },
            { slots = 1, checkType = checkGarrison, params = { xi.zone.CAPE_TERIGGAN }, name = 'Garrison: Cape Teriggan' },

            -- Sky Gods
            { slots = 1, checkType = checkNm, params = { 'Byakko' }, name = 'Defeat: Byakko' },
            { slots = 1, checkType = checkNm, params = { 'Genbu' }, name = 'Defeat: Genbu' },
            { slots = 1, checkType = checkNm, params = { 'Seiryu' }, name = 'Defeat: Seiryu' },
            { slots = 1, checkType = checkNm, params = { 'Suzaku' }, name = 'Defeat: Suzaku' },
            { slots = 3, checkType = checkNm, params = { 'Kirin' }, name = 'Defeat: Kirin' },

            -- Sea Jailers
            { slots = 1, checkType = checkNm, params = { 'Jailer_of_Hope' }, name = 'Defeat: Jailer of Hope' },
            { slots = 1, checkType = checkNm, params = { 'Jailer_of_Prudence' }, name = 'Defeat: Jailer of Prudence' },
            { slots = 1, checkType = checkNm, params = { 'Jailer_of_Justice' }, name = 'Defeat: Jailer of Justice' },
            { slots = 1, checkType = checkNm, params = { 'Jailer_of_Love' }, name = 'Defeat: Jailer of Love' },
            { slots = 3, checkType = checkNm, params = { 'Absolute_Virtue' }, name = 'Defeat: Absolute Virtue' },

            -- Hydra Corps items
            { slots = 1, checkType = checkKi, params = { xi.ki.HYDRA_CORPS_COMMAND_SCEPTER }, name = 'Obtain: Hydra Corps Command Scepter' },
            { slots = 1, checkType = checkKi, params = { xi.ki.HYDRA_CORPS_LANTERN }, name = 'Obtain: Hydra Corps Lantern' },
            { slots = 1, checkType = checkKi, params = { xi.ki.HYDRA_CORPS_EYEGLASS }, name = 'Obtain: Hydra Corps Eyeglass' },
            { slots = 1, checkType = checkKi, params = { xi.ki.HYDRA_CORPS_TACTICAL_MAP }, name = 'Obtain: Hydra Corps Tactical Map' },
            { slots = 1, checkType = checkKi, params = { xi.ki.HYDRA_CORPS_INSIGNIA }, name = 'Obtain: Hydra Corps Insignia' },

            -- Dynamis
            { slots = 3, checkType = checkNm, params = { 'Dynamis_Lord' }, name = 'Defeat: Dynamis Lord' },

            -- Dynamis Slivers
            { slots = 1, checkType = checkKi, params = { xi.ki.DYNAMIS_VALKURM_SLIVER }, name = 'Obtain: Dynamis - Valkurm sliver' },
            { slots = 1, checkType = checkKi, params = { xi.ki.DYNAMIS_BUBURIMU_SLIVER }, name = 'Obtain: Dynamis - Buburimu sliver' },
            { slots = 1, checkType = checkKi, params = { xi.ki.DYNAMIS_QUFIM_SLIVER }, name = 'Obtain: Dynamis - Qufim sliver' },
            { slots = 3, checkType = checkKi, params = { xi.ki.DYNAMIS_TAVNAZIA_SLIVER }, name = 'Obtain: Dynamis - Tavnazia sliver' },

            -- Limbus
            { slots = 3, checkType = checkNm, params = { 'Proto-Omega' }, name = 'Defeat: Proto-Omega' },
            { slots = 3, checkType = checkNm, params = { 'Proto-Ultima' }, name = 'Defeat: Proto-Ultima' },

            -- Wyrm battles
            { slots = 1, checkType = checkNm, params = { 'Ouryu' }, name = 'Ouryu Cometh' },
            { slots = 1, checkType = checkNm, params = { 'Bahamut' }, name = 'The Wyrmking Descends' },

            -- ZNMs (Zeni Notorious Monsters)
            { slots = 1, checkType = checkNm, params = { 'Krabkatoa' }, name = 'Defeat: Krabkatoa' },
            { slots = 1, checkType = checkNm, params = { 'Blobdingnag' }, name = 'Defeat: Blobdingnag' },
            { slots = 1, checkType = checkNm, params = { 'Orcus' }, name = 'Defeat: Orcus' },
            { slots = 1, checkType = checkNm, params = { 'Verthandi' }, name = 'Defeat: Verthandi' },
            { slots = 1, checkType = checkNm, params = { 'Lord_Ruthven' }, name = 'Defeat: Lord Ruthven' },
            { slots = 1, checkType = checkNm, params = { 'Dawon' }, name = 'Defeat: Dawon' },
            { slots = 3, checkType = checkNm, params = { 'Yilbegan' }, name = 'Defeat: Yilbegan' },
            { slots = 1, checkType = checkNm, params = { 'Tinnin' }, name = 'Defeat: Tinnin' },
            { slots = 1, checkType = checkNm, params = { 'Sarameya' }, name = 'Defeat: Sarameya' },
            { slots = 1, checkType = checkNm, params = { 'Tyger' }, name = 'Defeat: Tyger' },
            { slots = 3, checkType = checkNm, params = { 'Pandemonium_Warden' }, name = 'Defeat: Pandemonium Warden' },

            -- Salvage Chariots
            { slots = 1, checkType = checkNm, params = { 'Armored_Chariot' }, name = 'Defeat: Armored Chariot' },
            { slots = 1, checkType = checkNm, params = { 'Long-Bowed_Chariot' }, name = 'Defeat: Long-Bowed Chariot' },
            { slots = 1, checkType = checkNm, params = { 'Long-Armed_Chariot' }, name = 'Defeat: Long-Armed Chariot' },
            { slots = 1, checkType = checkNm, params = { 'Battleclad_Chariot' }, name = 'Defeat: Battleclad Chariot' },

            -- Campaign Ops BCNMs (NOT IMPLEMENTED)
            -- { slots = 3, checkType = checkBcnm, params = { ... }, name = 'The Blood-bathed Crown' },
            -- { slots = 3, checkType = checkBcnm, params = { ... }, name = 'A Malicious Manifest' },
            -- { slots = 3, checkType = checkBcnm, params = { ... }, name = 'The Buried God' },
        },
    },

    -- Wardrobe 5 unlocks (various NMs)
    [xi.inv.WARDROBE5] =
    {
        {
            { slots = 1, checkType = checkNm, params = { 'Maighdean_Uaine' }, name = 'Defeat: Maighdean Uaine' },
            { slots = 1, checkType = checkNm, params = { 'Carnero' }, name = 'Defeat: Carnero' },
            { slots = 1, checkType = checkNm, params = { 'Geyser_Lizard' }, name = 'Defeat: Geyser Lizard' },
            { slots = 1, checkType = checkNm, params = { 'BuGhi_Howlblade' }, name = 'Defeat: Bu\'Ghi Howlblade' },
            { slots = 1, checkType = checkNm, params = { 'Ghillie_Dhu' }, name = 'Defeat: Ghillie Dhu' },
            { slots = 1, checkType = checkNm, params = { 'Toxic_Tamlyn' }, name = 'Defeat: Toxic Tamlyn' },
            { slots = 1, checkType = checkNm, params = { 'DaDha_Hundredmask' }, name = 'Defeat: Da\'Dha Hundredmask' },
            { slots = 1, checkType = checkNm, params = { 'Ravenous_Crawler' }, name = 'Defeat: Ravenous Crawler' },
            { slots = 1, checkType = checkNm, params = { 'Golden_Bat' }, name = 'Defeat: Golden Bat' },
            { slots = 1, checkType = checkNm, params = { 'Fungus_Beetle' }, name = 'Defeat: Fungus Beetle' },
            { slots = 1, checkType = checkNm, params = { 'Thousandarm_Deshglesh' }, name = 'Defeat: Thousandarm Deshglesh' },
            { slots = 1, checkType = checkNm, params = { 'Bigmouth_Billy' }, name = 'Defeat: Bigmouth Billy' },
            { slots = 1, checkType = checkNm, params = { 'Gwyllgi' }, name = 'Defeat: Gwyllgi' },
            { slots = 1, checkType = checkNm, params = { 'Agar_Agar' }, name = 'Defeat: Agar Agar' },
            { slots = 1, checkType = checkNm, params = { 'Nihniknoovi' }, name = 'Defeat: Nihniknoovi' },
            { slots = 1, checkType = checkNm, params = { 'Sappy_Sycamore' }, name = 'Defeat: Sappy Sycamore' },
            { slots = 1, checkType = checkNm, params = { 'Tempest_Tigon' }, name = 'Defeat: Tempest Tigon' },
            { slots = 1, checkType = checkNm, params = { 'Blubbery_Bulge' }, name = 'Defeat: Blubbery Bulge' },
            { slots = 1, checkType = checkNm, params = { 'Eyegouger' }, name = 'Defeat: Eyegouger' },
            { slots = 1, checkType = checkNm, params = { 'Sharp-Eared_Ropipi' }, name = 'Defeat: Sharp-Eared Ropipi' },
            { slots = 1, checkType = checkNm, params = { 'Cwn_Cyrff' }, name = 'Defeat: Cwn Cyrff' },
            { slots = 1, checkType = checkNm, params = { 'Tom_Tit_Tat' }, name = 'Defeat: Tom Tit Tat' },
            { slots = 1, checkType = checkNm, params = { 'Vuu_Puqu_the_Beguiler' }, name = 'Defeat: Vuu Puqu the Beguiler' },
            { slots = 1, checkType = checkNm, params = { 'Desmodont' }, name = 'Defeat: Desmodont' },
            { slots = 1, checkType = checkNm, params = { 'Serpopard_Ishtar' }, name = 'Defeat: Serpopard Ishtar' },
            { slots = 1, checkType = checkNm, params = { 'Buburimboo' }, name = 'Defeat: Buburimboo' },
            { slots = 1, checkType = checkNm, params = { 'Trembler_Tabitha' }, name = 'Defeat: Trembler Tabitha' },
            { slots = 1, checkType = checkNm, params = { 'Shankha' }, name = 'Defeat: Shankha' },
            { slots = 1, checkType = checkNm, params = { 'Naa_Zeku_the_Unwaiting' }, name = 'Defeat: Naa Zeku the Unwaiting' },
            { slots = 1, checkType = checkNm, params = { 'Blighting_Brand' }, name = 'Defeat: Blighting Brand' },
            { slots = 1, checkType = checkNm, params = { 'Gloom_Eye' }, name = 'Defeat: Gloom Eye' },
            { slots = 1, checkType = checkNm, params = { 'Kirata' }, name = 'Defeat: Kirata' },
            { slots = 1, checkType = checkNm, params = { 'Mind_Hoarder' }, name = 'Defeat: Mind Hoarder' },
            { slots = 1, checkType = checkNm, params = { 'Barbaric_Weapon' }, name = 'Defeat: Barbaric Weapon' },
            { slots = 1, checkType = checkNm, params = { 'Dark_Spark' }, name = 'Defeat: Dark Spark' },
            { slots = 1, checkType = checkNm, params = { 'Trickster_Kinetix' }, name = 'Defeat: Trickster Kinetix' },
            { slots = 1, checkType = checkNm, params = { 'Rhoitos' }, name = 'Defeat: Rhoitos' },
            { slots = 1, checkType = checkNm, params = { 'Qull_the_Shellbuster' }, name = 'Defeat: Qull the Shellbuster' },
            { slots = 1, checkType = checkNm, params = { 'Hoar-knuckled_Rimberry' }, name = 'Defeat: Hoar-knuckled Rimberry' },
            { slots = 1, checkType = checkNm, params = { 'Tonberry_Kinq' }, name = 'Defeat: Tonberry Kinq' },
            { slots = 1, checkType = checkNm, params = { 'Tawny-fingered_Mugberry' }, name = 'Defeat: Tawny-fingered Mugberry' },
            { slots = 1, checkType = checkNm, params = { 'Falcatus_Aranei' }, name = 'Defeat: Falcatus Aranei' },
            { slots = 1, checkType = checkNm, params = { 'Celphie' }, name = 'Defeat: Celphie' },
            { slots = 1, checkType = checkNm, params = { 'Cancer' }, name = 'Defeat: Cancer' },
            { slots = 1, checkType = checkNm, params = { 'Sabotender_Mariachi' }, name = 'Defeat: Sabotender Mariachi' },
            { slots = 1, checkType = checkNm, params = { 'Tribunus_VII-I' }, name = 'Defeat: Tribunus VII-I' },
            { slots = 1, checkType = checkNm, params = { 'Keeper_of_Halidom' }, name = 'Defeat: Keeper of Halidom' },
            { slots = 1, checkType = checkNm, params = { 'Rogue_Receptacle' }, name = 'Defeat: Rogue Receptacle' },
            { slots = 1, checkType = checkNm, params = { 'Shii' }, name = 'Defeat: Shii' },
            { slots = 1, checkType = checkNm, params = { 'Helion' }, name = 'Defeat: Helion' },
            { slots = 1, checkType = checkNm, params = { 'Unut' }, name = 'Defeat: Unut' },
            { slots = 1, checkType = checkNm, params = { 'Nis_Puk' }, name = 'Defeat: Nis Puk' },
            { slots = 1, checkType = checkNm, params = { 'Mahishasura' }, name = 'Defeat: Mahishasura' },
            { slots = 1, checkType = checkNm, params = { 'Firedance_Magmaal_Ja' }, name = 'Defeat: Firedance Magmaal Ja' },
            { slots = 1, checkType = checkNm, params = { 'Flammeri' }, name = 'Defeat: Flammeri' },
            { slots = 1, checkType = checkNm, params = { 'Fahrafahr_the_Bloodied' }, name = 'Defeat: Fahrafahr the Bloodied' },
            { slots = 1, checkType = checkNm, params = { 'Cookieduster_Lipiroon' }, name = 'Defeat: Cookieduster Lipiroon' },
            { slots = 1, checkType = checkNm, params = { 'Oupire' }, name = 'Defeat: Oupire' },
            { slots = 1, checkType = checkNm, params = { 'Centipedal_Centruroides' }, name = 'Defeat: Centipedal Centruroides' },
            { slots = 1, checkType = checkNm, params = { 'Delicieuse_Delphine' }, name = 'Defeat: Delicieuse Delphine' },
            { slots = 1, checkType = checkNm, params = { 'Sugaar' }, name = 'Defeat: Sugaar' },
            { slots = 1, checkType = checkNm, params = { 'Kotan-kor_Kamuy' }, name = 'Defeat: Kotan-kor Kamuy' },
            { slots = 1, checkType = checkNm, params = { 'Voirloup' }, name = 'Defeat: Voirloup' },
            { slots = 1, checkType = checkNm, params = { 'GrandGoule' }, name = 'Defeat: Grand\'Goule' },
            { slots = 1, checkType = checkNm, params = { 'Prince_Orobas' }, name = 'Defeat: Prince Orobas' },
            { slots = 1, checkType = checkNm, params = { 'Ambusher_Antlion' }, name = 'Defeat: Ambusher Antlion' },
            { slots = 1, checkType = checkNm, params = { 'Goblin_Collector' }, name = 'Defeat: Goblin Collector' },
            { slots = 1, checkType = checkNm, params = { 'Bomb_Queen' }, name = 'Defeat: Bomb Queen' },
            { slots = 1, checkType = checkNm, params = { 'Kurrea' }, name = 'Defeat: Kurrea' },
            { slots = 1, checkType = checkNm, params = { 'Gration' }, name = 'Defeat: Gration' },
            { slots = 1, checkType = checkNm, params = { 'Ungur' }, name = 'Defeat: Ungur' },
            { slots = 1, checkType = checkNm, params = { 'Fafnir' }, name = 'Defeat: Fafnir' },
            { slots = 2, checkType = checkNm, params = { 'Nidhogg' }, name = 'Defeat: Nidhogg' },
            { slots = 1, checkType = checkNm, params = { 'Adamantoise' }, name = 'Defeat: Adamantoise' },
            { slots = 2, checkType = checkNm, params = { 'Aspidochelone' }, name = 'Defeat: Aspidochelone' },
            { slots = 1, checkType = checkNm, params = { 'Behemoth' }, name = 'Defeat: Behemoth' },
            { slots = 2, checkType = checkNm, params = { 'King_Behemoth' }, name = 'Defeat: King Behemoth' },
        },
    },

    -- Wardrobe 6 unlocks (Key Items - Maps)
    [xi.inv.WARDROBE6] =
    {
        {
            -- 1-slot maps (Base game dungeons and regions)
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_BEADEAUX }, name = 'KI: Map of Beadeaux' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_CASTLE_OZTROJA }, name = 'KI: Map of Castle Oztroja' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_DAVOI }, name = 'KI: Map of Davoi' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_ELDIEME_NECROPOLIS }, name = 'KI: Map of the Eldieme Necropolis' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_GARLAIGE_CITADEL }, name = 'KI: Map of the Garlaige Citadel' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_KUZOTZ_REGION }, name = 'KI: Map of the Kuzotz region' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_LITELOR_REGION }, name = 'KI: Map of the Li\'Telor region' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_VOLLBOW_REGION }, name = 'KI: Map of the Vollbow region' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_ELSHIMO_REGIONS }, name = 'KI: Map of the Elshimo regions' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_KORROLOKA_TUNNEL }, name = 'KI: Map of the Korroloka Tunnel' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_CARPENTERS_LANDING }, name = 'KI: Map of Carpenters\' Landing' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_BIBIKI_BAY }, name = 'KI: Map of Bibiki Bay' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_KING_RANPERRES_TOMB }, name = 'KI: Map of King Ranperre\'s Tomb' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_DANGRUF_WADI }, name = 'KI: Map of the Dangruf Wadi' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_GUSGEN_MINES }, name = 'KI: Map of the Gusgen Mines' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_HORUTOTO_RUINS }, name = 'KI: Map of the Horutoto Ruins' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_BOSTAUNIEUX_OUBLIETTE }, name = 'KI: Map of Bostaunieux Oubliette' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_RANGUEMONT_PASS }, name = 'KI: Map of the Ranguemont Pass' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_NORTHLANDS_AREA }, name = 'KI: Map of the Northlands area' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_DELKFUTTS_TOWER }, name = 'KI: Map of Delkfutt\'s Tower' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_CASTLE_ZVAHL }, name = 'KI: Map of Castle Zvahl' },
            -- 1-slot maps (CoP)
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_THE_ATTOHWA_CHASM }, name = 'KI: Map of the Attohwa Chasm' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_TAVNAZIA }, name = 'KI: Map of Tavnazia' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_ALTAIEU }, name = 'KI: Map of Al\'Taieu' },
            -- 1-slot maps (ToAU)
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_BHAFLAU_THICKETS }, name = 'KI: Map of Bhaflau Thickets' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_WAJAOM_WOODLANDS }, name = 'KI: Map of Wajaom Woodlands' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_NASHMAU }, name = 'KI: Map of Nashmau' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_MAMOOK }, name = 'KI: Map of Mamook' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_HALVUNG }, name = 'KI: Map of Halvung' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_ARRAPAGO_REEF }, name = 'KI: Map of Arrapago Reef' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_ALZADAAL_RUINS }, name = 'KI: Map of Alzadaal Ruins' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_CAEDARVA_MIRE }, name = 'KI: Map of Caedarva Mire' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_MOUNT_ZHAYOLM }, name = 'KI: Map of Mount Zhayolm' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_AYDEEWA_SUBTERRANE }, name = 'KI: Map of Aydeewa Subterrane' },
            -- 1-slot maps (WotG)
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_VUNKERL_INLET }, name = 'KI: Map of Vunkerl Inlet' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_GRAUBERG }, name = 'KI: Map of Grauberg' },
            { slots = 1, checkType = checkKi, params = { xi.ki.MAP_OF_FORT_KARUGO_NARUGO }, name = 'KI: Map of Fort Karugo-Narugo' },
            -- 2-slot maps (Base game dungeons)
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_TORAIMARAI_CANAL }, name = 'KI: Map of the Toraimarai Canal' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_FEIYIN }, name = 'KI: Map of Fei\'Yin' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_BOYAHDA_TREE }, name = 'KI: Map of the Boyahda Tree' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_DEN_OF_RANCOR }, name = 'KI: Map of the Den of Rancor' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_IFRITS_CAULDRON }, name = 'KI: Map of Ifrit\'s Cauldron' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_KUFTAL_TUNNEL }, name = 'KI: Map of the Kuftal Tunnel' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_LABYRINTH_OF_ONZOZO }, name = 'KI: Map of the Labyrinth of Onzozo' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_QUICKSAND_CAVES }, name = 'KI: Map of the Quicksand Caves' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_RUAUN_GARDENS }, name = 'KI: Map of the Ru\'Aun Gardens' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_SEA_SERPENT_GROTTO }, name = 'KI: Map of the Sea Serpent Grotto' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_VELUGANNON_PALACE }, name = 'KI: Map of the Ve\'Lugannon Palace' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_ULEGUERAND_RANGE }, name = 'KI: Map of the Uleguerand Range' },
            -- 2-slot maps (CoP)
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_PSOXJA }, name = 'KI: Map of Pso\'Xja' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_AQUEDUCTS }, name = 'KI: Map of the Aqueducts' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_THE_SACRARIUM }, name = 'KI: Map of the Sacrarium' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_CAPE_RIVERNE }, name = 'KI: Map of Cape Riverne' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_OLDTON_MOVALPOLOS }, name = 'KI: Map of Oldton Movalpolos' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_NEWTON_MOVALPOLOS }, name = 'KI: Map of Newton Movalpolos' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_HUXZOI }, name = 'KI: Map of Hu\'Xzoi' },
            { slots = 2, checkType = checkKi, params = { xi.ki.MAP_OF_RUHMET }, name = 'KI: Map of Ru\'Hmet' },
            -- 3-slot maps
            { slots = 3, checkType = checkKi, params = { xi.ki.MAP_OF_THE_CRAWLERS_NEST }, name = 'KI: Map of the Crawlers\' Nest' },
        },
    },

    -- Wardrobe 7 unlocks (Quests)
    [xi.inv.WARDROBE7] =
    {
        {
            -- Bastok Quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.STAMP_HUNT }, name = 'Quest: Stamp Hunt' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.BREAKING_STONES }, name = 'Quest: Breaking Stones' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_SIGNPOST_MARKS_THE_SPOT }, name = 'Quest: The Signpost Marks the Spot' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.STARDUST }, name = 'Quest: Stardust' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_STARS_OF_IFRIT }, name = 'Quest: The Stars of Ifrit' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.GUEST_OF_HAUTEUR }, name = 'Quest: Guest of Hauteur' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_RETURN_OF_THE_ADVENTURER }, name = 'Quest: The Return of the Adventurer' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.TILL_DEATH_DO_US_PART }, name = 'Quest: Till Death Do Us Part' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.BEADEAUX_SMOG }, name = 'Quest: Beadeaux Smog' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.TEAK_ME_TO_THE_STARS }, name = 'Quest: Teak Me to the Stars' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_CURSE_COLLECTOR }, name = 'Quest: The Curse Collector' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.WISH_UPON_A_STAR }, name = 'Quest: Wish Upon a Star' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_USUAL }, name = 'Quest: The Usual' },
            { slots = 3, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.LOVERS_IN_THE_DUSK }, name = 'Quest: Lovers in the Dusk' },

            -- San d'Oria Quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.A_SENTRYS_PERIL }, name = 'Quest: A Sentry\'s Peril' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.GRAVE_CONCERNS }, name = 'Quest: Grave Concerns' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.THE_DISMAYED_CUSTOMER }, name = 'Quest: The Dismayed Customer' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.FLYERS_FOR_REGINE }, name = 'Quest: Flyers for Regine' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.GRIMY_SIGNPOSTS }, name = 'Quest: Grimy Signposts' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.SLEEPLESS_NIGHTS }, name = 'Quest: Sleepless Nights' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.THE_VICASQUES_SERMON }, name = 'Quest: The Vicasque\'s Sermon' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.A_PURCHASE_OF_ARMS }, name = 'Quest: A Purchase of Arms' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.A_JOB_FOR_THE_CONSORTIUM }, name = 'Quest: A Job for the Consortium' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.TO_CURE_A_COUGH }, name = 'Quest: To Cure a Cough' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.ADVANCED_TEAMWORK }, name = 'Quest: Advanced Teamwork' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.TEA_WITH_A_TONBERRY }, name = 'Quest: Tea with a Tonberry?' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.THE_SETTING_SUN }, name = 'Quest: The Setting Sun' },

            -- Windurst Quests
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.TO_CATCH_A_FALLING_STAR }, name = 'Quest: To Catch a Falling Star' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.HAT_IN_HAND }, name = 'Quest: Hat in Hand' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.SAY_IT_WITH_FLOWERS }, name = 'Quest: Say It with Flowers' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.A_CRISIS_IN_THE_MAKING }, name = 'Quest: A Crisis in the Making' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.TO_BEE_OR_NOT_TO_BEE }, name = 'Quest: To Bee or Not to Bee?' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.ROCK_RACKETEER }, name = 'Quest: Rock Racketeer' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.WONDER_WANDS }, name = 'Quest: Wonder Wands' }, -- Not implemented
            -- { slots = 2, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.HOIST_THE_JELLY_ROGER }, name = 'Quest: Hoist the Jelly, Roger' }, -- Not implemented
            { slots = 2, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.BLAST_FROM_THE_PAST }, name = 'Quest: Blast from the Past' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.THE_PROMISE }, name = 'Quest: The Promise' },
            -- { slots = 2, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.CAN_CARDIANS_CRY }, name = 'Quest: Can Cardians Cry?' }, -- Not implemented
            { slots = 2, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.TORAIMARAI_TURMOIL }, name = 'Quest: Toraimarai Turmoil' },

            -- Jeuno Quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.A_CANDLELIGHT_VIGIL }, name = 'Quest: A Candlelight Vigil' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.NEVER_TO_RETURN }, name = 'Quest: Never to Return' }, -- Not implemented
            -- { slots = 2, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.RUBBISH_DAY }, name = 'Quest: Rubbish Day' }, -- Not implemented
            -- { slots = 2, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_KIND_CARDIAN }, name = 'Quest: The Kind Cardian' }, -- Not implemented
            { slots = 2, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.THE_CLOCKMASTER }, name = 'Quest: The Clockmaster' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.A_CHOCOBOS_TALE }, name = 'Quest: A Chocobo\'s Tale' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.HOOK_LINE_AND_SINKER }, name = 'Quest: Hook, Line, and Sinker' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.STORMS_OF_FATE }, name = 'Quest: Storms of Fate' },

            -- Other Areas Quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_REAL_GIFT }, name = 'Quest: The Real Gift' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.TEST_MY_METTLE }, name = 'Quest: Test My Mettle' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.ORLANDOS_ANTIQUES }, name = 'Quest: Orlando\'s Antiques' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.A_POTTERS_PREFERENCE }, name = 'Quest: A Potter\'s Preference' }, -- Not implemented
            { slots = 2, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_BASICS }, name = 'Quest: The Basics' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.KNOCKING_ON_FORBIDDEN_DOORS }, name = 'Quest: Knocking on Forbidden Doors' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.ELDERLY_PURSUITS }, name = 'Quest: Elderly Pursuits' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.X_MARKS_THE_SPOT }, name = 'Quest: X Marks the Spot' },

            -- Outlands Quests
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.PERSONAL_HYGIENE }, name = 'Quest: Personal Hygiene' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.GREETINGS_TO_THE_GUARDIAN }, name = 'Quest: Greetings to the Guardian' }, -- Not implemented
            -- { slots = 2, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.THE_OPO_OPO_AND_I }, name = 'Quest: The Opo-opo and I' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.CHASING_DREAMS }, name = 'Quest: Chasing Dreams' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.THE_KUFTAL_TOUR }, name = 'Quest: The Kuftal Tour' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.DONT_FORGET_THE_ANTIDOTE }, name = 'Quest: Don\'t Forget the Antidote' }, -- Not implemented
        },
    },

    -- Wardrobe 8 unlocks (Aht Urhgan and other quest-based unlocks)
    [xi.inv.WARDROBE8] =
    {
        {
            -- Aht Urhgan quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.ARTS_AND_CRAFTS }, name = 'Quest: Arts and Crafts' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.OLDUUM }, name = 'Quest: Olduum' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.THREE_MEN_AND_A_CLOSET }, name = 'Quest: Three Men and a Closet' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.MOMENT_OF_TRUTH }, name = 'Quest: Moment of Truth' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.SAGA_OF_THE_SKYSERPENT }, name = 'Quest: Saga of the Skyserpent' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.ODE_TO_THE_SERPENTS }, name = 'Quest: Ode to the Serpents' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.WHEN_THE_BOW_BREAKS }, name = 'Quest: When the Bow Breaks' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.FIST_OF_THE_PEOPLE }, name = 'Quest: Fist of the People' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.SOOTHING_WATERS }, name = 'Quest: Soothing Waters' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.EMBERS_OF_HIS_PAST }, name = 'Quest: Embers of His Past' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.STRIKING_A_BALANCE }, name = 'Quest: Striking a Balance' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.NOT_MEANT_TO_BE }, name = 'Quest: Not Meant to Be' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.LED_ASTRAY }, name = 'Quest: Led Astray' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.THE_DIE_IS_CAST }, name = 'Quest: The Die is Cast' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.TWO_HORN_THE_SAVAGE }, name = 'Quest: Two Horn the Savage' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.SUCH_SWEET_SORROW }, name = 'Quest: Such Sweet Sorrow' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.FEAR_OF_THE_DARK_II }, name = 'Quest: Fear of the Dark II' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.WAKING_THE_COLOSSUS }, name = 'Quest: Waking the Colossus' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.THE_RIDER_COMETH }, name = 'Quest: The Rider Cometh' }, -- Not implemented
            { slots = 2, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.RAT_RACE }, name = 'Quest: Rat Race' },
            { slots = 2, checkType = checkQuest, params = { xi.questLog.AHT_URHGAN, xi.quest.id.ahtUrhgan.A_TASTE_OF_HONEY }, name = 'Quest: A Taste of Honey' },
            -- Runic Key
            { slots = 1, checkType = checkKi, params = { xi.ki.RUNIC_KEY }, name = 'Obtain: Runic Key' },
            -- Crystal War quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.MESSAGE_ON_THE_WINDS }, name = 'Quest: Message on the Wind' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.HEALING_HERBS }, name = 'Quest: Healing Herbs' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.REDEEMING_ROCKS }, name = 'Quest: Redeeming Rocks' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_DAWN_OF_DELECTABILITY }, name = 'Quest: The Dawn of Delectability' },
            -- San d'Oria quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.ATELLOUNES_LAMENT }, name = 'Quest: Atelloune\'s Lament' },
            -- Crystal War story quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.HAMMERING_HEARTS }, name = 'Quest: Hammering Hearts' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BEAST_FROM_THE_EAST }, name = 'Quest: Beast from the East' }, -- Not implemented
            { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.SAY_IT_WITH_A_HANDBAG }, name = 'Quest: Say It with a Handbag' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.A_JEWELERS_LAMENT }, name = 'Quest: A Jeweler\'s Lament' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_YOUNG_AND_THE_THREADLESS }, name = 'Quest: The Young and the Threadless' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.SON_AND_FATHER }, name = 'Quest: Son and Father' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.CHAMPION_OF_THE_DAWN }, name = 'Quest: Champion of the Dawn' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.A_FORBIDDEN_REUNION }, name = 'Quest: A Forbidden Reunion' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.ROSE_ON_THE_HEATH }, name = 'Quest: Rose on the Heath' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.ADDLED_MIND_UNDYING_DREAMS }, name = 'Quest: Addled Mind, Undying Dreams' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_WALKING_WOUNDED }, name = 'Quest: The Walking Wounded' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.UNBREAK_HIS_HEART }, name = 'Quest: Unbreak His Heart' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.AN_EYE_FOR_REVENGE }, name = 'Quest: An Eye for Revenge' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.OUT_OF_TOUCH }, name = 'Quest: Out of Touch' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.WEAPONS_NOT_WORRIES }, name = 'Quest: Weapons, Not Worries' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.SISTERS_IN_CRIME }, name = 'Quest: Sisters in Crime' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.TANGLING_WITH_TONGUE_TWISTERS }, name = 'Quest: Tangling with Tongue-twisters' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.DESTINY_ODYSSEY }, name = 'Quest: Destiny Odyssey' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.DROPPING_THE_BOMB }, name = 'Quest: Dropping the Bomb' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.WHITHER_THE_WHISKER }, name = 'Quest: Whither the Whisker' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.FAMILY_TIES }, name = 'Quest: Family Ties' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.AN_OFFER_YOU_CANT_REFUSE }, name = 'Quest: An Offer You Can\'t Refuse' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.FOR_WANT_OF_A_POT }, name = 'Quest: For Want of a Pot' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.LOOK_TO_THE_SKY }, name = 'Quest: Look to the Sky' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.THE_UNMARKED_TOMB }, name = 'Quest: The Unmarked Tomb' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.IMPERIAL_ESPIONAGE_II }, name = 'Quest: Imperial Espionage II' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BROTHERS_IN_ARMS }, name = 'Quest: Brothers in Arms' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.BRUGAIRES_AMBITION }, name = 'Quest: Brugaire\'s Ambition' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.CRYSTAL_WAR, xi.quest.id.crystalWar.VOICES_FROM_BEYOND }, name = 'Quest: Voices from Beyond' }, -- Not implemented
            -- Adoulin quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.TRANSPORTING }, name = 'Quest: Transporting' },
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.NOTSOCLEAN_BILL }, name = 'Quest: Not-So-Clean Bill' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.A_BARREL_OF_LAUGHS }, name = 'Quest: A Barrel of Laughs' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.A_THIRST_BEFORE_TIME }, name = 'Quest: A Thirst Before Time' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.IN_THE_LAND_OF_THE_BLIND }, name = 'Quest: In the Land of the Blind' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.THE_WEATHERSPOON_WAR }, name = 'Quest: The Weatherspoon War' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.ONE_GOOD_TURN }, name = 'Quest: One Good Turn...' }, -- Not implemented
            -- { slots = 1, checkType = checkQuest, params = { xi.questLog.ADOULIN, xi.quest.id.adoulin.THE_ARCIELA_DIRECTIVE }, name = 'Quest: The Arciela Directive' }, -- Not implemented
            -- Bastok/Windurst job quests
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_WALLS_OF_YOUR_MIND }, name = 'Quest: The Walls of Your Mind' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.CLOAK_AND_DAGGER }, name = 'Quest: Cloak and Dagger' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.OLD_WOUNDS }, name = 'Quest: Old Wounds' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.INHERITANCE }, name = 'Quest: Inheritance' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.JEUNO, xi.quest.id.jeuno.AXE_THE_COMPETITION }, name = 'Quest: Axe the Competition' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.THE_WEIGHT_OF_YOUR_LIMITS }, name = 'Quest: The Weight of Your Limits' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.SOULS_IN_SHADOW }, name = 'Quest: Souls in Shadow' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.SANDORIA, xi.quest.id.sandoria.METHODS_CREATE_MADNESS }, name = 'Quest: Methods Create Madness' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.BUGI_SODEN }, name = 'Quest: Bugi Soden' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.OUTLANDS, xi.quest.id.outlands.THE_POTENTIAL_WITHIN }, name = 'Quest: The Potential Within' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.ORASTERY_WOES }, name = 'Quest: Orastery Woes' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.BLOOD_AND_GLORY }, name = 'Quest: Blood and Glory' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.WINDURST, xi.quest.id.windurst.FROM_SAPLINGS_GROW }, name = 'Quest: From Saplings Grow' },
            { slots = 1, checkType = checkQuest, params = { xi.questLog.BASTOK, xi.quest.id.bastok.SHOOT_FIRST_ASK_QUESTIONS_LATER }, name = 'Quest: Shoot First, Ask Questions Later' },
        },
    },
}

-----------------------------------
-- Get char_var name for tracking unlocks
-- Uses bag enum value as suffix for simplicity
-----------------------------------
local function getUnlockVarName(bag, groupIndex)
    if groupIndex > 1 then
        return string.format('WardrobeUnlock_%d_%d', bag, groupIndex)
    end

    return string.format('WardrobeUnlock_%d', bag)
end

-----------------------------------
-- Check if unlock has been received
-----------------------------------
local function hasReceivedUnlock(player, bag, groupIndex, unlockIndex)
    local varName = getUnlockVarName(bag, groupIndex)
    return utils.mask.getBit(player:getCharVar(varName), unlockIndex)
end

-----------------------------------
-- Mark unlock as received
-----------------------------------
local function markUnlockReceived(player, bag, groupIndex, unlockIndex)
    local varName = getUnlockVarName(bag, groupIndex)
    local current = player:getCharVar(varName)
    player:setCharVar(varName, utils.mask.setBit(current, unlockIndex, true))
end

-----------------------------------
-- Check and award unlocks for a specific bag
-----------------------------------
local function checkAndAwardBagUnlocks(player, bag, silent)
    local bagUnlockGroups = unlockData[bag]
    local totalAwarded = 0
    local bagName = bagDisplayNames[bag]

    for groupIndex, unlocks in ipairs(bagUnlockGroups) do
        for unlockIndex, unlock in ipairs(unlocks) do
            local bitPos = unlockIndex - 1

            if
                not hasReceivedUnlock(player, bag, groupIndex, bitPos) and
                evaluateCheck(player, unlock.checkType, unlock.params)
            then
                local oldSize = player:getContainerSize(bag)
                player:changeContainerSize(bag, unlock.slots)
                local newSize = player:getContainerSize(bag)
                markUnlockReceived(player, bag, groupIndex, bitPos)
                totalAwarded = totalAwarded + unlock.slots

                if not silent then
                    player:printToPlayer(
                        string.format('%s capacity increased by %d from %d to %d (%s)',
                            bagName, unlock.slots, oldSize, newSize, unlock.name),
                        xi.msg.channel.SYSTEM_3,
                        ''
                    )
                end
            end
        end
    end

    return totalAwarded
end

-----------------------------------
-- Public API
-----------------------------------
xi = xi or {}
xi.wardrobeUnlocks = xi.wardrobeUnlocks or {}

-----------------------------------
-- Check and award all unlocks for a player
-- @param player CCharEntity: The player to check
-- @param silent boolean: If true, don't show messages
-- @return number: Total unlocks awarded
-----------------------------------
xi.wardrobeUnlocks.checkAllUnlocks = function(player, silent)
    local totalAwarded = 0
    for bag, _ in pairs(unlockData) do
        totalAwarded = totalAwarded + checkAndAwardBagUnlocks(player, bag, silent)
    end

    return totalAwarded
end

-----------------------------------
-- Character Creation: Initialize wardrobes to 0
-----------------------------------
m:addOverride('xi.player.charCreate', function(player)
    super(player)

    -- Set all wardrobes to 0 slots
    player:changeContainerSize(xi.inv.MOGCASE, -80)
    player:changeContainerSize(xi.inv.WARDROBE, -80)
    player:changeContainerSize(xi.inv.WARDROBE2, -80)
    player:changeContainerSize(xi.inv.WARDROBE3, -80)
    player:changeContainerSize(xi.inv.WARDROBE4, -80)
    player:changeContainerSize(xi.inv.WARDROBE5, -80)
    player:changeContainerSize(xi.inv.WARDROBE6, -80)
    player:changeContainerSize(xi.inv.WARDROBE7, -80)
    player:changeContainerSize(xi.inv.WARDROBE8, -80)
end)

-----------------------------------
-- Hook: Mission Completion
-----------------------------------
m:addOverride('npcUtil.completeMission', function(player, logId, missionId, params)
    local result = super(player, logId, missionId, params)

    if result then
        xi.wardrobeUnlocks.checkAllUnlocks(player)
    end

    return result
end)

-----------------------------------
-- Hook: Quest Completion
-----------------------------------
m:addOverride('npcUtil.completeQuest', function(player, area, quest, params)
    local result = super(player, area, quest, params)

    if result then
        xi.wardrobeUnlocks.checkAllUnlocks(player)
    end

    return result
end)

-----------------------------------
-- Hook: Key Item Obtained
-----------------------------------
m:addOverride('npcUtil.giveKeyItem', function(player, keyItem, msgId)
    local result = super(player, keyItem, msgId)

    if result then
        xi.wardrobeUnlocks.checkAllUnlocks(player)
    end

    return result
end)

-----------------------------------
-- Hook: NM Death
-----------------------------------
m:addOverride('xi.mob.onMobDeathEx', function(mob, player, isKiller, isWeaponSkillKill)
    super(mob, player, isKiller, isWeaponSkillKill)

    if player and mob:isNM() then
        xi.wardrobeUnlocks.checkAllUnlocks(player)
    end
end)

-----------------------------------
-- Hook: Player Level Up
-----------------------------------
m:addOverride('xi.player.onPlayerLevelUp', function(player)
    super(player)

    xi.wardrobeUnlocks.checkAllUnlocks(player)
end)

-----------------------------------
-- Hook: Player Login (check for any missed unlocks)
-----------------------------------
m:addOverride('xi.player.onGameIn', function(player, firstLogin, zoning)
    super(player, firstLogin, zoning)

    -- Check all unlocks silently on login (not when zoning)
    if not zoning then
        xi.wardrobeUnlocks.checkAllUnlocks(player, true)
    end
end)

-----------------------------------
-- Get unlock data (for debugging)
-----------------------------------
xi.wardrobeUnlocks.getUnlockData = function()
    return unlockData
end

-----------------------------------
-- Get all unlock statuses for a player
-- @param player CCharEntity: The player to check
-- @return table: Table of bag statuses with completed and available unlocks
-----------------------------------
xi.wardrobeUnlocks.getUnlockStatuses = function(player)
    local statuses = {}

    for bag, groups in pairs(unlockData) do
        local bagName = bagDisplayNames[bag] or ('Bag ' .. bag)
        local completed = {}
        local available = {}

        for groupIndex, unlocks in ipairs(groups) do
            for unlockIndex, unlock in ipairs(unlocks) do
                local bitPos = unlockIndex - 1
                local received = hasReceivedUnlock(player, bag, groupIndex, bitPos)

                if received then
                    table.insert(completed, { name = unlock.name, slots = unlock.slots })
                else
                    -- Check if they qualify but haven't received it yet
                    local qualifies = evaluateCheck(player, unlock.checkType, unlock.params)
                    if qualifies then
                        table.insert(available, { name = unlock.name, slots = unlock.slots })
                    end
                end
            end
        end

        statuses[bag] =
        {
            name      = bagName,
            completed = completed,
            available = available,
        }
    end

    return statuses
end

return m
