-----------------------------------
-- Protect/Protectra Spell Defense Rebalance
-- Adjusts the defense amounts for Protect and Protectra spells
-----------------------------------
require('modules/module_utils')
-----------------------------------

local m = Module:new('protectRebalance')

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

return m
