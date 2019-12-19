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
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 1.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        if Config.AllowShowSelf or players[i] ~= PlayerId() then
            found_players = true
            table.insert(players_clean, { playerName = GetPlayerName(players[i]), playerId = GetPlayerServerId(players[i]) })
        end
    end
    return players_clean
end

RegisterCommand('closeMenu', function()
    ESX.UI.Menu.CloseAll()
end)

RegisterCommand('lookup', function()
    if ESX.PlayerData.job.name == 'police' then
        local nearByPlayers = GetNeareastPlayers()

        local options = {}
        for k, v in pairs(nearByPlayers) do
            table.insert(options, {
                label = v.playerName .. ' (' .. v.playerId .. ')', action = function()
                    ESX.UI.Menu.CloseAll()
                    PlayAnim('random@arrests', 'generic_radio_chatter', 49)
                    Citizen.Wait(Config.LookupTime)
                    ClearPedTasksImmediately(GetPlayerPed(-1))
                    TriggerServerEvent('disc-identification:getIdFor', v.playerId)
                end })
        end

        local menu = {
            type = 'default',
            title = 'Lookup',
            name = 'id_lookup_players',
            options = options
        }
        TriggerEvent('disc-base:openMenu', menu)
    end
end)

RegisterNetEvent('disc-identification:idcard')
AddEventHandler('disc-identification:idcard', function()
    ShowPlayers()
end)

function ShowPlayers()
    local nearByPlayers = GetNeareastPlayers()

    local options = {}
    for k, v in pairs(nearByPlayers) do
        table.insert(options, {
            label = v.playerName .. ' (' .. v.playerId .. ')', action = function()
                ESX.UI.Menu.CloseAll()
                TriggerServerEvent('disc-identification:showIdTo', v.playerId)
                PlayAnim('mp_common', 'givetake1_a', 0)
            end })
    end

    local menu = {
        type = 'default',
        title = 'Show Id to',
        name = 'id_show_players',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

RegisterNetEvent('disc-identification:showId')
AddEventHandler('disc-identification:showId', function(data)
    ESX.UI.Menu.CloseAll()
    local menu = {
        head = { '', '' },
        name = 'id_show',
        type = 'list',
        title = 'Id of ',
        options = {
            { 'First Name', data.firstname },
            { 'Last Name', data.lastname },
            { 'Date Of Birth', data.dateofbirth },
            { "Sex", data.sex == "m" and "Male" or "Female" },
            { "Job", data.job }
        }
    }

    TriggerEvent('disc-base:openMenu', menu)
end)

function PlayAnim(lib, anim, r)
    local playerPed = GetPlayerPed(-1)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8, -1, r or 0, 0, 0, 0, 0)
    end)
end
