--------------------------------
-- Revert 2014 combat skill increases
-- Public Module for ZenithXI
--------------------------------

-- 2014 update notes https://forum.square-enix.com/ffxi/threads/44539-dev1235-Job-Adjustments?p=526824#post526824

-- THF Dagger skill from A+ to an A
UPDATE `skill_ranks` SET `thf` = 2 WHERE `name` = 'dagger'; 

-- NIN Katana skill from A+ to an A
UPDATE `skill_ranks` SET `nin` = 2 WHERE `name` = 'katana';

-- BLU Sword skill from A+ to an A
UPDATE `skill_ranks` SET `blu` = 2 WHERE `name` = 'sword';

-- PUP H2H skill from A+ to a B+
UPDATE `skill_ranks` SET `pup` = 3 WHERE `name` = 'hand2hand';

-- DNC Dagger skill from A+ to B+
UPDATE `skill_ranks` SET `dnc` = 3 WHERE `name` = 'dagger';
