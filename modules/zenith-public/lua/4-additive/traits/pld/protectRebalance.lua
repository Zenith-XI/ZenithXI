-----------------------------------
-- Protect/Protectra Enhancement Module
-- Combines defense rebalancing and Shield Barrier trait modifications
-- - Adjusts defense amounts for Protect and Protectra spells
-- - Modifies Shield Barrier to grant Protect Defense + (Shield Defense / 2)
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('a-t-p_protect')

-- Define the new defense values for Protect and Protectra spells
-- Both spell lines will use the same defense values
local protectDefenseValues = {
    -- Protect spells
    [xi.magic.spell.PROTECT]       = 10,  -- Protect
    [xi.magic.spell.PROTECT_II]    = 25,  -- Protect II
    [xi.magic.spell.PROTECT_III]   = 40,  -- Protect III
    [xi.magic.spell.PROTECT_IV]    = 55,  -- Protect IV
    [xi.magic.spell.PROTECT_V]     = 65,  -- Protect V

    -- Protectra spells
    [xi.magic.spell.PROTECTRA]     = 10,  -- Protectra
    [xi.magic.spell.PROTECTRA_II]  = 25,  -- Protectra II
    [xi.magic.spell.PROTECTRA_III] = 40,  -- Protectra III
    [xi.magic.spell.PROTECTRA_IV]  = 55,  -- Protectra IV
    [xi.magic.spell.PROTECTRA_V]   = 65,  -- Protectra V
}

-- Override the base power calculation for Protect/Protectra spells
m:addOverride('xi.spells.enhancing.calculateEnhancingBasePower', function(caster, target, spell, spellId, skillLevel, spellParams, dayWeatherBonus)
    local basePower = super(caster, target, spell, spellId, skillLevel, spellParams, dayWeatherBonus)

    -- Check if this is a Protect or Protectra spell and override its base power
    local newDefense = protectDefenseValues[spellId]
    if newDefense then
        basePower = newDefense
    end

    return basePower
end)

-- Override the final power calculation to modify Shield Barrier trait behavior
m:addOverride('xi.spells.enhancing.calculateEnhancingFinalPower', function(caster, target, spell, basePower, spellGroup, tier, spellEffect)
    local finalPower = super(caster, target, spell, basePower, spellGroup, tier, spellEffect)

    -- Check if this is a Protect spell and caster has Shield Barrier trait
    if
        spellEffect == xi.effect.PROTECT and
        caster:isPC() and
        caster:getMod(xi.mod.SHIELD_BARRIER) > 0
    then
        -- Remove the original Shield Barrier bonus (which was added in the original function)
        finalPower = finalPower - caster:getShieldDefense()

        -- Add the modified Shield Barrier bonus (Shield Defense / 2)
        local shieldDefense = caster:getShieldDefense()
        finalPower = finalPower + math.floor(shieldDefense / 2)
    end

    return finalPower
end)

return m
