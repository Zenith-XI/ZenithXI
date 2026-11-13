-- -----------------------------------
-- xi.mobSkill additions
--
-- Mob skill IDs that LSB does not expose yet. Each one is assigned only when missing,
-- so an upstream definition wins and these lines can be removed without touching call sites.
-- -----------------------------------

require('modules/module_utils')

local m = Module:new('e-x_mob_skill')
m:addOverride('xi.dummyFunc', function()
end)

xi.mobSkill = xi.mobSkill or {}

-- Semih Lafihna Trust (ZENITHDEV-200)
xi.mobSkill.STELLAR_ARROW       = xi.mobSkill.STELLAR_ARROW or 3489
xi.mobSkill.LUX_ARROW           = xi.mobSkill.LUX_ARROW or 3490
xi.mobSkill.SEMIH_SIDEWINDER    = xi.mobSkill.SEMIH_SIDEWINDER or 3487
xi.mobSkill.SEMIH_ARCHING_ARROW = xi.mobSkill.SEMIH_ARCHING_ARROW or 3488

-- Nanaa Mihgo, Volker and Maat Trusts (ZENITHDEV-200)
xi.mobSkill.KING_COBRA_CLAMP    = xi.mobSkill.KING_COBRA_CLAMP or 3189
xi.mobSkill.VOLKER_BERSERK      = xi.mobSkill.VOLKER_BERSERK or 976 -- Berserk-Ruf
xi.mobSkill.BEAR_KILLER         = xi.mobSkill.BEAR_KILLER or 3263
xi.mobSkill.MAAT_COMBO          = xi.mobSkill.MAAT_COMBO or 3413
xi.mobSkill.MAAT_ONE_INCH_PUNCH = xi.mobSkill.MAAT_ONE_INCH_PUNCH or 3414
xi.mobSkill.MAAT_HOWLING_FIST   = xi.mobSkill.MAAT_HOWLING_FIST or 3415
xi.mobSkill.MAAT_DRAGON_KICK    = xi.mobSkill.MAAT_DRAGON_KICK or 3416
xi.mobSkill.MAAT_ASURAN_FISTS   = xi.mobSkill.MAAT_ASURAN_FISTS or 3417

return m
