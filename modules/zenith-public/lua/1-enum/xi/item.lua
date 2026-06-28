-- -----------------------------------
-- xi.item additions
--
-- Add enums we need that aren't needed in LSB
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('e_x-item')
m:addOverride('xi.dummyFunc', function()
end)

-- Vendor overrides
xi.item.HANDFUL_OF_STEEL_SCALES  = 676
xi.item.COEURL_WHISKER           = 927
xi.item.LEATHER_POUCH            = 1655
xi.item.TIGER_COD                = 4483
xi.item.RAPTOR_GLOVES            = 12700

-- Mog Pell rewards
xi.item.ADOULINIAN_TOMATOES      = 3718
xi.item.CRIMSON_CHEST            = 3732
xi.item.MANDRAGORA_POT           = 3744
xi.item.CHOCOBO_CHAIR            = 6411
xi.item.POROGGO_CASSOCK          = 23803
xi.item.KNIT_CAP                 = 23810

-- HELM
xi.item.SCARLET_STONE            = 1649
xi.item.RAFFLESIA_VINE           = 2513
xi.item.GNAT_WING                = 2522
xi.item.HEAD_OF_GRAUBERG_LETTUCE = 5688

return m
