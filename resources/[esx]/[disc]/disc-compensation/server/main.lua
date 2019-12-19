ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand("compensate", function(src, args, raw)
    local player = ESX.GetPlayerFromId(src)
    local job = Config.Jobs[player.job.name]
    if job ~= nil then
        for k, v in pairs(job) do
            if v == player.job.grade_name then
                TriggerClientEvent('disc-compensation:compensate', src)
            end
        end
    end
end)

RegisterServerEvent('disc-compensation:compensate')
AddEventHandler('disc-compensation:compensate', function(compensation)

    local compensator = ESX.GetPlayerFromId(compensation.compensator)
    local receiver = ESX.GetPlayerFromId(compensation.receiver)

    MySQL.Async.execute('INSERT INTO compensation (compensator, receiver, reason, amount) VALUES (@compensator, @receiver, @reason, @amount)', {
        ['@compensator'] = compensator.identifier,
        ['@receiver'] = receiver.identifier,
        ['@reason'] = compensation.reason,
        ['@amount'] = compensation.amount,
    }, function()
        local compensationP = Config.CompensationPercentage / 100
        receiver.addMoney(compensation.amount)
        compensator.addMoney(compensation.amount * compensationP)
        TriggerClientEvent('disc-compensation:receiveCompensation', compensation.receiver, compensation.amount)
    end)
end)
