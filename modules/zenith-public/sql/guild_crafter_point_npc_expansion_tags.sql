-- Guild Point and Crafter Point NPC Expansion Tags
-- Guild Point NPCs are tagged to COP (Chains of Promathia)
-- Crafter Point NPCs are tagged to SOA (Seekers of Adoulin)
-- Using calculated zoneid from npcid + name matching as npcid values can change with client updates
-- Zone formula: (npcid >> 12) & 0xFFF

-- Guild Point NPCs - Tag to COP (Chains of Promathia)
UPDATE `npc_list` SET `content_tag` = 'COP' WHERE CONCAT((`npcid` >> 12) & 0xFFF, '-', `name`) IN (
    '234-Hemewmew',       -- Alchemy (Bastok Mines)
    '241-Samigo-Pormigo', -- Bonecraft (Windurst Woods)
    '241-Hauh_Colphioh',  -- Clothcraft (Windurst Woods)
    '238-Qhum_Knaidjn',   -- Cooking (Windurst Waters)
    '240-Fennella',       -- Fishing (Port Windurst)
    '235-Ellard',         -- Goldsmithing (Bastok Markets)
    '230-Alivatand',      -- Leathercraft (South San d'Oria)
    '231-Macuillie',      -- Smithing (Northern San d'Oria)
    '237-Lorena',         -- Smithing (Metalworks)
    '231-Andreas'         -- Woodworking (Northern San d'Oria)
);

-- Crafter Point NPCs - Tag to SOA (Seekers of Adoulin)
UPDATE `npc_list` SET `content_tag` = 'SOA' WHERE CONCAT((`npcid` >> 12) & 0xFFF, '-', `name`) IN (
    '234-Yek_Falimeygo',  -- Alchemy (Bastok Mines)
    '241-Tergil',         -- Bonecraft (Windurst Woods)
    '241-Julissois',      -- Clothcraft (Windurst Woods)
    '238-Isanie',         -- Cooking (Windurst Waters)
    '235-Puyutete',       -- Goldsmithing (Bastok Markets)
    '230-Wolden-Bolden',  -- Leathercraft (South San d'Oria)
    '231-Ore_Guzzler',    -- Smithing (Northern San d'Oria)
    '237-Esvin',          -- Smithing (Metalworks)
    '231-Luren'           -- Woodworking (Northern San d'Oria)
);
