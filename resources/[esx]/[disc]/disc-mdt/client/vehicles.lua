RegisterNUICallback("SearchVehicles", function(data, cb)
    local model = GetHashKey(data.search:upper())
    local vehicleName = GetDisplayNameFromVehicleModel(-1008861746)
    print(vehicleName)
    ESX.TriggerServerCallback("disc-mdt:searchVehicles", function(vehicles)
        local formatVehicles = {}
        for k, v in ipairs(vehicles) do
            v.props = json.decode(v.vehicle)
            table.insert(formatVehicles, formatVehicle(v))
        end

        SendNUIMessage({
            type = "SET_VEHICLES",
            data = {
                vehicles = formatVehicles
            }
        })
        cb('OK')
    end, data.search, model)
end)


function formatVehicle(vehicle)
    vehicle.model = GetDisplayNameFromVehicleModel(vehicle.props.model)
    vehicle.colorPrimary = Config.Colors[tostring(vehicle.props.color1)]
    vehicle.colorSecondary = Config.Colors[tostring(vehicle.props.color2)]
    return vehicle
end


RegisterNUICallback('SetVehicleImage', function(data, cb)
    ESX.TriggerServerCallback('disc-mdt:setVehicleImage', function(done)
        cb('OK')
    end, data)
end)