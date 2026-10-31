-----------------------------------
-- Guild master rank cap (ZENITHDEV-275)
-- Guild masters do not offer a test or a promotion past Veteran. They decide that by comparing the skill level
-- to getCraftSkillCap, so during these two calls a Veteran's cap is out of reach. Skill caps do not change.
-- Based on Phoenix's modules/phoenix/lua/globals/hobbies/crafting/guild_master_rank_cap.lua
-----------------------------------
require('modules/module_utils')
require('scripts/globals/hobbies/crafting/guild_master')
-----------------------------------
local m = Module:new('c_guildMasterRankCap')

local unreachableCap = 110

local function withVeteranAsTopRank(func, player, npc, trade)
    local getCraftSkillCap = xi.crafting.getCraftSkillCap

    xi.crafting.getCraftSkillCap = function(target, skillId)
        if target:getSkillRank(skillId) >= xi.craftRank.VETERAN then
            return unreachableCap
        end

        return getCraftSkillCap(target, skillId)
    end

    local ok, err = pcall(func, player, npc, trade)

    xi.crafting.getCraftSkillCap = getCraftSkillCap

    if not ok then
        error(err, 0)
    end
end

m:addOverride('xi.crafting.guildMasterOnTrigger', function(player, npc)
    withVeteranAsTopRank(super, player, npc)
end)

m:addOverride('xi.crafting.guildMasterOnTrade', function(player, npc, trade)
    withVeteranAsTopRank(super, player, npc, trade)
end)

return m
