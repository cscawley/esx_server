ESX = nil

local currentArmory = nil

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
    for k, v in pairs(Config.Armories) do
        local marker = {
            name = v.name,
            type = 29,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 55 },
            size = vector3(1.5, 1.5, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to open the Armory',
            action = openArmoryMenu,
            armory = v,
            shouldDraw = function()
                return ESX.PlayerData.job.name == v.job
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function openArmoryMenu(marker)
    local menu = {
        name = 'armory',
        title = 'Armory',
        options = {
            { label = 'Take', action = showStoredWeapons },
            { label = 'Store', action = showStoringMenu },
            { label = 'Buy', action = showBuyMenu },
        }
    }
    currentArmory = marker.armory
    TriggerEvent('disc-base:openMenu', menu)
end

function showStoredWeapons()
    ESX.TriggerServerCallback('disc-armory:getStoredWeapons',
            function(weapons)
                local w = {}

                for k, v in pairs(weapons) do
                    table.insert(w, { label = ESX.GetWeaponLabel(v.weapon) .. (' <span style="color:green;">x%s</span>'):format(v.count), action = function()
                        takeOutWeapon(v.weapon)
                    end })
                end

                local menu = {
                    name = "take_weapons",
                    title = 'Take Weapons',
                    options = w
                }

                TriggerEvent('disc-base:openMenu', menu)

            end,
            currentArmory.job)

end

function doesPedHaveWeapon(ped, weapon)
    for i = 1, #Config.Weapons, 1 do

        if Config.Weapons[i].name == weapon then
            local weaponHash = GetHashKey(Config.Weapons[i].name)

            if HasPedGotWeapon(ped, weaponHash, false) then
                return true
            end
        end
    end
    return false
end

function takeOutWeapon(weapon)
    local playerPed = GetPlayerPed(-1)

    if doesPedHaveWeapon(playerPed, weapon) then
        exports['mythic_notify']:SendAlert('success', 'You already have a ' .. ESX.GetWeaponLabel(weapon))
    else
        ESX.TriggerServerCallback('disc-armory:modifyWeaponCount',
                function(result)
                    if result then
                        exports['mythic_notify']:SendAlert('success', 'Took Weapon ' .. ESX.GetWeaponLabel(weapon))
                        TriggerEvent('esx:addWeapon', weapon, 200)
                        ESX.UI.Menu.Close('default', 'disc-base', 'take_weapons')
                    else
                        exports['mythic_notify']:SendAlert('error', 'Unable to take Weapon ' .. ESX.GetWeaponLabel(weapon))
                    end
                end, currentArmory.job, weapon, -1)
    end
end

function putWeapon(weapon)
    ESX.TriggerServerCallback('disc-armory:modifyWeaponCount',
            function(result)
                if result then
                    exports['mythic_notify']:SendAlert('success', 'Stored Weapon ' .. ESX.GetWeaponLabel(weapon))
                    TriggerEvent('esx:removeWeapon', weapon)
                    ESX.UI.Menu.Close('default', 'disc-base', 'store_weapons')
                else
                    exports['mythic_notify']:SendAlert('error', 'Failed to store Weapon ' .. ESX.GetWeaponLabel(weapon))
                end
            end, currentArmory.job, weapon, 1)
end

function buyWeapon(weapon, price)
    local playerPed = GetPlayerPed(-1)
    if doesPedHaveWeapon(playerPed, weapon) then
        exports['mythic_notify']:SendAlert('success', 'You already have a ' .. ESX.GetWeaponLabel(weapon))
    else
        ESX.TriggerServerCallback('disc-base:buy',
                function(bought)
                    if bought == 1 then
                        TriggerEvent('esx:addWeapon', weapon, 200)
                        exports['mythic_notify']:SendAlert('success', 'You bought a ' .. ESX.GetWeaponLabel(weapon))
                        ESX.UI.Menu.Close('default', 'disc-base', 'buy_weapons')
                    elseif bought == 0 then
                        exports['mythic_notify']:SendAlert('error', 'You need $' .. price .. ' to buy a ' .. ESX.GetWeaponLabel(weapon))
                    else
                        exports['mythic_notify']:SendAlert('error', 'Unable to buy Weapon ' .. ESX.GetWeaponLabel(weapon))
                    end
                end, price)
    end
end

function showBuyMenu()
    local weapons = {}

    for k, v in pairs(currentArmory.weapons) do
        table.insert(weapons, { label = ESX.GetWeaponLabel(v.name) .. (' <span style="color:green;">$%s</span>'):format(v.price), action = function()
            buyWeapon(v.name, v.price)
        end })
    end

    local menu = {
        name = 'buy_weapons',
        title = 'Buy Weapons',
        options = weapons
    }

    TriggerEvent('disc-base:openMenu', menu)
end

function showStoringMenu()
    local weapons = {}

    for i = 1, #Config.Weapons, 1 do

        local weapon = Config.Weapons[i].name

        local playerPed = GetPlayerPed(-1)
        local weaponHash = GetHashKey(weapon)

        if HasPedGotWeapon(playerPed, weaponHash, false) then
            table.insert(weapons, { label = ESX.GetWeaponLabel(weapon), action = function()
                putWeapon(weapon)
            end })
        end
    end
    local menu = {
        name = "store_weapons",
        title = 'Store Weapons',
        options = weapons
    }
    TriggerEvent('disc-base:openMenu', menu)
end

