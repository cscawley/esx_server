ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

TriggerEvent('disc-base:registerItemUse', 'lockpick', function(source, item)
    TriggerClientEvent('disc-lockpick:lockpick', source, item)
end)

TriggerEvent('disc-base:registerItemUse', 'blowtorch', function(source, item)
    TriggerClientEvent('disc-lockpick:lockpick', source, item)
end)