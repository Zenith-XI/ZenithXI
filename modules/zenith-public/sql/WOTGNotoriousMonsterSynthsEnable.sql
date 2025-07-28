-- This SQL Module enables the Synthesis recipes for items dropped by Notorious
-- Monsters from the Wings of the Goddess expansion. These NMs will be enabled
-- on Zenith at launch, so setting the content_tag to NULL (Vanilla).

UPDATE synth_recipes
SET content_tag = NULL
WHERE Result IN
(
18766, -- Tyro Katars - Grimy Bronze Sheet - NM: Trembler Tabitha
18769, -- Severus Claws - Likho Talon - NM: Likho
19119, -- Ranging Knife - Stately Crab Shell - NM: Metal Shears
17968, -- Veldt Axe - Penumbral Brass Ingot - NM: Gloombound Lurker
18506, -- Tewhatewha - Aramid Fiber - NM: Tyrant
18956, -- Serpette - Bukktooth - NM: Rambukk
19276, -- Midare - Tokkyu Tama-Hagane - NM: Saa Doyi the Fervid
18606, -- Passaddhi Staff - Hefty Oak Lumber - NM: Legalox Heftyhind
18611, -- Qi Staff - Blue Jasper - NM: Supplespine Mujwuj
18873, -- Brise-os - Sahagin Gold - NM: Pyuu the Spatemaker
19231, -- Tracker's Bow - Mahogany Heartwood - NM: Toxic Tamlyn
19240, -- Aumoniere - Ensanguined Cloth - NM: Sluagh
19046, -- Reaver Grip - Malebolge Mandrel - NM: Calcabrina
11495, -- Zeal Cap - Thunder Coral - NM: Donnergugi
16301, -- Focus Collar - Flawed Garnet - NM: Bedrock Barry
11340, -- Salutary Robe - Mandragora Scale - NM: Backoo
11341, -- Vivacity Coat - Rugged Gold Thread - NM: Bugbear Muscleman
11345, -- Alacer Aketon - Radiant Velvet - NM: Humbaba
11344, -- Styrne Byrnie - Herensugue Skin - NM: Herensugue
11346, -- Vela Justaucorps - Bastet Fang - NM: Bastet
11347, -- Menetrier's Alb - Yel. Brass Chain - NM: Marquis Naberius
15053, -- Combat Mittens - Ephemeral Cloth - NM: Quu Xijo the Illusory
15055, -- Finesse Gloves - Coquecigrue Skin - NM: Coquecigrue
15939, -- Griot Belt - Quadav Silver - NM: Be'Hya Hundredwall
11530, -- Exactitude Mantle - Immortal Molt - NM: Highlander Lizard
11532, -- Accura Cape - Dahu Hair - NM: Dahu
11537, -- Kinesis Mantle - Ratatoskr Pelt - NM: Ratatoskr
11535, -- Fowler's Mantle - Woolly Pelage - NM: Flockbock
15849, -- Krousis Ring - Imperial Topaz - NM: Huwasi
16373, -- Kyoshu Sitabaki - Lineadach - NM: Sengann
11407 -- Mettle Leggings - Samwell's Shank - NM: Slumbering Samwell
)
