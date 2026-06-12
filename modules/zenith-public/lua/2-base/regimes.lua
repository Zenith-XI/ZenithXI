local m = Module:new('b_regimes')

m:addOverride('xi.regime.checkRegime', function(player, mob, regimeId, index, regimeType)
    if not player then
        return
    end

    local vanadielEpoch = VanadielUniqueDay()
    local localVarName = 'regimeReminder'
    if player:getCharVar('[regime]lastReward') < vanadielEpoch then
        player:setLocalVar(localVarName, 0)
        super(player, mob, regimeId, index, regimeType)
    else
        -- cannot receive credit for regime today, maybe give a system message once per zone?
        if
            player:getLocalVar(localVarName) == 0 and
            player:getCharVar('[regime]id') == regimeId
        then
            player:sys('You must wait until the next game day to complete another Page of Valor')
            player:setLocalVar(localVarName, 1)
        end
    end
end)

return m
