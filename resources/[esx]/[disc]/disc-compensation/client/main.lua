ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('disc-compensation:compensate')
AddEventHandler('disc-compensation:compensate', function()
    local players = GetNeareastPlayers()
    local options = {}
    for k, v in pairs(players) do
        if v.playerId ~= PlayerId() or Config.AllowSelfCompensation then
            table.insert(options, {
                label = v.playerName .. ' (' .. v.playerId .. ')', action = function()
                    local compensation = {
                        compensator = GetPlayerServerId(PlayerId()),
                        receiver = v.playerId
                    }
                    ESX.UI.Menu.CloseAll()
                    ShowCompensationReason(compensation)
                end })
        end
    end

    local menu = {
        type = 'default',
        title = 'Compensate',
        name = 'compensate_players',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end)

function ShowCompensationReason(compensation)
    local menu = {
        type = 'dialog',
        title = 'Compensation Reason',
        name = 'compensate_reason',
        action = function(value)
            if value == nil or value == '' then
                exports['mythic_notify']:SendAlert('error', 'Invalid Reason')
                return
            end
            ESX.UI.Menu.CloseAll()
            compensation.reason = value
            ShowCompensationValue(compensation)
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowCompensationValue(compensation)
    local menu = {
        type = 'dialog',
        title = 'Compensation Value',
        name = 'compensate_value',
        action = function(value)
            if tonumber(value) == nil then
                exports['mythic_notify']:SendAlert('error', 'Invalid Amount')
                return
            end
            ESX.UI.Menu.CloseAll()
            compensation.amount = value
            Compensate(compensation)
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function Compensate(compensation)
    TriggerServerEvent('disc-compensation:compensate', compensation)
    exports['mythic_notify']:SendAlert('success', 'Compensation has given!')
end

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, _ = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        found_players = true
        table.insert(players_clean, { playerName = GetPlayerName(players[i]), playerId = GetPlayerServerId(players[i]) })
    end
    return players_clean
end

RegisterNetEvent('disc-compensation:receiveCompensation')
AddEventHandler('disc-compensation:receiveCompensation', function(amount)
    exports['mythic_notify']:SendAlert('success', 'You have received compensation for $' .. amount)
end)


