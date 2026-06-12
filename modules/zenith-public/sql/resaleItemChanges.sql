-----------------------------------
-- Item Resale Price Adjustment
-- Updates every base sell price of items in the game to be 95% of its original value,
-- with a minimum value of 1 to prevent extremely low prices
-- Public module for ZenithXI
-----------------------------------

UPDATE item_basic
SET BaseSell = CEILING(BaseSell * 0.90) -- Reduce all item base sell prices by 10%
WHERE BaseSell > 0;
