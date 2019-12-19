ESX.RegisterServerCallback('disc-mdt:postReport', function(source, cb, data)
    local report = {
        area = data.location.area,
        street = data.location.street,
        coords = data.location.coords,
        date = data.date,
        time = data.time,
        notes = data.notes,
        crimes = data.crimes,
    }
    MySQL.Async.execute('INSERT INTO essentialmode.disc_mdt_reports (officerIdentifier, playerIdentifier, report, date, time) VALUES (@officerIdentifier, @playerIdentifier, @report, @date, @time)', {
        ['@officerIdentifier'] = data.form.officerIdentifier,
        ['@playerIdentifier'] = data.form.playerIdentifier,
        ['@report'] = json.encode(report),
        ['@date'] = data.date,
        ['@time'] = data.time,

    }, function()
        cb(true)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:getOfficerReports', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll([[SELECT reports.*, concat(ou.FIRSTNAME ,' ' ,OU.LASTNAME) as officerName, concat(pu.FIRSTNAME ,' ' ,pu.LASTNAME) as playerName FROM disc_mdt_reports reports
                            join users ou on ou.identifier = reports.OFFICERIDENTIFIER
                            join users pu on pu.identifier = reports.PLAYERIDENTIFIER
                            where reports.OFFICERIDENTIFIER=@identifier order by date, time LIMIT 50]], {
        ['@identifier'] = player.identifier
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-mdt:getReportsForPlayer', function(source, cb, identifier)
    MySQL.Async.fetchAll([[SELECT reports.*,
                            DATE_FORMAT(reports.date, '%d-%m-%Y') as stringDate,
                            DATE_FORMAT(reports.time, '%H:%i') as stringTime,
                            concat(ou.FIRSTNAME ,' ' ,OU.LASTNAME) as officerName, concat(pu.FIRSTNAME ,' ' ,pu.LASTNAME) as playerName FROM disc_mdt_reports reports
                            join users ou on ou.identifier = reports.OFFICERIDENTIFIER
                            join users pu on pu.identifier = reports.PLAYERIDENTIFIER
                            where reports.PLAYERIDENTIFIER=@identifier order by date DESC, time DESC LIMIT 5]], {
        ['@identifier'] = identifier
    }, function(results)
        for k, v in ipairs(results) do
            results[k].report = json.decode(v.report)
        end
        cb(results)
    end)
end)