-- Temporarily disable Silent Oil and Prism Powder synthesis during the level 50 cap phase.
--
-- This only disables synthesis recipes and does not disable item use.
--
-- IMPORTANT: Removing this module later does not restore deleted rows.
-- Restore the six original recipes from sql/synth_recipes.sql when the
-- level cap increases and then remove the tags. COP is only being used as a PH.

UPDATE `synth_recipes`
SET `content_tag` = 'COP'
WHERE `ID` IN (
    61011, -- Silent Oil
    61027, -- Silent Oil
    77628, -- Silent Oil (Trituration)
    61522, -- Prism Powder
    62002, -- Prism Powder
    62003  -- Prism Powder (Trituration)
);
