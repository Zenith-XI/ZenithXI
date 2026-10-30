-- ZenithXI guild master rank cap (modules/zenith-public/lua/3-complete/guild_master_rank_cap.lua).
--
-- Guild masters promote up to Veteran. A Veteran is offered no test item, and cannot hand one in.
-- The guild master functions take a player and an NPC, so plain tables stand in for both.

describe('Zenith guild master rank cap', function()
    local masters =
    {
        { name = 'Thubu_Parohren', skill = xi.skill.FISHING      },
        { name = 'Cheupirudaux',   skill = xi.skill.WOODWORKING  },
        { name = 'Ghemp',          skill = xi.skill.SMITHING     },
        { name = 'Mevreauche',     skill = xi.skill.SMITHING     },
        { name = 'Reinberta',      skill = xi.skill.GOLDSMITHING },
        { name = 'Ponono',         skill = xi.skill.CLOTHCRAFT   },
        { name = 'Faulpie',        skill = xi.skill.LEATHERCRAFT },
        { name = 'Peshi_Yohnts',   skill = xi.skill.BONECRAFT    },
        { name = 'Abd-al-Raziq',   skill = xi.skill.ALCHEMY      },
        { name = 'Piketo-Puketo',  skill = xi.skill.COOKING      },
    }

    local function fakePlayer(rank)
        local player = { rank = rank }

        player.getSkillRank = function(self) return self.rank end
        player.setSkillRank = function(self, _, newRank) self.rank = newRank end
        player.getCharSkillLevel = function(self) return (self.rank + 1) * 100 end
        player.getCharVar = function() return 0 end
        player.hasKeyItem = function() return false end
        player.tradeComplete = function() end
        player.startEvent = function(self, _, testItem) self.offered = testItem end

        return player
    end

    for _, master in ipairs(masters) do
        describe(master.name, function()
            local npc = { getName = function() return master.name end }

            local matched

            before_each(function()
                matched = false
                stub('npcUtil.tradeMatches', function()
                    matched = true

                    return true
                end)
            end)

            -- An offered test is an item ID. Without one, the first event parameter is the time.
            it('offers a test below Veteran', function()
                local player = fakePlayer(xi.craftRank.VETERAN - 1)

                xi.crafting.guildMasterOnTrigger(player, npc)

                assert(player.offered < 65536, 'no test offered')
            end)

            it('promotes to Veteran', function()
                local player = fakePlayer(xi.craftRank.VETERAN - 1)

                xi.crafting.guildMasterOnTrade(player, npc, {})

                assert(player.rank == xi.craftRank.VETERAN, 'not promoted to Veteran')
            end)

            it('offers no test at Veteran', function()
                local player = fakePlayer(xi.craftRank.VETERAN)

                xi.crafting.guildMasterOnTrigger(player, npc)

                assert(player.offered > 65536, 'a test was offered')
            end)

            it('takes no test item at Veteran', function()
                local player = fakePlayer(xi.craftRank.VETERAN)

                xi.crafting.guildMasterOnTrade(player, npc, {})

                assert(player.rank == xi.craftRank.VETERAN, 'promoted past Veteran')
                assert(not matched, 'the trade was looked at')
            end)
        end)
    end

    it('leaves the skill cap of a Veteran alone', function()
        assert(xi.crafting.getCraftSkillCap(fakePlayer(xi.craftRank.VETERAN), xi.skill.SMITHING) == 100, 'the skill cap changed')
    end)
end)
