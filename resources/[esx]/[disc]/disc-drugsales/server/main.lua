ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback("disc-drugsales:sellDrug", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player then
        local item, hasItem = DoPlayerHaveItems(player)

        if hasItem then
            math.randomseed(os.time())
            local randomPayment = math.random(item.priceMin, item.priceMax)

            local maxCount = player.getInventoryItem(item.name)["count"]
            local randomCount = math.random(item.sellCountMin, item.sellCountMax)
            local count = 0
            if maxCount <= randomCount then
                count = maxCount
            else
                count = randomCount
            end

            player.removeInventoryItem(item.name, count)

            player.addAccountMoney('black_money', randomPayment * count)

            cb(randomPayment * count)
        else
            cb(false)
        end
    else
        cb(false)
    end
end)

DoPlayerHaveItems = function(player)
    local item = false

    for k, v in pairs(Config.DrugItems) do
        local itemName = v.name
        local itemInformation = player.getInventoryItem(itemName)

        if itemInformation and itemInformation["count"] > 0 then
            item = v

            break
        end
    end

    return item, item ~= false
end

ESX.RegisterServerCallback('disc-drugsales:hasDrugs', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    local item, hasItem = DoPlayerHaveItems(player)
    cb(hasItem)
end)

ESX.RegisterServerCallback('disc-drugsales:getOnlinePolice', function(source, cb)
    local _source = source
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i = 1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    Wait(25)
    cb(cops)
end)