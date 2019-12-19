ESX = nil
local cooldown = false

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

Citizen.CreateThread(function()
    Citizen.Wait(0)
    local blip = {
        id = 'panic_current',
        name = 'Panic Alert',
        coords = vector3(0, 0, 0),
        display = 0,
        sprite = 472
    }
    TriggerEvent('disc-base:registerBlip', blip)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterCommand('panic', function(src, args, raw)

    if cooldown then
        return
    else
        cooldown = true
    end

    if ESX.PlayerData.job then
        local found = false
        local job = ESX.PlayerData.job.name
        print(job)
        for _, v in pairs(Config.AllowedJobs) do
            if v == job then
                found = true
                break ;
            end
        end
        if found then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('disc-panic:sendPanic', coords, job)
        end
    end
end)

RegisterNetEvent('disc-panic:addPanic')
AddEventHandler('disc-panic:addPanic', function(coords)
    local blip = {
        id = 'panic_current',
        name = 'Panic Alert',
        coords = coords,
        display = 4
    }
    TriggerEvent('disc-base:updateBlip', blip, true)
    SetNewWaypoint(coords.x, coords.y)
    exports['mythic_notify']:SendAlert('error', 'Panic Button has been Triggered!')
    for i = 1, 7, 1 do
        PlaySoundFrontend(GetSoundId(), "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        Citizen.Wait(200)
    end
end)

RegisterCommand('clearpanic', function(source, args, raw)
    local blip = {
        id = 'panic_current',
        name = 'Panic Alert',
        coords = vector3(0, 0, 0),
        display = 0,
        sprite = 472
    }
    TriggerEvent('disc-base:updateBlip', blip)
end)

RegisterCommand('911', function(source, args, rawCommand)

    if cooldown then
        return
    else
        cooldown = true
    end

    serverId = GetPlayerServerId(PlayerId())
    ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
        local msg = 'Dispatch Message: #' .. number .. ' : '
        msg = msg .. rawCommand:sub(5)
        TriggerServerEvent('disc-gcphone:sendMessageFrom', 'police', 'police', msg, serverId)
    end)
end, false)

Citizen.CreateThread(function()
    while true do
        if cooldown then
            Citizen.Wait(Config.CooldownTime)
            cooldown = false
        else
            Citizen.Wait(1000)
        end
    end
end)
