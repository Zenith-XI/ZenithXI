-- ZenithXI trust limits and cooldowns (modules/zenith-public/lua/2-base/trusts.lua).
--
-- Changes against LSB's xi.trust.canCast / xi.trust.spawn / npcUtil.completeQuest:
-- - one trust at a time, two at level 50+ once LB1 (In Defiant Challenge) is done ([TRUST]Additional);
--   LSB allows three
-- - every call starts a 15 minute cooldown in [TRUST]Cooldown1, or in [TRUST]Cooldown2 when slot 1 is
--   busy and LB1 is done; a call is blocked while every slot the player has is cooling down
-- - a player seeking a party may call trusts (LSB refuses), and the LFP flag comes back afterwards
-- - completing In Defiant Challenge for the first time sets [TRUST]Additional
-- The seeking-party bypass is not covered: it calls player:setSeekingParty, which the C++ module
-- modules/zenith-public/cpp/lfp_with_trusts.cpp binds. C++ modules are built into xi_map only, not
-- xi_test, so under xi_test that path raises "attempt to call method 'setSeekingParty'".
-- Trusts are put in the party with spawnTrust and the clock is moved past LSB's 120 s
-- "a member just joined" block, so a refusal can only come from the module's own limits.

describe('Zenith trust limits', function()
    ---@type CClientEntityPair
    local player

    local cooldownTime = 15 * 60

    local function canCast(spellId)
        return xi.trust.canCast(GetPlayerByID(player:getID()), GetSpell(spellId))
    end

    local function trustCount()
        local count = 0
        for _, member in ipairs(player:getPartyWithTrusts()) do
            if member:isTrust() then
                count = count + 1
            end
        end

        return count
    end

    -- Puts trusts in the party without casting, then waits out LSB's new-member block.
    local function withTrusts(...)
        for _, spellId in ipairs({ ... }) do
            player:spawnTrust(spellId)
            xi.test.world:skipTime(1)
        end

        xi.test.world:skipTime(121)
        assert(trustCount() == select('#', ...), string.format('precondition: expected %d trusts, got %d', select('#', ...), trustCount()))
        assert(GetSystemTime() - player:getPartyLastMemberJoinedTime() >= 120, 'precondition: LSB still blocks a new party member')
    end

    local function unlockSecondSlot()
        player:setCharVar('[TRUST]Additional', 1)
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 75 })
        assert(player:getGMLevel() == 0, 'precondition: the test character is a GM, LSB lets GMs call anything')
        assert(canCast(xi.magic.spell.SHANTOTTO) == 0, 'precondition: a fresh solo player cannot call a trust here')
    end)

    it('starts the slot 1 cooldown when a trust is called #trusts', function()
        player:addSpell(xi.magic.spell.SHANTOTTO)
        local before = GetSystemTime()

        player.actions:useSpell(player, xi.magic.spell.SHANTOTTO)
        for _ = 1, 5 do
            xi.test.world:skipTime(2)
        end

        assert(trustCount() == 1, 'precondition: the Shantotto cast did not summon her')

        local cooldown = player:getCharVar('[TRUST]Cooldown1')
        assert(cooldown >= before + cooldownTime and cooldown <= GetSystemTime() + cooldownTime,
            string.format('expected a cooldown about %d s out, got %d (now %d)', cooldownTime, cooldown, GetSystemTime()))
    end)

    it('refuses a call while slot 1 cools down without the LB1 unlock', function()
        player:setCharVar('[TRUST]Cooldown1', GetSystemTime() + 600)

        local result = canCast(xi.magic.spell.SHANTOTTO)

        assert(result == xi.msg.basic.TRUST_NO_CAST_TRUST, string.format('expected the cooldown refusal %d, got %d', xi.msg.basic.TRUST_NO_CAST_TRUST, result))
    end)

    it('allows a call on slot 2 while slot 1 cools down, and refuses once both cool down', function()
        unlockSecondSlot()
        player:setCharVar('[TRUST]Cooldown1', GetSystemTime() + 600)

        -- Control: slot 2 is free, so this passes with or without the module.
        assert(canCast(xi.magic.spell.SHANTOTTO) == 0, 'slot 1 cooling down blocked a player with a free slot 2')

        player:setCharVar('[TRUST]Cooldown2', GetSystemTime() + 300)
        local result = canCast(xi.magic.spell.SHANTOTTO)

        assert(result == xi.msg.basic.TRUST_NO_CAST_TRUST, string.format('expected the cooldown refusal %d, got %d', xi.msg.basic.TRUST_NO_CAST_TRUST, result))
    end)

    it('records the cooldown in slot 2 when slot 1 is busy after the LB1 unlock', function()
        unlockSecondSlot()
        local slot1 = GetSystemTime() + 600
        player:setCharVar('[TRUST]Cooldown1', slot1)

        xi.trust.spawn(GetPlayerByID(player:getID()), GetSpell(xi.magic.spell.SHANTOTTO))
        xi.test.world:skipTime(1)

        local slot2 = player:getCharVar('[TRUST]Cooldown2')
        assert(slot2 >= GetSystemTime() + cooldownTime - 5, string.format('expected a slot 2 cooldown about %d s out, got %d (now %d)', cooldownTime, slot2, GetSystemTime()))
        assert(player:getCharVar('[TRUST]Cooldown1') == slot1, 'the busy slot 1 cooldown was overwritten')
    end)

    it('allows only one trust before the LB1 unlock', function()
        withTrusts(xi.magic.spell.SHANTOTTO)

        local result = canCast(xi.magic.spell.NAJI)

        assert(result == -1, string.format('expected the trust limit refusal -1, got %d (LSB allows three)', result))
    end)

    it('allows two trusts at level 50 after the LB1 unlock, and no third', function()
        unlockSecondSlot()
        player:setLevel(50)
        withTrusts(xi.magic.spell.SHANTOTTO)

        -- Control: LSB allows this too.
        assert(canCast(xi.magic.spell.NAJI) == 0, 'a level 50 player with LB1 could not call a second trust')

        player:spawnTrust(xi.magic.spell.NAJI)
        xi.test.world:skipTime(121)
        assert(trustCount() == 2, 'precondition: Naji did not join')

        local result = canCast(xi.magic.spell.KUPIPI)
        assert(result == -1, string.format('expected the trust limit refusal -1, got %d (LSB allows three)', result))
    end)

    it('keeps the one trust limit below level 50 even after the LB1 unlock', function()
        unlockSecondSlot()
        player:setLevel(49)
        withTrusts(xi.magic.spell.SHANTOTTO)

        local result = canCast(xi.magic.spell.NAJI)

        assert(result == -1, string.format('expected the trust limit refusal -1, got %d', result))
    end)

    it('unlocks the second slot on the first In Defiant Challenge completion', function()
        assert(player:getCharVar('[TRUST]Additional') == 0, 'precondition: the second slot is already unlocked')

        npcUtil.completeQuest(GetPlayerByID(player:getID()), xi.questLog.JEUNO, xi.quest.id.jeuno.IN_DEFIANT_CHALLENGE, {})

        assert(player:hasCompletedQuest(xi.questLog.JEUNO, xi.quest.id.jeuno.IN_DEFIANT_CHALLENGE), 'precondition: the quest was not completed')
        assert(player:getCharVar('[TRUST]Additional') == 1, 'completing In Defiant Challenge did not unlock the second trust slot')
    end)
end)
