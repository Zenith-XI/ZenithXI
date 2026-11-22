-----------------------------------
-- Home Point menu without teleports (ZENITHDEV-248)
-- Copy of LSB's modules/custom/lua/homepoint.lua without its xi.pre(xi.expansion.SOA) condition,
-- so the Home Points stay a plain "set your home point" menu when SoA content is enabled.
-- Source: https://www.bg-wiki.com/ffxi/Home_Point
-----------------------------------
require('modules/module_utils')
require('scripts/globals/interaction/interaction_global')
-----------------------------------
local m = Module:new('c_homepointMenu')

local function showHomepointCustomMenu(player, npc)
    local triggerTarget = npc

    local menu =
    {
        title   = 'What will you do?',

        options =
        {
            {
                'Set this as your home point.',
                function(playerArg)
                    if triggerTarget and playerArg:checkDistance(triggerTarget) <= 6 then
                        triggerTarget:entityAnimationPacket(xi.animationString.EFFECT_HOME_POINT, player)
                        playerArg:setHomePoint()
                    end

                    if zones[playerArg:getZoneID()].text.HOMEPOINT_SET then
                        playerArg:messageSpecial(zones[playerArg:getZoneID()].text.HOMEPOINT_SET)
                    else
                        print(string.format('ERROR: missing ID.text.HOMEPOINT_SET in zone %s.', playerArg:getZoneName()))
                    end
                end,
            },
            {
                'On second thought, never mind.',
                function(playerArg)
                end,
            },
        },

        onCancelled = function(playerArg)
            playerArg:setFreezeFlag(false)
        end,

        onEnd = function(playerArg)
            playerArg:setFreezeFlag(false)
        end,
    }

    player:setFreezeFlag(true)
    player:customMenu(menu)
end

m:addOverride('xi.homepoint.onTrigger', function(player, csid, index)
    -- Examine a Home Point (M): kept from LSB's xi.homepoint.onTrigger, which this override replaces
    xi.roe.onRecordTrigger(player, 3769)

    local npc = player:getCursorTarget()
    showHomepointCustomMenu(player, npc)
end)

return m
