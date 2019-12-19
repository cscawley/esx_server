ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('disc-panic:sendPanic')
AddEventHandler('disc-panic:sendPanic', function(coords, job)
    local players = ESX.GetPlayers()
    for k, source in pairs(players) do
        local player = ESX.GetPlayerFromId(source)
        if player.job and player.job.name == job then
            TriggerClientEvent('disc-panic:addPanic', source, coords)
        end
    end
end)