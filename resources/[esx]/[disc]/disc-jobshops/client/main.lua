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

Citizen.CreateThread(function()
    for _, v in pairs(Config.Shops) do
        local marker = {
            name = v.name .. '_shop',
            type = v.markerType,
            coords = v.coords,
            colour = v.colour,
            size = vector3(1.5, 1.5, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to open the Shop',
            action = function()
                OpenShopMenu(v)
            end,
            shouldDraw = function()
                return ESX.PlayerData.job.name == v.job
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function OpenShopMenu(shop)
    local options = {}

    for _, v in pairs(shop.items) do
        table.insert(options, { label = v.label .. (' - <span style="color:green;">$%s</span>'):format(v.price), action = function()
            BuyItem(v.item, v.price)
        end })
    end

    local menu = {
        title = shop.name,
        name = 'shop_items',
        align = 'center',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function BuyItem(item, price)
    ESX.TriggerServerCallback('disc-shops:buyItem', function(result)
        if result == 1 then
            exports['mythic_notify']:SendAlert('success', 'Item bought!')
        elseif result == 0 then
            exports['mythic_notify']:SendAlert('error', 'You need $' .. price)
        else
            exports['mythic_notify']:SendAlert('error', 'You do not have inventory space')
        end
    end
    , item, price)
end
