IsInBoot = false
InVehicle = nil

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

function GetInBoot()
    local vehicle, closestDistance = ESX.Game.GetClosestVehicle()
    local playerPed = GetPlayerPed(-1)
    if  closestDistance > 4.0 or IsPedInAnyVehicle(playerPed) then
        return
    end
    if Config.MustHaveBoot and not DoesVehicleHaveDoor(vehicle, 5) then
        exports['mythic_notify']:SendALert('error', 'This car does not have a boot')
        return
    end
    if IsBigVehicle(vehicle) then
        exports['mythic_notify']:SendAlert('error', 'NO')
        return
    end

    if DoesEntityExist(vehicle) then
        SetEntityVisible(playerPed, false)
        SetEntityCollision(playerPed, false, false)
        IsInBoot = true
        InVehicle = vehicle
        TriggerBootAnimation()
    end
end

function TriggerBootAnimation()
    Citizen.CreateThread(function()
        SetVehicleDoorOpen(InVehicle, 5, false, false)
        Citizen.Wait(1000)
        SetVehicleDoorShut(InVehicle, 5, false)
    end)
end

function GetOutOfBoot()
    if not IsInBoot then
        exports['mythic_notify']:SendAlert('error', 'You are not in a boot')
        return
    end
    if DoesEntityExist(InVehicle) then
        local playerPed = GetPlayerPed(-1)
        local coords = GetOffsetFromEntityInWorldCoords(InVehicle, 0.0, -4.0, 0.0)
        SetEntityVisible(playerPed, true)
        SetEntityCoords(playerPed, coords)
        SetEntityCollision(playerPed, true, true)
        IsInBoot = false
        InVehicle = false
        TriggerBootAnimation()
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsInBoot then
            DisableAllControlActions(0)
            EnableControlAction(0, 1)
            EnableControlAction(0, 2)
            EnableControlAction(0, 245)
            AttachEntityToEntity(playerPed, InVehicle, -1, 0.0, 0.0, 0.4, 0.0, 0.0, 0.0, false, false, true, true, 2, true)
        else
            DetachEntity(playerPed, true, true)
        end
    end
end)

RegisterCommand("boot", function(src, args, raw)
    if args[1] == 'in' and not IsInBoot then
        GetInBoot()
    end

    if args[1] == 'out' and IsInBoot then
        GetOutOfBoot()
    end
end)
