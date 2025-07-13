-----------------------------------
-- ID: 4247
-- Item: Page From Miratete's Memo
-- Grants 1,250 - 2,000 EXP
-- Does not grant Limit Points.
-----------------------------------
---@type TItem
local itemObject = {}

itemObject.onItemCheck = function(target, item, param, caster)
    local check = 56
    if target:getMainLvl() >= 20 then
        check = 0
    end

    return check
end

itemObject.onItemUse = function(target)
    target:addExp(xi.settings.main.EXP_RATE * math.random(1250, 2000))
end

return itemObject
