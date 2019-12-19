local busy = false

function OpenGarage(property)

    local options = {
        { label = _U('parked'), action = function()
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed) then
                StoreVehicle(GetVehiclePedIsIn(playerPed), property.name)
            else
                exports['mythic_notify']:SendAlert('error', _U('noveh'))
            end
            ESX.UI.Menu.CloseAll()
        end },
        { label = _U('takeveh'), action = function()
            if ESX.Game.IsSpawnPointClear(property.garage.coords, 3.0) then
                ESX.TriggerServerCallback('disc-property:getStoredVehicles', function(results)
                    local options = {}
                    for k, v in pairs(results) do
                        local props = json.decode(v.props)
                        local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
                        local label = ('%s - <span style="color:blue;">%s</span>'):format(vehicleName, props.plate)
                        table.insert(options, {
                            label = label,
                            action = function()
                                SpawnVehicle(property.garage.coords, property.garage.heading, props)
                                ESX.UI.Menu.CloseAll()
                            end
                        })
                    end
                    local menu = {
                        name = 'garage_vehicles',
                        title = _U('garage'),
                        options = options
                    }
                    TriggerEvent('disc-base:openMenu', menu)
                end, property.name)
            else
                exports['mythic_notify']:SendAlert('error', _U('nospace'))
            end
        end },
    }

    local menu = {
        name = 'garage',
        title = _U('garage'),
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)

end

function StoreVehicle(vehicle, propertyName)

    local props = ESX.Game.GetVehicleProperties(vehicle)
    ESX.TriggerServerCallback('disc-property:storeVehicle', function(stored)
        if stored == 'stored' then
            local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
            local label = ('%s - <span style="color:blue;">%s</span>'):format(vehicleName, props.plate)
            ESX.Game.DeleteVehicle(vehicle)
            exports['mythic_notify']:SendAlert('success', _U('saving') .. label)
        elseif stored == 'notowned' then
            exports['mythic_notify']:SendAlert('error', _U('notowned'))
        elseif stored == 'max' then
            exports['mythic_notify']:SendAlert('error', _U('exceed'))
        end
        busy = false
    end, propertyName, props)
end

function SpawnVehicle(garageCoords, heading, props)

    local playerPed = GetPlayerPed(-1)
    local vehicleName = GetLabelText(GetDisplayNameFromVehicleModel(props.model))
    local label = ('%s - <span style="color:blue;">%s</span>'):format(vehicleName, props.plate)
    ESX.TriggerServerCallback('disc-property:spawnVehicle', function(spawned)
        if spawned then
            ESX.Game.SpawnVehicle(props.model, garageCoords, heading, function(vehicle)
                ESX.Game.SetVehicleProperties(vehicle, props)
                TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                exports['mythic_notify']:SendAlert('success', _U('spawned') .. label)
                busy = false
            end)
        end
    end
    , props.plate)
end
