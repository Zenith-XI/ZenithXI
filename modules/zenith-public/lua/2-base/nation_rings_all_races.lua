-----------------------------------
-- Module: Nation Rings for All Races
-- Ensures all new characters receive the nation ring for their
-- chosen starting nation, regardless of race selection.
--
-- Base behavior only gives the ring if the race's "home nation"
-- matches the chosen nation. This module removes that restriction.
-----------------------------------
local m = Module:new('b_nation_rings_all_races')

-- Map nations to their corresponding rings
local nationRings =
{
    [xi.nation.SANDORIA] = xi.item.SAN_DORIAN_RING,
    [xi.nation.BASTOK]   = xi.item.BASTOKAN_RING,
    [xi.nation.WINDURST] = xi.item.WINDURSTIAN_RING,
}

m:addOverride('xi.player.charCreate', function(player)
    -- Call the original charCreate function
    super(player)

    -- Ensure player has their nation's ring regardless of race
    local nation = player:getNation()
    local ringId = nationRings[nation]

    if ringId and not player:hasItem(ringId) then
        player:addItem(ringId)
    end
end)

return m
