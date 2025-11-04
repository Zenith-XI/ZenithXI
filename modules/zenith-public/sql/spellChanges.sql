--------------------------------
-- Spell Changes
-- Public Module for ZenithXI
--------------------------------

-------------------
-- Black Magic --
-------------------

-- Absorb spells' cast time reverted to pre-August 12, 2014 update values

UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` IN (
	'absorb-acc',
	'absorb-attri',
	'absorb-str',
	'absorb-dex',
	'absorb-vit',
	'absorb-agi',
	'absorb-int',
	'absorb-mnd',
	'absorb-chr',
	'absorb-tp'
);
