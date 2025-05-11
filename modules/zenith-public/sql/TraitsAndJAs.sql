--------------------------------
-- Job Ability and Trait Changes
--- Public Module for ZenithXI
--------------------------------
-- Content tags are set NULL to ensure they aren't disabled before we enable the corresponding `content_tag` expansion.

-------------------
-- Job Abilities --
-------------------

-- WAR
UPDATE `abilities` SET `level` = 71, `content_tag`= NULL WHERE `name` = 'restraint';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'blood_rage'; -- TODO: Potency changed from +20% to +10%.

-- MNK
UPDATE `abilities` SET `level` = 71, `recastTime`= 90, `content_tag`= NULL WHERE `name` = 'perfect_counter'; -- Recast changed from 60 to 90
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'impetus'; -- TODO: Duration changed from 180 to 120

-- WHM
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'divine_caress'; -- TODO: Ability needs to be corrected
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'sacrosanctity';

-- BLM
UPDATE `abilities` SET `level` = 45, `content_tag`= NULL WHERE `name` = 'manawell';
UPDATE `abilities` SET `level` = 60, `recastTime`= 90, `content_tag`= NULL WHERE `name` = 'cascade'; -- Recast changed from 60 to 90
UPDATE `abilities` SET `level` = 70, `content_tag`= NULL WHERE `name` = 'enmity_douse';
UPDATE `abilities` SET `level` = 70, `content_tag`= NULL WHERE `name` = 'mana_wall'; -- TODO: Test

-- RDM
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'spontaneity';
UPDATE `abilities` SET `level` = 60, `recastTime`= 300, `content_tag`= NULL WHERE `name` = 'saboteur'; -- Recast changed from 180 to 300

-- THF
UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'accomplice' ;
UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'collaborator';
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'despoil';
UPDATE `abilities` SET `level` = 65, `content_tag`= NULL WHERE `name` = 'conspirator'; -- TODO: Potency reduced.
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'bully';

-- PLD
UPDATE `abilities` SET `level` = 65, `content_tag`= NULL WHERE `name` = 'divine_emblem';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'sepulcher'; -- TODO: Duration changed from 180 to 120

-- DRK
UPDATE `abilities` SET `level` = 65, `content_tag`= NULL WHERE `name` = 'nether_void';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'arcane_crest'; -- TODO: Duration changed from 180 to 120.
UPDATE `abilities` SET `level` = 75, `recastTime`= 180, `content_tag`= NULL WHERE `name` = 'scarlet_delirium'; -- Recast changed from 90 to 180

-- BST
-- UPDATE `abilities` SET `level` = 65, `content_tag`= NULL WHERE `name` = 'spur'; -- TODO: Not yet implemented
-- UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'run_wild'; -- TODO: Not yet implemented

-- BRD
-- UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'tenuto'; -- TODO: Not yet implemented
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'marcato'; -- TODO: Potency changed from +50% to +25%

-- RNG
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'bounty_shot';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'double_shot'; -- TODO: Potency changed from 40% to 10%

-- SAM
UPDATE `abilities` SET `level` = 55, `content_tag`= NULL WHERE `name` = 'hagakure'; -- TODO: Bonus reduced by 50%
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'sengikori'; -- TODO: Potency reduced from 25% to 15%
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'hamanoha'; -- TODO: Duration changed from 180 to 120

-- NIN
UPDATE `abilities` SET `level` = 50, `content_tag`= NULL WHERE `name` = 'futae';
UPDATE `abilities` SET `level` = 71, `content_tag`= NULL WHERE `name` = 'issekigan';

-- DRG
UPDATE `abilities` SET `level` = 40, `content_tag`= NULL WHERE `name` = 'smiting_breath';
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'steady_wing';
UPDATE `abilities` SET `level` = 71, `recastTime`= 90, `content_tag`= NULL WHERE `name` = 'restoring_breath'; -- Recast changed from 60 to 90
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'dragon_breaker'; -- TODO: Duration changed from 180 to 120

-- SMN
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'mana_cede';

-- BLU
UPDATE `abilities` SET `level` = 65, `content_tag`= NULL WHERE `name` = 'efflux';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'unbridled_learning';

-- COR
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'triple_shot'; --TODO: Potency changed from 40% to 10%

-- PUP
UPDATE `abilities` SET `level` = 60, `content_tag`= NULL WHERE `name` = 'cooldown';
UPDATE `abilities` SET `level` = 71, `content_tag`= NULL WHERE `name` = 'tactical_switch';

-- DNC
UPDATE `abilities` SET `level` = 71, `recastTime`= 30, `content_tag`= NULL WHERE `name` = 'presto'; -- TODO: Potency changed from 5 steps to original 3. Daze increase from 5 to original 2. Step Accuracy from +50 to +20.
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'feather_step';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'climactic_flourish';
UPDATE `abilities` SET `level` = 71, `recastTime`= 45, `content_tag`= NULL WHERE `name` = 'striking_flourish'; -- TODO: Not yet implemented
UPDATE `abilities` SET `level` = 75, `recastTime`= 60, `content_tag`= NULL WHERE `name` = 'ternary_flourish'; -- TODO: Not yet implemented

-- SCH
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'libra';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'perpetuance';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'immanence';

-- Strategems
UPDATE `abilities_charges` SET `level` = 65 WHERE `recastId` = 231 AND `maxCharges` = 4; -- 4 stratagem limit at level 65. Recharges every 60 seconds
UPDATE `abilities_charges` SET `level` = 75 WHERE `recastId` = 231 AND `maxCharges` = 5; -- 5 stratagem limit at level 75. Recharges every 48 seconds

-- RUN
UPDATE `abilities` SET `level` = 71, `content_tag`= NULL WHERE `name` = 'liement';
UPDATE `abilities` SET `level` = 75, `content_tag`= NULL WHERE `name` = 'one_for_all';

-- GEO
UPDATE `abilities` SET `level` = 45, `content_tag`= NULL WHERE `name` = 'concentric_pulse';
UPDATE `abilities` SET `level` = 71, `content_tag`= NULL WHERE `name` = 'theurgic_focus'; -- TODO: Not yet implemented. TODO: Potency changed from +50MAB to +25MAB

------------------------
-- Disabled Abilities --
------------------------
DELETE FROM `abilities` WHERE `name`='majesty'; -- Majesty disabled

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

UPDATE `traits` SET `value` = 3 WHERE `name` = 'damage limit+' AND `rank` = 1; -- Damage Limit+ I, 0.03
UPDATE `traits` SET `value` = 5 WHERE `name` = 'damage limit+' AND `rank` = 2; -- Damage Limit+ II, 0.05
UPDATE `traits` SET `value` = 6 WHERE `name` = 'damage limit+' AND `rank` = 3; -- Damage Limit+ III, 0.06
UPDATE `traits` SET `value` = 7 WHERE `name` = 'damage limit+' AND `rank` = 4; -- Damage Limit+ IV, 0.07

UPDATE `traits` SET `value` = 3 WHERE `name` = 'skillchain bonus' AND `rank` = 1; -- Skillchain Bonus I, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'skillchain bonus' AND `rank` = 2; -- Skillchain Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'skillchain bonus' AND `rank` = 3; -- Skillchain Bonus III, 7%

UPDATE `traits` SET `value` = 3 WHERE `name` = 'mag. burst bonus' AND `rank` = 1; -- Mag. Burst Bonus II, 3%
UPDATE `traits` SET `value` = 5 WHERE `name` = 'mag. burst bonus' AND `rank` = 2; -- Mag. Burst Bonus II, 5%
UPDATE `traits` SET `value` = 7 WHERE `name` = 'mag. burst bonus' AND `rank` = 3; -- Mag. Burst Bonus III, 7%

UPDATE `traits` SET `value` = 5 WHERE `name` = 'shield def. bonus' AND `rank` = 3; -- Shield Def. Bonus III, -5 damage

-- UPDATE `traits` SET `value` = 3 WHERE `name` = 'true shot' AND `rank` = 1; -- True Shot I, +3% damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 4 WHERE `name` = 'true shot' AND `rank` = 2; -- True Shot II, +4% damage -- TODO: Not yet implemented

-- UPDATE `traits` SET `value` = 3 WHERE `name` = 'dead aim' AND `rank` = 1; -- Dead Aim I, +5% critical hit damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 7 WHERE `name` = 'dead aim' AND `rank` = 2; -- Dead Aim II, +7% critical hit damage -- TODO: Not yet implemented
-- UPDATE `traits` SET `value` = 9 WHERE `name` = 'dead aim' AND `rank` = 3; -- Dead Aim II, +9% critical hit damage -- TODO: Not yet implemented

UPDATE `traits` SET `value` = 10 WHERE `name` = 'daken' AND `rank` = 1; -- Daken I, 10%
UPDATE `traits` SET `value` = 12 WHERE `name` = 'daken' AND `rank` = 2; -- Daken II, 12%
UPDATE `traits` SET `value` = 14 WHERE `name` = 'daken' AND `rank` = 3; -- Daken III, 14%
UPDATE `traits` SET `value` = 16 WHERE `name` = 'daken' AND `rank` = 4; -- Daken IV, 16%

UPDATE `traits` SET `value` = 1 WHERE `name` = 'ws damage boost' AND `rank` = 1; -- WS Damage Boost I, 1%
UPDATE `traits` SET `value` = 2 WHERE `name` = 'ws damage boost' AND `rank` = 2; -- WS Damage Boost II, 2%
UPDATE `traits` SET `value` = 3 WHERE `name` = 'ws damage boost' AND `rank` = 3; -- WS Damage Boost III, 3%
-- UPDATE `traits` SET `value` = 4 WHERE `name` = 'ws damage boost' AND `rank` = 4; -- WS Damage Boost IV, 4% -- Tier 4 is intentionally disabled below

UPDATE `traits` SET `value` = 8 WHERE `name` = 'conserve tp' AND `rank` = 1;  -- Conserve TP I, 8%
UPDATE `traits` SET `value` = 10 WHERE `name` = 'conserve tp' AND `rank` = 2; -- Conserve TP II, 10%
UPDATE `traits` SET `value` = 12 WHERE `name` = 'conserve tp' AND `rank` = 3; -- Conserve TP III, 12%

UPDATE `traits` SET `value` = 10 WHERE `name` = 'tactical parry' AND `rank` = 1; -- Tactical Parry I, 10TP
UPDATE `traits` SET `value` = 20 WHERE `name` = 'tactical parry' AND `rank` = 2; -- Tactical Parry II, 20TP
UPDATE `traits` SET `value` = 30 WHERE `name` = 'tactical parry' AND `rank` = 3; -- Tactical Parry III, 30TP
UPDATE `traits` SET `value` = 40 WHERE `name` = 'tactical parry' AND `rank` = 4; -- Tactical Parry IV, 40TP

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
UPDATE `traits` SET `level` = 75 WHERE `name` = 'auto regen' AND `job` = 3 AND `rank` = 2;        -- Auto Regen II

-- BLM
UPDATE `traits` SET `level` = 65 WHERE `name` = 'occult acumen' AND `job` = 4 AND `rank` = 1; -- Occult Acumen I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'conserve mp' AND `job` = 4 AND `rank` = 2;   -- Conserve MP II

-- RDM
UPDATE `traits` SET `level` = 50 WHERE `name` = 'shield mastery' AND `job` = 5 AND `rank` = 1;    -- Shield Mastery I
UPDATE `traits` SET `level` = 65 WHERE `name` = 'mag. burst bonus' AND `job` = 5 AND `rank` = 1;  -- Mag. Burst Bonus I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'shield def. bonus' AND `job` = 5 AND `rank` = 1; -- Shield Def. Bonus I

-- THF
UPDATE `traits` SET `level` = 45 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 1; -- Crit. Atk. Bonus I
UPDATE `traits` SET `level` = 50 WHERE `name` = 'assassin' AND `job` = 6 AND `rank` = 1;         -- Assassin
UPDATE `traits` SET `level` = 60 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 2; -- Crit. Atk. Bonus II
UPDATE `traits` SET `level` = 71 WHERE `name` = 'crit. atk. bonus' AND `job` = 6 AND `rank` = 3; -- Crit. Atk. Bonus III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'dual wield' AND `job` = 6 AND `rank` = 1;       -- Dual Wield I

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
UPDATE `traits` SET `level` = 55 WHERE `name` = 'fencer' AND `job` = 9 AND `rank` = 1;          -- Fencer I
UPDATE `traits` SET `level` = 71 WHERE `name` = 'fencer' AND `job` = 9 AND `rank` = 2;          -- Fencer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'stout servant' AND `job` = 9 AND `rank` = 1;   -- Stout Servant I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'aquan killer' AND `job` = 9 AND `rank` = 2;    -- Aquan Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'amorph killer' AND `job` = 9 AND `rank` = 2;   -- Amorph Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'beast killer' AND `job` = 9 AND `rank` = 2;    -- Beast Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'bird killer' AND `job` = 9 AND `rank` = 2;     -- Bird Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'lizard killer' AND `job` = 9 AND `rank` = 2;   -- Lizard Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'plantoid killer' AND `job` = 9 AND `rank` = 2; -- Plantoid Killer II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'vermin killer' AND `job` = 9 AND `rank` = 2;   -- Vermin Killer II

-- BRD
UPDATE `traits` SET `level` = 55 WHERE `name` = 'fencer' AND `job` = 10 AND `rank` = 1;           -- Fencer I
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
UPDATE `traits` SET `level` = 50 WHERE `name` = 'crit. def. bonus' AND `job` = 14 AND `rank` = 1; -- Crit. Def. Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'crit. def. bonus' AND `job` = 14 AND `rank` = 2; -- Crit. Def. Bonus II

-- SMN
UPDATE `traits` SET `level` = 20 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 2; -- Max MP Boost II
UPDATE `traits` SET `level` = 35 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 3; -- Max MP Boost III
UPDATE `traits` SET `level` = 50 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 4; -- Max MP Boost IV
UPDATE `traits` SET `level` = 65 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 5; -- Max MP Boost V
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max mp boost' AND `job` = 15 AND `rank` = 6; -- Max MP Boost VI

-- COR
-- UPDATE `traits` SET `level` = 60 WHERE `name` = 'dead aim' AND `job` = 17 AND `rank` = 1;  -- Dead Aim I -- TODO: Not yet implemented
-- UPDATE `traits` SET `level` = 71 WHERE `name` = 'true shot' AND `job` = 17 AND `rank` = 1; -- True Shot I -- TODO: Not yet implemented

-- PUP
UPDATE `traits` SET `level` = 55 WHERE `name` = 'tactical guard' AND `job` = 18 AND `rank` = 1;   -- Tactical Guard I
UPDATE `traits` SET `level` = 70 WHERE `name` = 'crit. def. bonus' AND `job` = 18 AND `rank` = 1; -- Crit. Def. Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'stout servant' AND `job` = 18 AND `rank` = 1;    -- Stout Servant I
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
UPDATE `traits` SET `level` = 60 WHERE `name` = 'occult acumen' AND `job` = 20 AND `rank` = 1;    -- Occult Acumen I
UPDATE `traits` SET `level` = 65 WHERE `name` = 'mag. burst bonus' AND `job` = 20 AND `rank` = 1; -- Mag. Burst Bonus I
UPDATE `traits` SET `level` = 75 WHERE `name` = 'occult acumen' AND `job` = 20 AND `rank` = 2;    -- Occult Acumen II
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max mp boost' AND `job` = 20 AND `rank` = 2;     -- Max MP Boost II

-- GEO
UPDATE `traits` SET `level` = 75 WHERE `name` = 'clear mind' AND `job` = 21 AND `rank` = 4;   -- Clear Mind IV
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max mp boost' AND `job` = 21 AND `rank` = 3; -- Max MP Boost III

-- RUN
UPDATE `traits` SET `level` = 35 WHERE `name` = 'tactical parry' AND `job` = 22 AND `rank` = 1;   -- Tactical Parry I
UPDATE `traits` SET `level` = 71 WHERE `name` = 'tactical parry' AND `job` = 22 AND `rank` = 3;   -- Tactical Parry III
UPDATE `traits` SET `level` = 75 WHERE `name` = 'magic def. bonus' AND `job` = 22 AND `rank` = 5; -- Magic Def. Bonus V
UPDATE `traits` SET `level` = 75 WHERE `name` = 'max hp boost' AND `job` = 22 AND `rank` = 4;     -- Max HP Boost IV

---------------------
-- Disabled Traits --
---------------------
DELETE FROM `traits` WHERE `name`='ws damage boost' AND `rank` = 4; -- WS Damage Boost IV disabled

-------------------------
-- Content Tag Updates --
-------------------------
UPDATE `traits` SET `content_tag`= NULL WHERE `name` IN (
    'shield mastery',
    'shield def. bonus',
    'smite',
    'damage limit+',
    'fencer',
    'crit. atk. bonus',
    'tactical guard',
    'skillchain bonus',
    'auto regen',
    'tranquil heart',
    'occult acumen',
    'conserve mp',
    'elemental celerity',
    'mag. burst bonus',
    'shield barrier',
    'dual wield',
    'attack bonus',
    'tactical parry',
    'stout servant',
    'aquan killer',
    'amorph killer',
    'beast killer',
    'bird killer',
    'lizard killer',
    'plantoid killer',
    'vermin killer',
    'crit. def. bonus',
    'dead aim',
    'daken',
    'conserve tp',
    'ws damage boost',
    'blood boon',
    'max mp boost',
    'max hp boost',
    'clear mind',
    'inquartata',
    'tenacity',
    'magic def. bonus'
);
