ESX = nil
displayVehicle = nil

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

local vehicles = {}

Citizen.CreateThread(function()
    Citizen.Wait(0)
    while true do
        Citizen.Wait(1000)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        for k, v in pairs(vehicles) do
            local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, v.coords.x, v.coords.y, v.coords.z, true)
            if not v.spawned and distance <= Config.DrawDistance then
                ESX.Game.SpawnLocalVehicle(v.props.model, v.coords, v.heading, function(localVehicle)
                    ESX.Game.SetVehicleProperties(localVehicle, v.props)
                    SetEntityMaxSpeed(localVehicle, 0.0)
                    SetEntityInvincible(localVehicle, true)
                    FreezeEntityPosition(localVehicle, true)
                    for i = 0, GetNumberOfVehicleDoors(localVehicle) do
                        SetVehicleDoorCanBreak(localVehicle, i, false)
                        SetVehicleDoorShut(localVehicle, i, true)
                    end
                    SetVehicleDoorsLocked(localVehicle, 2)
                    vehicles[k].localVehicle = localVehicle
                    v.spawned = true
                end)
                local min, max = GetModelDimensions(model)
                local marker = {
                    name = 'vehicle_sales_' .. v.props.plate,
                    type = 1,
                    show3D = true,
                    coords = v.coords,
                    colour = { r = 55, b = 255, g = 55 },
                    size = vector3(max.x + 1.5, max.y + 1.5, 1.0),
                    msg = 'Press [E] to purchase this ' .. v.name .. ' for $' .. v.price,
                    action = function()
                        ShowBuyMenu(v)
                    end
                }
                TriggerEvent('disc-base:registerMarker', marker)
            end
            if v.spawned and distance > 10 then
                ESX.Game.DeleteVehicle(v.localVehicle)
                v.spawned = false
            end

            if v.remove then
                ESX.Game.DeleteVehicle(v.localVehicle)
                vehicles[k] = nil
                TriggerEvent('disc-base:removeMarker', 'vehicle_sales_' .. v.props.plate)
            end
        end
    end
end)

RegisterNetEvent('disc-vehiclesales:newVehicles')
AddEventHandler('disc-vehiclesales:newVehicles', function(newVehicles)
    for k, v in pairs(newVehicles) do
        if vehicles[k] == nil then
            vehicles[k] = v
        end
        if v.removed then
            vehicles[k].remove = true
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k, v in pairs(Config.StoreAreas) do
        local marker = {
            name = v.name,
            type = 1,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 55 },
            size = vector3(1.5, 1.5, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to Store Vehicle',
            action = function()
                StoreVehicle()
            end,
            shouldDraw = function()
                local playerPed = GetPlayerPed(-1)
                return IsPedInAnyVehicle(playerPed) and (ESX.PlayerData.job.name == v.job or v.job == 'all')
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function StoreVehicle()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed)
        local props = ESX.Game.GetVehicleProperties(vehicle)
        local plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent('disc-vehiclesales:storeVehicle', {
            plate = plate,
            props = props,
            job = ESX.PlayerData.job.name,
            name = GetDisplayNameFromVehicleModel(props.model)
        })
        ESX.Game.DeleteVehicle(vehicle)
    end
end

RegisterCommand('displayvehicle', function(source, args, raw)
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    ESX.TriggerServerCallback('disc-vehiclesales:getStoredVehicles', function(vehicles)
        local options = {}
        for k, v in pairs(vehicles) do
            v.props = json.decode(v.props)
            table.insert(options, {
                label = ('%s - <span style="color:darkgoldenrod;">%s</span>: '):format(v.name, v.plate),
                action = function()
                    ESX.UI.Menu.CloseAll()
                    if displayVehicle and DoesEntityExist(displayVehicle) then
                        ESX.Game.DeleteVehicle(displayVehicle)
                        displayVehicle = nil
                    end
                    ShowPriceDisplay(v, coords, heading)
                end
            })
        end

        local menu = {
            name = 'display_vehicle_selection',
            title = 'Select Vehicle to Display',
            options = options,
            onOpen = function()
                if #vehicles > 0 then
                    if displayVehicle and DoesEntityExist(displayVehicle) then
                        ESX.Game.DeleteVehicle(displayVehicle)
                    end
                    SpawnDisplayVehicle(vehicles[1], coords, heading)
                end
            end,
            onChange = function(data)
                if #vehicles > 0 then
                    if displayVehicle and DoesEntityExist(displayVehicle) then
                        ESX.Game.DeleteVehicle(displayVehicle)
                    end
                    SpawnDisplayVehicle(vehicles[data.current.value], coords, heading)
                end
            end,
            close = function()
                if displayVehicle and DoesEntityExist(displayVehicle) then
                    ESX.Game.DeleteVehicle(displayVehicle)
                    displayVehicle = nil
                end
            end
        }
        TriggerEvent('disc-base:openMenu', menu)
    end)
end)

function SpawnDisplayVehicle(vehicle, coords, heading)
    ESX.Game.SpawnLocalVehicle(vehicle.props.model, coords, heading, function(localVehicle)
        ESX.Game.SetVehicleProperties(localVehicle, vehicle.props)
        SetEntityMaxSpeed(localVehicle, 0.0)
        SetEntityInvincible(localVehicle, true)
        FreezeEntityPosition(localVehicle, true)
        for i = 0, GetNumberOfVehicleDoors(localVehicle) do
            SetVehicleDoorCanBreak(localVehicle, i, false)
            SetVehicleDoorShut(localVehicle, i, true)
        end
        SetVehicleDoorsLocked(localVehicle, 2)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), localVehicle, -1)
        displayVehicle = localVehicle
    end)
end

function ShowPriceDisplay(v, coords, heading)
    local menu = {
        type = 'dialog',
        action = function(value)
            if tonumber(value) ~= nil then
                v.coords = coords
                v.heading = heading
                v.price = tonumber(value)
                SetDisplayVehicle(v)
            end
        end,
        name = 'vehicle_sale_price',
        title = 'Enter Amount'
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function SetDisplayVehicle(v)
    TriggerServerEvent('disc-vehiclesales:setVehicleToDisplay', v)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayVehicle then
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
    end
end)

RegisterCommand('removedisplay', function(source, args, raw)
    local vehicle = ESX.Game.GetVehicleInDirection()
    if DoesEntityExist(vehicle) then
        TriggerServerEvent('disc-vehiclesales:removeVehicleToDisplay', GetVehicleNumberPlateText(vehicle))
    end
end)

function ShowBuyMenu(vehicle)
    local options = {
        { label = 'Test Drive WIP' },
        { label = 'Purchase', action = function()
            local menu = {
                type = 'confirmation',
                name = 'vehicle_sale_purchase',
                confirmation = function()
                    BuyVehicle(vehicle)
                end,
                denial = function()
                    ShowBuyMenu(vehicle)
                end
            }
            TriggerEvent('disc-base:openMenu', menu)

        end },
    }
    local menu = {
        title = 'Buy Menu',
        name = 'vehicle_sales_buy_menu',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function BuyVehicle(vehicle)
    TriggerServerEvent('disc-vehiclesales:buyVehicle', vehicle)
end

RegisterNetEvent('disc-vehiclesales:message')
AddEventHandler('disc-vehiclesales:message', function(type, msg)
    exports['mythic_notify']:SendAlert(type, msg)
end)

