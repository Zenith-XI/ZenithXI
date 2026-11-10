-- ZenithXI All in the Cards (modules/zenith-public/lua/3-complete/all_in_the_cards_tally.lua, ZENITHDEV-263).
--
-- Chululu's next batch of Tarut Cards, and the next repeat of the quest, wait for the conquest tally
-- instead of JST midnight. The cards themselves and the quest completion are unchanged.
-- The module changes the quest on server start, which xi_test does not run by itself.
-- ZXIALPHA-148: with Collect Tarut Cards completed and Rubbish Day not yet offered, Rubbish Day's
-- compatibility test (progress event 199) outranked the base new-batch event 10112, so talking to
-- Chululu never gave a new batch. The module raises 10112 above progress priority.

describe('Zenith All in the Cards', function()
    ---@type CClientEntityPair
    local player
    local quest
    local chululu

    local tarutCards =
    {
        xi.item.TARUT_CARD_THE_FOOL,
        xi.item.TARUT_CARD_DEATH,
        xi.item.TARUT_CARD_THE_HERMIT,
        xi.item.TARUT_CARD_THE_KING,
    }

    local function finish(section, csid, option)
        quest.sections[section][xi.zone.LOWER_JEUNO].onEventFinish[csid](player, csid, option or 0, chululu)
    end

    local function cardsHeld()
        local count = 0
        for _, card in ipairs(tarutCards) do
            count = count + player:getItemCount(card)
        end

        return count
    end

    setup(function()
        xi.server.onServerStart()
        quest = require('scripts/quests/jeuno/All_in_the_Cards')
    end)

    before_each(function()
        player  = xi.test.world:spawnPlayer({ zone = xi.zone.LOWER_JEUNO })
        chululu = player.entities:get('Chululu')
    end)

    it('starts the quest with five cards and waits for the conquest tally', function()
        finish(1, 10110)

        assert(player:getQuestStatus(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS) == xi.questStatus.QUEST_ACCEPTED, 'the quest did not start')
        assert(cardsHeld() == 5, string.format('expected 5 Tarut Cards, got %d', cardsHeld()))
        assert(quest:getVar(player, 'Date') == NextConquestTally(), 'the next batch waits for JST midnight, not the conquest tally')
    end)

    it('gives a new batch of cards that waits for the conquest tally', function()
        player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS)
        finish(3, 10112)

        assert(cardsHeld() == 5, string.format('expected 5 Tarut Cards, got %d', cardsHeld()))
        assert(quest:getVar(player, 'Date') == NextConquestTally(), 'the next batch waits for JST midnight, not the conquest tally')
    end)

    it('gives a new batch on talking to Chululu before Rubbish Day is offered', function()
        player:completeQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.COLLECT_TARUT_CARDS)
        player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS)
        quest:setVar(player, 'Date', 1) -- the wait for the next batch is over

        assert(player:getQuestStatus(xi.questLog.JEUNO, xi.quest.id.jeuno.RUBBISH_DAY) == xi.questStatus.QUEST_AVAILABLE, 'precondition: Rubbish Day is not available')

        player.entities:gotoAndTrigger('Chululu', { eventId = 10112, finishOption = 0 })

        assert(cardsHeld() == 5, string.format('expected 5 Tarut Cards, got %d', cardsHeld()))
        assert(quest:getVar(player, 'Date') == NextConquestTally(), 'the next batch waits for JST midnight, not the conquest tally')
    end)

    -- Control, passes with or without the module: the reminder keeps the base priority on purpose, so
    -- Rubbish Day's compatibility test is still reachable while the timer runs.
    it('still plays the Rubbish Day compatibility test while the timer runs', function()
        player:completeQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.COLLECT_TARUT_CARDS)
        player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS)
        quest:setVar(player, 'Date', NextConquestTally())

        player.entities:gotoAndTrigger('Chululu', { eventId = 199, finishOption = 0 })

        assert(cardsHeld() == 0, string.format('expected no Tarut Cards, got %d', cardsHeld()))
    end)

    it('completes the quest and makes the repeat wait for the conquest tally', function()
        player:addQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS)
        finish(3, 10114)

        assert(player:getQuestStatus(xi.questLog.JEUNO, xi.quest.id.jeuno.ALL_IN_THE_CARDS) == xi.questStatus.QUEST_COMPLETED, 'the quest did not complete')
        assert(quest:getVar(player, 'Date') == NextConquestTally(), 'the repeat waits for JST midnight, not the conquest tally')
    end)
end)
