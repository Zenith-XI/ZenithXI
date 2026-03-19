-----------------------------------
-- func: clearquestbonus <player>
-- desc: Clears all daily double gil bonus counters for repeatable quests.
--       Used for testing the repeatableQuestDoubleRewards module.
--       If no player name is provided, uses cursor target or self.
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 4,
    parameters = 's',
}

local function showError(player, msg)
    player:printToPlayer(msg, xi.msg.channel.SYSTEM_3)
    player:printToPlayer('Usage: !clearquestbonus [player]', xi.msg.channel.SYSTEM_3)
end

commandObj.onTrigger = function(player, targetName)
    local target

    if targetName == nil or targetName == '' then
        -- Check if cursor target is a PC
        local cursorTarget = player:getCursorTarget()
        if cursorTarget and cursorTarget:isPC() then
            target = cursorTarget
        else
            target = player
        end
    else
        target = GetPlayerByName(targetName)
        if target == nil then
            showError(player, string.format('Player "%s" not found or not online.', targetName))
            return
        end
    end

    -- Use getCharVarsWithPrefix to dynamically find all tracked quests
    -- This eliminates the need to maintain a duplicate quest list
    local vars = target:getCharVarsWithPrefix('DailyGilBonus_')
    local clearedCount = 0

    for varName, _ in pairs(vars) do
        target:setCharVar(varName, 0)
        clearedCount = clearedCount + 1
    end

    if clearedCount > 0 then
        player:printToPlayer(
            string.format(
                'Cleared %d daily quest bonus counter(s) for %s.',
                clearedCount,
                target:getName()
            ),
            xi.msg.channel.SYSTEM_3
        )
    else
        player:printToPlayer(
            string.format(
                'No daily quest bonus counters found for %s.',
                target:getName()
            ),
            xi.msg.channel.SYSTEM_3
        )
    end

    -- Also notify the target if different from the GM
    if clearedCount > 0 and target:getID() ~= player:getID() then
        target:printToPlayer(
            'Your daily repeatable quest bonus counters have been reset by a GM.',
            xi.msg.channel.SYSTEM_3
        )
    end
end

return commandObj
