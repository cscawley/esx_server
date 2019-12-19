ESX.RegisterServerCallback('disc-property:getClothes', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local count = store.count('dressing')
        local clothes = {}

        for i = 1, count, 1 do
            local entry = store.get('dressing', i)
            table.insert(clothes, entry)
        end
        cb(clothes)
    end)
end)

RegisterServerEvent('disc-property:removeOutfit')
AddEventHandler('disc-property:removeOutfit', function(label)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local count = store.count('dressing')
        local dressing = store.get('dressing')
        for i = 1, count, 1 do
            local entry = store.get('dressing', i)
            if entry.label == label then
                table.remove(dressing, i)
            end
        end
        store.set('dressing', dressing)
    end)
end)