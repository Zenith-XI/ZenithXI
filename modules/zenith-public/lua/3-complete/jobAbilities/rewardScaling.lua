-----------------------------------
-- Reward Ability Scaling
-- Custom modifications for ZenithXI
-- Scales back pet food healing from retail values
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('c-j_rewardScaling')

-- Override the Reward ability to use scaled healing values
m:addOverride('xi.job_utils.beastmaster.onUseAbilityReward', function(player, target, ability)
    -- 1st need to get the pet food is equipped in the range slot.
    local rangeObj         = player:getEquipID(xi.slot.AMMO)
    local minimumHealing   = 0
    local totalHealing     = 0
    local playerMnd        = player:getStat(xi.mod.MND)
    local rewardHealingMod = player:getMod(xi.mod.REWARD_HP_BONUS)
    local regenAmount      = 1   -- 1 is the minimum.
    local regenTime        = 90  -- 1.5 minutes (scaled from retail 3 minutes)
    local pet              = player:getPet()
    local petCurrentHP     = pet:getHP()
    local petMaxHP         = pet:getMaxHP()

    -- Need to start to calculate the HP to restore to the pet.
    -- Scaled values for ZenithXI balance

    switch(rangeObj):caseof
    {
        [xi.item.PET_FOOD_ALPHA_BISCUIT] = function() -- pet food alpha biscuit
            minimumHealing = 30
            regenAmount    = 1
            totalHealing   = math.floor(minimumHealing + 2 * (playerMnd - 10))
        end,

        [xi.item.PET_FOOD_BETA_BISCUIT] = function() -- pet food beta biscuit
            minimumHealing = 60
            regenAmount    = 2
            totalHealing   = math.floor(minimumHealing + 1 * (playerMnd - 33))
        end,

        [xi.item.PET_FOOD_GAMMA_BISCUIT] = function() -- pet food gamma biscuit
            minimumHealing = 100
            regenAmount    = 3
            totalHealing   = math.floor(minimumHealing + 1 * (playerMnd - 35))
        end,

        [xi.item.PET_FOOD_DELTA_BISCUIT] = function() -- pet food delta biscuit
            minimumHealing = 150
            regenAmount    = 4
            totalHealing   = math.floor(minimumHealing + 2 * (playerMnd - 40))
        end,

        [xi.item.PET_FOOD_EPSILON_BISCUIT] = function() -- pet food epsilon biscuit
            minimumHealing = 250
            regenAmount    = 5
            totalHealing   = math.floor(minimumHealing + 2 * (playerMnd - 45))
        end,

        [xi.item.PET_FOOD_ZETA_BISCUIT] = function() -- pet food zeta biscuit
            minimumHealing = 350
            regenAmount    = 6
            totalHealing   = math.floor(minimumHealing + 3 * (playerMnd - 45))
        end,

        [xi.item.PET_FOOD_ETA_BISCUIT] = function() -- pet food eta biscuit
            minimumHealing = 475
            regenAmount    = 7
            totalHealing   = math.floor(minimumHealing + 4 * (playerMnd - 60))
        end,

        [xi.item.PET_FOOD_THETA_BISCUIT] = function() -- pet food theta biscuit
            minimumHealing = 600
            regenAmount    = 8
            totalHealing   = math.floor(minimumHealing + 4 * (playerMnd - 65))
        end,
    }

    -- Now calculating the bonus based on gear.
    switch(player:getEquipID(xi.slot.BODY)):caseof
    {
        [xi.item.BEAST_JACKCOAT] = function() -- beast jackcoat
            -- This will remove Paralyze, Poison and Blind from the pet.
            pet:delStatusEffect(xi.effect.PARALYSIS)
            pet:delStatusEffect(xi.effect.POISON)
            pet:delStatusEffect(xi.effect.BLINDNESS)
        end,

        [xi.item.BEAST_JACKCOAT_P1] = function() -- beast jackcoat +1
            -- This will remove Paralyze, Poison, Blind, Weight, Slow and Silence from the pet.
            pet:delStatusEffect(xi.effect.PARALYSIS)
            pet:delStatusEffect(xi.effect.POISON)
            pet:delStatusEffect(xi.effect.BLINDNESS)
            pet:delStatusEffect(xi.effect.WEIGHT)
            pet:delStatusEffect(xi.effect.SLOW)
            pet:delStatusEffect(xi.effect.SILENCE)
        end,

        [xi.item.MONSTER_JACKCOAT] = function() -- monster jackcoat
            -- This will remove Weight, Slow and Silence from the pet.
            pet:delStatusEffect(xi.effect.WEIGHT)
            pet:delStatusEffect(xi.effect.SLOW)
            pet:delStatusEffect(xi.effect.SILENCE)
        end,

        [xi.item.MONSTER_JACKCOAT_P1] = function() -- monster jackcoat +1
            -- This will remove Paralyze, Poison, Blind, Weight, Slow and Silence from the pet.
            pet:delStatusEffect(xi.effect.PARALYSIS)
            pet:delStatusEffect(xi.effect.POISON)
            pet:delStatusEffect(xi.effect.BLINDNESS)
            pet:delStatusEffect(xi.effect.WEIGHT)
            pet:delStatusEffect(xi.effect.SLOW)
            pet:delStatusEffect(xi.effect.SILENCE)
        end,
    }

    -- Adding bonus to the total to heal.

    if
        rewardHealingMod ~= nil and
        rewardHealingMod > 0
    then
        totalHealing = totalHealing + math.floor(totalHealing * rewardHealingMod / 100)
    end

    local diff = petMaxHP - petCurrentHP

    if diff < totalHealing then
        totalHealing = diff
    end

    pet:addHP(totalHealing)
    pet:wakeUp()

    -- Apply regen xi.effect.

    pet:delStatusEffect(xi.effect.REGEN)
    pet:addStatusEffect(xi.effect.REGEN, regenAmount, 3, regenTime) -- 3 = tick, each 3 seconds.
    player:removeAmmo(1)

    pet:updateEnmityFromCure(pet, totalHealing)

    -- Debug output (remove after testing)
   -- print(string.format('[RewardScaling] Healed: %d, Regen: %d/tick for %ds, MND: %d', totalHealing, regenAmount, regenTime, playerMnd))

    return totalHealing
end)

return m
