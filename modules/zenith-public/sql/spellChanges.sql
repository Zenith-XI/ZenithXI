--------------------------------
-- Spell Changes
-- Public Module for ZenithXI
--------------------------------

-------------------
-- Black Magic --
-------------------

-- Absorb spells' cast time reverted to pre-August 12, 2014 update values

UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-acc';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-attri';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-str';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-dex';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-vit';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-agi';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-int';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-mnd';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-chr';
UPDATE `spell_list` SET `castTime` = 2000 WHERE `name` = 'absorb-tp';