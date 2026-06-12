-- ------------------------------
-- Disable ASA NMs
-- Public Module for ZenithXI
-- ------------------------------
-- Notorious Monsters that are part of the A Shantotto Ascension addon.
-- ------------------------------
-- Related MobIDs:
-- Blest Bones 17273309 17273310 17273311
-- Holey Horror 17273312 17273313 17273314
-- Fired Urn 17277135 17277136 17277137
-- Lode Golem 17277132 17277133 17277134
-- Skeleton Scuffler 17273306 17273307 17273308
-- Steely Weapon 17277129 17277130 17277131

UPDATE `mob_spawn_points`
SET pos_x = 0, pos_y = 0, pos_z = 0
WHERE `mobname` in
(
'Blest_Bones',
'Holey_Horror',
'Fired_Urn',
'Lode_Golem',
'Skeleton_Scuffler',
'Steely_Weapon'
);

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
'Becut',
'Big_Bang',
'Came-cruse',
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
