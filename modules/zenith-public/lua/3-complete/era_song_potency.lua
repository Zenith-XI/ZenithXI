-----------------------------------
-- Era Bard song potency (ZENITHDEV-267)
-- Undoes the February 10, 2017 update for Carol, Madrigal, Mambo, March, Minne, Minuet and Prelude: the base
-- power, skill scaling, potency cap and instrument multiplier go back to their level 75 values.
-- March power is in 1024ths of haste (64/1024 and 96/1024 at the cap).
-- calculateSongPower reads a table local to enhancing_song.lua, so the values and the part of the function
-- that uses them are here. Foe Sirvente and Adventurer's Dirge are not touched.
-- Source: https://forum.square-enix.com/ffxi/threads/52095-Feb.-10-2017-%28JST%29-Version-Update
-- Values from Phoenix's modules/phoenix/lua/globals/spells/enhancing_song.lua
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c_eraSongPotency')

local carol = { base = 20, skill = 200, cap = 40, multiplier = 5, divisor = 10 }

local eraSongs =
{
    [xi.magic.spell.FIRE_CAROL       ] = carol,
    [xi.magic.spell.ICE_CAROL        ] = carol,
    [xi.magic.spell.WIND_CAROL       ] = carol,
    [xi.magic.spell.EARTH_CAROL      ] = carol,
    [xi.magic.spell.LIGHTNING_CAROL  ] = carol,
    [xi.magic.spell.WATER_CAROL      ] = carol,
    [xi.magic.spell.LIGHT_CAROL      ] = carol,
    [xi.magic.spell.DARK_CAROL       ] = carol,

    [xi.magic.spell.SWORD_MADRIGAL   ] = { base =  5, skill =  40, cap = 15, multiplier = 2,   divisor = 23.25, merit = xi.merit.MADRIGAL_EFFECT },
    [xi.magic.spell.BLADE_MADRIGAL   ] = { base =  9, skill = 130, cap = 30, multiplier = 2,   divisor = 18,    merit = xi.merit.MADRIGAL_EFFECT },

    [xi.magic.spell.SHEEPFOE_MAMBO   ] = { base =  5, skill =  85, cap = 15, multiplier = 2.5, divisor = 18 },
    [xi.magic.spell.DRAGONFOE_MAMBO  ] = { base =  9, skill = 130, cap = 23, multiplier = 2.5, divisor = 18 },

    [xi.magic.spell.ADVANCING_MARCH  ] = { base = 35, skill = 200, cap = 64, multiplier = 16,  divisor = 7 },
    [xi.magic.spell.VICTORY_MARCH    ] = { base = 53, skill = 300, cap = 96, multiplier = 16,  divisor = 7 },

    [xi.magic.spell.KNIGHTS_MINNE    ] = { base =  5, skill =   0, cap = 13, multiplier = 2.5, divisor = 15, merit = xi.merit.MINNE_EFFECT, jobPoint = xi.jp.MINNE_EFFECT },
    [xi.magic.spell.KNIGHTS_MINNE_II ] = { base =  6, skill =   0, cap = 27, multiplier = 2.5, divisor = 15, merit = xi.merit.MINNE_EFFECT, jobPoint = xi.jp.MINNE_EFFECT },
    [xi.magic.spell.KNIGHTS_MINNE_III] = { base = 10, skill =   0, cap = 40, multiplier = 2.5, divisor = 15, merit = xi.merit.MINNE_EFFECT, jobPoint = xi.jp.MINNE_EFFECT },
    [xi.magic.spell.KNIGHTS_MINNE_IV ] = { base = 12, skill =   0, cap = 48, multiplier = 2.5, divisor = 15, merit = xi.merit.MINNE_EFFECT, jobPoint = xi.jp.MINNE_EFFECT },

    [xi.magic.spell.VALOR_MINUET     ] = { base =  5, skill =  50, cap = 16, multiplier = 2.5, divisor = 6, merit = xi.merit.MINUET_EFFECT, jobPoint = xi.jp.MINUET_EFFECT },
    [xi.magic.spell.VALOR_MINUET_II  ] = { base = 10, skill =  85, cap = 32, multiplier = 2.5, divisor = 6, merit = xi.merit.MINUET_EFFECT, jobPoint = xi.jp.MINUET_EFFECT },
    [xi.magic.spell.VALOR_MINUET_III ] = { base = 24, skill = 200, cap = 48, multiplier = 2.5, divisor = 6, merit = xi.merit.MINUET_EFFECT, jobPoint = xi.jp.MINUET_EFFECT },
    [xi.magic.spell.VALOR_MINUET_IV  ] = { base = 29, skill = 300, cap = 56, multiplier = 2.5, divisor = 6, merit = xi.merit.MINUET_EFFECT, jobPoint = xi.jp.MINUET_EFFECT },

    [xi.magic.spell.HUNTERS_PRELUDE  ] = { base = 10, skill =  85, cap = 15, multiplier = 2,   divisor = 18 },
    [xi.magic.spell.ARCHERS_PRELUDE  ] = { base = 20, skill = 130, cap = 30, multiplier = 2,   divisor = 18 },
}

m:addOverride('xi.spells.enhancing.calculateSongPower', function(caster, target, spell, spellId, tier, songEffect, instrumentBoost, soulVoicePower)
    local song = eraSongs[spellId]

    if not song then
        return super(caster, target, spell, spellId, tier, songEffect, instrumentBoost, soulVoicePower)
    end

    local power      = song.base
    local singingLvl = caster:getSkillLevel(xi.skill.SINGING)

    if caster:isPC() then
        local rangeType    = caster:getWeaponSkillType(xi.slot.RANGED)
        local isInstrument = rangeType == xi.skill.WIND_INSTRUMENT or rangeType == xi.skill.STRING_INSTRUMENT

        singingLvl = isInstrument and singingLvl + caster:getSkillLevel(rangeType) or singingLvl
    else
        singingLvl = singingLvl * 2
    end

    if singingLvl > song.skill then
        power = math.floor(power + (singingLvl - song.skill) / song.divisor)
    end

    power = math.min(power, song.cap)
    power = math.floor(power + instrumentBoost * song.multiplier)

    if song.merit then
        power = math.floor(power + caster:getMerit(song.merit))
    end

    if song.jobPoint then
        power = math.floor(power + caster:getJobPointLevel(song.jobPoint))
    end

    if soulVoicePower then
        local marcatoEffect = caster:getStatusEffect(xi.effect.MARCATO)

        if caster:hasStatusEffect(xi.effect.SOUL_VOICE) then
            power = math.floor(power * 2)
        elseif marcatoEffect ~= nil then
            power = math.floor(power * (1 + (marcatoEffect:getPower() / 100)))
        end
    end

    return power
end)

return m
