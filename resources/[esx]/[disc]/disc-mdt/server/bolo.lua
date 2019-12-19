ESX.RegisterServerCallback('disc-mdt:setBolo', function(source, cb, data)
    print(data.bolo)
    MySQL.Async.execute('UPDATE owned_vehicles SET bolo = @bolo WHERE plate = @plate', {
        ['@plate'] = data.plate,
        ['@bolo'] = data.bolo
    }, function()
        cb(true)
        local msg = "BOLO for " .. data.plate
        if data.bolo then
            msg = msg .. ' Issued'
        else
            msg = msg .. ' Removed'
        end
        TriggerClientEvent('disc-mdt:addNotification', -1, {
            message = msg
        })
    end)
end)