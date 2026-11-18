--------------------------------
-- Job Ability and Trait Changes
-- Public Module for ZenithXI
--------------------------------
-- Content tags set NULL ensure they aren't disabled before we enable the corresponding `content_tag` expansion.
-- Any ability is subject to rebalance or removal before an expansion release but many from 2010+ have already been reduced in potency.
-------------------
-- Job Abilities --
-------------------

-- WAR
-- (Lvl 60) Retaliation - WOTG
UPDATE `abilities` SET `level` = 71, `content_tag`= 'TOAU' WHERE `name` = 'restraint';
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'blood_rage'; -- Abyssea

-- MNK
-- (Lvl 65) Footwork - WOTG - Modern implementation but reduced power
UPDATE `abilities` SET `level` = 71, `recastTime`= 90, `content_tag`= 'TOAU' WHERE `name` = 'perfect_counter'; -- Recast changed from 60 to 90
-- UPDATE `abilities` SET `level` = 75 WHERE `name` = 'impetus'; -- Abyssea
UPDATE `abilities` SET `recastTime` = 300 WHERE `name` = 'focus' AND `abilityId` = 36; -- Focus: Update recast from 120 seconds (2 minutes) to 300 seconds (5 minutes)
UPDATE `abilities` SET `recastTime` = 300 WHERE `name` = 'dodge' AND `abilityId` = 37; -- Dodge: Update recast from 120 seconds (2 minutes) to 300 seconds (5 minutes)

-- WHM
UPDATE `abilities` SET `content_tag`= 'TOAU' WHERE `name` = 'afflatus_solace'; -- Set TOAU rather than WOTG due to retail merit category
UPDATE `abilities` SET `content_tag`= 'TOAU' WHERE `name` = 'afflatus_misery'; -- Set TOAU rather than WOTG due to retail merit category
-- UPDATE `abilities` SET `level` = 60, `content_tag`= 'COP' WHERE `name` = 'divine_caress'; -- TODO: Not implemented
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'sacrosanctity'; -- Abyssea

-- BLM
UPDATE `abilities` SET `level` = 40, `recastTime`= 90, `content_tag`= NULL WHERE `name` = 'cascade'; -- Recast changed from 60 to 90
UPDATE `abilities` SET `level` = 60, `content_tag`= 'TOAU' WHERE `name` = 'manawell';
UPDATE `abilities` SET `level` = 70, `content_tag`= 'COP' WHERE `name` = 'enmity_douse';
-- UPDATE `abilities` SET `level` = 75 WHERE `name` = 'mana_wall'; -- TODO: Not implemented -- Abyssea

-- RDM
-- (Lvl 50) Composure - WOTG - Era implementation
UPDATE `abilities` SET `level` = 60, `content_tag`= 'COP' WHERE `name` = 'spontaneity';
UPDATE `abilities` SET `level` = 75, `recastTime`= 600 WHERE `name` = 'saboteur'; -- Recast changed from 180 to 600 - Abyssea

-- THF
UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'accomplice' ;
UPDATE `abilities` SET `level` = 40, `content_tag`= 'ROTZ' WHERE `name` = 'collaborator';
UPDATE `abilities` SET `level` = 60, `content_tag`= 'COP' WHERE `name` = 'despoil';
UPDATE `abilities` SET `level` = 65, `content_tag`= 'TOAU' WHERE `name` = 'conspirator';
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'bully'; -- Abyssea

-- PLD
UPDATE `abilities` SET `recastTime` = 600 WHERE name = 'holy_circle'; -- 10 Minute recast (Era) but modern duration and bonuses preserved
-- (Lvl 62) Rampart - ROTZ
UPDATE `abilities` SET `level` = 65, `content_tag`= 'WOTG' WHERE `name` = 'divine_emblem';
UPDATE `abilities` SET `level` = 75, `content_tag`= 'ROTZ' WHERE `name` = 'sepulcher';

-- DRK
UPDATE `abilities` SET `recastTime` = 600 WHERE name = 'arcane_circle'; -- 10 Minute recast (Era) but modern duration and bonuses preserved
UPDATE `abilities` SET `content_tag`= 'COP' WHERE `name` = 'consume_mana';
UPDATE `abilities` SET `level` = 65, `content_tag`= 'WOTG' WHERE `name` = 'nether_void';
UPDATE `abilities` SET `level` = 75, `content_tag`= 'ROTZ' WHERE `name` = 'arcane_crest'; -- Duration changed from 180 to 120.
-- UPDATE `abilities` SET `level` = 75, `recastTime`= 180 WHERE `name` = 'scarlet_delirium'; -- Recast changed from 90 to 180 - Abyssea TODO: Not fully implemented

-- BST
-- (Lvl 45) Snarl - WOTG
UPDATE `abilities` SET `level` = 65 WHERE `name` = 'spur';
-- UPDATE `abilities` SET `level` = 75 WHERE `name` = 'run_wild'; -- Abyssea

-- BRD
UPDATE `abilities` SET `content_tag`= NULL WHERE `name` = 'pianissimo'; -- (Lvl 1)
-- UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'tenuto'; -- TODO: Not yet implemented
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'marcato';

-- RNG
-- (Lvl 45) Velocity Shot - TOAU
-- (Lvl 51) Unlimited Shot - ROTZ
UPDATE `abilities` SET `level` = 60, `content_tag`= 'COP' WHERE `name` = 'bounty_shot';
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'double_shot'; -- Abyssea

-- SAM
UPDATE `abilities` SET `recastTime` = 600 WHERE name = 'warding_circle'; -- 10 Minute recast (Era) but modern duration and bonuses preserved
-- (Lvl 25) Hasso - TOAU
-- (Lvl 35) Seigan - TOAU
-- (Lvl 40) Sekkanoki - WOTG
-- UPDATE `abilities` SET `level` = 71 WHERE `name` = 'hagakure'; -- Abyssea - JA unavailable due to SAM over-efficiency
-- UPDATE `abilities` SET `level` = 65, `recastTime`= 300, `content_tag`= 'COP' WHERE `name` = 'konzen-ittai'; -- Recast changed from 180s to 300s - JA unavailable due to SAM over efficiency
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'sengikori'; -- Abyssea
UPDATE `abilities` SET `level` = 75, `content_tag`= 'ROTZ' WHERE `name` = 'hamanoha';

-- NIN
UPDATE `abilities` SET `content_tag`= 'TOAU' WHERE `name` = 'yonin'; -- Set TOAU rather than WOTG due to retail merit category
UPDATE `abilities` SET `content_tag`= 'TOAU' WHERE `name` = 'innin'; -- Set TOAU rather than WOTG due to retail merit category
UPDATE `abilities` SET `level` = 50, `content_tag`= 'ROTZ' WHERE `name` = 'futae';
UPDATE `abilities` SET `level` = 71, `content_tag`= 'COP' WHERE `name` = 'issekigan';
UPDATE `abilities` SET `recastTime`= 300 WHERE `name` = 'sange'; -- Reverts recast reduction from October 2014 update

-- DRG
UPDATE `abilities` SET `content_tag`= 'ROTZ' WHERE `name` = 'spirit_surge'; -- (Lvl 1)
UPDATE `abilities` SET `recastTime` = 600 WHERE name = 'ancient_circle'; -- 10 Minute recast (Era) but modern duration and bonuses preserved
UPDATE `abilities` SET `level` = 40, `content_tag`= 'ROTZ' WHERE `name` = 'smiting_breath';
UPDATE `abilities` SET `level` = 60, `content_tag`= 'COP' WHERE `name` = 'steady_wing';
-- UPDATE `abilities` SET `level` = 65, `content_tag`= 'TOAU' WHERE `name` = 'spirit_bond'; -- TODO: 50% damage split needs to be coded
UPDATE `abilities` SET `level` = 70, `recastTime`= 90, `content_tag`= 'ROTZ' WHERE `name` = 'restoring_breath'; -- Recast changed from 60 to 90
UPDATE `abilities` SET `level` = 75, `content_tag`= 'ROTZ' WHERE `name` = 'dragon_breaker';

-- SMN
-- (Lvl 50) Elemental Siphon - WOTG
-- UPDATE `abilities` SET `level` = 75, `recastTime`= 300, `content_tag`= 'ROTZ' WHERE `name` = 'avatars_favor'; -- Recast reverted from 30 to 300 - TODO Perpetuation cost must first be added
UPDATE `abilities` SET `recastTime`= 300, `content_tag`= 'TOAU' WHERE `name` = 'apogee'; -- (Lvl 70) - Recast changed from 180 to 300
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'mana_cede'; -- Abyssea

-- BLU
UPDATE `abilities` SET `level` = 65 WHERE `name` = 'efflux'; -- Abyssea
UPDATE `abilities` SET `level` = 75, `content_tag`= 'WOTG' WHERE `name` = 'unbridled_learning';

-- COR
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'triple_shot'; -- Abyssea

-- PUP
UPDATE `abilities` SET `recastTime`= 180, `content_tag`= 'TOAU' WHERE `name` = 'maintenance'; -- (Lvl 30) Recast changed from 60 to 180
UPDATE `abilities` SET `level` = 60, `content_tag`= 'TOAU' WHERE `name` = 'cooldown';
-- UPDATE `abilities` SET `level` = 71 WHERE `name` = 'tactical_switch'; -- Abyssea TODO: Not yet implemented
UPDATE `abilities` SET `recastTime`= 90, `content_tag`= 'WOTG' WHERE `name` = 'deus_ex_automata'; -- (Lvl 5) Recast changed from 60 to 90

-- DNC
UPDATE `abilities` SET `content_tag`= 'WOTG' WHERE `name` = 'contradance'; -- (Lvl 50)
UPDATE `abilities` SET `content_tag`= 'WOTG' WHERE `name` = 'chocobo_jig_ii'; -- (Lvl 70)
-- UPDATE `abilities` SET `level` = 71, `recastTime`= 30, `content_tag`= 'WOTG' WHERE `name` = 'presto'; -- TODO: Revert to original potency. Grants 5 steps to 3. Daze increase from 5 to 2. Step Accuracy from +50 to +20.
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'feather_step'; -- Abyssea
-- UPDATE `abilities` SET `level` = 75 WHERE `name` = 'climactic_flourish'; -- Abyssea TODO: Not yet implemented. TODO: Flourish III Category does not display in the menu when making them available at an earlier level.
-- UPDATE `abilities` SET `level` = 71, `recastTime`= 45, `content_tag`= 'WOTG' WHERE `name` = 'striking_flourish'; -- TODO: Not yet implemented
-- UPDATE `abilities` SET `level` = 75, `recastTime`= 60 WHERE `name` = 'ternary_flourish'; -- Abyssea TODO: Not yet implemented

-- SCH
-- UPDATE `abilities` SET `level` = 75, `content_tag`= 'WOTG' WHERE `name` = 'libra'; -- TODO: Not yet implemented.
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'perpetuance'; -- Abyssea
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'immanence'; -- Abyssea

-- Strategems
UPDATE `abilities_charges` SET `level` = 65, `chargeTime` = 70 WHERE `recastId` = 231 AND `maxCharges` = 4; -- 4 stratagem limit at level 65. Recharges every 70 seconds instead of 60 (3 charges limit is 80 seconds)
UPDATE `abilities_charges` SET `level` = 75, `chargeTime` = 60 WHERE `recastId` = 231 AND `maxCharges` = 5; -- 5 stratagem limit at level 75. Recharges every 60 seconds instead of 48

-- RUN
UPDATE `abilities` SET `level` = 71 WHERE `name` = 'liement'; -- SOA
UPDATE `abilities` SET `level` = 75 WHERE `name` = 'one_for_all'; -- SOA

-- GEO
UPDATE `abilities` SET `level` = 65 WHERE `name` = 'concentric_pulse'; -- SOA
-- UPDATE `abilities` SET `level` = 71 WHERE `name` = 'theurgic_focus'; -- SOA TODO: Not yet implemented. TODO: Potency changed from +50MAB to +20MAB

------------------------
-- Disabled Abilities --
------------------------
UPDATE `abilities`
SET `level` = 76
WHERE `name` IN (
    'majesty',
    'konzen-ittai'
);

------------
-- Traits --
------------
-------------------------
-- Trait Power Changes --
-------------------------
UPDATE `traits` SET `value` = 3 WHERE `name` = 'crit. atk. bonus' AND `rank` = 1; -- Crit. Atk. Bonus I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'crit. atk. bonus' AND `rank` = 2; -- Crit. Atk. Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'crit. atk. bonus' AND `rank` = 3; -- Crit. Atk. Bonus III, 7%

UPDATE `traits` SET `value` = 3 WHERE `name` = 'crit. def. bonus' AND `rank` = 1; -- Crit. Def. Bonus I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'crit. def. bonus' AND `rank` = 2; -- Crit. Def. Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'crit. def. bonus' AND `rank` = 3; -- Crit. Def. Bonus III, 7%

UPDATE `traits` SET `value` = 3 WHERE `name` = 'damage limit+' AND `rank` = 1; -- Damage Limit+ I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'damage limit+' AND `rank` = 2; -- Damage Limit+ II, 5%
UPDATE `traits` SET `value` = 6 WHERE `name` = 'damage limit+' AND `rank` = 3; -- Damage Limit+ III, 6%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'damage limit+' AND `rank` = 4; -- Damage Limit+ IV, 7%

UPDATE `traits` SET `value` = 7 WHERE `name` = 'smite' AND `rank` = 1;  -- Smite I, 2.73%
UPDATE `traits` SET `value` = 9 WHERE `name` = 'smite' AND `rank` = 2;  -- Smite II, 3.52%
UPDATE `traits` SET `value` = 11 WHERE `name` = 'smite' AND `rank` = 3; -- Smite III, 4.3%
UPDATE `traits` SET `value` = 13 WHERE `name` = 'smite' AND `rank` = 4; -- Smite IV, 5.08%

UPDATE `traits` SET `value` = 10 WHERE `name` = 'stalwart soul' AND `rank` = 1; -- Stalwart Soul I, -1% (Souleater 9%)
UPDATE `traits` SET `value` = 15 WHERE `name` = 'stalwart soul' AND `rank` = 2; -- Stalwart Soul II, -1.5%  (Souleater 8.5%)
UPDATE `traits` SET `value` = 20 WHERE `name` = 'stalwart soul' AND `rank` = 3; -- Stalwart Soul III, -2%  (Souleater 8%)

UPDATE `traits` SET `value` = 3 WHERE `name` = 'skillchain bonus' AND `rank` = 1; -- Skillchain Bonus I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'skillchain bonus' AND `rank` = 2; -- Skillchain Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'skillchain bonus' AND `rank` = 3; -- Skillchain Bonus III, 7%

UPDATE `traits` SET `value` = 3 WHERE `name` = 'mag. burst bonus' AND `rank` = 1; -- Mag. Burst Bonus I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'mag. burst bonus' AND `rank` = 2; -- Mag. Burst Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'mag. burst bonus' AND `rank` = 3; -- Mag. Burst Bonus III, 7%

-- Shield Def. Bonus I, -2 damage
-- Shield Def. Bonus II, -4 damage
UPDATE `traits` SET `value` = 5 WHERE `name` = 'shield def. bonus' AND `rank` = 3; -- Shield Def. Bonus III, -5 damage

-- Shield Mastery I, 10 TP
UPDATE `traits` SET `value` = 15 WHERE `name` = 'shield mastery' AND `rank` = 2; -- Shield Mastery II, 15 TP
UPDATE `traits` SET `value` = 20 WHERE `name` = 'shield mastery' AND `rank` = 3; -- Shield Mastery III, 20 TP

-- UPDATE `traits` SET `value` = 2 WHERE `name` = 'true shot' AND `rank` = 1; -- True Shot I, +2% damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 3 WHERE `name` = 'true shot' AND `rank` = 2; -- True Shot II, +3% damage -- TODO: Not yet implemented

-- UPDATE `traits` SET `value` = 3 WHERE `name` = 'dead aim' AND `rank` = 1; -- Dead Aim I, +3% critical hit damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 5 WHERE `name` = 'dead aim' AND `rank` = 2; -- Dead Aim II, +5% critical hit damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 7 WHERE `name` = 'dead aim' AND `rank` = 3; -- Dead Aim II, +7% critical hit damage -- TODO: Not yet implemented

UPDATE `traits` SET `value` = 5 WHERE `name` = 'tandem strike' AND `rank` = 1;    -- Tandem Strike I, +5 Acc/Macc
UPDATE `traits` SET `value` = 10 WHERE `name` = 'tandem strike' AND `rank` = 2;   -- Tandem Strike II, +10 Acc/Macc
UPDATE `traits` SET `value` = 15 WHERE `name` = 'tandem strike' AND `rank` = 3;   -- Tandem Strike III, +15 Acc/Macc
UPDATE `traits` SET `value` = 20 WHERE `name` = 'tandem strike' AND `rank` = 4;   -- Tandem Strike IV, +20 Acc/Macc

UPDATE `traits` SET `value` = 6 WHERE `name` = 'daken' AND `rank` = 1; -- Daken I, 6%
UPDATE `traits` SET `value` = 8 WHERE `name` = 'daken' AND `rank` = 2; -- Daken II, 8%
UPDATE `traits` SET `value` = 10 WHERE `name` = 'daken' AND `rank` = 3; -- Daken III, 10%
UPDATE `traits` SET `value` = 12 WHERE `name` = 'daken' AND `rank` = 4; -- Daken IV, 12%

UPDATE `traits` SET `value` = 1 WHERE `name` = 'ws damage boost' AND `rank` = 1; -- WS Damage Boost I, 1%
UPDATE `traits` SET `value` = 2 WHERE `name` = 'ws damage boost' AND `rank` = 2; -- WS Damage Boost II, 2%
UPDATE `traits` SET `value` = 3 WHERE `name` = 'ws damage boost' AND `rank` = 3; -- WS Damage Boost III, 3%

UPDATE `traits` SET `value` = 8 WHERE `name` = 'conserve tp' AND `rank` = 1;  -- Conserve TP I, 8%
UPDATE `traits` SET `value` = 10 WHERE `name` = 'conserve tp' AND `rank` = 2; -- Conserve TP II, 10%
UPDATE `traits` SET `value` = 12 WHERE `name` = 'conserve tp' AND `rank` = 3; -- Conserve TP III, 12%

UPDATE `traits` SET `value` = 10 WHERE `name` = 'tactical parry' AND `rank` = 1; -- Tactical Parry I, 10TP
UPDATE `traits` SET `value` = 20 WHERE `name` = 'tactical parry' AND `rank` = 2; -- Tactical Parry II, 20TP
UPDATE `traits` SET `value` = 25 WHERE `name` = 'tactical parry' AND `rank` = 3; -- Tactical Parry III, 25TP
UPDATE `traits` SET `value` = 30 WHERE `name` = 'tactical parry' AND `rank` = 4; -- Tactical Parry IV, 30TP

UPDATE `traits` SET `value` = 15 WHERE `name` = 'tactical guard' AND `rank` = 1; -- Tactical Guard I, 15TP
UPDATE `traits` SET `value` = 30 WHERE `name` = 'tactical guard' AND `rank` = 2; -- Tactical Guard II, 30TP
UPDATE `traits` SET `value` = 45 WHERE `name` = 'tactical guard' AND `rank` = 3; -- Tactical Guard III, 45TP

--------------------------------
-- Job Specific Trait Changes --
--------------------------------

-- WAR
UPDATE `traits` SET `level` = 40 WHERE `name` = 'shield mastery' AND `job` = 1 AND `rank` = 1;    -- Shield Mastery I
UPDATE `traits` SET `level` = 50 WHERE `name` = 'shield def. bonus' AND `job` = 1 AND `rank` = 1; -- Shield Def. Bonus I
UPDATE `traits` SET `level` = 60 WHERE `name` = 'shield mastery' AND `job` = 1 AND `rank` = 2;    -- Shield Mastery II
UPDATE `traits` SET `level` = 65 WHERE `name` = 'crit. atk. bonus' AND `job` = 1 AND `rank` = 1;  -- Crit. Atk. Bonus I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'shield def. bonus' AND `job` = 1 AND `rank` = 2; -- Shield Def. Bonus II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'damage limit+' AND `job` = 1 AND `rank` = 2;     -- Damage Limit+ II

-- MNK
UPDATE `traits` SET `level` = 40 WHERE `name` = 'tactical guard' AND `job` = 2 AND `rank` = 1;   -- Tactical Guard I
UPDATE `traits` SET `level` = 60 WHERE `name` = 'tactical guard' AND `job` = 2 AND `rank` = 2;   -- Tactical Guard II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'tactical guard' AND `job` = 2 AND `rank` = 3;   -- Tactical Guard III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'skillchain bonus' AND `job` = 2 AND `rank` = 1; -- Skillchain Bonus I

-- WHM
UPDATE `traits` SET `level` = 50 WHERE `name` = 'shield def. bonus' AND `job` = 3 AND `rank` = 1; -- Shield Def. Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'shield def. bonus' AND `job` = 3 AND `rank` = 2; -- Shield Def. Bonus II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'auto regen' AND `job` = 3 AND `rank` = 2;        -- Auto Regen II - Abyssea

-- BLM
UPDATE `traits` SET `level` = 55 WHERE `name` = 'occult acumen' AND `job` = 4 AND `rank` = 1; -- Occult Acumen I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'conserve mp' AND `job` = 4 AND `rank` = 2;   -- Conserve MP II

-- RDM
UPDATE `traits` SET `level` = 50 WHERE `name` = 'shield mastery' AND `job` = 5 AND `rank` = 1;    -- Shield Mastery I
UPDATE `traits` SET `level` = 65 WHERE `name` = 'mag. burst bonus' AND `job` = 5 AND `rank` = 1;  -- Mag. Burst Bonus I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'shield def. bonus' AND `job` = 5 AND `rank` = 1; -- Shield Def. Bonus I

-- THF
UPDATE `traits` SET `level` = 45 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 1; -- Crit. Atk. Bonus I
UPDATE `traits` SET `level` = 50 WHERE `name` = 'assassin' AND `job` = 6 AND `rank` = 1;         -- Assassin - Level lowered
UPDATE `traits` SET `level` = 60 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 2; -- Crit. Atk. Bonus II
UPDATE `traits` SET `level` = 71 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 3; -- Crit. Atk. Bonus III
UPDATE `traits` SET `level` = 71 WHERE `name` = 'dual wield' AND `job` = 6 AND `rank` = 1;       -- Dual Wield I

-- PLD
UPDATE `traits` SET `level` = 35 WHERE `name` = 'crit. def. bonus' AND `job` = 7 AND `rank` = 1;  -- Crit. Def. Bonus I
UPDATE `traits` SET `level` = 50 WHERE `name` = 'shield def. bonus' AND `job` = 7 AND `rank` = 1; -- Shield Def. Bonus I
UPDATE `traits` SET `level` = 55 WHERE `name` = 'crit. def. bonus' AND `job` = 7 AND `rank` = 2;  -- Crit. Def. Bonus II
UPDATE `traits` SET `level` = 60 WHERE `name` = 'shield def. bonus' AND `job` = 7 AND `rank` = 2; -- Shield Def. Bonus II
UPDATE `traits` SET `level` = 71 WHERE `name` = 'shield barrier' AND `job` = 7 AND `rank` = 1;    -- Shield Barrier
UPDATE `traits` SET `level` = 75 WHERE `name` = 'crit. def. bonus' AND `job` = 7 AND `rank` = 3;  -- Crit. Def. Bonus III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'shield def. bonus' AND `job` = 7 AND `rank` = 3; -- Shield Def. Bonus III

-- DRK
UPDATE `traits` SET `level` = 55 WHERE `name` = 'occult acumen' AND `job` = 8 AND `rank` = 2;  -- Occult Acumen II
UPDATE `traits` SET `level` = 65 WHERE `name` = 'occult acumen' AND `job` = 8 AND `rank` = 3;  -- Occult Acumen III
UPDATE `traits` SET `level` = 70 WHERE `name` = 'tactical parry' AND `job` = 8 AND `rank` = 1; -- Tactical Parry I

-- BST
UPDATE `traits` SET `level` = 50 WHERE `name` = 'fencer' AND `job` = 9 AND `rank` = 1;          -- Fencer I
UPDATE `traits` SET `level` = 71 WHERE `name` = 'fencer' AND `job` = 9 AND `rank` = 2;          -- Fencer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'stout servant' AND `job` = 9 AND `rank` = 1;   -- Stout Servant I - Abyssea
UPDATE `traits` SET `level` = 75 WHERE `name` = 'aquan killer' AND `job` = 9 AND `rank` = 2;    -- Aquan Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'amorph killer' AND `job` = 9 AND `rank` = 2;   -- Amorph Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'beast killer' AND `job` = 9 AND `rank` = 2;    -- Beast Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'bird killer' AND `job` = 9 AND `rank` = 2;     -- Bird Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'lizard killer' AND `job` = 9 AND `rank` = 2;   -- Lizard Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'plantoid killer' AND `job` = 9 AND `rank` = 2; -- Plantoid Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'vermin killer' AND `job` = 9 AND `rank` = 2;   -- Vermin Killer II

-- BRD
UPDATE `traits` SET `level` = 58 WHERE `name` = 'fencer' AND `job` = 10 AND `rank` = 1;           -- Fencer I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'crit. def. bonus' AND `job` = 10 AND `rank` = 1; -- Crit. Def. Bonus I

-- RNG
-- UPDATE `traits` SET `level` = 65 WHERE `name` = 'true shot' AND `job` = 11 AND `rank` = 1; -- True Shot I -- TODO: Not yet implemented
-- UPDATE `traits` SET `level` = 75 WHERE `name` = 'true shot' AND `job` = 11 AND `rank` = 2; -- True Shot II -- TODO: Not yet implemented

-- SAM
UPDATE `traits` SET `level` = 60 WHERE `name` = 'skillchain bonus' AND `job` = 12 AND `rank` = 1; -- Skillchain Bonus I
-- UPDATE `traits` SET `level` = 65 WHERE `name` = 'dead aim' AND `job` = 12 AND `rank` = 1;         -- Dead Aim I -- TODO: Not yet implemented
UPDATE `traits` SET `level` = 75 WHERE `name` = 'skillchain bonus' AND `job` = 12 AND `rank` = 2; -- Skillchain Bonus II

-- NIN
UPDATE `traits` SET `level` = 55 WHERE `name` = 'tactical parry' AND `job` = 13 AND `rank` = 1;   -- Tactical Parry I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'mag. burst bonus' AND `job` = 13 AND `rank` = 1; -- Mag. Burst Bonus I
UPDATE `traits` SET `level` = 71 WHERE `name` = 'skillchain bonus' AND `job` = 13 AND `rank` = 1; -- Skillchain Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max hp boost' AND `job` = 13 AND `rank` = 4;     -- Max HP Boost IV
UPDATE `traits` SET `level` = 75 WHERE `name` = 'tactical parry' AND `job` = 13 AND `rank` = 2;   -- Tactical Parry II

-- DRG
UPDATE `traits` SET `level` = 35 WHERE `name` = 'conserve tp' AND `job` = 14 AND `rank` = 1;      -- Conserve TP I
UPDATE `traits` SET `level` = 50 WHERE `name` = 'crit. def. bonus' AND `job` = 14 AND `rank` = 1; -- Crit. Def. Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'crit. def. bonus' AND `job` = 14 AND `rank` = 2; -- Crit. Def. Bonus II

-- SMN
UPDATE `traits` SET `level` = 20 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 2; -- Max MP Boost II
UPDATE `traits` SET `level` = 40 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 3; -- Max MP Boost III
UPDATE `traits` SET `level` = 50 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 4; -- Max MP Boost IV
UPDATE `traits` SET `level` = 70 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 5; -- Max MP Boost V

-- COR
-- UPDATE `traits` SET `level` = 60 WHERE `name` = 'dead aim' AND `job` = 17 AND `rank` = 1;  -- Dead Aim I -- TODO: Not yet implemented
-- UPDATE `traits` SET `level` = 71 WHERE `name` = 'true shot' AND `job` = 17 AND `rank` = 1; -- True Shot I -- TODO: Not yet implemented

-- PUP
UPDATE `traits` SET `level` = 55 WHERE `name` = 'tactical guard' AND `job` = 18 AND `rank` = 1;   -- Tactical Guard I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'crit. def. bonus' AND `job` = 18 AND `rank` = 1; -- Crit. Def. Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'stout servant' AND `job` = 18 AND `rank` = 1;    -- Stout Servant I - Abyssea
UPDATE `traits` SET `level` = 75 WHERE `name` = 'tactical guard' AND `job` = 18 AND `rank` = 2;   -- Tactical Guard II

-- DNC
UPDATE `traits` SET `level` = 40 WHERE `name` = 'tactical parry' AND `job` = 19 AND `rank` = 1;   -- Tactical Parry I
UPDATE `traits` SET `level` = 55 WHERE `name` = 'tactical parry' AND `job` = 19 AND `rank` = 2;   -- Tactical Parry II
UPDATE `traits` SET `level` = 60 WHERE `name` = 'conserve tp' AND `job` = 19 AND `rank` = 1;      -- Conserve TP I
UPDATE `traits` SET `level` = 60 WHERE `name` = 'crit. atk. bonus' AND `job` = 19 AND `rank` = 1; -- Crit. Atk. Bonus I
UPDATE `traits` SET `level` = 65 WHERE `name` = 'tactical parry' AND `job` = 19 AND `rank` = 3;   -- Tactical Parry III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'conserve tp' AND `job` = 19 AND `rank` = 2;      -- Conserve TP II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'crit. atk. bonus' AND `job` = 19 AND `rank` = 2; -- Crit. Atk. Bonus II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'tactical parry' AND `job` = 19 AND `rank` = 4;   -- Tactical Parry IV

-- SCH
UPDATE `traits` SET `level` = 50 WHERE `name` = 'occult acumen' AND `job` = 20 AND `rank` = 1;    -- Occult Acumen I
UPDATE `traits` SET `level` = 60 WHERE `name` = 'mag. burst bonus' AND `job` = 20 AND `rank` = 1; -- Mag. Burst Bonus I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'occult acumen' AND `job` = 20 AND `rank` = 2;    -- Occult Acumen II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max mp boost' AND `job` = 20 AND `rank` = 2;     -- Max MP Boost II

-- GEO
UPDATE `traits` SET `level` = 75 WHERE `name` = 'clear mind' AND `job` = 21 AND `rank` = 4;   -- Clear Mind IV
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max mp boost' AND `job` = 21 AND `rank` = 3; -- Max MP Boost III

-- RUN
UPDATE `traits` SET `level` = 35 WHERE `name` = 'tactical parry' AND `job` = 22 AND `rank` = 1;   -- Tactical Parry I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'tactical parry' AND `job` = 22 AND `rank` = 3;   -- Tactical Parry III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'magic def. bonus' AND `job` = 22 AND `rank` = 5; -- Magic Def. Bonus V
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max hp boost' AND `job` = 22 AND `rank` = 4;     -- Max HP Boost IV

---------------------
-- Disabled Traits --
---------------------
DELETE FROM `traits` WHERE `name`='double attack' AND `rank` = 2;   -- Double Attack II
DELETE FROM `traits` WHERE `name`='double attack' AND `rank` = 3;   -- Double Attack III
DELETE FROM `traits` WHERE `name`='dual wield' AND `rank` = 2 AND `job` = 19; -- Dual Wield II - DNC - Job is receiving a lot of OOE traits/JAs. We need to observe how it handles these without a free /WAR boost too.
DELETE FROM `traits` WHERE `name`='dual wield' AND `rank` = 3 AND `job` = 19; -- Dual Wield III - DNC - DW III on DNC could be the tipping point on balance.
DELETE FROM `traits` WHERE `name`='max hp boost II' AND `rank` = 1; -- Max HP Boost II I
DELETE FROM `traits` WHERE `name`='ws damage boost' AND `rank` = 4; -- WS Damage Boost IV

-------------------------
-- Content Tag Updates --
-------------------------
UPDATE `traits` SET `content_tag`= NULL WHERE `name` IN (
    'amorph killer',
    'aquan killer',
    'attack bonus',
    'beast killer',
    'bird killer',
    'blood boon',
    'clear mind',
    'conserve mp',
    'conserve tp',
    'crit. atk. bonus',
    'crit. def. bonus',
    'daken',
    'damage limit+',
    'dead aim',
    'defense bonus',
    'divine benison',
    'dual wield',
    'elemental celerity',
    'fencer',
    'inquartata',
    'lizard killer',
    'mag. burst bonus',
    'max hp boost',
    'max mp boost',
    'occult acumen',
    'plantoid killer',
    'shield barrier',
    'shield def. bonus',
    'shield mastery',
    'skillchain bonus',
    'smite',
    'stalwart soul',
    'tactical guard',
    'tactical parry',
    'tandem blow',
    'tandem strike',
    'tenacity',
    'tranquil heart',
    'vermin killer',
    'ws damage boost'
);
