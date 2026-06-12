-----------------------------------
-- Bazaar Tax Rate Adjustment
-- Sets the tax rate to 10% for all zones
-- Public module for ZenithXI
-----------------------------------

UPDATE `zone_settings`
SET tax = 10.00; -- Set bazaar tax to 10% for all zones
