-----------------------------------
-- Daily Instant Warp and Instant Reraise limit (ZENITHDEV-272)
-- A character buys one of each per day, whichever vendor it uses, to offset their low price. Only a purchase
-- that went through counts, which shows as the currency going down. The char vars expire at JST midnight, so
-- they survive logouts and restarts. Scrolls from anywhere else and scrolls already owned are not affected.
-- Conquest overseers and Imperial Standing NPCs are the two vendors that sell them on this server. Ujlei Zelekko
-- (Adoulin), Unity and the curio moogles' Rhapsody stock are left out, none of them can be reached.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_instantScrollLimit')

local instantReraise = '[Zenith]DailyInstantReraise'
local instantWarp    = '[Zenith]DailyInstantWarp'

local conquestOptions =
{
    [32928] = instantReraise,
    [32929] = instantWarp,
}

local imperialStandingOptions =
{
    [1]    = instantReraise,
    [4097] = instantWarp,
}

local function conquestPoints(player)
    return player:getCP()
end

local function imperialStanding(player)
    return player:getCurrency('imperial_standing')
end

local function buyOncePerDay(player, charVar, getCurrency, buy)
    if player:getCharVar(charVar) > 0 then
        player:printToPlayer('You have already purchased this scroll today.', xi.msg.channel.SYSTEM_3)

        return
    end

    local before = getCurrency(player)

    buy()

    if getCurrency(player) < before then
        player:setCharVar(charVar, 1, JstMidnight())
    end
end

m:addOverride('xi.conquest.overseerOnEventFinish', function(player, csid, option, guardNation, guardType, guardRegion)
    local charVar = conquestOptions[option]

    if not charVar then
        return super(player, csid, option, guardNation, guardType, guardRegion)
    end

    buyOncePerDay(player, charVar, conquestPoints, function()
        super(player, csid, option, guardNation, guardType, guardRegion)
    end)
end)

m:addOverride('xi.besieged.onEventFinish', function(player, csid, option, npc)
    local charVar = imperialStandingOptions[option]

    if not charVar then
        return super(player, csid, option, npc)
    end

    buyOncePerDay(player, charVar, imperialStanding, function()
        super(player, csid, option, npc)
    end)
end)

return m
