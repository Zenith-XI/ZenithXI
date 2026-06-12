-----------------------------------
-- Exclusive Equipment Groups
-- Prevents dual wielding of items within the same exclusion group
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('a-i_excl_equ')

-- Define exclusive groups - items in the same group cannot be equipped together
-- To add new groups, create a new entry with the group name as key and a table
-- of item IDs mapped to their internal names as the value
local exclusiveGroups =
{
    -- Multi-attack clubs that cannot be dual wielded
    multiAttackClubs =
    {
        [xi.item.KRAKEN_CLUB] = 'kraken_club',
        [xi.item.OCTAVE_CLUB] = 'octave_club',
    },
    -- Add more groups here as needed
    -- Example:
    -- specialSwords =
    -- {
    --     [xi.item.SOME_SWORD] = 'some_sword',
    --     [xi.item.OTHER_SWORD] = 'other_sword',
    -- },
}

-- Helper function to handle equipment conflicts
-- @param target object: The player object
local function handleEquipmentConflict(target)
    target:timer(50, function(targetArg)
        -- Unequip both MAIN and SUB weapons when conflict detected
        targetArg:unequipItem(xi.slot.MAIN)
        targetArg:unequipItem(xi.slot.SUB)
        targetArg:messageBasic(xi.msg.basic.ITEM_UNABLE_TO_USE)
    end)
end

-- Apply overrides for all exclusive items
for groupName, groupItems in pairs(exclusiveGroups) do
    for itemId, itemName in pairs(groupItems) do
        local itemPath = fmt('xi.items.{}', itemName)
        xi.module.ensureTable(itemPath)

        m:addOverride(itemPath .. '.onItemEquip', function(player, item)
            super(player, item)

            -- Get currently equipped items
            local mainWeapon = player:getEquipID(xi.slot.MAIN)
            local subWeapon = player:getEquipID(xi.slot.SUB)

            -- Check for exclusive group conflicts between main and sub weapons
            if
                mainWeapon ~= subWeapon and
                groupItems[mainWeapon] and
                groupItems[subWeapon]
            then
                handleEquipmentConflict(player)
            end
        end)
    end
end

return m
