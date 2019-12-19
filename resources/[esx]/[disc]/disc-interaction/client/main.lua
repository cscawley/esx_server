ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 73) then
            local isInVehicle = IsPedInAnyVehicle(PlayerPedId())
            local maxSeats = -1
            local doorIndex = -1
            if isInVehicle then
                local veh = GetVehiclePedIsIn(PlayerPedId())
                maxSeats = GetVehicleMaxNumberOfPassengers(veh)
                doorIndex = GetNumberOfVehicleDoors(veh)
            end
            SendNUIMessage({
                action = 'show',
                isInVehicle = isInVehicle,
                seatMaxIndex = maxSeats,
                doorIndex = doorIndex
            })
            SetNuiFocus(true, true)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SendNUIMessage({
            action = 'hide',
        })
        SetNuiFocus(false, false)
    end
end)

RegisterNUICallback('NUIFocusOff', function()
    SendNUIMessage({
        action = 'hide'
    })
    SetNuiFocus(false, false)
end)
