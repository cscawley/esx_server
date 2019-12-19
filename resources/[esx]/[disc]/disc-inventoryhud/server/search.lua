RegisterCommand('search', function(source, args, raw)
    TriggerClientEvent('disc-inventoryhud:search', source)
end)

RegisterCommand('steal', function(source, args, raw)
    TriggerClientEvent('disc-inventoryhud:steal', source)
end)

ESX.RegisterServerCallback('disc-inventoryhud:getIdentifier', function(source, cb, serverid)
    cb(ESX.GetPlayerFromId(serverid).identifier)
end)

RegisterServerEvent('disc-inventoryhud:StealCash')
AddEventHandler('disc-inventoryhud:StealCash', function(data)
    local player = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromIdentifier(data.target)
    if player and target then
        if Config.Steal.cash then
            player.addMoney(target.getMoney())
            target.setMoney(0)
        end
        if Config.Steal.black_money then
            player.addAccountMoney('black_money', target.getAccount('black_money').money)
            target.setAccountMoney('black_money', 0)
        end
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', target.source)
    end
end)

RegisterServerEvent('disc-inventoryhud:SeizeCash')
AddEventHandler('disc-inventoryhud:SeizeCash', function(data)
    local player = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromIdentifier(data.target)
    if player and target then
        if Config.Seize.cash then
            player.addMoney(target.getMoney())
            target.setMoney(0)
        end
        if Config.Seize.black_money then
            player.addAccountMoney('black_money', target.getAccount('black_money').money)
            target.setAccountMoney('black_money', 0)
        end
        TriggerClientEvent('disc-inventoryhud:refreshInventory', source)
        TriggerClientEvent('disc-inventoryhud:refreshInventory', target.source)
    end
end)