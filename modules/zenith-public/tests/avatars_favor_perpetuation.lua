-- ZenithXI Avatar's Favor perpetuation (modules/zenith-public/lua/3-complete/jobAbilities/avatars_favor_perpetuation.lua
-- and modules/zenith-public/git-patches/121-AvatarsFavorNoPerpetuationMultiplier.patch).
--
-- While Avatar's Favor is up, the avatar's perpetuation cost is 3 higher, 2 for Carbuncle, whether the avatar
-- was summoned before or after Favor. Spirits are exempt. Patch 121 removes LSB's x1.2 drain multiplier, so
-- the MP lost per tick goes up by exactly that much (SMN 75, no refresh: Ifrit 13 -> 16, Carbuncle 9 -> 11).

describe('Zenith Avatar\'s Favor perpetuation', function()
    ---@type CClientEntityPair
    local player

    local function addFavor()
        player:addStatusEffect(xi.effect.AVATARS_FAVOR, { power = 1, duration = 7200, origin = player, tick = 10 })
    end

    -- Summons the avatar, then checks the cost with and after Favor
    local function checkFavor(petId, increase)
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        player:spawnPet(petId)
        assert(player:getPet(), 'precondition: the avatar is summoned')

        local cost = player:getMod(xi.mod.AVATAR_PERPETUATION)

        addFavor()
        assert(player:getMod(xi.mod.AVATAR_PERPETUATION) == cost + increase, string.format('with Favor: expected %d, got %d', cost + increase, player:getMod(xi.mod.AVATAR_PERPETUATION)))

        player:delStatusEffect(xi.effect.AVATARS_FAVOR)
        assert(player:getMod(xi.mod.AVATAR_PERPETUATION) == cost, string.format('after Favor: expected %d, got %d', cost, player:getMod(xi.mod.AVATAR_PERPETUATION)))
    end

    -- Uses Favor, then summons the avatar. On summon the cost is set before the pet has a master (ZXIALPHA-128).
    local function checkSummonWithFavor(petId, expected)
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        addFavor()
        player:spawnPet(petId)
        assert(player:getPet(), 'precondition: the avatar is summoned')

        assert(player:getMod(xi.mod.AVATAR_PERPETUATION) == expected, string.format('summoned with Favor up: expected %d, got %d', expected, player:getMod(xi.mod.AVATAR_PERPETUATION)))
    end

    -- MP lost on one effect tick, without and then with Favor
    local function checkDrain(petId, without, with)
        player = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        player:setMod(xi.mod.REFRESH, 0)
        xi.test.world:setVanaDay(xi.day.DARKSDAY)
        player:spawnPet(petId)
        assert(player:getPet(), 'precondition: the avatar is summoned')

        local function drain()
            player:setMP(player:getMaxMP())
            local startMP = player:getMP()
            xi.test.world:tick(xi.tick.EFFECT)

            return startMP - player:getMP()
        end

        local lost = drain()
        assert(lost == without, string.format('precondition: without Favor expected to lose %d MP per tick, lost %d', without, lost))

        addFavor()
        lost = drain()
        assert(lost == with, string.format('with Favor: expected to lose %d MP per tick, lost %d', with, lost))
    end

    it('raises the perpetuation of Ifrit by 3 while Favor is up', function()
        checkFavor(xi.petId.IFRIT, 3)
    end)

    it('raises the perpetuation of Carbuncle by 2 while Favor is up', function()
        checkFavor(xi.petId.CARBUNCLE, 2)
    end)

    it('raises the perpetuation of Ifrit summoned while Favor is up', function()
        checkSummonWithFavor(xi.petId.IFRIT, 16)
    end)

    it('raises the perpetuation of Carbuncle summoned while Favor is up', function()
        checkSummonWithFavor(xi.petId.CARBUNCLE, 11)
    end)

    -- Control: passes with or without the module, guards against Favor reaching spirits
    it('leaves the perpetuation of spirits alone', function()
        checkFavor(xi.petId.FIRE_SPIRIT, 0)
        checkSummonWithFavor(xi.petId.FIRE_SPIRIT, 5)
    end)

    it('drains 3 more MP per tick with Ifrit while Favor is up', function()
        checkDrain(xi.petId.IFRIT, 13, 16)
    end)

    it('drains 2 more MP per tick with Carbuncle while Favor is up', function()
        checkDrain(xi.petId.CARBUNCLE, 9, 11)
    end)

    it('keeps the surcharge of other summoners when one Favor wears off', function()
        local first  = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        local second = xi.test.world:spawnPlayer({ zone = xi.zone.WEST_RONFAURE, job = xi.job.SMN, level = 75 })
        first:spawnPet(xi.petId.IFRIT)
        second:spawnPet(xi.petId.IFRIT)

        local cost = second:getMod(xi.mod.AVATAR_PERPETUATION)

        for _, summoner in ipairs({ first, second }) do
            summoner:addStatusEffect(xi.effect.AVATARS_FAVOR, { power = 1, duration = 7200, origin = summoner, tick = 10 })
        end

        first:delStatusEffect(xi.effect.AVATARS_FAVOR)

        -- A later recalculation for the second summoner still adds the surcharge
        xi.job_utils.summoner.applyPerpetuationCost(GetPlayerByID(second:getID()), second:getPet())
        assert(second:getMod(xi.mod.AVATAR_PERPETUATION) == cost + 3, 'the second summoner lost the Favor surcharge')
    end)
end)
