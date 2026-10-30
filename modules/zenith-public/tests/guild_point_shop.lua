-- ZenithXI out of era Guild Point rewards (modules/zenith-public/lua/3-complete/guild_point_shop.lua).
--
-- Blocked rewards take no Guild Points and give nothing, permitted ones still sell.
-- An item option is (category << 2) + index + (quantity << 9), a key item option is (3 << 2) + ((index + 1) << 5).
-- The module blocks rewards on server start, which xi_test does not run by itself.

describe('Zenith Guild Point rewards', function()
    ---@type CClientEntityPair
    local player
    local entity
    local notices

    local guilds =
    {
        { name = 'Fishing',      id = xi.guild.FISHING,      currency = 'guild_fishing',      keyItem = 3 },
        { name = 'Woodworking',  id = xi.guild.WOODWORKING,  currency = 'guild_woodworking',  keyItem = 4 },
        { name = 'Smithing',     id = xi.guild.SMITHING,     currency = 'guild_smithing',     keyItem = 4 },
        { name = 'Goldsmithing', id = xi.guild.GOLDSMITHING, currency = 'guild_goldsmithing', keyItem = 5 },
        { name = 'Clothcraft',   id = xi.guild.CLOTHCRAFT,   currency = 'guild_weaving',      keyItem = 4 },
        { name = 'Leathercraft', id = xi.guild.LEATHERCRAFT, currency = 'guild_leathercraft', keyItem = 3 },
        { name = 'Bonecraft',    id = xi.guild.BONECRAFT,    currency = 'guild_bonecraft',    keyItem = 3 },
        { name = 'Alchemy',      id = xi.guild.ALCHEMY,      currency = 'guild_alchemy',      keyItem = 6 },
        { name = 'Cooking',      id = xi.guild.COOKING,      currency = 'guild_cooking',      keyItem = 4 },
    }

    local function itemOption(index)
        local category = math.floor(index / 4) + 1

        return bit.lshift(category, 2) + index % 4 + bit.lshift(1, 9)
    end

    local function keyItemOption(index)
        return bit.lshift(3, 2) + bit.lshift(index + 1, 5)
    end

    before_each(function()
        xi.test.world:setSetting('main.ENABLE_WOTG', 0)
        xi.server.onServerStart()

        player = xi.test.world:spawnPlayer({ zone = xi.zone.NORTHERN_SAN_DORIA })
        entity = GetPlayerByID(player:getID())
        notices = 0

        for _, guild in ipairs(guilds) do
            entity:setSkillRank(xi.crafting.guildTable[guild.id][1], xi.craftRank.VETERAN)
            entity:setCurrency(guild.currency, 1000000)
        end

    end)

    -- Plays the part of the player, and counts the notices the module prints
    local function buy(guild, option)
        local proxy = setmetatable({
            printToPlayer = function()
                notices = notices + 1
            end,
        }, { __index = function(_, key)
            local value = entity[key]

            if type(value) == 'function' then
                return function(_, ...)
                    return value(entity, ...)
                end
            end

            return value
        end })

        xi.crafting.guildPointOnEventUpdate(proxy, option, entity, guild.id)
    end

    for _, guild in ipairs(guilds) do
        describe(guild.name, function()
            for _, slot in ipairs({ 4, 5, 6, 7 }) do
                it(string.format('blocks the reward in slot %d', slot), function()
                    local reward = xi.crafting.guildItemTable[guild.id][slot]

                    -- Fishing has no ring: Robber Rig sits with the crystals
                    if reward then
                        buy(guild, itemOption(slot))

                        assert(not entity:hasItem(reward.id), 'the reward was handed over')
                        assert(entity:getCurrency(guild.currency) == 1000000, 'Guild Points were taken')
                        assert(notices == 1, 'no notice')
                    end
                end)
            end

            it('blocks the out of era key item', function()
                local keyItem = xi.crafting.guildKeyItemTable[guild.id][guild.keyItem]

                buy(guild, keyItemOption(guild.keyItem))

                assert(not entity:hasKeyItem(keyItem.id), 'the key item was handed over')
                assert(entity:getCurrency(guild.currency) == 1000000, 'Guild Points were taken')
                assert(notices == 1, 'no notice')
            end)

            it('still sells the first reward', function()
                local reward = xi.crafting.guildItemTable[guild.id][0]

                buy(guild, itemOption(0))

                assert(entity:hasItem(reward.id), 'the reward was not handed over')
                assert(entity:getCurrency(guild.currency) == 1000000 - reward.cost, 'wrong Guild Point cost')
                assert(notices == 0, 'a notice for a permitted reward')
            end)
        end)
    end

    it('keeps the LSB price of Aurora and Twilight Crystals', function()
        assert(xi.crafting.hqCrystals[7].cost == 200, 'Aurora Crystal price changed')
        assert(xi.crafting.hqCrystals[8].cost == 200, 'Twilight Crystal price changed')
    end)
end)
