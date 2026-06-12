-----------------------------------
-- Thief Enmity Rebalance
-- Custom modifications for ZenithXI
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('a-j_thf_enmity_rebal')

-----------------------------------
-- Sneak Attack & Trick Attack Recast Reduction
-----------------------------------
-- Reduces the recast time of Sneak Attack and Trick Attack
-- based on the number of merit points spent in Ambush
-- Each merit point reduces recast by 1 second
local adjustRecast = function(player, ability)
    local merits = player:getMerit(xi.merit.AMBUSH)

    if merits > 0 then
        -- Reduce recast timer by 1 second per merit point
        -- Minimum recast is 0 seconds (instant)
        ability:setRecast(math.max(0, ability:getRecast() - merits))
    end
end

-----------------------------------
-- Apply Recast Reduction to Sneak Attack
-----------------------------------
m:addOverride('xi.actions.abilities.sneak_attack.onAbilityCheck', function(player, target, ability)
    adjustRecast(player, ability)

    return super(player, target, ability)
end)

-----------------------------------
-- Apply Recast Reduction to Trick Attack
-----------------------------------
m:addOverride('xi.actions.abilities.trick_attack.onAbilityCheck', function(player, target, ability)
    adjustRecast(player, ability)

    return super(player, target, ability)
end)

-----------------------------------
-- Enhanced Trick Attack Enmity Transfer
-----------------------------------
-- When Trick Attack effect ends, transfers a portion of the Thief's
-- enmity (hate) to the designated trick attack partner (tank/trust)
-- The amount transferred scales with Thief level:
-- - At level 75 THF: 50% of enmity is transferred
-- - Lower levels transfer proportionally less (e.g., level 37 = 25%)
--
-- Flag usage:
-- - TA_PROCESSING: Prevents recursive re-entry when we temporarily re-add TA
--   (delStatusEffectSilent still triggers onEffectLose callbacks)
-- - TA_TRANSFERRED: Prevents double transfer from game's double-application of TA
--
-- Limitation: Enmity transfer requires player to still be targeting the mob
-- when the effect wears off. If target changes, transfer will not occur.
m:addOverride('xi.effects.trick_attack.onEffectLose', function(player, effect)
    -- Always call super first for proper effect cleanup (removes TRICK_ATK_AGI mod)
    super(player, effect)

    -- Prevent recursive re-entry during our temp effect manipulation
    -- delStatusEffectSilent still triggers onEffectLose, so we must guard against it
    if player:getLocalVar('TA_PROCESSING') == 1 then
        return
    end

    -- Check if we already transferred enmity for this TA usage
    -- The game applies TA twice, so onEffectLose fires twice per usage
    if player:getLocalVar('TA_TRANSFERRED') == 1 then
        player:setLocalVar('TA_TRANSFERRED', 0)
        return
    end

    -- Calculate enmity transfer percentage based on Thief level
    -- Main job THF uses main level, subjob THF uses sub level
    -- Formula: 50% * (THF Level / 75)
    -- Example: Level 75 THF = 50% transfer, Level 37 THF = 25% transfer
    local thfLevel = 0
    if player:getMainJob() == xi.job.THF then
        thfLevel = player:getMainLvl()
    elseif player:getSubJob() == xi.job.THF then
        thfLevel = player:getSubLvl()
    end

    -- Exit if THF level is 0 (shouldn't happen, but guard against it)
    if thfLevel == 0 then
        return
    end

    local taEnmityPerc = 0.5 * thfLevel / 75
    local pTarget = player:getTarget()

    if pTarget then
        -- Set processing flag to prevent recursive calls from delStatusEffectSilent
        player:setLocalVar('TA_PROCESSING', 1)

        -- Temporarily re-apply Trick Attack effect to identify the TA partner
        -- This is needed because getTrickAttackChar requires the effect to be active
        player:addStatusEffect(xi.effect.TRICK_ATTACK, 0, 0, 10)
        local taTarget = player:getTrickAttackChar(pTarget)
        player:delStatusEffectSilent(xi.effect.TRICK_ATTACK)

        -- Clear processing flag
        player:setLocalVar('TA_PROCESSING', 0)

        if taTarget then
            -- Get current enmity values
            -- CE = Cumulative Enmity (permanent hate)
            -- VE = Volatile Enmity (decaying hate)
            local ce = pTarget:getCE(player)
            local ve = pTarget:getVE(player)

            -- Transfer calculated percentage of enmity from Thief to TA partner
            -- The partner gains the transferred enmity
            pTarget:setCE(taTarget, pTarget:getCE(taTarget) + ce * taEnmityPerc)
            pTarget:setVE(taTarget, pTarget:getVE(taTarget) + ve * taEnmityPerc)

            -- Reduce Thief's enmity by the transferred amount
            -- Thief keeps the remaining percentage
            pTarget:setCE(player, ce * (1 - taEnmityPerc))
            pTarget:setVE(player, ve * (1 - taEnmityPerc))

            -- Mark transfer complete to prevent double-transfer from game's double-application
            player:setLocalVar('TA_TRANSFERRED', 1)
        end
    end
end)

return m
