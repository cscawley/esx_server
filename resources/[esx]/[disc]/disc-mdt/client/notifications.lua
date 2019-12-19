RegisterNetEvent('disc-mdt:addNotification')
AddEventHandler('disc-mdt:addNotification', function(data)
    SendNUIMessage({
        type = 'ADD_NOTIFICATION',
        data = data
    })
end)

