-- ---------------------------------------------------------
-- Mog Pell Cosmetic Items
-- Removes CANUSE flag (0x0200) from items that should be
-- purely cosmetic when awarded from Mog Pell rewards
-- ---------------------------------------------------------
-- Item IDs:
--   25774 = FANCY_GILET
--   25775 = FANCY_TOP
--   25838 = FANCY_TRUNKS
--   25839 = FANCY_SHORTS
--   25715 = KORRIGAN_SUIT
-- ---------------------------------------------------------

-- Remove CANUSE flag (0x0200 = 512) using bitwise AND with inverse
UPDATE `item_basic` SET `flags` = `flags` & ~0x0200 WHERE (`flags` & 0x0200) != 0 AND `itemid` IN (25774, 25775, 25838, 25839, 25715);
