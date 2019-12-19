ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-shops:buyItem', function(source, cb, item, price)
    local player = ESX.GetPlayerFromId(source)
    local invItem = player.getInventoryItem(item)

    if invItem.count + 1 > invItem.limit then
        cb(-1)
        return
    end

    if player.getMoney() >= price then
        player.removeMoney(price)
        player.addInventoryItem(item, 1)
        cb(1)
    else
        cb(0)
    end
end)