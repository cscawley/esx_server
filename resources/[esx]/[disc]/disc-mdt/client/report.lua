RegisterNUICallback('PostReport', function(data, cb)
    ESX.TriggerServerCallback('disc-mdt:postReport', function(done)
        cb('OK')
    end, data)
end)

RegisterNUICallback('GetReportsForPlayer', function(data, cb)
    ESX.TriggerServerCallback('disc-mdt:getReportsForPlayer', function(reports)
        SendNUIMessage({
            type = "SET_CIVILIAN_REPORTS",
            data = {
                reports = reports
            }
        })
        cb('OK')
    end, data.identifier)
end)