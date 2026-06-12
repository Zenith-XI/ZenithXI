-----------------------------------
-- func: checkwardrobes
-- desc: Checks and awards any pending wardrobe/mog case unlocks for a player
--       Also displays all completed and available unlocks
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 1,
    parameters = 's',
}

local function showError(player, message)
    player:printToPlayer(message, xi.msg.channel.SYSTEM_3)
    player:printToPlayer('!checkwardrobes (player)', xi.msg.channel.SYSTEM_3)
end

local function msg(player, text)
    player:printToPlayer(text, xi.msg.channel.SYSTEM_3)
end

commandObj.onTrigger = function(player, target)
    -- Validate target
    local targ
    if target == nil then
        targ = player
    else
        targ = GetPlayerByName(target)
        if targ == nil then
            showError(player, string.format('Player named "%s" not found!', target))
            return
        end
    end

    -- Check if the wardrobe unlock system is loaded
    if not xi.wardrobeUnlocks or not xi.wardrobeUnlocks.checkAllUnlocks then
        msg(player, 'Wardrobe unlock system is not loaded.')
        return
    end

    -- Run the check silently - we'll display results ourselves
    local awarded = xi.wardrobeUnlocks.checkAllUnlocks(targ, true)

    -- Get and display all unlock statuses
    if not xi.wardrobeUnlocks.getUnlockStatuses then
        msg(player, 'Unlock status API not available.')
        return
    end

    local statuses = xi.wardrobeUnlocks.getUnlockStatuses(targ)

    msg(player, 'Wardrobe Unlocks for ' .. targ:getName())

    -- Sort bags by their enum value for consistent display order
    local sortedBags = {}
    for bag, _ in pairs(statuses) do
        table.insert(sortedBags, bag)
    end

    table.sort(sortedBags)

    local totalCompleted = 0
    local totalAvailable = 0
    local totalSlots = 0

    for _, bag in ipairs(sortedBags) do
        local status = statuses[bag]
        local completedCount = #status.completed
        local availableCount = #status.available

        if completedCount > 0 or availableCount > 0 then
            -- Calculate total slots for this bag
            local bagSlots = 0
            for _, unlock in ipairs(status.completed) do
                bagSlots = bagSlots + unlock.slots
            end

            msg(player, string.format('[%s] %d unlocks / %d slots', status.name, completedCount, bagSlots))

            -- Show completed unlocks
            for _, unlock in ipairs(status.completed) do
                msg(player, string.format('  * %s (+%d)', unlock.name, unlock.slots))
            end

            -- Show available but not yet claimed
            if availableCount > 0 then
                msg(player, '  Pending:')
                for _, unlock in ipairs(status.available) do
                    msg(player, string.format('  > %s (+%d)', unlock.name, unlock.slots))
                end
            end

            totalCompleted = totalCompleted + completedCount
            totalAvailable = totalAvailable + availableCount
            totalSlots = totalSlots + bagSlots
        end
    end

    msg(player, string.format('Total: %d unlocks / %d slots', totalCompleted, totalSlots))

    if awarded > 0 then
        msg(player, string.format('Newly awarded: %d', awarded))
    end

    if totalAvailable > 0 then
        msg(player, string.format('Pending: %d (run again to claim)', totalAvailable))
    end

    if totalCompleted == 0 and totalAvailable == 0 then
        msg(player, 'No unlocks completed yet.')
    end
end

return commandObj
