ESX = nil

local carsRepairing = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-autorepair:checkHasRepair', function(source, cb, place)
    cb(GetVehicleAtPlaceForSource(place, source) ~= nil)
end)


--Track Vehicle Existence
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for place, v in pairs(carsRepairing) do
            for source, _ in pairs(carsRepairing[place]) do
                local veh = carsRepairing[place][source].vehicle
                if veh ~= nil then
                    if not DoesEntityExist(veh) then
                        carsRepairing[place][source].vehicle = nil
                    end
                end
            end
        end
    end
end)

RegisterServerEvent('disc-autorepair:kickPed')
AddEventHandler('disc-autorepair:kickPed', function(playerId)
    local player = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent('disc-autorepair:kickPed', player.source)
end)

RegisterServerEvent('disc-autorepair:startCarRepair')
AddEventHandler('disc-autorepair:startCarRepair', function(veh, place)
    local player = ESX.GetPlayerFromId(source)
    local _source = source
    local vehAtPlace = GetVehicleAtPlaceForSource(place, source)
    if vehAtPlace == veh then
        return
    end
    SetVehicleAtPlaceForSource(place, source, veh)
    Citizen.CreateThread(function()
        for i = 0, 7, 1 do
            Citizen.Wait(Config.StageTime)
            TriggerClientEvent('disc-autorepair:setVehicleRepairStage', -1, veh, i)
        end
        SetVehicleAtPlaceForSource(place, _source, nil)
        TriggerClientEvent('disc-autorepair:setVehicleDoneRepair', -1, veh)
        TriggerClientEvent('disc-autorepair:notifyOwner', player.source, veh)
    end)
end)

ESX.RegisterServerCallback('disc-autorepair:takeMoney', function(source, cb, price)
    local player = ESX.GetPlayerFromId(source)
    if player.getMoney() >= price then
        player.removeMoney(price)
        cb(true)
    elseif Config.AllowBank then
        if player.getBank() >= price or Config.AllowNegativeBank then
            player.removeAccountMoney('bank', price)
            cb(true)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

function GetVehicleAtPlaceForSource(place, source)
    if carsRepairing[place.name] and carsRepairing[place.name][source] then
        return carsRepairing[place.name][source].vehicle
    else
        return nil
    end
end

function SetVehicleAtPlaceForSource(place, source, veh)
    if carsRepairing[place.name] == nil then
        carsRepairing[place.name] = {}
    end
    if carsRepairing[place.name][source] == nil then
        carsRepairing[place.name][source] = {}
    end
    carsRepairing[place.name][source].vehicle = veh
end

function GetAllVehicles()

end
