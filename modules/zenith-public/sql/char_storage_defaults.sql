-----------------------------------
-- Character Storage Default Values
-- Sets case and wardrobe columns to default to 0
-- Public module for ZenithXI
-----------------------------------
-- Players must unlock these storage expansions rather than
-- having them available by default
-----------------------------------

ALTER TABLE `char_storage`
    ALTER COLUMN `case` SET DEFAULT 0,
    ALTER COLUMN `wardrobe` SET DEFAULT 0,
    ALTER COLUMN `wardrobe2` SET DEFAULT 0,
    ALTER COLUMN `wardrobe3` SET DEFAULT 0,
    ALTER COLUMN `wardrobe4` SET DEFAULT 0,
    ALTER COLUMN `wardrobe5` SET DEFAULT 0,
    ALTER COLUMN `wardrobe6` SET DEFAULT 0,
    ALTER COLUMN `wardrobe7` SET DEFAULT 0,
    ALTER COLUMN `wardrobe8` SET DEFAULT 0;
