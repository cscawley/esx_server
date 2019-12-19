ESX = nil
local ActiveVehicle
local IsImportActive = false

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
        if ActiveVehicle ~= nil and IsImportActive then
            if not DoesEntityExist(ActiveVehicle) then
                IsImportActive = false
                for k, v in pairs(Config.ImportJobs) do
                    Config.ImportJobs[k].State = 0
                end
                ESX.TriggerServerCallback('disc-base:takePlayerItem', function()
                end, 'crate', 1)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.ImportJobs) do
        local marker = {
            name = v.Item .. 'import_job_sl',
            type = 39,
            coords = v.StartingLocation,
            colour = { r = 55, b = 55, g = 255 },
            size = vector3(1.0, 1.0, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to start Import of ' .. v.Item,
            action = function()
                StartImport(k, v)
            end,
            shouldDraw = function()
                return not IsImportActive
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end

    for k, v in pairs(Config.ImportJobs) do
        local marker = {
            name = v.Item .. 'import_job_pl',
            type = 39,
            coords = v.PickupLocation,
            colour = { r = 55, b = 55, g = 255 },
            size = vector3(1.0, 1.0, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to Pickup ' .. v.Item,
            action = function()
                PickupCrate(k, v)
            end,
            shouldDraw = function()
                return Config.ImportJobs[k].State == 1 and InImportVehicle()
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end

    for k, v in pairs(Config.ImportJobs) do
        local marker = {
            name = v.Item .. 'import_job_rl',
            type = 39,
            coords = v.StartingLocation,
            colour = { r = 55, b = 55, g = 255 },
            size = vector3(1.0, 1.0, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to Return Vehicle',
            action = function()
                FinishImport(k, v)
            end,
            shouldDraw = function()
                return Config.ImportJobs[k].State == 2 and InImportVehicle()
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end

end)

function InImportVehicle()
    local playerPed = PlayerPedId()
    return IsPedInAnyVehicle(playerPed) and GetVehiclePedIsIn(playerPed) == ActiveVehicle
end

function StartImport(k, config)

    ESX.TriggerServerCallback('disc-base:buy', function(bought)
        if bought == 0 then
            exports['mythic_notify']:SendAlert('error', 'Not Enough Money! You need $' .. config.Price)
            return
        end

        local playerPed = PlayerPedId()
        ESX.Game.SpawnVehicle(config.Vehicle, config.VehicleSpawnLocation, config.VehicleSpawnHeading, function(vehicle)
            ActiveVehicle = vehicle
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            IsImportActive = true
            Config.ImportJobs[k].State = 1
        end)
    end, config.Price)

end

function PickupCrate(k, config)
    Config.ImportJobs[k].State = 2
    TriggerServerEvent('disc-base:givePlayerItem', 'crate', 1)
end

function FinishImport(k, v)
    ESX.TriggerServerCallback('disc-base:takePlayerItem', function(took)
        if took then
            Config.ImportJobs[k].State = 0
            IsImportActive = false
            ESX.Game.DeleteVehicle(ActiveVehicle)
            ActiveVehicle = nil
            TriggerServerEvent('disc-base:givePlayerItem', v.Item , v.Quantity)
        else
            exports['mythic_notify']:SendAlert('error', 'Where are my items?!')
        end
    end, 'crate', 1)
end
