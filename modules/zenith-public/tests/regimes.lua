-- ZenithXI daily Page of Valor lock (modules/zenith-public/lua/2-base/regimes.lua).
--
-- LSB keeps counting kills (and pays page EXP) after the daily gil/tab reward was claimed, and only
-- skips the gil and tabs. The module blocks the whole regime until the next Vana'diel day: no kill
-- credit, and a system message on every kill of a mob on the active page. It relies on
-- 101-RegimeRestrictions.patch keeping '[regime]lastReward' when the regime vars are cleared.
--
-- Setup: West Ronfaure FoV regime 2 (Forest Hare x6, index 1). checkKillCredit needs the mob to
-- hold the player's level (m_HiPCLvl), so the direct-call cases give the player damage enmity on it first.

describe('Zenith regime daily lock', function()
    local regimeId    = 2
    local regimeIndex = 1
    local waitMessage = 'You must wait until the next game day to complete another Page of Valor'

    ---@type CClientEntityPair
    local player
    ---@type CTestEntity
    local mob

    local function startRegime(lastReward)
        player:setCharVar('[regime]type', xi.regime.type.FIELDS)
        player:setCharVar('[regime]zone', xi.zone.WEST_RONFAURE)
        player:setCharVar('[regime]id', regimeId)
        player:setCharVar('[regime]repeat', 0)
        player:setCharVar('[regime]needed1', 6)
        player:setCharVar('[regime]killed1', 0)
        player:setCharVar('[regime]lastReward', lastReward)
    end

    local function creditKill(id)
        xi.regime.checkRegime(GetPlayerByID(player:getID()), GetMobByID(mob:getID()), id or regimeId, regimeIndex, xi.regime.type.FIELDS)
    end

    -- How many CHAT_STD (0x017) packets since the last clear carry the wait message. Text starts at 0x17.
    local function waitMessagesSent()
        local count = 0
        for _, packet in ipairs(player.packets:getIncoming()) do
            if packet.type == 0x017 then
                local text = ''
                for i = 0x17, packet.size - 1 do
                    local byte = packet.data[i]
                    if byte == nil or byte == 0 then
                        break
                    end

                    text = text .. string.char(byte)
                end

                if text == waitMessage then
                    count = count + 1
                end
            end
        end

        return count
    end

    before_each(function()
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.WAR, level = 1 })
        mob    = player.entities:moveTo('Forest_Hare')
        mob:respawn()
        player.entities:moveTo(mob)

        -- Records the player's level on the mob, which checkKillCredit reads
        GetMobByID(mob:getID()):updateEnmityFromDamage(GetPlayerByID(player:getID()), 1)
        player.packets:clear()
    end)

    -- Control: passes with and without the module. Guards the setup the other cases rely on.
    it('counts a kill without a warning while today\'s page reward is unclaimed', function()
        startRegime(0)

        creditKill()

        local killed = player:getCharVar('[regime]killed1')
        local sent   = waitMessagesSent()
        assert(killed == 1, string.format('precondition: an unclaimed day should credit the kill, killed1 = %d', killed))
        assert(sent == 0, string.format('a credited kill should not warn, got %d wait messages', sent))
    end)

    it('gives no kill credit once today\'s page reward was claimed', function()
        startRegime(VanadielUniqueDay())

        creditKill()

        local killed = player:getCharVar('[regime]killed1')
        assert(killed == 0, string.format('kill was credited after the daily reward (LSB behaviour), killed1 = %d', killed))
    end)

    -- ZXIALPHA-24: the warning used to be sent once per zone, so every later blocked kill was silent.
    it('warns on every blocked kill, not just the first', function()
        startRegime(VanadielUniqueDay())

        creditKill()

        local sent = waitMessagesSent()
        assert(sent == 1, string.format('expected the wait message on the first blocked kill, got %d', sent))

        player.packets:clear()
        creditKill()

        sent = waitMessagesSent()
        local killed = player:getCharVar('[regime]killed1')
        assert(sent == 1, string.format('expected the wait message again on the second blocked kill, got %d', sent))
        assert(killed == 0, string.format('second kill was credited after the daily reward, killed1 = %d', killed))
    end)

    -- Guard: passes with and without the module. A mob that is not on the active page stays silent.
    it('does not warn for a mob that is not on the active page', function()
        startRegime(VanadielUniqueDay())

        creditKill(regimeId + 1)

        local sent = waitMessagesSent()
        assert(sent == 0, string.format('a mob from another page should not warn, got %d wait messages', sent))
    end)

    -- Guard: passes with and without the module. The lock lifts on the next Vana'diel day.
    it('credits again on the next Vana\'diel day', function()
        startRegime(VanadielUniqueDay() - 1)

        creditKill()

        local killed = player:getCharVar('[regime]killed1')
        local sent   = waitMessagesSent()
        assert(killed == 1, string.format('a new day should credit the kill, killed1 = %d', killed))
        assert(sent == 0, string.format('a new day should not warn, got %d wait messages', sent))
    end)

    -- Control: passes with and without the module. Proves a real kill reaches checkRegime and earns
    -- credit, so the next case cannot pass just because the kill never counted.
    it('credits a real kill while today\'s page reward is unclaimed', function()
        startRegime(0)

        player:claimAndKillMob(mob)

        local killed = player:getCharVar('[regime]killed1')
        assert(killed == 1, string.format('precondition: a real Forest Hare kill should credit regime 2, killed1 = %d', killed))
    end)

    -- Goes in from the side LSB calls: Forest Hare's onMobDeath calls xi.regime.checkRegime.
    it('blocks credit from a real kill after the daily reward and says why', function()
        startRegime(VanadielUniqueDay())

        player:claimAndKillMob(mob)

        assert(mob:isDead(), 'precondition: Forest Hare should be dead')
        local killed = player:getCharVar('[regime]killed1')
        local sent   = waitMessagesSent()
        assert(killed == 0, string.format('real kill was credited after the daily reward (LSB behaviour), killed1 = %d', killed))
        assert(sent == 1, string.format('expected the wait message on the real blocked kill, got %d', sent))
    end)
end)
