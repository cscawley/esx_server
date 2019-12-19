ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-base:registerItemUse', 'lockpick', function(source, item)
        TriggerClientEvent('disc-hotwire:hotwire', source)
    end)
end)

ESX.RegisterServerCallback('disc-hotwire:checkOwner', function(source, cb, plate)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier AND plate = @plate', {
        ['@identifier'] = player.identifier,
        ['@plate'] = plate
    }, function(results)
        cb(#results == 1)
    end)
end)