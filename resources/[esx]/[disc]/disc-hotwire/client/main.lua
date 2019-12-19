ESX = nil
local isActive = false

local trackedVehicles = {}

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

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('disc-hotwire:forceTurnOver')
AddEventHandler('disc-hotwire:forceTurnOver', function(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    TrackVehicle(plate, vehicle)
    trackedVehicles[plate].canTurnOver = true
end)

RegisterNetEvent('disc-hotwire:hotwire')
AddEventHandler('disc-hotwire:hotwire', function()
    if isActive then
        return
    end
    local playerPed = GetPlayerPed(-1)

    if not IsPedInAnyVehicle(playerPed) then
        return
    end

    local veh = GetVehiclePedIsIn(playerPed)
    local plate = GetVehicleNumberPlateText(veh)

    if GetIsVehicleEngineRunning(veh) or IsVehicleEngineStarting(veh) then
        return
    end

    if trackedVehicles[plate].canTurnOver then
        return
    end

    isActive = true
    for i = 0, Config.Stages - 1, 1 do
        exports['mythic_notify']:SendAlert('inform', 'Starting Stage ' .. i + 1)
        Citizen.Wait(Config.HotwireTime)
    end

    exports['mythic_notify']:SendAlert('success', 'Ignition Wired!')
    trackedVehicles[plate].canTurnOver = true
    isActive = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        --Test Entering Vehicles
        if IsPedGettingIntoAVehicle(playerPed) then
            local vehicle = GetVehiclePedIsTryingToEnter(playerPed)
            local plate = GetVehicleNumberPlateText(vehicle)
            if plate ~= nil then
                TrackVehicle(plate, vehicle)
                if GetIsVehicleEngineRunning(vehicle) then
                    TriggerEvent('disc-hotwire:forceTurnOver', vehicle)
                end
            end
        end
        --Test In Vehicles (Helps with Spawning Vehicles)
        if IsPedInAnyVehicle(playerPed) then
            local vehicle = GetVehiclePedIsIn(playerPed)
            local plate = GetVehicleNumberPlateText(vehicle)
            if plate ~= nil then
                TrackVehicle(plate, vehicle)
            end
        end
    end
end)

function TrackVehicle(plate, vehicle)
    if trackedVehicles[plate] == nil then
        trackedVehicles[plate] = {}
        trackedVehicles[plate].vehicle = vehicle
        trackedVehicles[plate].canTurnOver = false
    end
end


--Disable All Cars Not tracked or Turned over
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(trackedVehicles) do
            if not v.canTurnOver or v.state == 0 then
                SetVehicleEngineOn(v.vehicle, false, false)
            elseif v.state == 1 then
                SetVehicleEngineOn(v.vehicle, true, false)
                v.state = -1
            end
        end
    end
end)

--Turnover key
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, Config.TurnOverKey) then
            local playerPed = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(playerPed)
            local isTurned = GetIsVehicleEngineRunning(vehicle)
            local plate = GetVehicleNumberPlateText(vehicle)
            if trackedVehicles[plate] == nil then
                TrackVehicle(plate, vehicle)
            end

            if isTurned then
                trackedVehicles[plate].state = 0
            elseif trackedVehicles[plate].canTurnOver then
                trackedVehicles[plate].state = 1
            elseif trackedVehicles[plate] ~= nil then
                ESX.TriggerServerCallback('disc-hotwire:checkOwner', function(owner)
                    if owner then
                        trackedVehicles[plate].canTurnOver = true
                        trackedVehicles[plate].state = 1
                    end
                end, plate)
            end

        end
    end
end)
