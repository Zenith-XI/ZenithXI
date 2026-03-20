-----------------------------------
-- Experience Band/Ring Timer Updates
-- Public Module for ZenithXI
-----------------------------------
-- Updates activation, useDelay, and reuseDelay for experience bonus items
-- in the item_usable table
-----------------------------------

UPDATE `item_usable` SET `reuseDelay` = 43200 WHERE `name` = 'chariot_band'; -- 7 charges, 5s useDelay, 12hr reuseDelay
UPDATE `item_usable` SET `reuseDelay` = 50400 WHERE `name` = 'empress_band'; -- 7 charges, 5s useDelay, 14hr reuseDelay
UPDATE `item_usable` SET `reuseDelay` = 57600 WHERE `name` = 'emperor_band'; -- 3 charges, 5s useDelay, 16hr reuseDelay
UPDATE `item_usable` SET `activation` = 15, `useDelay` = 15, `reuseDelay` = 3600 WHERE `name` = 'kupofrieds_ring'; -- 11 charges, 15s activation, 15s useDelay, 1hr reuseDelay
