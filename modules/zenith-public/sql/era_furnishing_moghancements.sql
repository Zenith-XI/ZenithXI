-- ------------------------------------------------------------
-- ZENITHDEV-277: these furnishings no longer grant their modern Moghancement.
-- Only the Moghancement is cleared: `element` and `aura` stay, so they still count towards the
-- Mog House elemental balance. Aurum Coffer has no weekly item reward in LSB, so nothing changes there.
-- ------------------------------------------------------------
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 264;  -- Stuffed Chocobo: Moghancement: Money
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 277;  -- Prishe Statue: Moghancement: Money
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 320;  -- Harpsichord: Moghancement: Money
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 3705; -- Far East Hearth: Moghancement: Skill Gains
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 3706; -- Vana'clock: Moghancement: Bounty
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 3707; -- Murrey Grisaille: Moglification: Experience Boost
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 3708; -- Moss Green Grisaille: Moglification: Capacity Boost
UPDATE `item_furnishing` SET `moghancement` = 0 WHERE `itemid` = 3735; -- Aurum Coffer: Moghancement: Money II
