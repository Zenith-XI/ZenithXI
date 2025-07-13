-- Garrison improvements: grants outpost warps on victory

local m = Module:new('exp_scroll_adjustements')

-- Override the experience gained from Page from the Dragon Chronicles to 1000-1500
m:addOverride('xi.items.page_from_the_dragon_chronicles.onItemUse', function(target)   
    target:addExp(xi.settings.main.EXP_RATE * math.random(1000, 1500))
end)

-- Override the experience gained from Page from Miratetes Memoirs to 1250-2000
m:addOverride('xi.items.page_from_miratetes_memoirs.onItemUse', function(target)   
    target:addExp(xi.settings.main.EXP_RATE * math.random(1250, 2000))
end)

return m