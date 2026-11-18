-- Prevents Tree Saplings from being harvested before Rise of the Zilart.
--
-- Tree Saplings (1238) were introduced with the level 75 cap in December 2003.
-- Saplings will be available during ROTZ
--
-- Restore the original gardening_results rows when Zilart is enabled.

DELETE FROM `gardening_results` WHERE `result` = 1238; -- Tree Saplings

-- -----------------------------------------------------------------------------
-- RESTORATION - Original Tree Sapling Gardening Results
-- -----------------------------------------------------------------------------

-- INSERT INTO `gardening_results` VALUES (1276,6,0,0,1238,1,2,28);
-- INSERT INTO `gardening_results` VALUES (1282,6,0,1,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1291,6,0,2,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1298,6,0,3,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1305,6,0,4,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1313,6,0,5,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1321,6,0,6,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1329,6,0,7,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1337,6,0,8,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1345,6,1,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1421,6,2,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1494,6,3,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1561,6,4,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1636,6,5,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1711,6,6,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1786,6,7,0,1238,1,2,14);
-- INSERT INTO `gardening_results` VALUES (1861,6,8,0,1238,1,2,14);
