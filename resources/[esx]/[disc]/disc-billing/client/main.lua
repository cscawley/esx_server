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

RegisterNetEvent('disc-billing:bill')
AddEventHandler('disc-billing:bill', function(billing)
    local nearByPlayers = GetNeareastPlayers()

    local options = {}
    for k, v in pairs(nearByPlayers) do
        table.insert(options, {
            label = v.playerName .. ' (' .. v.playerId .. ')', action = function()
                ESX.UI.Menu.CloseAll()
                ShowBillName(v.playerId, billing.society)
            end })
    end

    local menu = {
        type = 'default',
        title = 'Billing',
        name = 'billing_players',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)

end)

function ShowBillName(id, society)
    local menu = {
        type = 'dialog',
        name = 'billing_show_name',
        title = 'Billing Reason',
        action = function(value)
            ESX.UI.Menu.CloseAll()
            if value == nil or value == '' then
                exports['mythic_notify']:SendAlert('error', 'Invalid Reason')
                return
            end
            ShowBillAmount(id, society, value)
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowBillAmount(id, society, name)
    local menu = {
        type = 'dialog',
        name = 'billing_show_amount',
        title = 'Billing Amount',
        action = function(value)
            ESX.UI.Menu.CloseAll()
            if tonumber(value) == nil then
                exports['mythic_notify']:SendAlert('error', 'Invalid Amount')
                return
            end
            Bill(id, society, name, value)
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function Bill(id, society, name, value)
    exports['mythic_notify']:SendAlert('success', 'Bill sent')
    TriggerServerEvent('esx_billing:sendBill', id, society, name, value)
end

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        found_players = true
        table.insert(players_clean, { playerName = GetPlayerName(players[i]), playerId = GetPlayerServerId(players[i]) })
    end
    return players_clean
end
