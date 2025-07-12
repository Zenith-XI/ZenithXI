-- Blanket increase of all fishing pool sizes by 50% for ZenithXI server
UPDATE fishing_group
SET pool_size = FLOOR(pool_size * 1.5)
