RegisterNUICallback('GetCrimes', function(data, cb)
    ESX.TriggerServerCallback('disc-mdt:getCrimes', function(crimes)
        SendNUIMessage({
            type = "SET_CRIMES",
            data = {
                crimes = crimes
            }
        })
    end)
    cb('OK')
end)