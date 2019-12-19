ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local isShowing = false

RegisterCommand('mdt', function()
    if not isShowing then
        ESX.TriggerServerCallback('disc-mdt:getUser', function(user)
            SendNUIMessage({
                type = 'SET_USER',
                data = {
                    user = user
                }
            })
        end)

        SendNUIMessage({
            type = "APP_SHOW"
        })
        SetNuiFocus(true, true)
        isShowing = true
    else
        SendNUIMessage({
            type = "APP_HIDE"
        })
        SetNuiFocus(false, false)
        isShowing = false
    end
end)

RegisterNUICallback("CloseUI", function(data, cb)
    isShowing = false
    SetNuiFocus(false, false)
end)

RegisterNUICallback('SetDarkMode', function(data, cb)
    TriggerServerEvent('disc-mdt:setDarkMode', data)
    cb('OK')
end)

RegisterNUICallback('GetLocation', function(data, cb)
    local player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(player))
    local coords = { x = x, y = y, z = z }
    local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    street1 = GetStreetNameFromHashKey(var1)
    street2 = GetStreetNameFromHashKey(var2)
    streetName = street1
    if street2 ~= nil and street2 ~= '' then
        streetName = streetName .. ' + ' .. street2
    end
    area = GetLabelText(GetNameOfZone(x, y, z))
    SendNUIMessage({
        type = 'SET_LOCATION',
        data = {
            location = {
                street = streetName,
                area = area,
                coords = coords
            }
        }
    })
    cb('OK')
end)

RegisterNetEvent('disc-mdt:addNotification')
AddEventHandler('disc-mdt:addNotification', function(data)
    SendNUIMessage({
        type = 'ADD_NOTIFICATION',
        data = data
    })
end)
