-- ------------------------------
-- Disable Aptant NMs
-- Public Module for ZenithXI
-- ------------------------------
-- Notorious Monsters that are part of the Ebon / Ebur / Furia synergy equipment sets.
-- November 2009 Version Update. (Post WotG / A Shantotto Ascension)
-- ------------------------------
-- Related MobIDs:
-- Abatwa 17477675
-- Aqrabuamelu 17584416
-- Atkorkamuy 17293485
-- Becut 17334356
-- Big Bang 17117349
-- Came-cruse 17334523
-- Canal Moocher 17469578
-- Chary Apkallu 17027228
-- Chelicerata 16986188
-- Citadel Pipistrelles 17448990
-- Croque-mitaine 17145965
-- Demoiselle Desolee 17170569
-- Drumskull Zogdregg 17113381
-- Frost Flambeau 16797738
-- Harvestman 16990252
-- Jenglot 17612840
-- Konjac 17469632
-- Laelaps 17494135
-- Martinet 17277011
-- Muq Shabeel 17174561
-- Nargun 17277103
-- Sabotender Corrido 17244350
-- Sargas 16806117
-- Skvader 16797770
-- Tegmine 17240232
-- Venomfang 17043466
-- Warabouc 17117295
-- Zmey Gorynych 17240315

UPDATE `mob_spawn_points`
SET pos_x = 0, pos_y = 0, pos_z = 0
WHERE `mobname` in
(
'Abatwa',
'Aqrabuamelu',
'Atkorkamuy',
'Big_Bang',
'Canal_Moocher',
'Chary_Apkallu',
'Chelicerata',
'Citadel_Pipistrelles',
'Croque-Mitaine',
'Demoiselle_Desolee',
'Drumskull_Zogdregg',
'Frost_Flambeau',
'Harvestman',
'Jenglot',
'Konjac',
'Laelaps',
'Martinet',
'Muq_Shabeel',
'Nargun',
'Sabotender_Corrido',
'Sargas',
'Skvader',
'Tegmine',
'Venomfang',
'Warabouc',
'Zmey_Gorynych'
);
