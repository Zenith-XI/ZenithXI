-- -----------------------------------
-- Mob Reposition Module Template
--
-- This module overrides the default spawn points
-- for the chosen mob groups.
-- -----------------------------------

require('modules/module_utils')
local m = Module:new('mob_reposition_template')

local mobList =
{
    ['Locus_bright_Rarab'] =
    {
        limit = 0,
    },
    ['Locus_Camelopard'] =
    {
        limit = { 4, 7, 11, 13, 17, 18, 22 },
        pos =
        {
            [4] = { x = 634.1308, y = -19.9076, z = 842.1681, rot = 116 },
            [7] = { x = 634.1308, y = -19.9076, z = 842.1681, rot = 116 },
            [13] = { x = 546.8382, y = -19.3444, z = 759.1634, rot = 213 },
            [17] = { x = 546.5234, y = -19.8379, z = 753.1788, rot = 19 },
            [22] = { x = 554.6318, y = -19.8303, z = 790.6303, rot = 149 },
        },
    },
    ['Locus_Ghost_Crab'] =
    {
        limit = 20,
    },
    ['Locus_Hypnos_Eft'] =
    {
        limit = 6,
        pos =
        {
            [1] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
            [2] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
            [3] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
            [4] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
            [5] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
            [6] = { x = 182.0314, y = -28.1075, z = 481.0372, rot = 197 },
        }
    },
}

-- override zone init so we can remove or reposition mobs
m:addOverride('xi.zones.Bibiki_Bay.Zone.onInitialize',
function(zone)
    super(zone)
    zxi.mobHelpers.zoneInitReposition(zone, mobList)
end)

return m
