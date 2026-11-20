-----------------------------------
-- All in the Cards once per conquest tally (ZENITHDEV-263)
-- Chululu hands out Tarut Cards (and offers the repeat) once per conquest tally instead of once per Earth day.
-- The quest stores its next allowed time in the quest var 'Date', which base sets to JstMidnight() whenever
-- cards are given or the quest is turned in. Each onEventFinish handler of the quest is wrapped: after base
-- has run, a 'Date' of JstMidnight() becomes NextConquestTally(). Rewards, completion, repeatability and
-- the Collect Tarut Cards quest are unchanged.
--
-- The new batch is also raised above progress priority (ZXIALPHA-148). Until Rubbish Day is offered,
-- Chululu answers with its compatibility test as a progress event, which outranks the base batch event,
-- so a player who had not started Rubbish Day never got a new batch. The reminder keeps the base
-- priority, so the compatibility test can still be reached while the timer runs.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_allInTheCardsTally')

m:addOverride('xi.server.onServerStart', function()
    super()

    xi.module.modifyInteractionEntry('scripts/quests/jeuno/All_in_the_Cards', function(quest)
        -- Section 3 is the accepted quest.
        quest.sections[3][xi.zone.LOWER_JEUNO]['Chululu'].onTrigger = function(player, npc)
            if GetSystemTime() > quest:getVar(player, 'Date') then
                -- Above progress, or the tie with Rubbish Day makes Chululu alternate between the two
                return quest:progressEvent(10112):setPriority(Action.Priority.Progress + 1) -- A new batch of cards
            else
                return quest:event(10111) -- Reminder
            end
        end

        for _, section in ipairs(quest.sections) do
            for _, zoneHandlers in pairs(section) do
                if
                    type(zoneHandlers) == 'table' and
                    type(zoneHandlers.onEventFinish) == 'table'
                then
                    for csid, baseHandler in pairs(zoneHandlers.onEventFinish) do
                        zoneHandlers.onEventFinish[csid] = function(player, csidArg, option, npc)
                            local result = baseHandler(player, csidArg, option, npc)

                            if quest:getVar(player, 'Date') == JstMidnight() then
                                quest:setVar(player, 'Date', NextConquestTally())
                            end

                            return result
                        end
                    end
                end
            end
        end
    end)
end)

return m
