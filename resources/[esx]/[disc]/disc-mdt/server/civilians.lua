ESX.RegisterServerCallback('disc-mdt:searchCivilians', function(source, cb, search)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE lower(firstname) LIKE lower(@name)', {
        ['@name'] = '%' .. search .. '%'
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:setCivilianImage', function(source, cb, data)
    MySQL.Async.execute('UPDATE users SET userimage=@url WHERE identifier = @identifier', {
        ['@url'] = data.url,
        ['@identifier'] = data.identifier
    }, function()
        cb(true)
    end)
end)