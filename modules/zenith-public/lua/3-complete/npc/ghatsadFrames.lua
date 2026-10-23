-----------------------------------
-- Ghatsad automaton frame items before the March 2015 update (ZENITHDEV-30)
-- Source: the March 2015 FFXI version update notes (official forum, Version Updates).
-- The update swapped two of the items Ghatsad asks for, as they were hard to find:
--   Valoredge X-900: Tigerfangs instead of Patas
--   Sharpshot Z-500: Repeating Crossbow instead of Heavy Crossbow
--
-- Base keeps the items in a local table of
-- scripts/zones/Aht_Urhgan_Whitegate/npcs/Ghatsad.lua, so the materials trade for those two
-- frames is handled here, with the same events and variables as base. Every other trade
-- (Stormwaker, payment, puppet turbans, coffee) goes to base. Ghatsad's cutscene text still
-- names the modern items; it is in the client.
-- While Aht Urhgan Whitegate is disabled the framework skips this override; it applies once
-- the zone is enabled.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_ghatsadFrames')

-- Keyed by PUP_AttachmentStatus, as in base
local frameItems =
{
    [2] = { xi.item.BRASS_SHEET,              xi.item.WAMOURA_COCOON,          xi.item.CHUNK_OF_IMPERIAL_CERMET,  xi.item.TIGERFANGS         }, -- Valoredge
    [3] = { xi.item.PIECE_OF_ROSEWOOD_LUMBER, xi.item.SQUARE_OF_KARAKUL_CLOTH, xi.item.SQUARE_OF_KARAKUL_LEATHER, xi.item.REPEATING_CROSSBOW }, -- Sharpshot
}

-- Copies of base's unlock cost and head list
local unlockCost =
{
    [0] = { xi.item.IMPERIAL_SILVER_PIECE,  3 },
    [1] = { xi.item.IMPERIAL_MYTHRIL_PIECE, 3 },
    [2] = { xi.item.IMPERIAL_GOLD_PIECE,    1 },
    [3] = { xi.item.IMPERIAL_MYTHRIL_PIECE, 2 },
    [4] = { xi.item.IMPERIAL_MYTHRIL_PIECE, 4 },
}

local automatonHeads =
{
    xi.item.VALOREDGE_HEAD,
    xi.item.SHARPSHOT_HEAD,
    xi.item.STORMWAKER_HEAD,
    xi.item.SOULSOOTHER_HEAD,
    xi.item.SPIRITREAVER_HEAD,
}

local getNumUnlockedHeads = function(player)
    local headCount = 0

    for _, head in ipairs(automatonHeads) do
        if player:hasAttachment(head) then
            headCount = headCount + 1
        end
    end

    return headCount
end

local hasRequiredMats = function(trade, items)
    for _, item in ipairs(items) do
        if trade:getItemQty(item) ~= 1 then
            return false
        end
    end

    return true
end

zxi = zxi or {}
zxi.ghatsadFrames = zxi.ghatsadFrames or {}

-- Handles the Valoredge and Sharpshot materials trade; anything else goes to baseOnTrade.
-- A function of its own so the test can run it while Whitegate is disabled.
zxi.ghatsadFrames.onTrade = function(player, npc, trade, baseOnTrade)
    local attachmentStatus = player:getCharVar('PUP_AttachmentStatus')
    local items            = frameItems[attachmentStatus]

    if not items then
        return baseOnTrade(player, npc, trade)
    end

    -- Same as base's "Initial Trade: Has Materials + Payment, or just Materials"
    if not hasRequiredMats(trade, items) then
        return
    end

    local cost      = unlockCost[getNumUnlockedHeads(player)]
    local slotCount = trade:getSlotCount()

    if slotCount == 4 then
        player:tradeComplete()
        player:setCharVar('PUP_AttachmentStatus', attachmentStatus + 3)
        player:startEvent(624, 0, 0, 0, 0, 0, cost[1], cost[2])
    elseif slotCount == 5 and trade:getItemQty(cost[1]) == cost[2] then
        player:tradeComplete()
        player:setCharVar('PUP_AttachmentStatus', attachmentStatus + 6)
        player:setCharVar('PUP_AttachmentReady', VanadielUniqueDay() + 1)
        player:startEvent(625)
    end
end

m:addOverride('xi.zones.Aht_Urhgan_Whitegate.npcs.Ghatsad.onTrade', function(player, npc, trade)
    return zxi.ghatsadFrames.onTrade(player, npc, trade, super)
end)

return m
