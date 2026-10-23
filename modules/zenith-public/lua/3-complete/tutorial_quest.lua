-----------------------------------
-- Tutorial NPC quests up to the Raising Earring (ZENITHDEV-212)
-- Gulldago (Bastok Markets), Alaune (Southern San d'Oria), Selele (Windurst Woods).
--
-- The quest line ended with the Raising Earring when it was added in 2008. The April 2026 update
-- added a Records of Eminence step and five steps after the earring. The 2008 cutscenes are no
-- longer in the client, so this is base's modern quest (scripts/quests/hiddenQuests/Tutorial_Quest.lua,
-- steps 0 to 7) as its own quest, which replaces base's:
--   Step 5 (Records of Eminence) rewards without the Memorandoll, so RoE does not have to be
--          enabled, and the key item is never handed out.
--   Step 7 (Raising Earring) is the last step; base's later steps do not exist here.
-- Being a copy, base changes to Tutorial_Quest.lua do not affect it. The earring cutscene still tells
-- the player to get a trust permit; cutscene text is client side.
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_tutorialQuest')

local baseQuestFile = 'scripts/quests/hiddenQuests/Tutorial_Quest'
local progFinished  = 8

local quest = HiddenQuest:new('ZenithTutorial')

local function hasLearntWeaponskill(player)
    for skillId = xi.skill.HAND_TO_HAND, xi.skill.STAFF do
        if player:getSkillLevel(skillId) >= 5 then
            return true
        end
    end

    return false
end

quest.sections =
{
    -- Step 0 -> Introduction.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 0
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] = quest:progressEvent(719),

            onEventFinish =
            {
                [719] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] = quest:progressEvent(3662),

            onEventFinish =
            {
                [3662] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] = quest:progressEvent(1010),

            onEventFinish =
            {
                [1010] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 1)
                end,
            },
        },
    },

    -- Step 1 -> Instruct to get Signet.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 1
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] = quest:progressEvent(697),

            onEventFinish =
            {
                [697] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] = quest:progressEvent(3640),

            onEventFinish =
            {
                [3640] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] = quest:progressEvent(988),

            onEventFinish =
            {
                [988] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 2)
                end,
            },
        },
    },

    -- Step 2 -> Talk to NPC after getting Signet (Reward: Meat Jerky x6.). Instruct to eat.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 2
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.SIGNET) then
                        return quest:progressEvent(699)
                    else
                        return quest:event(698)
                    end
                end,
            },

            onEventFinish =
            {
                [699] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.STRIP_OF_MEAT_JERKY, 6 } }) then
                        quest:setVar(player, 'Prog', 3)
                    end
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.SIGNET) then
                        return quest:progressEvent(3642)
                    else
                        return quest:event(3641)
                    end
                end,
            },

            onEventFinish =
            {
                [3642] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.STRIP_OF_MEAT_JERKY, 6 } }) then
                        quest:setVar(player, 'Prog', 3)
                    end
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.SIGNET) then
                        return quest:progressEvent(990)
                    else
                        return quest:event(989)
                    end
                end,
            },

            onEventFinish =
            {
                [990] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.STRIP_OF_MEAT_JERKY, 6 } }) then
                        quest:setVar(player, 'Prog', 3)
                    end
                end,
            },
        },
    },

    -- Step 3 -> Talk to NPC after having eaten. Instruct to learn a weaponskill.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 3
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.FOOD) then
                        return quest:progressEvent(701)
                    else
                        return quest:event(700)
                    end
                end,
            },

            onEventFinish =
            {
                [701] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.FOOD) then
                        return quest:progressEvent(3644)
                    else
                        return quest:event(3643)
                    end
                end,
            },

            onEventFinish =
            {
                [3644] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] =
            {
                onTrigger = function(player, npc)
                    if player:hasStatusEffect(xi.effect.FOOD) then
                        return quest:progressEvent(992)
                    else
                        return quest:event(991)
                    end
                end,
            },

            onEventFinish =
            {
                [992] = function(player, csid, option, npc)
                    quest:setVar(player, 'Prog', 4)
                end,
            },
        },
    },

    -- Step 4 -> Talk to NPC after learning a Weaponskill (Reward: 100 gil). Instruct to activate Records of Eminence. NOTE: Retail does NOT check for weaponskill usage.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 4
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] =
            {
                onTrigger = function(player, npc)
                    if hasLearntWeaponskill(player) then
                        return quest:progressEvent(703)
                    else
                        return quest:event(702)
                    end
                end,
            },

            onEventFinish =
            {
                [703] = function(player, csid, option, npc)
                    npcUtil.giveCurrency(player, 'gil', 100 * xi.settings.main.GIL_RATE)
                    quest:setVar(player, 'Prog', 5)
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] =
            {
                onTrigger = function(player, npc)
                    if hasLearntWeaponskill(player) then
                        return quest:progressEvent(3646)
                    else
                        return quest:event(3645)
                    end
                end,
            },

            onEventFinish =
            {
                [3646] = function(player, csid, option, npc)
                    npcUtil.giveCurrency(player, 'gil', 100 * xi.settings.main.GIL_RATE)
                    quest:setVar(player, 'Prog', 5)
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] =
            {
                onTrigger = function(player, npc)
                    if hasLearntWeaponskill(player) then
                        return quest:progressEvent(994)
                    else
                        return quest:event(993)
                    end
                end,
            },

            onEventFinish =
            {
                [994] = function(player, csid, option, npc)
                    npcUtil.giveCurrency(player, 'gil', 100 * xi.settings.main.GIL_RATE)
                    quest:setVar(player, 'Prog', 5)
                end,
            },
        },
    },

    -- Step 5 -> Talk to NPC again, no Memorandoll needed (Reward: Crystal and 2 items). Instruct to check the AH.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 5
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] = quest:progressEvent(705), -- Zenith: no Memorandoll needed

            onEventFinish =
            {
                [705] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.LIZARD_TAIL, 1 }, { xi.item.POT_OF_HONEY, 1 }, { xi.item.FIRE_CRYSTAL, 1 } }) then
                        quest:setVar(player, 'Prog', 6)
                    end
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] = quest:progressEvent(3648), -- Zenith: no Memorandoll needed

            onEventFinish =
            {
                [3648] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.CHUNK_OF_ROCK_SALT, 1 }, { xi.item.SLICE_OF_HARE_MEAT, 1 }, { xi.item.FIRE_CRYSTAL, 1 } }) then
                        quest:setVar(player, 'Prog', 6)
                    end
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] = quest:progressEvent(996), -- Zenith: no Memorandoll needed

            onEventFinish =
            {
                [996] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, { { xi.item.BIRD_EGG, 1 }, { xi.item.POT_OF_HONEY, 1 }, { xi.item.WATER_CRYSTAL, 1 } }) then
                        quest:setVar(player, 'Prog', 6)
                    end
                end,
            },
        },
    },

    -- Step 6 -> Talk to NPC after checking the AH (Reward: Conquest promotion voucher). Instruct to reach level 5.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 6
        end,

        [xi.zone.AHT_URHGAN_WHITEGATE] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },

            ['Gulldago'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 1 then
                        return quest:progressEvent(707)
                    else
                        return quest:event(706)
                    end
                end,
            },

            onEventFinish =
            {
                [707] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.keyItem.CONQUEST_PROMOTION_VOUCHER)
                    quest:setVar(player, 'Prog', 7)
                    quest:setVar(player, 'Option', 0)
                end,
            },
        },

        [xi.zone.BASTOK_MINES] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.EASTERN_ADOULIN] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.LOWER_JEUNO] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.PORT_SAN_DORIA] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.RULUDE_GARDENS] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },

            ['Alaune'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 1 then
                        return quest:progressEvent(3650)
                    else
                        return quest:event(3649)
                    end
                end,
            },

            onEventFinish =
            {
                [3650] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.keyItem.CONQUEST_PROMOTION_VOUCHER)
                    quest:setVar(player, 'Prog', 7)
                    quest:setVar(player, 'Option', 0)
                end,
            },
        },

        [xi.zone.WESTERN_ADOULIN] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.WINDURST_WALLS] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Auction_Counter'] =
            {
                onTrigger = function(player, npc)
                    quest:setVar(player, 'Option', 1)
                    player:sendMenu(xi.menuType.AUCTION)
                    return quest:noAction()
                end,
            },

            ['Selele'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'Option') == 1 then
                        return quest:progressEvent(998)
                    else
                        return quest:event(997)
                    end
                end
            },

            onEventFinish =
            {
                [998] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.keyItem.CONQUEST_PROMOTION_VOUCHER)
                    quest:setVar(player, 'Prog', 7)
                    quest:setVar(player, 'Option', 0)
                end,
            },
        },
    },

    -- Step 7 -> Talk to NPC after reaching level 5 (Reward: Raising Earring). Last step.
    {
        check = function(player, questVars, vars)
            return questVars.Prog == 7
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] =
            {
                onTrigger = function(player, npc)
                    if player:getMainLvl() >= 5 then
                        return quest:progressEvent(709)
                    else
                        return quest:event(708)
                    end
                end,
            },

            onEventFinish =
            {
                [709] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, xi.item.RAISING_EARRING) then
                        quest:setVar(player, 'Prog', progFinished)
                    end
                end,
            },
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] =
            {
                onTrigger = function(player, npc)
                    if player:getMainLvl() >= 5 then
                        return quest:progressEvent(3652)
                    else
                        return quest:event(3651)
                    end
                end,
            },

            onEventFinish =
            {
                [3652] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, xi.item.RAISING_EARRING) then
                        quest:setVar(player, 'Prog', progFinished)
                    end
                end,
            },
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] =
            {
                onTrigger = function(player, npc)
                    if player:getMainLvl() >= 5 then
                        return quest:progressEvent(1000)
                    else
                        return quest:event(999)
                    end
                end,
            },

            onEventFinish =
            {
                [1000] = function(player, csid, option, npc)
                    if npcUtil.giveItem(player, xi.item.RAISING_EARRING) then
                        quest:setVar(player, 'Prog', progFinished)
                    end
                end,
            },
        },
    },

    -- Default dialog after completing tutorial.
    {
        check = function(player, questVars, vars)
            return questVars.Prog >= progFinished
        end,

        [xi.zone.BASTOK_MARKETS] =
        {
            ['Gulldago'] = quest:event(718),
        },

        [xi.zone.SOUTHERN_SAN_DORIA] =
        {
            ['Alaune'] = quest:event(3661),
        },

        [xi.zone.WINDURST_WOODS] =
        {
            ['Selele'] = quest:event(1009),
        },
    },
}

m:addOverride('xi.server.onServerStart', function()
    super()

    -- Base's quest would answer the same NPCs, so it is taken out
    local base = utils.prequire(baseQuestFile)
    if not base or not InteractionGlobal.lookup.containers[base.id] then
        print(string.format('[tutorial_quest] Error: %s not found, base tutorial quest is not replaced', baseQuestFile))
        return
    end

    InteractionGlobal.lookup:removeContainer(base)
    InteractionGlobal.lookup:addContainer(quest)
end)

return m
