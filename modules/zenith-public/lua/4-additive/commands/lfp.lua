-----------------------------------
-- func: lfp
-- desc: Toggles Looking for Party flag, bypassing client restrictions with trusts
--
-- [ZENITH MOD] This command allows players to toggle their LFP status even
-- when trusts are deployed, working around the client-side restriction.
-----------------------------------
---@type TCommand
local commandObj = {}

commandObj.cmdprops =
{
    permission = 0,  -- Available to all players
    parameters = ''
}

commandObj.onTrigger = function(player)
    local currentLfp = player:isSeekingParty()
    local newLfp = not currentLfp

    -- Use the entity method binding (from lfp_with_trusts.cpp)
    local success = player:setSeekingParty(newLfp)

    if success then
        if newLfp then
            player:printToPlayer('You are now seeking a party.', xi.msg.channel.SYSTEM_3)
        else
            player:printToPlayer('You are no longer seeking a party.', xi.msg.channel.SYSTEM_3)
        end
    else
        player:printToPlayer('Failed to change party status.', xi.msg.channel.SYSTEM_3)
    end
end

return commandObj
