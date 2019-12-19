Citizen.CreateThread(function()
    TriggerEvent('disc-inventoryhud:RegisterInventory', {
        name = 'cupboard',
        label = _U('cupboard'),
        slots = 20,
    })
end)
