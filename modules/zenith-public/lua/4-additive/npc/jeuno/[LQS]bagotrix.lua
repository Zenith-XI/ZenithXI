-----------------------------------
-- NPC: Bagotrix
-- Location: Upper Jeuno
-- Mog Satchel Vendor
-----------------------------------
-- Goblin merchant who sells Mog Satchel unlocks
-- with dynamic pricing based on nation mission ranks.
--
-- Pricing Formula:
--   Base: 1,000,000 gil
--   Discount: 37,000 gil per nation rank above 1
--   Minimum: 1,000 gil (rank 10 in all nations)
--
-- !pos 0.4745 1.8001 75.9075 244
-----------------------------------
local m = Module:new('a-n_bagotrix')

local bagotrix = 'Bagotrix'

-- Calculate Mog Satchel price based on nation ranks
local function calculateSatchelPrice(player)
    local sandoriaRank = player:getRank(xi.nation.SANDORIA)
    local bastokRank   = player:getRank(xi.nation.BASTOK)
    local windurstRank = player:getRank(xi.nation.WINDURST)

    -- Each rank above 1 provides a discount (27 total possible ranks)
    local totalRanks = (sandoriaRank - 1) + (bastokRank - 1) + (windurstRank - 1)
    local discount   = totalRanks * 37000
    local price      = math.max(1000, 1000000 - discount)

    return price, totalRanks
end

-- Check if player already has Mog Satchel unlocked
local function hasSatchelUnlocked(player)
    return player:getContainerSize(xi.inv.MOGSATCHEL) > 0
end

-- Process the satchel purchase
-- Uses npcName string instead of npc object to avoid stale C++ pointers in callbacks
local function processPurchase(player, npcName)
    local price = calculateSatchelPrice(player)

    -- Check if player has enough gil
    if player:getGil() < price then
        LQS.event(player, nil, {
            'Bagotrix: Bah! Uplander pockets empty!',
            string.format(' Need %s gil! You no have enough!', price),
            ' Come back when have proper gil!',
            ' Bagotrix no give charity!',
        })
        return
    end

    -- Atomic transaction: deduct gil and grant satchel together
    player:delGil(price)
    player:changeContainerSize(xi.inv.MOGSATCHEL, 80)

    -- Success dialog using LQS.event for proper sequencing
    LQS.event(player, nil, {
        'Bagotrix: Ahhh! Good business with uplander!',
        ' Here! Satchel now big and full!',
        string.format(' You paid %s gil! Very good!', price),
        { delay = 1000 },
        ' You come back if need more things, yes?',
        ' Bagotrix always have best deals in Jeuno!',
    })
end

-- Show purchase menu with proper parameter scoping
-- Caches npcName to avoid stale C++ pointer issues in menu callbacks
local function showPurchaseMenu(player, npcName)
    local menuPrice = calculateSatchelPrice(player)

    player:customMenu({
        title = string.format('Purchase Mog Satchel for %s gil?', menuPrice),
        options =
        {
            {
                'No thanks',
                function(playerMenuArg)
                    LQS.event(playerMenuArg, nil, {
                        'Bagotrix: Hmph! Uplander no want good deal?',
                        ' Bagotrix wait here if you change mind!',
                        ' Come back when pockets heavy with gil!',
                    })
                end,
            },
            {
                'Yes, purchase Mog Satchel',
                function(playerMenuArg)
                    processPurchase(playerMenuArg, npcName)
                end,
            },
        },
    })
end

local info =
{
    name   = 'Bagotrix - Mog Satchel Vendor',
    author = 'Zenith',
    var    = '[LQS]BAGOTRIX_VENDOR',
}

LQS.add(m, {
    info     = info,
    entities =
    {
        ['Upper_Jeuno'] =
        {
            {
                name    = bagotrix,
                type    = xi.objType.NPC,
                look    = 85,
                pos     = { 0.4745, 1.8001, 75.9075, 9 },
                -- REQUIRED: default event table needed for onTrigger to be registered
                default =
                {
                    'Psssst! Uplander! Bagotrix have special deal for you!',
                },
            },
        },
    },
    steps =
    {
        -- Step 0: Main interaction - check and offer Mog Satchel
        {
            [bagotrix] =
            {
                onTrigger = function(player, npc)
                    -- Check if already purchased/unlocked
                    if hasSatchelUnlocked(player) then
                        LQS.event(player, npc, {
                            'Oho! Uplander already have big satchel!',
                            ' Bagotrix no have more to sell you!',
                            ' You keep satchel full of treasures, yes?',
                        })
                        return
                    end

                    -- Calculate price and cache npc name to avoid stale pointer issues
                    local price, totalRanks = calculateSatchelPrice(player)
                    local npcName = npc:getPacketName()

                    -- Show greeting and offer using LQS.event for proper sequencing
                    LQS.event(player, npc, {
                        'Psssst! Uplander! You want special deal?',
                        ' Bagotrix have Mog Satchel unlock!',
                        ' Very rare! Very special!',
                        { delay = 1500 },
                        string.format(' For you, only %s gil!', price),
                        string.format(' You have %d completed mission ranks!', totalRanks),
                        ' Each rank save you 37,000 gil! Good deal, yes?',
                        function(playerArg)
                            showPurchaseMenu(playerArg, npcName)
                        end,
                    })
                end,
            },
        },
    },
})

return m
