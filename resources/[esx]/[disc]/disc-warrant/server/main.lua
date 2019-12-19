ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-warrant:searchWarrants', function(source, cb, value)
    MySQL.Async.fetchAll(
            [[SELECT *
                FROM warrants w
                LEFT JOIN users u ON u.identifier = w.identifier
                WHERE (LOWER(u.firstname) = LOWER(@value) OR LOWER(u.lastname) = LOWER(@value)) and active]], {
                ['@value'] = value
            },
            function(results)
                cb(results)
            end)
end)

ESX.RegisterServerCallback('disc-warrant:searchUsers', function(source, cb, value)
    MySQL.Async.fetchAll(
            [[SELECT *
                FROM users u
                WHERE LOWER(u.firstname) = LOWER(@value) OR LOWER(u.lastname) = LOWER(@value)]], {
                ['@value'] = value
            },
            function(results)
                cb(results)
            end)
end)

ESX.RegisterServerCallback('disc-warrant:allWarrants', function(source, cb, value)
    MySQL.Async.fetchAll(
            [[SELECT *
                FROM warrants w
                LEFT JOIN users u ON u.identifier = w.identifier
                WHERE active]], {
                ['@value'] = value
            },
            function(results)
                cb(results)
            end)
end)

RegisterServerEvent('disc-warrant:createWarrant')
AddEventHandler('disc-warrant:createWarrant', function(warrant)
    MySQL.Async.execute(
            'INSERT INTO warrants (identifier, crime_description, char_description, code) VALUES (@identifier, @crime_description, @char_description, @code)',
            {
                ['@identifier'] = warrant.identifier,
                ['@crime_description'] = warrant.crime_description,
                ['@char_description'] = warrant.char_description,
                ['@code'] = warrant.code,
            }
    )
end)

RegisterServerEvent('disc-warrant:setWarrantState')
AddEventHandler('disc-warrant:setWarrantState', function(warrant)
    MySQL.Async.execute(
            'UPDATE warrants SET active = @active WHERE id = @id',
            {
                ['@id'] = warrant.id,
                ['@active'] = warrant.active
            }
    )
end)
