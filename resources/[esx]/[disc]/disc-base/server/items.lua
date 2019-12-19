local items = {}

RegisterServerEvent('disc-base:registerItemUse')
AddEventHandler('disc-base:registerItemUse', function(item, cb)
    if items[item] == nil then
        items[item] = {}
        items[item].callbacks = {}
        ESX.RegisterUsableItem(item, function(source)
            UseItem(source, item)
        end)
    end
    table.insert(items[item].callbacks, cb)
end)

function UseItem(source, item)
    for k, v in pairs(items[item].callbacks) do
        v(source, item)
        Citizen.Wait(10)
    end
end

