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

local currentBench

Citizen.CreateThread(function()
    for k, v in ipairs(Config.Benches) do
        local marker = {
            name = v.name,
            type = 1,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 55 },
            size = vector3(1.5, 1.5, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to open Crafting Bench',
            action = function()
                openBench(v)
            end,
            shouldDraw = function()
                return true
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function openBench(bench)
    currentBench = bench
    SendNUIMessage({
        action = "display",
        type = "normal"
    })
    ESX.TriggerServerCallback('disc-crafting:getInventory', function(identifier, inventory)
        SendNUIMessage({
            action = "setItems",
            invOwner = identifier,
            itemList = inventory,
            benchName = bench.name
        })
    end)
    SetNuiFocus(true, true)
end

function close()
    SendNUIMessage({
        action = "hide"
    })
    SetNuiFocus(false, false)
end

RegisterNUICallback('NUIFocusOff', function(data, cb)
    close()
    cb('OK')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        close()
    end
end)

RegisterNUICallback('Craft', function(data, cb)
    TriggerServerEvent('disc-crafting:craft', currentBench, data.craftingSet)
    cb('OK')
end)

RegisterNetEvent('disc-crafting:crafted')
AddEventHandler('disc-crafting:crafted', function()
    SendNUIMessage({
        action = "crafted"
    })
    openBench(currentBench)
end)