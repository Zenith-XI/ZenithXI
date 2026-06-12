-- -----------------------------------
-- Treasure Caskets Module
--
-- This module overrides the amount of attempts a player has to open a casket.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('treasure_caskets')

-- When caskets are spawned, increment the number of attempts
-- a player has to open the casket by 1
m:addOverride('xi.caskets.spawnCasket', function(player, mob, x, y, z, r)
    if player and mob then
        super(player, mob, x, y, z, r)

        -- find the newly spawned chest and bump the attempts to unlock by 1
        local zone = mob:getZone()
        for _, chest in ipairs(zone:queryEntitiesByName('Treasure_Casket')) do
            if chest:getLocalVar('[caskets]INCREMENTED') == 0 then
                -- increment attempts
                local newAttempts = chest:getLocalVar('[caskets]ATTEMPTS') + 1
                chest:setLocalVar('[caskets]ATTEMPTS', newAttempts)

                -- mark as handled so we never bump it again
                chest:setLocalVar('[caskets]INCREMENTED', 1)
            end
        end
    end
end)

return m
