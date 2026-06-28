-- -- -----------------------------------
-- -- Dragoon Adjustments Module
-- --
-- -- This module overrides the base behaviour of Dragoon job abilities.
-- -- -----------------------------------

require('modules/module_utils')

local m = Module:new('b_dragoon_adjustments')

local wyvernMods = {
    { xi.mod.ACC, 1 },
    { xi.mod.HPP, 3 },
    { xi.mod.ATTP, 1 },
}

local playerMods = {
    { xi.mod.ATTP, 2 },
    { xi.mod.DEFP, 2 },
    { xi.mod.HASTE_ABILITY, 100 },
    { xi.mod.ALL_WSDMG_ALL_HITS, 2 },
}

m:addOverride('xi.job_utils.dragoon.addWyvernExp', function(player, ability)
    local numLevelUps = super(player, ability)

    if numLevelUps > 0 then
        local wyvern = player:getPet()

        -- Trim the pet buffs down to ACC+5, HPP+3, ATTP+4 per lvl
        for _, mod in ipairs(wyvernMods) do
            wyvern:delMod(mod[1], mod[2] * numLevelUps)
        end

        -- Cut all the player buffs in half
        for _, mod in ipairs(playerMods) do
            player:delMod(mod[1], mod[2] * numLevelUps)
        end
    end

    return numLevelUps
end)

m:addOverride('xi.pets.wyvern.removeWyvernLevels', function(mob)
    local master  = mob:getMaster()
    local numLvls = mob:getLocalVar('level_Ups')

    -- The player only ever received the trimmed buffs (see the addWyvernExp override),
    -- but base removeWyvernLevels deletes the full base amounts. Re-add the trimmed delta
    -- first so the net removal matches what the player actually has.
    -- NOTE: the wyvern's onMobDeath is invoked with a nil killer arg, so the player must
    -- be resolved via mob:getMaster() rather than a function parameter.
    if master and numLvls > 0 then
        for _, mod in ipairs(playerMods) do
            master:addMod(mod[1], mod[2] * numLvls)
        end
    end

    super(mob)
end)

return m
