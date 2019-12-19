RegisterServerEvent('disc-interaction:drag')
AddEventHandler('disc-interaction:drag', function(target)
    TriggerClientEvent('disc-interaction:drag', target, source)
end)

RegisterServerEvent('disc-interaction:stopDrag')
AddEventHandler('disc-interaction:stopDrag', function(target)
    TriggerClientEvent('disc-interaction:stopDrag', target, source)
end)

RegisterServerEvent('disc-interaction:carry')
AddEventHandler('disc-interaction:carry', function(target)
    TriggerClientEvent('disc-interaction:carry', target, source)
end)
RegisterServerEvent('disc-interaction:stopCarry')
AddEventHandler('disc-interaction:stopCarry', function(target)
    TriggerClientEvent('disc-interaction:stopCarry', target, source)
end)

RegisterServerEvent('disc-interaction:putInVehicle')
AddEventHandler('disc-interaction:putInVehicle', function(target)
    TriggerClientEvent('disc-interaction:putInVehicle', target)
end)

RegisterServerEvent('disc-interaction:outOfVehicle')
AddEventHandler('disc-interaction:outOfVehicle', function(target)
    TriggerClientEvent('disc-interaction:outOfVehicle', target)
end)

