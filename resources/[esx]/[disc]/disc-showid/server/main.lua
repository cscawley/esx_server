ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand('id', function(source, args, raw)
    local player = ESX.GetPlayerFromId(source)
    if Config.AdminOnly then
        if player.getGroup() == 'user' then
            return
        end
    end
    TriggerClientEvent('disc-showid:id', source)
end)