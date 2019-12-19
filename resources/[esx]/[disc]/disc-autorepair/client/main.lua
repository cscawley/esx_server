ESX = nil

local vehiclesRepairing = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.VehicleRepair) do
        local marker = {
            name = v.name .. '_vr' .. k,
            type = 36,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 255 },
            size = vector3(2.0, 2.0, 2.0),
            msg = 'Press ~INPUT_CONTEXT~ to Repair Car',
            action = RunRepair,
            place = v,
            shouldDraw = function()
                return IsPedInAnyVehicle(PlayerPedId())
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)

        local blip = {
            name = v.name,
            coords = v.coords,
            colour = 39,
            sprite = 402
        }
        TriggerEvent('disc-base:registerBlip', blip)
    end
end)

function RunRepair(marker)
    local place = marker.place
    local veh = GetVehiclePedIsIn(PlayerPedId())

    if veh == 0 then
        exports['mythic_notify']:SendAlert('error', 'You must be in a Vehicle!')
        return
    end

    if not IsVehicleDamaged(veh) then
        exports['mythic_notify']:SendAlert('inform', 'Vehicle is in good condition!')
        return
    end

    ESX.TriggerServerCallback('disc-autorepair:checkHasRepair', function(isCarRepairing)
        if isCarRepairing then
            exports['mythic_notify']:SendAlert('error', 'You already have a Vehicle Repairing here!')
            return
        else
            local engineprice = Config.EnginePricePerHP * (1000 - math.max(GetVehicleEngineHealth(veh), 0))
            local bodyprice = Config.BodyPricePerHP * (1000 - math.max(GetVehicleBodyHealth(veh), 0))
            local price = math.ceil(engineprice + bodyprice)
            ESX.TriggerServerCallback('disc-autorepair:takeMoney', function(took)
                if took then
                    StartRepair(place)
                    exports['mythic_notify']:SendAlert('success', 'Starting Vehicle Repair for $' .. price .. '!')
                else
                    exports['mythic_notify']:SendAlert('error', 'No funds! You need $' .. price .. '!')
                end
            end, price)
        end
    end, place)
end

function StartRepair(place)
    local veh = GetVehiclePedIsIn(PlayerPedId())
    KickAllPeds(veh)
    while IsPedInAnyVehicle(PlayerPedId()) do
        Citizen.Wait(10)
    end
    table.insert(vehiclesRepairing, veh)
    Citizen.Wait(1000)
    TriggerServerEvent('disc-autorepair:startCarRepair', veh, place)
end

function KickAllPeds(veh)
    maxSeats = GetVehicleMaxNumberOfPassengers(veh)
    for i = maxSeats - 1, -1, -1 do
        local ped = GetPedInVehicleSeat(veh, i)
        if ped ~= 0 then
            TriggerServerEvent('disc-autorepair:kickPed', GetPlayerIdFromPed(ped))
        end
    end
end

function GetPlayerIdFromPed(ped)
    local players = ESX.Game.GetPlayers()
    for _, v in pairs(players) do
        local playerPed = GetPlayerPed(v)
        if playerPed == ped then
            return GetPlayerServerId(v)
        end
    end
    return nil
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, v in pairs(vehiclesRepairing) do
            SetVehicleEngineOn(v, false, false)
            SetVehicleDoorsLockedForAllPlayers(v, true)
        end
    end
end)

function RemoveVehicle(veh)
    for k, v in pairs(vehiclesRepairing) do
        if v == veh then
            vehiclesRepairing[k] = nil
            return
        end
    end
end

RegisterNetEvent('disc-autorepair:kickPed')
AddEventHandler('disc-autorepair:kickPed', function()
    TaskLeaveAnyVehicle(GetPlayerPed(-1))
end)

RegisterNetEvent('disc-autorepair:setVehicleRepairStage')
AddEventHandler('disc-autorepair:setVehicleRepairStage', function(veh, stage)
    SetVehicleDoorOpen(veh, stage, true, true)
end)

RegisterNetEvent('disc-autorepair:setVehicleDoneRepair')
AddEventHandler('disc-autorepair:setVehicleDoneRepair', function(veh)
    RemoveVehicle(veh)
    SetVehicleFixed(veh)
end)

RegisterNetEvent('disc-autorepair:notifyOwner')
AddEventHandler('disc-autorepair:notifyOwner', function(veh)
    SetVehicleDoorsLockedForAllPlayers(veh, false)
    serverId = GetPlayerServerId(PlayerId())
    ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
        coords = GetEntityCoords(veh)
        plate = GetVehicleNumberPlateText(veh)
        message = 'Vehicle Repair: Your Vehicle ' .. plate .. ' is ready at GPS: ' .. coords.x .. ', ' .. coords.y
        TriggerServerEvent('disc-gcphone:sendMessageFrom', 'repair', number, message, serverId)
    end)
end)
