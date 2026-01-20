-----------------------------------
-- NM Kill Tracking Module
-- Tracks Notorious Monster kills using char_vars with bitwise flags
-- Each char_var can track up to 32 NMs (1 bit per NM)
-----------------------------------
local m = Module:new('c_nmKillTracking')

-----------------------------------
-- NM Tracking Table
-- Structure: charvar name -> list of NMs (max 32 per var)
-- Each NM entry: { name = 'Mob_Name', zoneId = xi.zone.ZONE_NAME }
-- Bit position is determined by array index (index 1 = bit 0, etc.)
-----------------------------------
local nmTracking =
{
    -- Base NM tracking entries
    ['NM_Kills_Base'] =
    {
        { name = 'Leaping_Lizzy', zoneId = xi.zone.SOUTH_GUSTABERG },
        { name = 'Valkurm_Emperor', zoneId = xi.zone.VALKURM_DUNES },
    },

    -- Wardrobe Unlock NM Group 1: Sky Gods, Sea Jailers, Proto bosses
    ['WardrobeNM_Group1'] =
    {
        { name = 'Byakko', zoneId = xi.zone.RUAUN_GARDENS },
        { name = 'Genbu', zoneId = xi.zone.RUAUN_GARDENS },
        { name = 'Seiryu', zoneId = xi.zone.RUAUN_GARDENS },
        { name = 'Suzaku', zoneId = xi.zone.RUAUN_GARDENS },
        { name = 'Kirin', zoneId = xi.zone.THE_SHRINE_OF_RUAVITAU },
        { name = 'Jailer_of_Hope', zoneId = xi.zone.ALTAIEU },
        { name = 'Jailer_of_Prudence', zoneId = xi.zone.ALTAIEU },
        { name = 'Jailer_of_Justice', zoneId = xi.zone.ALTAIEU },
        { name = 'Jailer_of_Love', zoneId = xi.zone.ALTAIEU },
        { name = 'Absolute_Virtue', zoneId = xi.zone.ALTAIEU },
        { name = 'Dynamis_Lord', zoneId = xi.zone.DYNAMIS_XARCABARD },
        { name = 'Proto-Omega', zoneId = xi.zone.APOLLYON },
        { name = 'Proto-Ultima', zoneId = xi.zone.TEMENOS },
        { name = 'Ouryu', zoneId = xi.zone.RIVERNE_SITE_A01 },
        { name = 'Bahamut', zoneId = xi.zone.RIVERNE_SITE_B01 },
        { name = 'Tiamat', zoneId = xi.zone.ATTOHWA_CHASM },
        { name = 'Vrtra', zoneId = xi.zone.KING_RANPERRES_TOMB },
        { name = 'Jormungand', zoneId = xi.zone.ULEGUERAND_RANGE },
        { name = 'Yilbegan', zoneId = xi.zone.BATALLIA_DOWNS },
        { name = 'Pandemonium_Warden', zoneId = xi.zone.AYDEEWA_SUBTERRANE },
        { name = 'Krabkatoa', zoneId = xi.zone.EAST_RONFAURE },
        { name = 'Blobdingnag', zoneId = xi.zone.NORTH_GUSTABERG },
        { name = 'Orcus', zoneId = xi.zone.MERIPHATAUD_MOUNTAINS },
        { name = 'Verthandi', zoneId = xi.zone.BATALLIA_DOWNS },
        { name = 'Lord_Ruthven', zoneId = xi.zone.BEAUCEDINE_GLACIER },
        { name = 'Dawon', zoneId = xi.zone.KONSCHTAT_HIGHLANDS },
        { name = 'Tinnin', zoneId = xi.zone.WAJAOM_WOODLANDS },
        { name = 'Sarameya', zoneId = xi.zone.MOUNT_ZHAYOLM },
        { name = 'Tyger', zoneId = xi.zone.CAEDARVA_MIRE },
        { name = 'Armored_Chariot', zoneId = xi.zone.ARRAPAGO_REMNANTS },
        { name = 'Long-Bowed_Chariot', zoneId = xi.zone.BHAFLAU_REMNANTS },
        { name = 'Long-Armed_Chariot', zoneId = xi.zone.SILVER_SEA_REMNANTS },
    },

    -- Wardrobe Unlock NM Group 2: Chariots, HNMs, World NMs
    ['WardrobeNM_Group2'] =
    {
        { name = 'Battleclad_Chariot', zoneId = xi.zone.ZHAYOLM_REMNANTS },
        { name = 'Fafnir', zoneId = xi.zone.DRAGONS_AERY },
        { name = 'Nidhogg', zoneId = xi.zone.DRAGONS_AERY },
        { name = 'Adamantoise', zoneId = xi.zone.VALLEY_OF_SORROWS },
        { name = 'Aspidochelone', zoneId = xi.zone.VALLEY_OF_SORROWS },
        { name = 'Behemoth', zoneId = xi.zone.BEHEMOTHS_DOMINION },
        { name = 'King_Behemoth', zoneId = xi.zone.BEHEMOTHS_DOMINION },
        { name = 'Maighdean_Uaine', zoneId = xi.zone.NORTH_GUSTABERG },
        { name = 'Carnero', zoneId = xi.zone.SOUTH_GUSTABERG },
        { name = 'Geyser_Lizard', zoneId = xi.zone.DANGRUF_WADI },
        { name = 'BuGhi_Howlblade', zoneId = xi.zone.PALBOROUGH_MINES },
        { name = 'Ghillie_Dhu', zoneId = xi.zone.KONSCHTAT_HIGHLANDS },
        { name = 'Toxic_Tamlyn', zoneId = xi.zone.PASHHOW_MARSHLANDS },
        { name = 'DaDha_Hundredmask', zoneId = xi.zone.BEADEAUX },
        { name = 'Ravenous_Crawler', zoneId = xi.zone.ROLANBERRY_FIELDS },
        { name = 'Golden_Bat', zoneId = xi.zone.VALKURM_DUNES },
        { name = 'Fungus_Beetle', zoneId = xi.zone.WEST_RONFAURE },
        { name = 'Thousandarm_Deshglesh', zoneId = xi.zone.GHELSBA_OUTPOST },
        { name = 'Bigmouth_Billy', zoneId = xi.zone.EAST_RONFAURE },
        { name = 'Gwyllgi', zoneId = xi.zone.KING_RANPERRES_TOMB },
        { name = 'Agar_Agar', zoneId = xi.zone.ORDELLES_CAVES },
        { name = 'Nihniknoovi', zoneId = xi.zone.LA_THEINE_PLATEAU },
        { name = 'Sappy_Sycamore', zoneId = xi.zone.JUGNER_FOREST },
        { name = 'Tempest_Tigon', zoneId = xi.zone.CARPENTERS_LANDING },
        { name = 'Blubbery_Bulge', zoneId = xi.zone.DAVOI },
        { name = 'Eyegouger', zoneId = xi.zone.BATALLIA_DOWNS },
        { name = 'Sharp-Eared_Ropipi', zoneId = xi.zone.EAST_SARUTABARUTA },
        { name = 'Cwn_Cyrff', zoneId = xi.zone.THE_ELDIEME_NECROPOLIS },
        { name = 'Tom_Tit_Tat', zoneId = xi.zone.WEST_SARUTABARUTA },
        { name = 'Vuu_Puqu_the_Beguiler', zoneId = xi.zone.GIDDEUS },
        { name = 'Desmodont', zoneId = xi.zone.OUTER_HORUTOTO_RUINS },
        { name = 'Serpopard_Ishtar', zoneId = xi.zone.TAHRONGI_CANYON },
    },

    -- Wardrobe Unlock NM Group 3: More NMs
    ['WardrobeNM_Group3'] =
    {
        { name = 'Buburimboo', zoneId = xi.zone.BUBURIMU_PENINSULA },
        { name = 'Trembler_Tabitha', zoneId = xi.zone.MAZE_OF_SHAKHRAMI },
        { name = 'Shankha', zoneId = xi.zone.BIBIKI_BAY },
        { name = 'Naa_Zeku_the_Unwaiting', zoneId = xi.zone.MERIPHATAUD_MOUNTAINS },
        { name = 'Blighting_Brand', zoneId = xi.zone.SAUROMUGUE_CHAMPAIGN },
        { name = 'Gloom_Eye', zoneId = xi.zone.RANGUEMONT_PASS },
        { name = 'Kirata', zoneId = xi.zone.BEAUCEDINE_GLACIER },
        { name = 'Mind_Hoarder', zoneId = xi.zone.FEIYIN },
        { name = 'Barbaric_Weapon', zoneId = xi.zone.XARCABARD },
        { name = 'Dark_Spark', zoneId = xi.zone.CASTLE_ZVAHL_BAILEYS },
        { name = 'Trickster_Kinetix', zoneId = xi.zone.QUFIM_ISLAND },
        { name = 'Rhoitos', zoneId = xi.zone.MIDDLE_DELKFUTTS_TOWER },
        { name = 'Qull_the_Shellbuster', zoneId = xi.zone.SEA_SERPENT_GROTTO },
        { name = 'Hoar-knuckled_Rimberry', zoneId = xi.zone.YHOATOR_JUNGLE },
        { name = 'Tonberry_Kinq', zoneId = xi.zone.TEMPLE_OF_UGGALEPIH },
        { name = 'Tawny-fingered_Mugberry', zoneId = xi.zone.DEN_OF_RANCOR },
        { name = 'Falcatus_Aranei', zoneId = xi.zone.KORROLOKA_TUNNEL },
        { name = 'Celphie', zoneId = xi.zone.WESTERN_ALTEPA_DESERT },
        { name = 'Cancer', zoneId = xi.zone.KUFTAL_TUNNEL },
        { name = 'Sabotender_Mariachi', zoneId = xi.zone.KUFTAL_TUNNEL },
        { name = 'Tribunus_VII-I', zoneId = xi.zone.QUICKSAND_CAVES },
        { name = 'Keeper_of_Halidom', zoneId = xi.zone.THE_SANCTUARY_OF_ZITAH },
        { name = 'Rogue_Receptacle', zoneId = xi.zone.ROMAEVE },
        { name = 'Shii', zoneId = xi.zone.BOSTAUNIEUX_OUBLIETTE },
        { name = 'Unut', zoneId = xi.zone.THE_BOYAHDA_TREE },
        { name = 'Nis_Puk', zoneId = xi.zone.BHAFLAU_THICKETS },
        { name = 'Mahishasura', zoneId = xi.zone.BHAFLAU_THICKETS },
        { name = 'Firedance_Magmaal_Ja', zoneId = xi.zone.MAMOOK },
        { name = 'Fahrafahr_the_Bloodied', zoneId = xi.zone.MOUNT_ZHAYOLM },
        { name = 'Cookieduster_Lipiroon', zoneId = xi.zone.ALZADAAL_UNDERSEA_RUINS },
        { name = 'Centipedal_Centruroides', zoneId = xi.zone.MERIPHATAUD_MOUNTAINS_S },
    },

    -- Wardrobe Unlock NM Group 4: Additional NMs
    ['WardrobeNM_Group4'] =
    {
        { name = 'Delicieuse_Delphine', zoneId = xi.zone.ROLANBERRY_FIELDS_S },
        { name = 'Sugaar', zoneId = xi.zone.PASHHOW_MARSHLANDS_S },
        { name = 'Kotan-kor_Kamuy', zoneId = xi.zone.GRAUBERG_S },
        { name = 'Voirloup', zoneId = xi.zone.JUGNER_FOREST_S },
        { name = 'GrandGoule', zoneId = xi.zone.BEAUCEDINE_GLACIER_S },
        { name = 'Prince_Orobas', zoneId = xi.zone.XARCABARD_S },
        { name = 'Ambusher_Antlion', zoneId = xi.zone.ATTOHWA_CHASM },
        { name = 'Goblin_Collector', zoneId = xi.zone.NEWTON_MOVALPOLOS },
        { name = 'Bomb_Queen', zoneId = xi.zone.IFRITS_CAULDRON },
        { name = 'Kurrea', zoneId = xi.zone.LUFAISE_MEADOWS },
        { name = 'Gration', zoneId = xi.zone.MISAREAUX_COAST },
        { name = 'Ungur', zoneId = xi.zone.GUSTAV_TUNNEL },
        { name = 'Flammeri', zoneId = xi.zone.HALVUNG },
        { name = 'Oupire', zoneId = xi.zone.ALZADAAL_UNDERSEA_RUINS },
    },
}

-----------------------------------
-- Helper: Find NM in tracking table
-- @param mobName string: The mob's internal name
-- @param zoneId number: The zone ID (xi.zone.*)
-- @return charVarName string|nil, bitPos number|nil
-----------------------------------
local function findTrackedNM(mobName, zoneId)
    for charVarName, nmList in pairs(nmTracking) do
        for bitPos, nmData in ipairs(nmList) do
            if nmData.name == mobName and nmData.zoneId == zoneId then
                return charVarName, bitPos - 1 -- 0-indexed bit position
            end
        end
    end

    return nil, nil
end

-----------------------------------
-- Helper: Track kill for a single player
-- @param player CCharEntity: The player to track the kill for
-- @param charVarName string: The char_var name to use
-- @param bitPos number: The bit position (0-indexed)
-- @param mobName string: The mob name for display
-----------------------------------
local function trackKillForPlayer(player, charVarName, bitPos, mobName)
    local currentVar = player:getCharVar(charVarName)

    if not utils.mask.getBit(currentVar, bitPos) then
        local newVar = utils.mask.setBit(currentVar, bitPos, true)
        player:setCharVar(charVarName, newVar)

        -- Notify player of new kill tracked
        local displayName = string.gsub(mobName, '_', ' ')
        player:printToPlayer(
            string.format('NM kill tracked: %s', displayName),
            xi.msg.channel.SYSTEM_3
        )
    end
end

-----------------------------------
-- Hook into mob death to track NM kills
-----------------------------------
m:addOverride('xi.mob.onMobDeathEx', function(mob, player, isKiller, isWeaponSkillKill)
    super(mob, player, isKiller, isWeaponSkillKill)

    -- Only process if there's a valid player and mob is NM
    if player == nil or not mob:isNM() then
        return
    end

    local mobName = mob:getName()
    local zoneId = mob:getZoneID()

    -- Check if this NM is tracked
    local charVarName, bitPos = findTrackedNM(mobName, zoneId)
    if charVarName == nil then
        return
    end

    -- Track the kill for this player
    -- Note: onMobDeathEx is already called once per alliance member by the core
    trackKillForPlayer(player, charVarName, bitPos, mobName)
end)

-----------------------------------
-- Public API (optional helper functions)
-----------------------------------
xi = xi or {}
xi.nmTracking = xi.nmTracking or {}

-----------------------------------
-- Get the NM tracking table (for external use)
-- @return table: The nmTracking table
-----------------------------------
xi.nmTracking.getTrackingTable = function()
    return nmTracking
end

-----------------------------------
-- Count how many NMs have been killed in a group
-- @param player CCharEntity: The player to check
-- @param charVarName string: The char_var group name
-- @return number: Count of killed NMs in the group
-----------------------------------
xi.nmTracking.getKillCount = function(player, charVarName)
    if not nmTracking[charVarName] then
        return 0
    end

    local mask = player:getCharVar(charVarName)
    return utils.mask.countBits(mask, #nmTracking[charVarName])
end

-----------------------------------
-- Check if all NMs in a group have been killed
-- @param player CCharEntity: The player to check
-- @param charVarName string: The char_var group name
-- @return boolean: True if all NMs in group are killed
-----------------------------------
xi.nmTracking.hasKilledAll = function(player, charVarName)
    if not nmTracking[charVarName] then
        return false
    end

    local mask = player:getCharVar(charVarName)
    return utils.mask.isFull(mask, #nmTracking[charVarName])
end

-----------------------------------
-- Check if a specific NM has been killed
-- @param player CCharEntity: The player to check
-- @param mobName string: The mob's internal name
-- @param zoneId number: The zone ID (optional, for exact matching)
-- @return boolean: True if the NM has been killed
-----------------------------------
xi.nmTracking.hasKilledNM = function(player, mobName, zoneId)
    -- If zoneId not provided, search all groups for the mob name
    if zoneId == nil then
        for charVarName, nmList in pairs(nmTracking) do
            for bitPos, nmData in ipairs(nmList) do
                if nmData.name == mobName then
                    if utils.mask.getBit(player:getCharVar(charVarName), bitPos - 1) then
                        return true
                    end
                end
            end
        end

        return false
    end

    local charVarName, bitPos = findTrackedNM(mobName, zoneId)
    if charVarName == nil then
        return false
    end

    return utils.mask.getBit(player:getCharVar(charVarName), bitPos)
end

-----------------------------------
-- Check if NM is marked as not coded (placeholder)
-- @param mobName string: The mob's internal name
-- @return boolean: True if NM is not coded
-----------------------------------
xi.nmTracking.isNMNotCoded = function(mobName)
    for _, nmList in pairs(nmTracking) do
        for _, nmData in ipairs(nmList) do
            if nmData.name == mobName and nmData.notCoded then
                return true
            end
        end
    end

    return false
end

return m
