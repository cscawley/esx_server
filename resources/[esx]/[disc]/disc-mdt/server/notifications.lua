function sendNotification(source, data)
    TriggerClientEvent('disc-mdt:addNotification', source, data)
end

RegisterServerEvent('disc-mdt:sendNotification')
AddEventHandler('disc-mdt:sendNotification', function(source, data)
    sendNotification(source, data)
end)

RegisterServerEvent('disc-mdt:sendNotificationToJob')
AddEventHandler('disc-mdt:sendNotificationToJob', function(job, data)
    local players = ESX.GetPlayers()
    for k, v in pairs(players) do
        local player = ESX.GetPlayerFromId(v)
        print(player.job.name)
        if player.job.name == job then
            sendNotification(player.source, data)
        end
    end
end)