-----------------------------------
-- Guild Point rewards out of era (ZENITHDEV-276)
-- Rewards added after the level 75 era cannot be bought: their required rank is one no player reaches, so
-- LSB takes no Guild Points and hands nothing over. The client still lists them, so the player gets a notice.
--   Signboards: November 20, 2007. Rings: June 9, 2008. Blocked while Wings of the Goddess is off.
--   Emblems, the seventh slot items and the Way of the ... key items: December 7, 2010. Always blocked.
-- Aurora and Twilight Crystals keep their LSB price.
-- Based on Phoenix's modules/phoenix/lua/globals/hobbies/crafting/guild_point_shop.lua
-----------------------------------
require('modules/module_utils')
require('scripts/globals/hobbies/crafting/guild_points')
-----------------------------------
local m = Module:new('c_guildPointShop')

local disabledRank = 99
local notice       = 'This item is not available on this server.'

local outOfEraKeyItems =
{
    [xi.keyItem.ANGLERS_ALMANAC      ] = true,
    [xi.keyItem.WAY_OF_THE_CARPENTER ] = true,
    [xi.keyItem.WAY_OF_THE_BLACKSMITH] = true,
    [xi.keyItem.WAY_OF_THE_GOLDSMITH ] = true,
    [xi.keyItem.WAY_OF_THE_WEAVER    ] = true,
    [xi.keyItem.WAY_OF_THE_TANNER    ] = true,
    [xi.keyItem.WAY_OF_THE_BONEWORKER] = true,
    [xi.keyItem.WAY_OF_THE_ALCHEMIST ] = true,
    [xi.keyItem.WAY_OF_THE_CULINARIAN] = true,
}

local outOfEraItems =
{
    [xi.item.NET_AND_LURE             ] = true,
    [xi.item.FISHERMENS_EMBLEM        ] = true,
    [xi.item.CARPENTERS_KIT           ] = true,
    [xi.item.CARPENTERS_EMBLEM        ] = true,
    [xi.item.STONE_HEARTH             ] = true,
    [xi.item.BLACKSMITHS_EMBLEM       ] = true,
    [xi.item.GEMSCOPE                 ] = true,
    [xi.item.GOLDSMITHS_EMBLEM        ] = true,
    [xi.item.SPINNING_WHEEL           ] = true,
    [xi.item.WEAVERS_EMBLEM           ] = true,
    [xi.item.HIDE_STRETCHER           ] = true,
    [xi.item.TANNERS_EMBLEM           ] = true,
    [xi.item.SET_OF_BONECRAFTING_TOOLS] = true,
    [xi.item.BONEWORKERS_EMBLEM       ] = true,
    [xi.item.ALEMBIC                  ] = true,
    [xi.item.ALCHEMISTS_EMBLEM        ] = true,
    [xi.item.BRASS_CROCK              ] = true,
    [xi.item.CULINARIANS_EMBLEM       ] = true,
}

local wotgItems =
{
    [xi.item.FISHERMANS_SIGNBOARD ] = true,
    [xi.item.CARPENTERS_SIGNBOARD ] = true,
    [xi.item.CARPENTERS_RING      ] = true,
    [xi.item.BLACKSMITHS_SIGNBOARD] = true,
    [xi.item.SMITHS_RING          ] = true,
    [xi.item.GOLDSMITHS_SIGNBOARD ] = true,
    [xi.item.GOLDSMITHS_RING      ] = true,
    [xi.item.WEAVERS_SIGNBOARD    ] = true,
    [xi.item.TAILORS_RING         ] = true,
    [xi.item.TANNERS_SIGNBOARD    ] = true,
    [xi.item.TANNERS_RING         ] = true,
    [xi.item.BONEWORKERS_SIGNBOARD] = true,
    [xi.item.BONECRAFTERS_RING    ] = true,
    [xi.item.ALCHEMISTS_SIGNBOARD ] = true,
    [xi.item.ALCHEMISTS_RING      ] = true,
    [xi.item.CULINARIANS_SIGNBOARD] = true,
    [xi.item.CHEFS_RING           ] = true,
}

-- Analysis Crystals are not implemented in LSB. Their menu entry only ever gets the notice.
local function isAnalysisCrystal(option, category)
    return category == 0 and option ~= utils.EVENT_CANCELLED_OPTION and bit.band(option, 3) == 2
end

m:addOverride('xi.crafting.guildPointOnEventUpdate', function(player, option, target, guildId)
    local category = bit.band(bit.rshift(option, 2), 3)
    local reward

    if isAnalysisCrystal(option, category) then
        player:printToPlayer(notice, xi.msg.channel.SYSTEM_3)

        return
    end

    if category == 3 then
        reward = xi.crafting.guildKeyItemTable[guildId][bit.band(bit.rshift(option, 5), 15) - 1]
    elseif category == 2 or category == 1 then
        reward = xi.crafting.guildItemTable[guildId][(category - 1) * 4 + bit.band(option, 3)]
    end

    if reward and reward.rank >= disabledRank then
        player:printToPlayer(notice, xi.msg.channel.SYSTEM_3)
    end

    return super(player, option, target, guildId)
end)

m:addOverride('xi.server.onServerStart', function()
    super()

    for _, keyItems in pairs(xi.crafting.guildKeyItemTable) do
        for _, keyItem in pairs(keyItems) do
            if outOfEraKeyItems[keyItem.id] then
                keyItem.rank = disabledRank
            end
        end
    end

    for _, items in pairs(xi.crafting.guildItemTable) do
        for _, item in pairs(items) do
            if
                outOfEraItems[item.id] or
                (wotgItems[item.id] and xi.settings.main.ENABLE_WOTG == 0)
            then
                item.rank = disabledRank
            end
        end
    end
end)

return m
