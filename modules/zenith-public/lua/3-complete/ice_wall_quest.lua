-- -----------------------------------
-- Ice Wall Quest Module
--
-- This module creates a quest to interact with
-- The Ice Wall in Uleguerand Range.
-- Players can trade a Fire Cluster to open the wall.
-- -----------------------------------

local m = Module:new('ice_wall_quest')

local ID = zones[xi.zone.ULEGUERAND_RANGE]
local npcName = 'Ice Wall'
local checkWaterfall = function(player)
    local waterfall = GetNPCByID(ID.npc.WATERFALL)

    local waterfallOpen = waterfall:getAnimation() ~= xi.anim.OPEN_DOOR

    if not waterfallOpen then
        player:fmt('{} : The path is currently clear!', npcName)
    end

    return waterfallOpen
end

local openWaterfall = function(player)
    -- can't just use :openDoor(30) because we need to check the weather before closing it
    local waterfall = GetNPCByID(ID.npc.WATERFALL)
    waterfall:setAnimation(xi.anim.OPEN_DOOR)

    -- close door after 30s, unless weather changed in that time
    waterfall:timer(30000, function(npcArg)
        local weather = npcArg:getZone():getWeather()

        if
        npcArg:actionQueueEmpty() and -- don't close the door if someone else traded while it was open
        (weather == xi.weather.SNOW or
        weather == xi.weather.BLIZZARDS)
        then
            npcArg:setAnimation(xi.anim.CLOSE_DOOR)
        end
    end)

    return true
end

local info =
{
    name     = 'Breaking the Ice Wall',
    author   = 'ZenithXI',
    var      = '[LQS]ICE_WALL_QUEST',
    required = { { xi.item.FIRE_CLUSTER, 1 } },
    reward   =
    {
        after = openWaterfall,
    },
}

LQS.add(m, {
    info = info,
    entities =
    {
        ['Uleguerand_Range'] =
        {
            {
                name = npcName,
                type = xi.objType.NPC,
                marker = LQS.MAIN_QUEST,
                pos = { 3.84123, -177.199, 67.45, 106 }, -- !pos -3.276 -0.000 25.295 244
                default = -- onTrigger functions aren't registered if entity doesn't have this default event table
                {
                    { delay   = 500 },
                },
            },
        },
    },
    steps =
    {
        {
            [npcName] =
            {
                LQS.dialog({
                    quest = info.name,
                    event =
                    {
                        'This area looks charred.',
                    },
                }),
                check = LQS.checks({ eval = checkWaterfall }), -- executed when onTrigger for this step is called
                onTrigger = LQS.dialog({
                    step  = false,
                    event =
                    {
                        'If only there was some way to melt the ice...', -- don't say anything, messages will come from check function
                    },
                }),
                onTrade = LQS.trade({
                    quest    = info.name,
                    required = info.required,
                    reward   = info.reward,
                    step     = false,
                    declined =
                    {
                        'You won\'t be able to melt the ice with that.',
                    },
                    accepted =
                    {
                        'You trade a Fire Cluster to the Ice Wall, revealing a hidden path.',
                    },
                }),
            },
        },
    },
})

return m
