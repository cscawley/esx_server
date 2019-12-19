ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

local vehicles = {}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        MySQL.Async.execute('UPDATE disc_vehiclesales_stored_vehicles SET state = 0')
    end
end)

RegisterServerEvent('disc-vehiclesales:storeVehicle')
AddEventHandler('disc-vehiclesales:storeVehicle', function(data)
    MySQL.Async.execute('INSERT INTO disc_vehiclesales_stored_vehicles (plate, props, job, name, state) VALUES (@plate, @props, @job, @name, 0)', {
        ['@plate'] = data.plate,
        ['@props'] = json.encode(data.props),
        ['@job'] = data.job,
        ['@name'] = data.name
    })
end)

ESX.RegisterServerCallback('disc-vehiclesales:getStoredVehicles', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM disc_vehiclesales_stored_vehicles WHERE job = @job AND state = 0', {
        ['@job'] = player.job.name
    }, function(results)
        cb(results)
    end)
end)

RegisterServerEvent('disc-vehiclesales:setVehicleToDisplay')
AddEventHandler('disc-vehiclesales:setVehicleToDisplay', function(data)
    data.sellerId = ESX.GetPlayerFromId(source).identifier
    vehicles[data.plate] = data
    TriggerClientEvent('disc-vehiclesales:newVehicles', -1, vehicles)
    SetVehicleState(data.plate, 1)
end)

RegisterServerEvent('disc-vehiclesales:removeVehicleToDisplay')
AddEventHandler('disc-vehiclesales:removeVehicleToDisplay', function(plate)
    vehicles[plate] = {
        removed = true
    }
    TriggerClientEvent('disc-vehiclesales:newVehicles', -1, vehicles)
    vehicles[plate] = nil
    SetVehicleState(plate, 0)
end)

function SetVehicleState(plate, state)
    MySQL.Async.execute('UPDATE disc_vehiclesales_stored_vehicles SET state = @state WHERE plate = @plate', {
        ['@state'] = state,
        ['@plate'] = plate
    })
end

RegisterServerEvent('disc-vehiclesales:buyVehicle')
AddEventHandler('disc-vehiclesales:buyVehicle', function(vehicle)
    local player = ESX.GetPlayerFromId(source)
    local seller = ESX.GetPlayerFromIdentifier(vehicle.sellerId)
    if player.getMoney() >= vehicle.price then
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
            ['@plate'] = vehicle.props.plate,
            ['@vehicle'] = json.encode(vehicle.props),
            ['@owner'] = player.identifier
        }, function(results)
            player.removeMoney(vehicle.price)
            TriggerClientEvent('disc-vehiclesales:message', player.source, 'success', 'Vehicle Bought')
            if seller then
                seller.addAccountMoney('bank', vehicle.price)
                TriggerClientEvent('disc-vehiclesales:message', seller.source, 'success', 'Your vehicle with plate ' .. vehicle.props.plate .. ' was sold for $' .. vehicle.price)
            else
                MySQL.Async.execute('UPDATE users SET bank = bank + @price WHERE identifier = @identifier', {
                    ['@price'] = vehicle.price,
                    ['@identifier'] = vehicle.sellerId
                })
            end
            MySQL.Async.execute('DELETE FROM disc_vehiclesales_stored_vehicles WHERE plate = @plate', {
                ['@plate'] = vehicle.props.plate
            })
            TriggerEvent('disc-vehiclesales:removeVehicleToDisplay', vehicle.props.plate)
        end)
    end
end)