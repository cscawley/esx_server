ESX.RegisterServerCallback('disc-property:storeVehicle', function(source, cb, propertyName, props)
    MySQL.Async.fetchAll('SELECT * FROM disc_property_garage_vehicles WHERE name = @name', {
        ['@name'] = propertyName,
    }, function(results)

        if Config.Garage.max and #results >= Config.Garage.max then
            cb('max')
            return
        end

        if Config.Garage.owned then
            local player = ESX.GetPlayerFromId(source)
            MySQL.Async.fetchAll('SELECT plate FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
                ['@owner'] = player.identifier,
                ['@plate'] = props.plate,
            }, function(results)
                if #results > 0 then
                    StoreVehicle(propertyName, props, cb)
                else
                    cb('notowned')
                end
            end)
            return
        end
        StoreVehicle(propertyName, props, cb)
    end)
end)

function StoreVehicle(propertyName, props, cb)
    MySQL.Async.execute('INSERT INTO disc_property_garage_vehicles (name, plate, props) VALUES (@name, @plate, @props)', {
        ['@name'] = propertyName,
        ['@plate'] = props.plate,
        ['@props'] = json.encode(props)
    }, function()
        cb('stored')
    end)
end

ESX.RegisterServerCallback('disc-property:getStoredVehicles', function(source, cb, propertyName)
    MySQL.Async.fetchAll('SELECT * FROM disc_property_garage_vehicles WHERE name = @name', {
        ['@name'] = propertyName
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-property:spawnVehicle', function(source, cb, plate)
    MySQL.Async.execute('DELETE FROM disc_property_garage_vehicles where plate = @plate', {
        ['@plate'] = plate,
    }, function()
        cb(true)
    end)
end)
