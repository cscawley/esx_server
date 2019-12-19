ESX.RegisterServerCallback('disc-mdt:searchVehicles', function(source, cb, search, model)
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles o JOIN users u on u.identifier = o.owner WHERE lower(plate) LIKE lower(@plate)', {
        ['@plate'] = '%' .. search .. '%'
    }, function(vehicles)
        if model ~= nil then
            MySQL.Async.fetchAll('SELECT * from owned_vehicles o JOIN users u on u.identifier = o.owner where JSON_EXTRACT(VEHICLE, "$.model") = @model', {
                ['@model'] = model
            }, function(models)
                cb(table.combine(vehicles, models))
            end)
        else
            cb(vehicles)
        end
    end)
end)

ESX.RegisterServerCallback('disc-mdt:setVehicleImage', function(source, cb, data)
    MySQL.Async.execute('UPDATE owned_vehicles SET vehicleimage=@url WHERE plate = @plate', {
        ['@url'] = data.url,
        ['@plate'] = data.plate
    }, function()
        cb(true)
    end)
end)
