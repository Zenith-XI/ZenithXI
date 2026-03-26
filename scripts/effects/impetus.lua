-----------------------------------
-- xi.effect.IMPETUS
-----------------------------------
---@type TEffect
local effectObject = {}

effectObject.onEffectGain = function(target, effect)
    target:addListener('MELEE_SWING_MISS', 'IMPETUS_MISS', xi.job_utils.monk.impetusMissListener)
    target:addListener('MELEE_SWING_HIT', 'IMPETUS_HIT', xi.job_utils.monk.impetusHitListener)
end

effectObject.onEffectTick = function(target, effect)
end

effectObject.onEffectLose = function(target, effect)
    -- TODO: Support Tantra Cyclas + 1 (does not give critical hit damage)
    target:removeListener('IMPETUS_MISS')
    target:removeListener('IMPETUS_HIT')
end

return effectObject
