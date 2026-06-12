-----------------------------------
-- Experience Band/Ring Max Bonus Adjustments
-- Public Module for ZenithXI
-----------------------------------
-- Updates the maximum experience point bonus (subpower) for various
-- experience bonus items (bands and rings)
--
-- Item Configuration:
--   power    = EXP bonus percentage
--   duration = Effect duration in seconds
--   subpower = Maximum EXP bonus cap
-----------------------------------

local m = Module:new('c-i_exp_band_adj')

-----------------------------------
-- EXP Item Configuration Table
-----------------------------------
local expItems =
{
    chariot_band     = { power =  75, duration = 43200, subpower =  750 },  -- +75%, 720 min, 750 max
    empress_band     = { power =  50, duration = 43200, subpower = 1000 },  -- +50%, 720 min, 1000 max
    emperor_band     = { power =  50, duration = 43200, subpower = 2000 },  -- +50%, 720 min, 2000 max
    anniversary_ring = { power = 100, duration = 43200, subpower = 3000 },  -- +100%, 720 min, 3000 max
    decennial_ring   = { power = 100, duration = 43200, subpower = 4000 },  -- +100%, 720 min, 4000 max
    kupofrieds_ring  = { power = 100, duration = 86400, subpower = 6000 },  -- +100%, 24 hr, 6000 max
    caliber_ring     = { power = 150, duration = 43200, subpower =  750 },  -- +150%, 720 min, 750 max
    allied_ring      = { power = 150, duration = 43200, subpower = 9000 },  -- +150%, 720 min, 9000 max
}

-----------------------------------
-- Generate Overrides for All Items
-----------------------------------
for itemName, data in pairs(expItems) do
    local overridePath = string.format('xi.items.%s.onItemUse', itemName)
    m:addOverride(overridePath, function(target)
        xi.itemUtils.addItemExpEffect(target, xi.effect.DEDICATION, data.power, data.duration, data.subpower)
    end)
end

return m
