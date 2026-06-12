-----------------------------------
-- Crab Blunt/H2H Weakness
-- Public Module for ZenithXI
-----------------------------------
-- Adds 25% weakness to blunt (impact) damage
-- Adds 12.5% weakness to H2H damage
-- Affects ALL crab variants (resist_ids: 75, 76, 77, 372, 400)
-----------------------------------

UPDATE `mob_resistances` SET `impact_sdt` = `impact_sdt` + 2500, `h2h_sdt` = `h2h_sdt` + 1250 WHERE `name` LIKE "Crab%";
