RegisterNUICallback('SwitchSeats', function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if IsVehicleSeatFree(vehicle, data.seat) and data.seat then
        SetPedIntoVehicle(PlayerPedId(), vehicle, data.seat)
    end
    cb('OK')
end)

RegisterNUICallback('ToggleDoor', function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if data.door == 'all' then
        if data.action == 'open' then
            local maxDoors = GetNumberOfVehicleDoors(vehicle)
            for i = 0, maxDoors do
                SetVehicleDoorOpen(vehicle, i, false, false)
            end
        else
            SetVehicleDoorsShut(vehicle, false)
        end
    else

        if GetVehicleDoorAngleRatio(vehicle, data.door) ~= 0 then
            SetVehicleDoorShut(vehicle, data.door, true)
        else
            SetVehicleDoorOpen(vehicle, data.door, false, false)
        end
    end
    cb('OK')
end)