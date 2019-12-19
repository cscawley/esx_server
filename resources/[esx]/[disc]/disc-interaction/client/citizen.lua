local draggingPlayer = nil
local draggerPlayer = nil
local dragged = false
local carrying = false
local carryingTarget
local gettingCarried = false
local isDead = false
local dragStatus = {}
dragStatus.isDragged = false

AddEventHandler('disc-death:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('disc-death:onPlayerRevive', function(data)
    isDead = false
end)

RegisterCommand('drag', function()
    drag()
end)

RegisterNUICallback('Drag', function(data, cb)
    cb('OK')
    drag()
end)

function drag()
    if dragged then
        return
    end

    if draggingPlayer ~= nil then
        TriggerServerEvent('disc-interaction:stopDrag', draggingPlayer)
        draggingPlayer = nil
        return
    end

    local player, distance = ESX.Game.GetClosestPlayer()
    if distance >= 5.0 or player == 0 or not canCarry(player) then
        return
    end
    draggingPlayer = GetPlayerServerId(player)
    TriggerServerEvent('disc-interaction:drag', draggingPlayer)
end
RegisterNetEvent('disc-interaction:drag')
AddEventHandler('disc-interaction:drag', function(dragger)
    dragStatus.isDragged = true
    dragStatus.dragger = dragger
end)

RegisterNetEvent('disc-interaction:stopDrag')
AddEventHandler('disc-interaction:stopDrag', function()
    dragStatus.isDragged = false
    dragStatus.dragger = nil
end)

Citizen.CreateThread(function()
    local playerPed
    local targetPed

    while true do
        Citizen.Wait(1)
        playerPed = PlayerPedId()

        if dragStatus.isDragged then
            targetPed = GetPlayerPed(GetPlayerFromServerId(dragStatus.dragger))

            -- undrag if target is in an vehicle
            if not IsPedSittingInAnyVehicle(targetPed) then
                AttachEntityToEntity(playerPed, targetPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            else
                dragStatus.isDragged = false
                DetachEntity(playerPed, true, false)
            end
        else
            DetachEntity(playerPed, true, false)
        end
    end
end)


RegisterNUICallback('Carry', function(data, cb)
    if not carrying then
        Carry()
        carrying = true
    else
        StopCarrying()
        carrying = false
    end
    cb('OK')
end)

function Carry()
    local playerPed = PlayerPedId()
    ClearPedSecondaryTask(playerPed)
    local target, distance = ESX.Game.GetClosestPlayer()
<<<<<<< HEAD
    if DoesEntityExist(target) and distance < 3 and canCarry(target) then
=======
    if target ~= 0 and distance < 3 and canCarry(target) then
>>>>>>> master
        TriggerServerEvent('disc-interaction:carry', GetPlayerServerId(target))
        Citizen.Wait(200)
        carryingTarget = target
        lib = 'missfinale_c2mcs_1'
        anim = 'fin_c2_mcs_1_camman'
        ESX.Streaming.RequestAnimDict(lib, function()
            TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 100000, 49, 0, false, false, false)
        end)
    end
end

function canCarry(target)
    local playerPed = GetPlayerPed(target)
    return not IsPedInAnyVehicle(playerPed)
end

function StopCarrying()
    if carryingTarget then
        local playerPed = PlayerPedId()
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent('disc-interaction:stopCarry', GetPlayerServerId(carryingTarget))
    end
end

RegisterNetEvent('disc-interaction:carry')
AddEventHandler('disc-interaction:carry', function(carrier)
    gettingCarried = true
    local playerPed = PlayerPedId()
    ClearPedSecondaryTask(playerPed)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(carrier))
    lib = 'nm'
    anim = 'firemans_carry'
    TriggerEvent('disc-death:stopAnim')
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(playerPed, lib, anim, 8.0, -8.0, 100000, 1, 0, false, false, false)
    end)
    Citizen.CreateThread(function()
        while gettingCarried do
            Citizen.Wait(1)
            AttachEntityToEntity(playerPed, targetPed, 0, 0.27, 0.15, 0.63, 0.5, 0.5, 180, false, false, false, false, 2, false)
        end
        DetachEntity(playerPed, true, false)
    end)
end)

RegisterNetEvent('disc-interaction:stopCarry')
AddEventHandler('disc-interaction:stopCarry', function()
    gettingCarried = false
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    DetachEntity(playerPed, true, false)
    Citizen.Wait(0)
    ESX.Streaming.RequestAnimDict('dead', function()
        TaskPlayAnim(playerPed, 'dead', 'dead_a', 8.0, 8.0, -1, 33, 0, 0, 0, 0)
    end)
    Citizen.Wait(3000)
    if not isDead and not gettingCarried then
        ClearPedSecondaryTask(playerPed)
        ESX.Streaming.RequestAnimDict('get_up@directional@movement@from_knees@action', function()
            TaskPlayAnim(playerPed, 'get_up@directional@movement@from_knees@action', 'getup_r_0', 8.0, -8.0, -1, 0, 0, 0, 0, 0)
        end)
    end

    TriggerEvent('disc-death:startAnim')
end)

RegisterNUICallback('PutInVehicle', function(data, cb)
    local target, distance = ESX.Game.GetClosestPlayer()
    if target and distance < 3 then
        TriggerServerEvent('disc-interaction:putInVehicle', GetPlayerServerId(target))
    end
end)

RegisterNetEvent('disc-interaction:putInVehicle')
AddEventHandler('disc-interaction:putInVehicle', function()
    local playerPed = PlayerPedId()
    if not IsPedInAnyVehicle(playerPed) then
        local vehicle, distance = ESX.Game.GetClosestVehicle()
        local modelHash = GetEntityModel(vehicle)
        if vehicle and distance < 3 then
            for i = GetVehicleModelNumberOfSeats(modelHash), 0, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    if carrying then
                        StopCarrying()
                    end
                    if draggingPlayer then
                        drag()
                    end
                    if not isDead then
                        TaskWarpPedIntoVehicle(playerPed, vehicle, i)
                    else
                        TriggerEvent('disc-death:stopAnim')
                        ClearPedSecondaryTask(playerPed)
                        Citizen.Wait(0)
                        TaskWarpPedIntoVehicle(playerPed, vehicle, i)
                    end
                    break
                end

            end
        end
    end
end)

RegisterNUICallback('OutOfVehicle', function(data, cb)
    local target, distance = ESX.Game.GetClosestPlayer()
    if target and distance < 3 then
        TriggerServerEvent('disc-interaction:outOfVehicle', GetPlayerServerId(target))
    end
end)

RegisterNetEvent('disc-interaction:outOfVehicle')
AddEventHandler('disc-interaction:outOfVehicle', function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed) then
        local vehicle = GetVehiclePedIsIn(playerPed)
        TaskLeaveVehicle(playerPed, vehicle, 16)
        if isDead then
            TriggerEvent('disc-death:startAnim')
        end
    end
end)