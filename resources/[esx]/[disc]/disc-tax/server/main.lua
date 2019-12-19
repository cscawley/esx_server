ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

Citizen.CreateThread(function()
    TriggerEvent('disc-base:registerTimeCron', TaxPlayers, Config.TaxTime)
end)

function TaxPlayers()
    MySQL.Async.fetchAll('SELECT identifier, money, bank FROM users', {}, function(results)
        for k, player in pairs(results) do
            local fullMoney = player.bank

            if Config.TaxMoney then
                fullMoney = fullMoney + player.money
            end

            local percent = getTaxPercent(fullMoney)
            local taxAmount = math.floor(fullMoney * percent)

            local onlinePlayer = ESX.GetPlayerFromIdentifier(player.identifier)
            if onlinePlayer ~= nil then
                onlinePlayer.removeAccountMoney('bank', taxAmount)
                TriggerClientEvent('disc-tax:notifyOfPay', onlinePlayer.source, taxAmount)
            else
                MySQL.Async.execute('UPDATE users SET bank = @newBank WHERE identifier = @identifier', {
                    ['@identifier'] = player.identifier,
                    ['@newBank'] = player.bank - taxAmount
                })
            end
        end
    end)
end

function getTaxPercent(money)
    for k, v in pairs(Config.TaxBrackets) do
        if k ~= 'default' and money >= v.low and money <= v.high then
            return v.percent / 100
        end
    end
    return Config.TaxBrackets['default'].percent / 100
end