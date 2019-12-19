RegisterNUICallback('SetCivilianImage', function(data, cb)
    ESX.TriggerServerCallback('disc-mdt:setCivilianImage', function(done)
        cb('OK')
    end, data)
end)

RegisterNUICallback("SearchCivilians", function(data, cb)
    ESX.TriggerServerCallback("disc-mdt:searchCivilians", function(civilians)
        SendNUIMessage({
            type = "SET_CIVILIANS",
            data = {
                civilians = civilians
            }
        })
        cb('OK')
    end, data.search)
end)
