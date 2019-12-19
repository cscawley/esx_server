local isDead = false
local ShouldPlayDeathAnimation = false
local deathCoords

RegisterNetEvent('disc-death:onPlayerDeath')
RegisterNetEvent('disc-death:onPlayerRevive')

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
    ShouldPlayDeathAnimation = true
end)

RegisterNetEvent('disc-death:stopAnim')
AddEventHandler('disc-death:stopAnim', function()
    ShouldPlayDeathAnimation = false
end)
RegisterNetEvent('disc-death:startAnim')
AddEventHandler('disc-death:startAnim', function()
    ShouldPlayDeathAnimation = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(data)
    ESX.TriggerServerCallback('disc-death:getDead', function(dead)
        isDead = dead
    end)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local playerPed = PlayerPedId()
        if isDead or GetEntityHealth(playerPed) <= 0 then
            deathCoords = GetEntityCoords(playerPed)
            ShouldPlayDeathAnimation = true
            TriggerEvent('disc-death:onPlayerDeath')
            TriggerServerEvent('disc-death:setDead', true)
            ClearPedTasksImmediately(playerPed)
            SetEntityInvincible(playerPed, true)
            Citizen.CreateThread(function()
                while isDead do
                    DisableAllControlActions(0)
                    EnableControlAction(0, 1)
                    EnableControlAction(0, 2)
                    EnableControlAction(0, 51)
                    EnableControlAction(0, 51)
                    EnableControlAction(0, 245)
                    EnableControlAction(0, 200)
                    Citizen.Wait(0)
                end
                EnableAllControlActions(0)
            end)
            Citizen.Wait(200)
            SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
            ClearPedTasksImmediately(playerPed)
            --local lib, anim = 'random@drunk_driver_1', 'drunk_fall_over'
            local lib, anim = 'move_fall', 'land_fall'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, -1, 1, 0, 0, 0, 0)
                Citizen.Wait(1000)
                while isDead do
                    if not IsEntityPlayingAnim(playerPed, 'dead', 'dead_a', 3) and ShouldPlayDeathAnimation then
                        SetEntityCoords(playerPed, deathCoords)
                        ESX.Streaming.RequestAnimDict('dead', function()
                            TaskPlayAnim(playerPed, 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
                        end)
                        Citizen.Wait(3000)
                    elseif ShouldPlayDeathAnimation then
                        ClearPedSecondaryTask(playerPed)
                        Citizen.Wait(0)
                    end
                    Citizen.Wait(0)
                end
            end)
        end
    end
end)

function Revive(playerPed)
    Coords = GetEntityCoords(playerPed)
    Heading = GetEntityHeading(playerPed)
    NetworkResurrectLocalPlayer(Coords.x, Coords.y, Coords.z, Heading, true, false)

    TriggerServerEvent('disc-death:setDead', false)
    TriggerEvent('disc-death:onPlayerRevive')
    isDead = false
    ClearPedTasksImmediately(playerPed)
    SetEntityInvincible(playerPed, false)
    ClearPedBloodDamage(playerPed)
    SetEntityHealth(playerPed, GetPedMaxHealth(playerPed))
end

RegisterNetEvent('disc-death:revive')
AddEventHandler('disc-death:revive', function()
    local playerPed = PlayerPedId()
    DoScreenFadeOut(200)
    while IsScreenFadingOut() do
        Citizen.Wait(100)
    end
    Revive(playerPed)
    DoScreenFadeIn(3000)
    ESX.Streaming.RequestAnimDict('get_up@directional@movement@from_knees@action', function()
        TaskPlayAnim(playerPed, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
    end)
    while IsScreenFadingIn() do
        Citizen.Wait(100)
    end
end)