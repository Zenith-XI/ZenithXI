-- -----------------------------------
-- Explorer Moogle Module
--
-- This module overrides the conditions to use explorer moogle teleports.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('explorer_moogle')

local canNotTeleport = function(player)
    -- Check if player is at least rank 3 in any nation
    local noRank3Nation =
            player:getRank(player:getNation(xi.nation.BASTOK)) < 3 and
            player:getRank(player:getNation(xi.nation.SANDORIA)) < 3 and
            player:getRank(player:getNation(xi.nation.WINDURST)) < 3

    -- Returns true if player is not rank 3 in any nation and meets the minimum level requirement
    -- The handling of not meeting the level requirement is done in the original explorerMoogleOnTrigger
    return noRank3Nation and player:getMainLvl() >= xi.settings.main.EXPLORER_MOOGLE_LV
end

-- Override the teleport conditions for explorer moogle
m:addOverride('xi.teleport.explorerMoogleOnTrigger', function(player, event)
    if canNotTeleport(player) then
        event = event + 1
    end

    -- Call the original function with the modified event or
    -- startEvent gets called before we change the event id
    super(player, event)
end)

m:addOverride('xi.teleport.explorerMoogleOnEventFinish', function(player, csid, option, event)
    -- Check if the player is eligible for the teleport
    -- If they are not, we skip the event finish and do nothing
    if
        canNotTeleport(player) and
        option > 0
    then
        -- If player is not eligible but managed to reach the event finish,
        -- we log this because they have possibility cheated.
        print(fmt('[JAILUTILS] player {} with id {} has teleported with the explorer moogle while ineligible', player:getName(), player:getID()))
        return
    else
        -- Call the original function
        super(player, csid, option, event)
    end
end)

return m
