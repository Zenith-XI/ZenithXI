-- -----------------------------------
-- -- HNM Respawn Windows Module
-- --
-- -- This module overrides the respawn times for specific NMs to have:
-- -- - Respawn time: 21 hours to 21.5 hours (75600 to 77400 seconds)
-- -- - Spawn window: 5 minutes (300 seconds)
-- -- - Respawn time: 71 hours to 72 hours (255600 to 259200 seconds)
-- -- - Spawn window: 10 minutes (600 seconds)
-- -----------------------------------

require('modules/module_utils')
local m = Module:new('hnm_respawn_windows_21hr')

-- List of NMs to modify respawn times for
-- Format: { zone_name, mob_name, respawn_hours, spawn_window_minutes }
local nmsToModify = {
    { 'Arrapago_Reef', 'Medusa', 71, 10 },
    { 'Attohwa_Chasm', 'Tiamat', 71, 10 },
    { 'Attohwa_Chasm', 'Xolotl', 21, 5 },
    { 'Bostaunieux_Oubliette', 'Bloodsucker_NM', 21, 5 },
    { 'Caedarva_Mire', 'Khimaira', 71, 10 },
    { 'Cape_Teriggan', 'Kreutzet', 9, 30 },
    { 'Castle_Zvahl_Baileys', 'Duke_Haborym', 21, 5 },
    { 'Castle_Zvahl_Baileys', 'Grand_Duke_Batym', 21, 5 },
    { 'Castle_Zvahl_Baileys', 'Marquis_Allocen', 21, 5 },
    { 'Castle_Zvahl_Baileys', 'Marquis_Amon', 21, 5 },
    { 'FeiYin', 'Capricious_Cassie', 21, 5 },
    { 'Garlaige_Citadel', 'Serket', 21, 5 },
    { 'Garlaige_Citadel', 'Skewer_Sam', 21, 5 },
    { 'Gusgen_Mines', 'Juggler_Hecatomb', 21, 5 },
    { 'Gustav_Tunnel', 'Bune', 21, 5 },
    { 'Halvung', 'Gurfurlur_the_Menacing', 71, 10 },
    { 'Ifrits_Cauldron', 'Ash_Dragon', 21, 5 },
    { 'King_Ranperres_Tomb', 'Vrtra', 71, 10 },
    { 'Mamook', 'Gulool_Ja_Ja', 71, 10 },
    { 'Meriphataud_Mountains', 'Waraxe_Beak', 21, 5 },
    { 'Misareaux_Coast', 'Upyri', 21, 5 },
    { 'Mount_Zhayolm', 'Cerberus', 71, 10 },
    { 'Ordelles_Caves', 'Morbolger', 21, 5 },
    { 'Palborough_Mines', 'NoMho_Crimsonarmor', 21, 5 },
    { 'Qufim_Island', 'Dosetsu_Tree', 21, 5 },
    { 'Quicksand_Caves', 'Antican_Consul', 21, 5 },
    { 'Riverne-Site_B01', 'Boroka', 21, 5 },
    { 'Rolanberry_Fields', 'Simurgh', 21, 5 },
    { 'RoMaeve', 'Shikigami_Weapon', 21, 5 },
    { 'Sauromugue_Champaign', 'Roc', 21, 5 },
    { 'Sea_Serpent_Grotto', 'Ocean_Sahagin', 21, 5 },
    { 'The_Boyahda_Tree', 'Ancient_Goobbue', 21, 5 },
    { 'Toraimarai_Canal', 'Oni_Carcass', 21, 5 },
    { 'Uleguerand_Range', 'Jormungand', 71, 10 },
    { 'Wajaom_Woodlands', 'Hydra', 71, 10 },
    { 'Western_Altepa_Desert', 'King_Vinegarroon', 21, 5 },
    { 'Xarcabard', 'Ereshkigal', 21, 5 },
    { 'Yhoator_Jungle', 'Bright-handed_Kunberry', 21, 5 },
    { 'Yhoator_Jungle', 'Woodland_Sage', 21, 5 },
}

-- Beastmen NQ/HQ NM configuration
local beastmenNMs = {
    {
        zone = 'Monastic_Cavern',
        zoneId = 'MONASTIC_CAVERN',
        nqName = 'Orcish_Overlord',
        nqIdName = 'ORCISH_OVERLORD',
        hqName = 'Overlord_Bakgodek',
        hqOffset = 1,
        popVar = '[POP]Overlord_Bakgodek',
        phVar = '[PH]Overlord_Bakgodek',
        respawnHours = 21,
        respawnWindowLengthDuration = 5
    },
    {
        zone = 'Castle_Oztroja',
        zoneId = 'CASTLE_OZTROJA',
        nqName = 'Yagudo_Avatar',
        nqIdName = 'YAGUDO_AVATAR',
        hqName = 'Tzee_Xicu_the_Manifest',
        hqOffset = 3, -- Different offset due to elementals
        popVar = '[POP]Tzee_Xicu_the_Manifest',
        phVar = '[PH]Tzee_Xicu_the_Manifest',
        respawnHours = 21,
        respawnWindowLengthDuration = 5
    },
    {
        zone = 'Qulun_Dome',
        zoneId = 'QULUN_DOME',
        nqName = 'Diamond_Quadav',
        nqIdName = 'DIAMOND_QUADAV',
        hqName = 'ZaDha_Adamantking',
        hqOffset = 1,
        popVar = '[POP]Za_Dha_Adamantking',
        phVar = '[PH]Za_Dha_Adamantking',
        respawnHours = 21,
        respawnWindowLengthDuration = 5
    }
}

----------------------------------- HELPER FUNCTIONS -----------------------------------

-- Helper function to set respawn time and persist it
local function setAndPersistRespawnTime(mob, respawnTimeCalc)
    if mob then
        local mobName = mob:getName()
        local id = mob:getID()
        local varName = '[Respawn]'..mobName..'_'..id

        mob:setRespawnTime(respawnTimeCalc)
        SetServerVariable(varName, os.time() + respawnTimeCalc)
    end
end

-- Generic function to restore or set mob respawn time on zone init
local function restoreOrSetRespawnTime(mobId, respawnTimeCalc)
    local mob = GetMobByID(mobId)

    if mob then
        local mobName = mob:getName()
        local varName = '[Respawn]'..mobName..'_'..mobId
        local savedRespawnTime = GetServerVariable(varName)
        local currentTime = os.time()

        -- Check if we have a valid saved respawn time (not 0 and not nil)
        if savedRespawnTime and savedRespawnTime > 0 then
            -- If saved respawn time is greater than current time, restore it
            if savedRespawnTime > currentTime then
                GetMobByID(mobId):setRespawnTime(savedRespawnTime - currentTime)
            elseif
                mobName == 'Kreutzet' or
                mobName == 'King_Vinegarroon'
            then
                -- Special case for Kreutzet and KV, to ensure they don't respawn with no weather
                -- Disallow respawn, this will get set to false if the weather is correct
                DisallowRespawn(mobId, true)
                mob:setRespawnTime(10)
            -- If saved respawn time has passed, check if mob is already spawned if not spawn it
            else
                if not mob:isSpawned() then
                    SpawnMob(mobId)
                end
            end
        else
            -- No valid saved respawn time found, set a new one
            local newRespawnTime = respawnTimeCalc
            GetMobByID(mobId):setRespawnTime(newRespawnTime)
            SetServerVariable(varName, os.time() + newRespawnTime)
        end
    end
end

-- Restore or set respawn on a contiguous group of mobs
-- startId         = first mob ID
-- count           = how many sequential IDs
-- namePrefix      = base name used in ServerVariable key
-- respawnTimeCalc = respawn calculation in seconds
-- skipOffset      = (optional) offset within [0..count] to skip
local function restoreGroup(startId, count, respawnTimeCalc, skipOffset)
    for offset = 0, count - 1 do
        if offset ~= skipOffset then
            local id = startId + offset
            restoreOrSetRespawnTime(id, respawnTimeCalc)
        end
    end
end

----------------------------------- STANDARD NM LOGIC -----------------------------------

-- Generic function to create standard NM overrides
local function createStandardNMOverrides(nmList)
    for _, entry in pairs(nmList) do
        local zoneName = entry[1]
        local mobName = entry[2]
        local respawnHours = entry[3]
        local respawnWindowLengthDuration = entry[4]
        local respawnTimeCalc = math.random(0, 6) * (respawnWindowLengthDuration * 60) + (respawnHours * 3600)

        -- Zone initialization override
        m:addOverride(fmt('xi.zones.{}.Zone.onInitialize', zoneName),
        function(zone)
            super(zone)
            local mob = zone:queryEntitiesByName(mobName)[1]
            if mob then
                -- randomly choose 1 of 7 windows, multiply by window length then add respawn hours
                restoreOrSetRespawnTime(mob:getID(), respawnTimeCalc)
            end
        end)

        -- onMobDespawn override
        xi.module.ensureTable(fmt('xi.zones.{}.mobs.{}.onMobDespawn', zoneName, mobName))
        m:addOverride(fmt('xi.zones.{}.mobs.{}.onMobDespawn', zoneName, mobName),
        function(mob)
            super(mob)
            setAndPersistRespawnTime(mob, respawnTimeCalc)
        end)
    end
end

-- Create overrides for standard NMs
createStandardNMOverrides(nmsToModify)

----------------------------------- BEASTMEN NQ/HQ HNM LOGIC -----------------------------------
--decide wether to spawn NQ or HQ version of beastmen NMs
--returns true if the mob was spawned or respawn time was set, false otherwise
local function processNqHqSpawn(primaryId, secondaryId, name, currentTime)
    local varName = '[Respawn]'..name..'_'..primaryId
    local respawn   = GetServerVariable(varName)
    if respawn and respawn > 0 then
        if respawn > currentTime then
            DisallowRespawn(secondaryId, true)
            DisallowRespawn(primaryId,  false)
            GetMobByID(primaryId):setRespawnTime(respawn - currentTime)
        else
            if not GetMobByID(primaryId):isSpawned() then
                SpawnMob(primaryId)
            end
        end

        return true
    end

    return false
end

--- When NQ despawns it either pops HQ or schedules its own respawn.
--- When HQ despawns it resets back to NQ for the next cycle.
local function handleBeastmenDespawn(mob, config)
    local ID = zones[xi.zone[config.zoneId]]

    if mob and ID then
        local mobId = mob:getID()
        local nqId  = ID.mob[config.nqIdName]
        local hqId  = nqId + config.hqOffset
        local calcRespawnTime = function()
            return math.random(0, 6) * (config.respawnWindowLengthDuration * 60) + (config.respawnHours * 3600)
        end

        if mobId == nqId then
            -- PH logic: count kills, decide whether to pop HQ or repop NQ
            local lastPop = GetServerVariable(config.popVar)
            local kills = GetServerVariable(config.phVar) + 1
            local popNow = kills >= 7 or (kills >= 2 and math.random(1, 100) <= 20)
            if
                GetSystemTime() > lastPop and
                popNow
            then
                setAndPersistRespawnTime(GetMobByID(hqId),
                    calcRespawnTime()
                )
            else
                setAndPersistRespawnTime(GetMobByID(nqId),
                    calcRespawnTime()
                )
            end
        elseif mobId == hqId then
            setAndPersistRespawnTime(GetMobByID(nqId),
                calcRespawnTime()
            )
        end
    end
end

-- Create beastmen NM overrides
for _, config in pairs(beastmenNMs) do
    m:addOverride(fmt('xi.zones.{}.Zone.onInitialize', config.zone),
    function(zone)
        local ID = zones[xi.zone[config.zoneId]]
        super(zone)

        local nqId = ID.mob[config.nqIdName]
        local hqId = nqId + config.hqOffset
        local currentTime = os.time()
        -- first attempt NQ, then HQ; if neither has a saved respawn, roll a new NQ time
        if
            not processNqHqSpawn(nqId, hqId, config.nqName, currentTime) and
            not processNqHqSpawn(hqId, nqId, config.hqName, currentTime)
        then
            restoreOrSetRespawnTime(nqId, math.random(0, 6) * (5 * 60) + (21 * 3600))
        end
    end)

    -- NQ/HQ despawn override
    for _, phase in ipairs{ config.nqName, config.hqName } do
        m:addOverride(
            fmt('xi.zones.{}.mobs.{}.onMobDespawn', config.zone, phase),
            function(mob)
                super(mob)
                handleBeastmenDespawn(mob, config)
            end
        )
    end
end

----------------------------------- SPECIAL CASE NMS -----------------------------------

----------------------------------- Argus/Leech King Logic -----------------------------------
local mazeOfShakhramiId = zones[xi.zone.MAZE_OF_SHAKHRAMI]

-- pick one of the two NMs
local function chooseArgusLK()
    if math.random(1, 100) <= 50 then
        return mazeOfShakhramiId.mob.ARGUS
    else
        return mazeOfShakhramiId.mob.LEECH_KING
    end
end

-- common apply logic (either restoring or freshly setting)
local function applyArgusLK(choice, restoreOnly)
    local other = mazeOfShakhramiId.mob.ARGUS
    if choice ~= mazeOfShakhramiId.mob.LEECH_KING then
        choice = mazeOfShakhramiId.mob.ARGUS
        other = mazeOfShakhramiId.mob.LEECH_KING
    end

    DisallowRespawn(other, true)
    DisallowRespawn(choice, false)
    UpdateNMSpawnPoint(choice)
    local spawnTime = math.random(0, 6) * (5 * 60) + (21 * 3600) -- 21 hours, 5 minute windows

    if restoreOnly then
        restoreOrSetRespawnTime(choice, spawnTime)
    else
        setAndPersistRespawnTime(GetMobByID(choice), spawnTime)
        SetServerVariable('[NextSpawn]Argus/LK', choice)
    end
end

m:addOverride('xi.zones.Maze_of_Shakhrami.Zone.onInitialize',
function(zone)
    super(zone)

    local nextSpawn = GetServerVariable('[NextSpawn]Argus/LK')
    -- if never set or corrupted, pick one at random
    if
        nextSpawn ~= mazeOfShakhramiId.mob.ARGUS and
        nextSpawn ~= mazeOfShakhramiId.mob.LEECH_KING
    then
        nextSpawn = chooseArgusLK()
    end

    applyArgusLK(nextSpawn, true)
end)

m:addOverride('xi.zones.Maze_of_Shakhrami.mobs.Argus.onMobDespawn',
function(mob)
    super(mob)
    applyArgusLK(chooseArgusLK(), false)
end)

m:addOverride('xi.zones.Maze_of_Shakhrami.mobs.Leech_King.onMobDespawn',
function(mob)
    super(mob)
    applyArgusLK(chooseArgusLK(), false)
end)

----------------------------------- Carmine Dobsonfly Logic -----------------------------------
local riverneSiteA01Id = zones[xi.zone.RIVERNE_SITE_A01]

m:addOverride('xi.zones.Riverne-Site_A01.Zone.onInitialize',
function(zone)
    super(zone)
    -- passing in respawn time calculation in case no server value for next respawn can be found
    restoreGroup(riverneSiteA01Id.mob.CARMINE_DOBSONFLY_OFFSET, 10, math.random(0, 6) * (5 * 60) + (21 * 3600))
end)

m:addOverride('xi.zones.Riverne-Site_A01.mobs.Carmine_Dobsonfly.onMobDespawn',
function(mob)
    super(mob)

    local respawnTime = math.random(0, 6) * (5 * 60) + (21 * 3600) -- 21 hours, 5 minute windows
    local respawnTimestamp = respawnTime + os.time()
    -- Check if all flies are dead and a new respawn time was set
    -- If yes, set respawn time for all Carmine Dobsonflies to 21 hours, with 5 minute windows
    for i = riverneSiteA01Id.mob.CARMINE_DOBSONFLY_OFFSET, riverneSiteA01Id.mob.CARMINE_DOBSONFLY_OFFSET + 9 do
        if GetMobByID(i):getRespawnTime() > 0 then
            setAndPersistRespawnTime(GetMobByID(i), respawnTimestamp)
        end
    end
end)

----------------------------------- King Arthro Logic -----------------------------------
local jugnerForestId = zones[xi.zone.JUGNER_FOREST]

m:addOverride('xi.zones.Jugner_Forest.Zone.onInitialize',
function(zone)
    super(zone)

    -- 10 Knight Crabs
    restoreGroup(jugnerForestId.mob.KING_ARTHRO - 10, 10, math.random(0, 6) * (5 * 60) + (21 * 3600))
end)

m:addOverride('xi.zones.Jugner_Forest.mobs.King_Arthro.onMobDespawn',
function(mob)
    super(mob)

    local kingArthroID = jugnerForestId.mob.KING_ARTHRO
    local respawnTime = math.random(0, 6) * (5 * 60) + (21 * 3600) -- 21 hours, 5 minute windows
    local respawnTimeStamp = respawnTime + os.time()
    for offset = 1, 10 do
        setAndPersistRespawnTime(GetMobByID(kingArthroID - offset), respawnTimeStamp)
    end
end)

----------------------------------- Weeping Willow/Lumber Jack Logic -----------------------------------
m:addOverride('xi.zones.Batallia_Downs.Zone.onInitialize',
function(zone)
    super(zone)
    local mob = zone:queryEntitiesByName('Weeping_Willow')[1]
    restoreOrSetRespawnTime(mob:getID(), math.random(0, 6) * (5 * 60) + (21 * 3600))
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Weeping_Willow.onMobDespawn',
function(mob)
    super(mob)
    -- Disable respawning logic until Lumber Jack is killed/despawns
    DisallowRespawn(mob:getID(), true)
end)

m:addOverride('xi.zones.Batallia_Downs.mobs.Lumber_Jack.onMobDespawn',
function(mob)
    super(mob)

    local willow = mob:getID() -6
    DisallowRespawn(willow, false) -- Allow Weeping Willow to respawn
    if mob:getLocalVar('death') then
        -- Lumber Jack died, Set Weeping Willow's respawn time (21 hours, 5 minute windows)
        setAndPersistRespawnTime(GetMobByID(willow), math.random(0, 6) * (5 * 60) + (21 * 3600)) -- 21 hours 5 minute windows
    else
        -- Lumber Jack despawned without dying, reset Weeping Willow's respawn time to 30 minutes
        setAndPersistRespawnTime(GetMobByID(willow), 1800) -- 30 minutes
    end
end)

----------------------------------- Cherry Saplings/Cemetery Cherry Logic -----------------------------------
local kingRanperresTombId = zones[xi.zone.KING_RANPERRES_TOMB]

m:addOverride('xi.zones.King_Ranperres_Tomb.Zone.onInitialize',
function(zone)
    super(zone)
    -- 8 saplings, skip the cemetery cherry at offset 6
    restoreGroup(kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET, 9, math.random(0, 6) * (5 * 60) + (21 * 3600), 6)
end)

-- Add sapling despawn logic to check if all are dead
m:addOverride('xi.zones.King_Ranperres_Tomb.mobs.Cherry_Sapling.onMobDeath',
function(mob)
    super(mob)
    local cemeteryCherry = GetMobByID(kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET + 6) -- Cemetery Cherry

    -- If Cemetery Cherry is alive, disallow respawn for all saplings.
    if cemeteryCherry:isAlive() then
        for i = kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET, kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET + 8 do
            if i ~= kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET + 6 then -- Skip Cemetery Cherry
                DisallowRespawn(i, true)
            end
        end
    end
end)

m:addOverride('xi.zones.King_Ranperres_Tomb.mobs.Cemetery_Cherry.onMobDespawn',
function(mob)
    super(mob)
    for i = kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET, kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET + 8 do
        if i ~= kingRanperresTombId.mob.CHERRY_SAPLING_OFFSET + 6 then -- Skip Cemetery Cherry
            local sapling = GetMobByID(i)
            DisallowRespawn(i, false)
            if mob:getLocalVar('wasKilled') == 1 then
                setAndPersistRespawnTime(sapling, math.random(0, 6) * (10 * 60) + (71 * 3600)) -- 71 hours, 10 minute windows
            else
                setAndPersistRespawnTime(sapling, sapling:getRespawnTime())
            end
        end
    end
end)

----------------------------------- Padfoot Logic -----------------------------------
local lufaiseMeadowsId = zones[xi.zone.LUFAISE_MEADOWS]

m:addOverride('xi.zones.Lufaise_Meadows.Zone.onInitialize',
function(zone)
    super(zone)
    local respawnTime = math.random(0, 6) * (5 * 60) + (21 * 3600)
    for _, v in pairs(lufaiseMeadowsId.mob.PADFOOT) do
        local padfoot = GetMobByID(v)
        if padfoot then
            restoreOrSetRespawnTime(padfoot:getID(), respawnTime)
        end
    end
end)

m:addOverride('xi.zones.Lufaise_Meadows.mobs.Padfoot.onMobDespawn',
function(mob)
    super(mob)
    local mobId = mob:getID()

    if mobId == lufaiseMeadowsId.mob.PADFOOT[GetServerVariable('realPadfoot')] then
        local respawn = math.random(0, 6) * (5 * 60) + (21 * 3600) -- 21 hours, 5 minute windows

        for _, v in pairs(lufaiseMeadowsId.mob.PADFOOT) do
            setAndPersistRespawnTime(GetMobByID(v), respawn)
        end
    end
end)

return m
