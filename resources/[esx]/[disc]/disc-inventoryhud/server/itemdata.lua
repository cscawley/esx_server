local itemData = {}

Citizen.CreateThread(function()
    Citizen.Wait(0)
    itemData = {}
    MySQL.Async.fetchAll('SELECT * FROM disc_inventory_itemdata', {}, function(results)
        for k, v in pairs(results) do
            itemData[v.name] = v
        end
    end)
end)

function getItemDataProperty(name, property)
    if itemData[name] and itemData[name][property] then
        return itemData[name][property]
    else
        return nil
    end
end
