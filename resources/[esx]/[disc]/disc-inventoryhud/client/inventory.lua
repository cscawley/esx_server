secondInventory = nil

RegisterNUICallback('MoveToEmpty', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:MoveToEmpty', data)
    TriggerEvent('disc-inventoryhud:MoveToEmpty', data)
    cb('OK')
end)

RegisterNUICallback('EmptySplitStack', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:EmptySplitStack', data)
    TriggerEvent('disc-inventoryhud:EmptySplitStack', data)
    cb('OK')
end)

RegisterNUICallback('SplitStack', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:SplitStack', data)
    TriggerEvent('disc-inventoryhud:SplitStack', data)
    cb('OK')
end)

RegisterNUICallback('CombineStack', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:CombineStack', data)
    TriggerEvent('disc-inventoryhud:CombineStack', data)
    cb('OK')
end)

RegisterNUICallback('TopoffStack', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:TopoffStack', data)
    TriggerEvent('disc-inventoryhud:TopoffStack', data)
    cb('OK')
end)

RegisterNUICallback('SwapItems', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:SwapItems', data)
    TriggerEvent('disc-inventoryhud:SwapItems', data)
    cb('OK')
end)

RegisterNUICallback('GiveItem', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:GiveItem', data)
    cb('OK')
end)

RegisterNUICallback('GiveCash', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:GiveCash', data)
    cb('OK')
end)

RegisterNUICallback('CashStore', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:CashStore', data)
    cb('OK')
end)

RegisterNUICallback('CashTake', function(data, cb)
    TriggerServerEvent('disc-inventoryhud:CashTake', data)
    cb('OK')
end)

RegisterNUICallback('GetNearPlayers', function(data, cb)
    if data.action == 'give' then
        SendNUIMessage({
            action = "nearPlayersGive",
            players = GetNeareastPlayers(),
            originItem = data.originItem
        })
    end
    if data.action == 'pay' then
        SendNUIMessage({
            action = "nearPlayersPay",
            players = GetNeareastPlayers(),
            originItem = data.originItem
        })
    end
    cb('OK')
end)

function GetNeareastPlayers()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 2.0)

    local players_clean = {}
    local found_players = false

    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            found_players = true
            table.insert(players_clean, { name = GetPlayerName(players[i]), id = GetPlayerServerId(players[i]) })
        end
    end
    return players_clean
end

RegisterNetEvent('disc-inventoryhud:refreshInventory')
AddEventHandler('disc-inventoryhud:refreshInventory', function()
    Citizen.Wait(250)
    refreshPlayerInventory()
    if secondInventory ~= nil then
        refreshSecondaryInventory()
    end
    SendNUIMessage({
        action = "unlock"
    })
end)

function refreshPlayerInventory()
    ESX.TriggerServerCallback('disc-inventoryhud:getPlayerInventory', function(data)
        SendNUIMessage(
                { action = "setItems",
                  itemList = data.inventory,
                  invOwner = data.invId,
                  invTier = data.invTier,
                  money = {
                      cash = data.cash,
                      bank = data.bank,
                      black_money = data.black_money
                  }
                }
        )
        TriggerServerEvent('disc-inventoryhud:openInventory', {
            type = 'player',
            owner = ESX.GetPlayerData().identifier
        })
    end, 'player', ESX.GetPlayerData().identifier)
end

function refreshSecondaryInventory()
    ESX.TriggerServerCallback('disc-inventoryhud:canOpenInventory', function(canOpen)
        if canOpen or secondInventory.type == 'shop' then
            ESX.TriggerServerCallback('disc-inventoryhud:getSecondaryInventory', function(data)
                SendNUIMessage(
                        { action = "setSecondInventoryItems",
                          itemList = data.inventory,
                          invOwner = data.invId,
                          invTier = data.invTier,
                          money = {
                              cash = data.cash,
                              black_money = data.black_money
                          }
                        }
                )
                SendNUIMessage(
                        {
                            action = "show",
                            type = 'secondary'
                        }
                )
                TriggerServerEvent('disc-inventoryhud:openInventory', secondInventory)
            end, secondInventory.type, secondInventory.owner)
        else
            SendNUIMessage(
                    {
                        action = "hide",
                        type = 'secondary'
                    }
            )
        end
    end, secondInventory.type, secondInventory.owner)
end

function closeInventory()
    isInInventory = false
    SendNUIMessage({ action = "hide", type = 'primary' })
    SetNuiFocus(false, false)
    TriggerServerEvent('disc-inventoryhud:closeInventory', {
        type = 'player',
        owner = ESX.GetPlayerData().identifier
    })
    if secondInventory ~= nil then
        TriggerServerEvent('disc-inventoryhud:closeInventory', secondInventory)
    end
end

RegisterNetEvent('disc-inventoryhud:openInventory')
AddEventHandler('disc-inventoryhud:openInventory', function(sI)
    openInventory(sI)
end)

function openInventory(_secondInventory)
    isInInventory = true
    refreshPlayerInventory()
    SendNUIMessage({
        action = "display",
        type = "normal"
    })
    if _secondInventory ~= nil then
        secondInventory = _secondInventory
        refreshSecondaryInventory()
        SendNUIMessage({
            action = "display",
            type = 'secondary'
        })
        if _secondInventory.seize then
            SendNUIMessage({
                action = "showSeize"
            })
        end
        if _secondInventory.steal then
            SendNUIMessage({
                action = "showSteal"
            })
        end
    end
    SetNuiFocus(true, true)
end

RegisterNetEvent("disc-inventoryhud:MoveToEmpty")
AddEventHandler("disc-inventoryhud:MoveToEmpty", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:EmptySplitStack")
AddEventHandler("disc-inventoryhud:EmptySplitStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:TopoffStack")
AddEventHandler("disc-inventoryhud:TopoffStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:SplitStack")
AddEventHandler("disc-inventoryhud:SplitStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:CombineStack")
AddEventHandler("disc-inventoryhud:CombineStack", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

RegisterNetEvent("disc-inventoryhud:SwapItems")
AddEventHandler("disc-inventoryhud:SwapItems", function(data)
    playPickupOrDropAnimation(data)
    playStealOrSearchAnimation(data)
end)

function playPickupOrDropAnimation(data)
    if data.originTier.name == 'drop' or data.destinationTier.name == 'drop' then
        local playerPed = GetPlayerPed(-1)
        if not IsEntityPlayingAnim(playerPed, 'random@domestic', 'pickup_low', 3) then
            ESX.Streaming.RequestAnimDict('random@domestic', function()
                TaskPlayAnim(playerPed, 'random@domestic', 'pickup_low', 8.0, -8, -1, 48, 0, 0, 0, 0)
            end)
        end
    end
end

function playStealOrSearchAnimation(data)
    if data.originTier.name == 'player' and data.destinationTier.name == 'player' then
        local playerPed = GetPlayerPed(-1)
        if not IsEntityPlayingAnim(playerPed, 'random@mugging4', 'agitated_loop_a', 3) then
            ESX.Streaming.RequestAnimDict('random@mugging4', function()
                --- TaskPlayAnim(playerPed, 'random@mugging4', 'agitated_loop_a', 8.0, -8, -1, 48, 0, 0, 0, 0)
            end)
        end
    end
end
