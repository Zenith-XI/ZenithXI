-- ZenithXI Ghatsad frame items (modules/zenith-public/lua/3-complete/npc/ghatsadFrames.lua).
--
-- Valoredge X-900 needs Tigerfangs again and Sharpshot Z-500 a Repeating Crossbow, instead of the
-- Patas and Heavy Crossbow of the March 2015 update.
--
-- While Aht Urhgan Whitegate is disabled (DisableZones.sql) the framework skips the module's
-- override of Ghatsad, so the test puts the module's trade handler on Ghatsad itself and restores
-- base's afterwards.

describe('Zenith Ghatsad frames', function()
    ---@type CClientEntityPair
    local player

    local valoredge = { xi.item.BRASS_SHEET, xi.item.WAMOURA_COCOON, xi.item.CHUNK_OF_IMPERIAL_CERMET }
    local sharpshot = { xi.item.PIECE_OF_ROSEWOOD_LUMBER, xi.item.SQUARE_OF_KARAKUL_CLOTH, xi.item.SQUARE_OF_KARAKUL_LEATHER }

    local function trade(status, items, last, eventId)
        player:setCharVar('PUP_AttachmentStatus', status)

        local offer = {}
        for _, item in ipairs(items) do
            player:addItem(item)
            table.insert(offer, item)
        end

        player:addItem(last)
        table.insert(offer, last)

        player.actions:tradeNpc('Ghatsad', offer, eventId and { eventId = eventId } or nil)
    end

    local ghatsad
    local baseOnTrade

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.AHT_URHGAN_WHITEGATE, job = xi.job.PUP, level = 30 })

        ghatsad     = xi.zones.Aht_Urhgan_Whitegate.npcs.Ghatsad
        baseOnTrade = ghatsad.onTrade

        -- An applied override has `super` in its environment (applyOverride in module_utils.lua)
        if getfenv(baseOnTrade).super == nil then
            ghatsad.onTrade = function(playerArg, npc, trade)
                return zxi.ghatsadFrames.onTrade(playerArg, npc, trade, baseOnTrade)
            end
        end
    end)

    after_each(function()
        ghatsad.onTrade = baseOnTrade
    end)

    it('takes Tigerfangs for Valoredge', function()
        trade(2, valoredge, xi.item.TIGERFANGS, 624)

        assert(player:getCharVar('PUP_AttachmentStatus') == 5, 'the Valoredge materials were not accepted')
    end)

    it('refuses Patas for Valoredge', function()
        trade(2, valoredge, xi.item.PATAS)

        assert(player:getCharVar('PUP_AttachmentStatus') == 2, 'Patas were accepted')
    end)

    it('takes a Repeating Crossbow for Sharpshot', function()
        trade(3, sharpshot, xi.item.REPEATING_CROSSBOW, 624)

        assert(player:getCharVar('PUP_AttachmentStatus') == 6, 'the Sharpshot materials were not accepted')
    end)

    it('refuses a Heavy Crossbow for Sharpshot', function()
        trade(3, sharpshot, xi.item.HEAVY_CROSSBOW)

        assert(player:getCharVar('PUP_AttachmentStatus') == 3, 'the Heavy Crossbow was accepted')
    end)
end)
