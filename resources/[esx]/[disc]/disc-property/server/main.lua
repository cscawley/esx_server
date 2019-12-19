ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-property:getPropertyData', function(_, cb)
    MySQL.Async.fetchAll('SELECT * FROM disc_property', {}, function(propertyData)
        MySQL.Async.fetchAll('SELECT * FROM disc_property_owners where active', {}, function(ownerData)
            cb(propertyData, ownerData)
        end)
    end)
end)

--Update Clients With Data
Citizen.CreateThread(function()
    Citizen.Wait(0)
    while true do
        Citizen.Wait(1000)
        MySQL.Async.fetchAll('SELECT * FROM disc_property', {}, function(propertyData)
            MySQL.Async.fetchAll('SELECT * FROM disc_property_owners where active', {}, function(ownerData)
                TriggerClientEvent('disc-property:updatePropertyData', -1, propertyData, ownerData)
            end)
        end)
    end
end)