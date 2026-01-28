require('modules/module_utils')

local m = Module:new('b_abilities')

local effectAdjustments =
{
    -- Warrior
    blood_rage =
    {
        effectId = xi.effect.BLOOD_RAGE,
        add =
        {
            power = -10, -- Changed from 20% to 10%
        },
    },
    defender =
    {
        effectId = xi.effect.DEFENDER,
        set =
        {
            power = 25, -- Force static 25% defense modifier
        },
    },
    -- Monk
    impetus =
    {
        effectId = xi.effect.IMPETUS,
        add =
        {
            duration = -60000, -- Changed from 180s to 120s
        },
    },
    -- Thief
    conspirator =
    {
        effectId = xi.effect.CONSPIRATOR,
        multiply =
        {
            power = 0.75, -- 25% reduction
            subpower = 0.75, -- 25% reduction
        },
    },
    dodge =
    {
        effectId = xi.effect.DODGE,
        set =
        {
            duration = 90000, -- Changed to 90 seconds
        },
    },
    focus =
    {
        effectId = xi.effect.FOCUS,
        set =
        {
            duration = 90000, -- Changed to 90 seconds
        },
    },
    sepulcher =
    {
        effectId = xi.effect.SEPULCHER,
        add =
        {
            duration = -60000, -- Changed from 180s to 120s
        },
    },
    -- Samurai
    hagakure =
    {
        effectId = xi.effect.HAGAKURE,
        multiply =
        {
            power = 0.5, -- 50% reduction
            subpower = 0.5, -- 50% reduction
        },
    },
    hamanoha =
    {
        effectId = xi.effect.HAMANOHA,
        add =
        {
            duration = -60000, -- Changed from 180s to 120s
        },
    },
    sengikori =
    {
        effectId = xi.effect.SENGIKORI,
        add =
        {
            power = -15, -- Changed from 25% to 10%
        },
    },
    -- Dragoon
    dragon_breaker =
    {
        effectId = xi.effect.DRAGON_BREAKER,
        add =
        {
            duration = -60000, -- Changed from 180s to 120s
        },
    },
    -- Ranger
    double_shot =
    {
        effectId = xi.effect.DOUBLE_SHOT,
        add =
        {
            power = -30, -- Changed from 40% to 10%
        },
    },
    triple_shot =
    {
        effectId = xi.effect.TRIPLE_SHOT,
        add =
        {
            power = -30, -- Changed from 40% to 10%
        },
    },
    -- Bard
    marcato =
    {
        effectId = xi.effect.MARCATO,
        add =
        {
            power = -25, -- Changed from 1.5x to 1.25x
        },
    },
}

-- Helper function to check if an effect is being restored
local function isEffectBeingRestored(target)
    if not target or not target:isPC() then
        return false
    end

    -- If ZoneInTime is 0, player is in the process of zoning (onGameIn hasn't run yet)
    -- This means effects are being restored
    return target:getLocalVar('ZoneInTime') == 0
end

-- Apply effect adjustments to all configured effects
for effectName, config in pairs(effectAdjustments) do
    local effectConfig = config
    m:addOverride('xi.effects.' .. effectName .. '.onEffectGain', function(target, effect)
        local isRestoring = isEffectBeingRestored(target)

        -- Only apply adjustments for fresh effects, not restored ones
        if not isRestoring then
            -- Handle set operations (force specific values)
            if effectConfig.set then
                if effectConfig.set.power then
                    effect:setPower(effectConfig.set.power)
                end

                if effectConfig.set.subpower then
                    effect:setSubPower(effectConfig.set.subpower)
                end

                if effectConfig.set.duration then
                    effect:setDuration(effectConfig.set.duration)
                end
            end

            -- Handle add operations
            if effectConfig.add then
                if effectConfig.add.power then
                    effect:setPower(effect:getPower() + effectConfig.add.power)
                end

                if effectConfig.add.subpower then
                    effect:setSubPower(effect:getSubPower() + effectConfig.add.subpower)
                end

                if effectConfig.add.duration then
                    effect:setDuration(effect:getDuration() + effectConfig.add.duration)
                end
            end

            -- Handle multiply operations
            if effectConfig.multiply then
                if effectConfig.multiply.power then
                    effect:setPower(math.floor(effect:getPower() * effectConfig.multiply.power))
                end

                if effectConfig.multiply.subpower then
                    effect:setSubPower(math.floor(effect:getSubPower() * effectConfig.multiply.subpower))
                end

                if effectConfig.multiply.duration then
                    effect:setDuration(math.floor(effect:getDuration() * effectConfig.multiply.duration))
                end
            end
        end

        super(target, effect)
    end)
end

return m
