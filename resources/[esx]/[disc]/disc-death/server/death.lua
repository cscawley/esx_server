RegisterServerEvent('disc-death:setDead')
AddEventHandler('disc-death:setDead', function(isDead)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE users SET is_dead = @isDead WHERE identifier = @identifier', {
        ['@isDead'] = isDead,
        ['@identifier'] = player.identifier
    })
end)

ESX.RegisterServerCallback('disc-death:getDead', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT is_dead FROM users WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results[1].is_dead)
    end)
end)

ESX.RegisterServerCallback('disc-death:isPlayerDead', function(source, cb, target)
    local player = ESX.GetPlayerFromId(target)
    MySQL.Async.fetchAll('SELECT is_dead FROM users WHERE identifier = @identifier', {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results[1].is_dead)
    end)
end)