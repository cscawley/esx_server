Citizen.CreateThread(function()
    for k, v in pairs(Config.VehicleLimit) do
        print('trunk-' .. string.upper(k))
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'trunk-' .. string.upper(k),
            label = k,
            slots = v
        })
    end
    for k,v in pairs(Config.VehicleSlot) do
        TriggerEvent('disc-inventoryhud:RegisterInventory', {
            name = 'trunk-' .. k,
            label = _U('trunk') .. k,
            slots = v
        })
    end
end)
