-- ZenithXI era Final Sting (modules/zenith-public/lua/3-complete/mobs/era_final_sting.lua).
--
-- Usable at 33% HP or less instead of 50% or less, and deals full current HP instead of half.
-- onMobSkillCheck returns 0 when the skill can be used.

describe('Zenith era Final Sting', function()
    local sting

    setup(function()
        sting = xi.actions.mobskills.final_sting
    end)

    -- The check only reads the mob's HP percent
    local function canUse(hpp)
        return sting.onMobSkillCheck(nil, { getHPP = function() return hpp end }, nil)
    end

    it('can be used at exactly 33% HP', function()
        assert(canUse(33) == 0, 'not usable at 33% HP')
    end)

    it('can be used below 33% HP', function()
        assert(canUse(20) == 0, 'not usable at 20% HP')
    end)

    it('cannot be used just above 33% HP', function()
        assert(canUse(34) == 1, 'usable at 34% HP')
    end)

    it('cannot be used between 33% and 50% HP, which base allows', function()
        assert(canUse(45) == 1, 'usable at 45% HP')
    end)

    it('sends current HP at fTP 1.0 and ignores shadows', function()
        local params
        stub('xi.mobskills.mobMagicalMove', function(_, _, _, _, moveParams)
            params = moveParams

            return { damage = 0, attackType = moveParams.attackType, damageType = moveParams.damageType }
        end)
        stub('xi.mobskills.processDamage', false)

        sting.onMobWeaponSkill({}, {}, { getMobHP = function() return 1234 end }, {})

        assert(params.baseDamage == 1234, 'base damage is not current HP')
        assert(params.fTP[1] == 1.0 and params.fTP[2] == 1.0 and params.fTP[3] == 1.0, 'fTP is not 1.0')
        assert(params.element == xi.element.NONE, 'has an element')
        assert(params.attackType == xi.attackType.MAGICAL, 'not a magical attack')
        assert(params.damageType == xi.damageType.NONE, 'has a damage type')
        assert(params.shadowBehavior == xi.mobskills.shadowBehavior.IGNORE_SHADOWS, 'does not ignore shadows')
        assert(params.skipDamageAdjustment and params.skipMagicBonusDiff, 'does not skip the damage adjustments')
    end)
end)
