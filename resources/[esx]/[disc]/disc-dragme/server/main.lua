RegisterServerEvent('dragme:drag')
AddEventHandler('dragme:drag', function(target)
    TriggerClientEvent('dragme:drag', target, source)
end)

RegisterServerEvent('dragme:detach')
AddEventHandler('dragme:detach', function()
    TriggerClientEvent('dragme:detach', source)
end)

RegisterServerEvent('dragme:putInVehicle')
AddEventHandler('dragme:putInVehicle', function(target)
    TriggerClientEvent('dragme:putInVehicle', target)
end)

RegisterServerEvent('dragme:OutVehicle')
AddEventHandler('dragme:OutVehicle', function(target)
    TriggerClientEvent('dragme:OutVehicle', target)
end)


