-----------------------------------
-- Mog Pell Rewards Override
-- Replaces festive moogle pell rewards
-- Uses custom menus for full control
-----------------------------------

local m = Module:new('c_mogPellRewards')

-----------------------------------
-- Pell names for menu titles
-----------------------------------
local pellNames =
{
    [xi.item.GOLD_MOG_PELL] = 'Gold Mog Pell',
    [xi.item.RED_MOG_PELL] = 'Red Mog Pell',
    [xi.item.GREEN_MOG_PELL] = 'Green Mog Pell',
    [xi.item.OCHRE_MOG_PELL] = 'Ochre Mog Pell',
    [xi.item.MARBLE_MOG_PELL] = 'Marble Mog Pell',
    [xi.item.RAINBOW_MOG_PELL] = 'Rainbow Mog Pell',
    [xi.item.SILVER_MOG_PELL] = 'Silver Mog Pell',
}

-----------------------------------
-- Level-gated items (require level 50+)
-----------------------------------
local levelGatedItems =
{
    [xi.item.CIPHER_OF_A_MOOGLES_ALTER_EGO] = 50,
    [xi.item.CIPHER_OF_STAR_SIBYLS_ALTER_EGO] = 50,
    [xi.item.CIPHER_OF_KUYINS_ALTER_EGO] = 50,
    [xi.item.CIPHER_OF_BRYGIDS_ALTER_EGO] = 50,
}

-----------------------------------
-- Reward items organized by pell type
-- Each entry: { itemId, quantity }
-----------------------------------
local rewardItems =
{
    [xi.item.GREEN_MOG_PELL] =
    {
        { xi.item.GOBLIN_SUIT, 1 },
        { xi.item.GREEN_MOOGLE_SUIT, 1 },
        { xi.item.GOBLIN_MASQUE, 1 },
        { xi.item.GREEN_MOOGLE_MASQUE, 1 },
        { xi.item.MORBOL_CAP, 1 },
        { xi.item.MORBOL_SHIELD, 1 },
        { xi.item.CAIT_SITH_GUARD, 1 },
        { xi.item.CAIT_SITH_CAP, 1 },
        { xi.item.ALLIANCE_SHIRT, 1 },
        { xi.item.ALLIANCE_PANTS, 1 },
        { xi.item.ALLIANCE_BOOTS, 1 },
        { xi.item.WORM_FEELERS, 1 },
        { xi.item.WORM_MASQUE, 1 },
        { xi.item.KYUKA_UCHIWA, 1 },
        { xi.item.CHOCOBO_MASQUE, 1 },
        { xi.item.CHOCOBO_SUIT, 1 },
        { xi.item.BOMB_MASQUE, 1 },
        { xi.item.PUPILS_SHIRT, 1 },
        { xi.item.PUPILS_TROUSERS, 1 },
        { xi.item.PUPILS_SHOES, 1 },
        { xi.item.PUPILS_CAMISA, 1 },
        { xi.item.LYCOPODIUM_MASQUE, 1 },
        { xi.item.LEAFKIN_CAP, 1 },
        { xi.item.SHEEP_CAP, 1 },
        { xi.item.HEARTBEATER, 1 },
        { xi.item.POROGGO_COAT, 1 },
        { xi.item.RARAB_CAP, 1 },
        { xi.item.KAKAI_CAP, 1 },
        { xi.item.CRAB_CAP, 1 },
        { xi.item.SANDOGASA, 1 },
        { xi.item.TRACK_SHIRT, 1 },
        { xi.item.TRACK_PANTS, 1 },
        { xi.item.ARK_TACHI, 1 },
        { xi.item.ARK_SABER, 1 },
        { xi.item.ARK_SCYTHE, 1 },
        { xi.item.ARK_TABAR, 1 },
        { xi.item.ARK_SWORD, 1 },
    },

    [xi.item.RAINBOW_MOG_PELL] =
    {
        { xi.item.SEIKA_UCHIWA, 1 },
        { xi.item.FIRETONGUE, 1 },
        { xi.item.LOST_SICKLE, 1 },
        { xi.item.WIND_KNIFE, 1 },
        { xi.item.ARTEMISS_BOW, 1 },
        { xi.item.PURPLE_SPRIGGAN_CLUB, 1 },
        { xi.item.TROTH, 1 },
        { xi.item.ARTHROS_CAP, 1 },
        { xi.item.WHITE_RARAB_CAP, 1 },
        { xi.item.SNOLL_MASQUE, 1 },
        { xi.item.KORRIGAN_MASQUE, 1 },
        { xi.item.KORRIGAN_SUIT, 1 },
        { xi.item.ADENIUM_MASQUE, 1 },
        { xi.item.ADENIUM_SUIT, 1 },
        { xi.item.POROGGO_FLEECE, 1 },
        { xi.item.PURPLE_SPRIGGAN_COAT, 1 },
        { xi.item.MITHKABOB_SHIRT, 1 },
        { xi.item.PRETTY_PINK_SUBLIGAR, 1 },
        { xi.item.NOMAD_MOOGLE_ROD, 1 },
        { xi.item.NOMAD_CAP, 1 },
        { xi.item.NOMAD_MOOGLE_SHIELD, 1 },
        { xi.item.CHOCOBO_BERET, 1 },
        { xi.item.MAESTROS_BATON, 1 },
        { xi.item.MOOGLE_MASQUE, 1 },
        { xi.item.MOOGLE_SUIT, 1 },
        { xi.item.SHELL_SCEPTER, 1 },
        { xi.item.GOBBIE_GAVEL, 1 },
        { xi.item.MELOMANE_MALLET, 1 },
        { xi.item.DECAZOOM_MK_XI, 1 },
        { xi.item.ESCRITORIO, 1 },
        { xi.item.HARPSICHORD, 1 },
        { xi.item.STUFFED_CHOCOBO, 1 },
        { xi.item.SPINET, 1 },
        { xi.item.NANAA_MIHGO_STATUE, 1 },
        { xi.item.NANAA_MIHGO_STATUE_II, 1 },
        -- { xi.item.LEAFKIN_BED, 1 }, -- Doesn't exist in DB
    },

    [xi.item.SILVER_MOG_PELL] =
    {
        { xi.item.BEASTMENS_SEAL, 20 },
        { xi.item.KINDREDS_SEAL, 20 },
        { xi.item.BLIZZARD_BRAND, 1 },
        { xi.item.DIAMOND_BUCKLER, 1 },
        { xi.item.SILVER_GUN, 1 },
        { xi.item.POROGGO_CASSOCK, 1 },
        { xi.item.ROLANBERRY_DELIGHTARU, 1 },
        { xi.item.HARVEST_PASTRY, 1 },
        { xi.item.CHERRY_TREE, 1 },
        { xi.item.FAR_EAST_HEARTH, 1 },
        { xi.item.POT_OF_WARDS, 1 },
        { xi.item.POT_OF_WHITE_CLEMATIS, 1 },
        { xi.item.POT_OF_PINK_CLEMATIS, 1 },
        { xi.item.BIRCH_TREE, 1 },
        { xi.item.CRIMSON_CHEST, 1 },
        { xi.item.AUTUMN_TREE, 1 },
        { xi.item.ADOULINIAN_TOMATOES, 1 },
        { xi.item.CHOCOBO_COMMODE, 1 },
        { xi.item.MANDRAGORA_POT, 1 },
        -- { xi.item.CHEMISTRY_SET, 1 }, -- Doesnt Exist in DB
        { xi.item.ASTRAL_CUBE, 1 },
        -- { xi.item.CHOCOBO_CHAIR_II, 1 }, --Doesnt Exist in DB
        -- { xi.item.COLIBRI_BED, 1 }, --Doesnt Exist in DB
        -- { xi.item.BLUEBLADE_FELL, 1 }, --Doesnt Exist in DB
    },

    [xi.item.RED_MOG_PELL] =
    {
        { xi.item.BEASTMENS_SEAL, 10 },
        { xi.item.KINDREDS_SEAL, 10 },
        { xi.item.ZANMATO, 1 },
        { xi.item.MOOGLE_ROD, 1 },
        { xi.item.CHOCOBO_WAND, 1 },
        { xi.item.TOWN_MOOGLE_SHIELD, 1 },
        { xi.item.EXCALIPOOR, 1 },
        { xi.item.SHA_WUJINGS_LANCE, 1 },
        { xi.item.MUTSUNOKAMI, 1 },
        { xi.item.FELINE_HAGOITA, 1 },
        { xi.item.FANCY_GILET, 1 },
        { xi.item.FANCY_TRUNKS, 1 },
        { xi.item.FANCY_TOP, 1 },
        { xi.item.FANCY_SHORTS, 1 },
        { xi.item.MOOGLE_BED, 1 },
        { xi.item.CANCRINE_APRON, 1 },
        { xi.item.KNIT_CAP, 1 },
        { xi.item.CIPHER_OF_ZEIDS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_ALDOS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_A_MOOGLES_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_FABLINIXS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_STAR_SIBYLS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_UKAS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_KUYINS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_BRYGIDS_ALTER_EGO, 1 },
        { xi.item.CIPHER_OF_MILDAURIONS_ALTER_EGO, 1 },
    },

    [xi.item.MARBLE_MOG_PELL] =
    {
        { xi.item.ADAMANTOISE_STATUE, 1 },
        { xi.item.ATOMOS_STATUE, 1 },
        { xi.item.ALEXANDER_STATUE, 1 },
        { xi.item.ODIN_STATUE, 1 },
        { xi.item.CARDIAN_STATUE, 1 },
        { xi.item.GOOBBUE_STATUE, 1 },
        { xi.item.LAMB_CARVING, 1 },
        { xi.item.POLISHED_LAMB_CARVING, 1 },
        { xi.item.ARK_ANGEL_EV_STATUE, 1 },
        { xi.item.ARK_ANGEL_GK_STATUE, 1 },
        { xi.item.ARK_ANGEL_HM_STATUE, 1 },
        { xi.item.ARK_ANGEL_MR_STATUE, 1 },
        { xi.item.ARK_ANGEL_TT_STATUE, 1 },
        { xi.item.NOMAD_MOOGLE_STATUE, 1 },
        { xi.item.FAFNIR_STATUE, 1 },
        { xi.item.PRISHE_STATUE, 1 },
        { xi.item.BEHEMOTH_STATUE, 1 },
        { xi.item.SHADOW_LORD_STATUE, 1 },
        { xi.item.SHADOW_LORD_STATUE_II, 1 },
        { xi.item.SHADOW_LORD_STATUE_III, 1 },
        { xi.item.YOVRA_REPLICA, 1 },
        { xi.item.LION_STATUE, 1 },
        { xi.item.APHMAU_STATUE, 1 },
        { xi.item.LILISETTE_STATUE, 1 },
        { xi.item.ARCIELA_STATUE, 1 },
        { xi.item.IROHA_STATUE, 1 },
        { xi.item.PRISHE_STATUE_II, 1 },
        { xi.item.UKA_STATUE, 1 },
    },
}

-----------------------------------
-- Items per page in custom menu
-----------------------------------
local itemsPerPage = 4
local maxNameLength = 20

-----------------------------------
-- Helper function to format item name (Title Case)
-----------------------------------
local function formatItemName(name)
    local formatted = name:gsub('_', ' ')

    formatted = formatted:gsub('(%a)([%w]*)', function(first, rest)
        return first:upper() .. rest:lower()
    end)

    -- Abbreviate common long prefixes
    formatted = formatted:gsub('^Cipher Of ', 'Ciph. ')

    return formatted
end

-----------------------------------
-- Helper function to get item display name
-----------------------------------
local function getItemDisplayName(itemId, quantity)
    local itemObj = GetItemByID(itemId)
    if itemObj then
        local name = formatItemName(itemObj:getName())

        if #name > maxNameLength then
            name = name:sub(1, maxNameLength - 2) .. '..'
        end

        if quantity > 1 then
            return string.format('%s x%d', name, quantity)
        end

        return name
    end

    return string.format('Item #%d', itemId)
end

-----------------------------------
-- Helper function to check level requirements
-----------------------------------
local function checkLevelRequirement(player, itemId)
    local requiredLevel = levelGatedItems[itemId]
    if requiredLevel then
        return player:getMainLvl() >= requiredLevel
    end

    return true
end

-----------------------------------
-- Helper function to check if player already has rare item
-----------------------------------
local function playerHasRareItem(player, itemId)
    local itemObj = GetItemByID(itemId)
    if itemObj and bit.band(itemObj:getFlag(), xi.itemFlag.RARE) ~= 0 then
        return player:hasItem(itemId)
    end

    return false
end

-----------------------------------
-- Helper function to check trade without locking
-- Returns true if trade contains exactly 1 of the specified item
-----------------------------------
local function tradeHasItemOnly(trade, itemId)
    -- Must have exactly 1 slot used
    if trade:getSlotCount() ~= 1 then
        return false
    end

    -- Must have exactly 1 of the item
    if trade:getItemQty(itemId) ~= 1 then
        return false
    end

    return true
end

-----------------------------------
-- Forward declaration for menu builder
-----------------------------------
local buildPellMenu

-----------------------------------
-- Show menu with delay (needed for page changes)
-----------------------------------
local function showMenuDelayed(player, pellItemId, rewards, page)
    player:timer(100, function(p)
        p:customMenu(buildPellMenu(p, pellItemId, rewards, page))
    end)
end

-----------------------------------
-- Build paginated menu for pell rewards
-----------------------------------
buildPellMenu = function(player, pellItemId, rewards, currentPage)
    local totalItems = #rewards
    local totalPages = math.ceil(totalItems / itemsPerPage)
    local startIdx = (currentPage - 1) * itemsPerPage + 1
    local endIdx = math.min(startIdx + itemsPerPage - 1, totalItems)

    local pellName = pellNames[pellItemId] or 'Mog Pell'
    local menuTitle = string.format('%s (Page %d/%d)', pellName, currentPage, totalPages)

    local options = {}

    -- Add navigation at the top if not on first page
    if currentPage > 1 then
        local prevPage = currentPage - 1
        options[#options + 1] =
        {
            '[Prev Page]',
            function(playerArg)
                showMenuDelayed(playerArg, pellItemId, rewards, prevPage)
            end,
        }
    end

    -- Add item options for this page
    for i = startIdx, endIdx do
        local reward = rewards[i]
        local itemId = reward[1]
        local quantity = reward[2]
        local displayName = getItemDisplayName(itemId, quantity)

        -- Store values for closure
        local capturedItemId = itemId
        local capturedQuantity = quantity

        options[#options + 1] =
        {
            displayName,
            function(playerArg)
                -- Check if already owned (rare)
                if playerHasRareItem(playerArg, capturedItemId) then
                    playerArg:printToPlayer('You already own this rare item.', xi.msg.channel.SYSTEM_3)
                    return
                end

                -- Check level requirement
                if not checkLevelRequirement(playerArg, capturedItemId) then
                    local reqLevel = levelGatedItems[capturedItemId]
                    playerArg:printToPlayer(
                        string.format('You must be level %d or higher to receive this item.', reqLevel),
                        xi.msg.channel.SYSTEM_3
                    )
                    return
                end

                -- Award the item
                if npcUtil.giveItem(playerArg, { { capturedItemId, capturedQuantity } }) then
                    playerArg:tradeComplete()
                end
            end,
        }
    end

    -- Add navigation at the bottom if not on last page
    if currentPage < totalPages then
        local nextPage = currentPage + 1
        options[#options + 1] =
        {
            '[Next Page]',
            function(playerArg)
                showMenuDelayed(playerArg, pellItemId, rewards, nextPage)
            end,
        }
    end

    return {
        title = menuTitle,
        options = options,
        onCancelled = function(playerArg)
            local ID = zones[playerArg:getZoneID()]
            playerArg:messageSpecial(ID.text.ITEM_RETURNED, pellItemId)
        end,
    }
end

-----------------------------------
-- Override onTrade to use custom menu
-----------------------------------
m:addOverride('xi.festiveMoogle.onTrade', function(player, npc, trade)
    for pellItemId, rewards in pairs(rewardItems) do
        if tradeHasItemOnly(trade, pellItemId) then
            -- Show custom menu with our rewards
            player:customMenu(buildPellMenu(player, pellItemId, rewards, 1))
            return
        end
    end

    -- Do nothing for pell types we don't handle - prevents unintended behavior
end)

return m
