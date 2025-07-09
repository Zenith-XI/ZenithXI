-- Garrison improvements: grants outpost warps on victory

local m = Module:new('garrison_improvements')

-- Override the gil payout function to also grant outpost warps
m:addOverride('xi.garrison.handleGilPayout', function(levelCap, players)
    super(levelCap, players)
    -- Then add our custom outpost warp logic
    if #players > 0 then
        local zone = players[1]:getZone()
        local region = zone:getRegionID()
        -- User-friendly region names mapping (matching outpost teleporter display)
        local regionNames = {
            [xi.region.RONFAURE]         = 'The Ronfaure Region',
            [xi.region.ZULKHEIM]         = 'The Zulkheim Region',
            [xi.region.NORVALLEN]        = 'The Norvallen Region',
            [xi.region.GUSTABERG]        = 'The Gustaberg Region',
            [xi.region.DERFLAND]         = 'The Derfland Region',
            [xi.region.SARUTABARUTA]     = 'The Sarutabaruta Region',
            [xi.region.KOLSHUSHU]        = 'The Kolshushu Region',
            [xi.region.ARAGONEU]         = 'The Aragoneu Region',
            [xi.region.FAUREGANDI]       = 'The Fauregandi Region',
            [xi.region.VALDEAUNIA]       = 'The Valdeaunia Region',
            [xi.region.QUFIMISLAND]      = 'The Qufim Island Region',
            [xi.region.LITELOR]          = 'The Li\'Telor Region',
            [xi.region.KUZOTZ]           = 'The Kuzotz Region',
            [xi.region.VOLLBOW]          = 'The Vollbow Region',
            [xi.region.ELSHIMO_LOWLANDS] = 'The Elshimo Lowlands Region',
            [xi.region.ELSHIMO_UPLANDS]  = 'The Elshimo Uplands Region',
            [xi.region.TULIA]            = 'The Tu\'Lia Region',
            [xi.region.MOVALPOLOS]       = 'The Movalpolos Region',
            [xi.region.TAVNAZIANARCH]    = 'The Tavnazian Archipelago Region',
        }

        local regionName = regionNames[region] or 'Unknown Region'
        -- Grant outpost warp to each player
        for _, player in ipairs(players) do
            if player ~= nil then
                local nation = player:getNation()
                -- Check if player already has the outpost teleport for this region
                if not player:hasTeleport(nation, region + 5) then
                    player:addTeleport(nation, region + 5)
                    player:printToPlayer(string.format('You have unlocked the outpost warp for %s!', regionName), xi.msg.channel.SYSTEM_3)
                end
            end
        end
    end
end)

return m
