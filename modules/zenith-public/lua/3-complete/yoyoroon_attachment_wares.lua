-- Removes out of era attachments and increases attachment costs by 5,000~10,000g

local m = Module:new('yoyoroon_attachment_wares')

m:addOverride('xi.zones.Nashmau.npcs.Yoyoroon.onTrigger', function(player, npc)
    local stock =
    {
        2239,  9940,    -- Tension Spring
        2243,  9940,    -- Loudspeaker
        2246,  9940,    -- Accelerator
        2251,  9940,    -- Armor Plate
        2254,  9940,    -- Stabilizer
        2258,  9940,    -- Mana Jammer
        2262,  9940,    -- Auto-Repair Kit
        2266,  9940,    -- Mana Tank
        2250, 14925,    -- Shock Absorber
        2255, 14925,    -- Volt Gun
        2260, 14925,    -- Stealth Screen
        2240, 19925,    -- Inhibitor
        2242, 19925,    -- Mana Booster
        2247, 19925,    -- Scope
        2264, 19925,    -- Damage Gauge
        2268, 19925,    -- Mana Conserver
    }

    player:showText(npc, zones[player:getZoneID()].text.YOYOROON_SHOP_DIALOG)
    xi.shop.general(player, stock)
end)

return m
