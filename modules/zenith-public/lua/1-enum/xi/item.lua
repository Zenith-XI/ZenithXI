-- -----------------------------------
-- xi.item additions
--
-- Add enums we need that aren't needed in LSB
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('e_x_item')

-- Vendor overrides
xi.item.PINCH_OF_CLUSTER_ASH     = 1630
xi.item.BAG_OF_IMPERIAL_RICE     = 2214
xi.item.BAG_OF_IMPERIAL_FLOUR    = 2237
xi.item.TENSION_SPRING           = 2239
xi.item.INHIBITOR                = 2240
xi.item.MANA_BOOSTER             = 2242
xi.item.LOUDSPEAKER              = 2243
xi.item.ACCELERATOR              = 2246
xi.item.SCOPE                    = 2247
xi.item.SHOCK_ABSORBER           = 2250
xi.item.ARMOR_PLATE              = 2251
xi.item.STABILIZER               = 2254
xi.item.VOLT_GUN                 = 2255
xi.item.MANA_JAMMER              = 2258
xi.item.STEALTH_SCREEN           = 2260
xi.item.AUTO_REPAIR_KIT          = 2262
xi.item.DAMAGE_GAUGE             = 2264
xi.item.MANA_TANK                = 2266
xi.item.MANA_CONSERVER           = 2268
xi.item.BAG_OF_COFFEE_BEANS      = 2271
xi.item.BLACK_PUPPET_TURBAN      = 2501
xi.item.WHITE_PUPPET_TURBAN      = 2502
xi.item.SAFEHOLD_WAYSTONE        = 2871
xi.item.NASHMAU_WAYSTONE         = 2873
xi.item.EMPIRE_WAYSTONE          = 2872
xi.item.BOWL_OF_TOMATO_SOUP      = 4420
xi.item.BOWL_OF_GOBLIN_STEW      = 4465
xi.item.SCROLL_OF_SHELLRA_IV     = 4741
xi.item.SCROLL_OF_DRAIN_II       = 4854
xi.item.SCROLL_OF_ABSORB_TP      = 4883
xi.item.SCROLL_OF_DREAD_SPIKES   = 4885
xi.item.SCROLL_OF_ASPIR_II       = 4886
xi.item.SCROLL_OF_RAPTOR_MAZURKA = 5075
xi.item.JAR_OF_REMEDY_OINTMENT   = 5356
xi.item.VIAL_OF_TINCTURE         = 5418
xi.item.SAMURAI_DIE              = 5488
xi.item.NINJA_DIE                = 5489
xi.item.DRAGOON_DIE              = 5490
xi.item.SUMMONER_DIE             = 5491
xi.item.BLUE_MAGE_DIE            = 5492
xi.item.CORSAIR_DIE              = 5493
xi.item.PUPPETMASTER_DIE         = 5494
xi.item.BOLTERS_DIE              = 5497
xi.item.CASTERS_DIE              = 5498
xi.item.DRIED_DATE               = 5567
xi.item.FLASK_OF_AYRAN           = 5576
xi.item.PLATE_OF_IC_PILAV        = 5584
xi.item.BALIK_SANDVICI           = 5590
xi.item.SIMIT                    = 5596
xi.item.SIS_KEBABI               = 5598
xi.item.BALIK_SIS                = 5600
xi.item.POGACA                   = 5637
xi.item.CHERRY_MUFFIN            = 5653
xi.item.SLICE_OF_SALTED_HARE     = 5737
xi.item.CHUNK_OF_SWEET_LIZARD    = 5738
xi.item.MUG_OF_HONEYED_EGG       = 5739
xi.item.CHEESE_SANDWICH          = 5686
xi.item.GEOMANCER_DIE            = 6368
xi.item.RUNE_FENCER_DIE          = 6369
xi.item.DARKSTEEL_MUFFLERS       = 12683
xi.item.DARKSTEEL_SOLLERETS      = 12939
xi.item.TIGER_LEDELSENS          = 12958
xi.item.BARONE_COSCIALES         = 14317
xi.item.BARONE_MANOPOLAS         = 14848
xi.item.BARONE_GAMBIERAS         = 15305
xi.item.VIR_SUBLIGAR             = 15389
xi.item.FEMINA_SUBLIGAR          = 15390
xi.item.DARKSTEEL_CLAWS          = 16413
xi.item.DARKSTEEL_AXE            = 16645
xi.item.DARKSTEEL_KNIFE          = 16468
xi.item.DARKSTEEL_LANCE          = 16848
xi.item.DARKSTEEL_MACE           = 17037
xi.item.DARKSTEEL_ROD            = 17063
xi.item.SILVER_ARROW             = 17321
xi.item.SINGLE_HOOK_FISHING_ROD  = 17382
xi.item.CLOTHESPOLE              = 17383
xi.item.VOULGE                   = 18214
xi.item.FALX                     = 18375

return m
