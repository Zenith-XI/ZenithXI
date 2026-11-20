-- Trust TP skill additions (ZENITHDEV-200).
-- Eligibility by level is decided by lua/2-base/trust_tp_skills.lua through git patch 122. Fallback skills are
-- only used from level 5 until the listed replacement becomes available; without that module and patch the
-- Trust keeps them at every level, next to the replacement.

-- Fallback weaponskills
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Kupipi',1013,160); -- Shining Strike, until Starlight
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Curilla',1017,33); -- Burning Blade, until Red Lotus Blade
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Volker',1018,32); -- Fast Blade, until Red Lotus Blade
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Trion',1020,33); -- Burning Blade, until Red Lotus Blade
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Semih_Lafihna',1055,192); -- Flaming Arrow, until Sidewinder

-- An earlier version of this file gave Semih mob skill 636, the Orc Warmachine's Flame Arrow
DELETE FROM `mob_skill_lists` WHERE `skill_list_id` = 1055 AND `mob_skill_id` = 636;

-- Reviewed weaponskill progression
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Trion',1020,969); -- Flat Blade
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Halver',1087,112); -- Double Thrust
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Halver',1087,115); -- Leg Sweep
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Halver',1087,114); -- Raiden Thrust
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Halver',1087,116); -- Penta Thrust
REPLACE INTO `mob_skill_lists` VALUES ('TRUST_Volker',1018,976); -- Berserk-Ruf, from level 40
