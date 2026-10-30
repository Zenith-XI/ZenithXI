local m = Module:new('b_regimes')

m:addOverride('xi.regime.checkRegime', function(player, mob, regimeId, index, regimeType)
    if not player then
        return
    end

    if player:getCharVar('[regime]lastReward') < VanadielUniqueDay() then
        super(player, mob, regimeId, index, regimeType)
    elseif player:getCharVar('[regime]id') == regimeId then
        -- cannot receive credit for regime today, so say why on every kill of a mob on the page
        player:printToPlayer('You must wait until the next game day to complete another Page of Valor', xi.msg.channel.SYSTEM_3)
    end
end)

return m
