ESX = nil
inAnimation = false
isLockPicking = false

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

RegisterNetEvent('disc-lockpick:lockpick')
AddEventHandler('disc-lockpick:lockpick', function(withTool)
    local playerPed = GetPlayerPed(-1)
    if isLockPicking or IsPedInAnyVehicle(playerPed) then
        return
    end

    local tool = Config.Tools[withTool]
    local veh, _ = ESX.Game.GetClosestVehicle()
    local playerPos = GetEntityCoords(playerPed)
    local boneIndex = GetEntityBoneIndexByName(veh, 'door_dside_f')
    local bonePos = GetWorldPositionOfEntityBone(veh, boneIndex)
    local distance = GetDistanceBetweenCoords(bonePos, playerPos)
    local count = 1
    if tool.use then
        count = 1
    else
        count = 0
    end

    if distance < 1.5 then
        if count >= 1 then
            ESX.TriggerServerCallback('disc-base:takePlayerItem', function(took)
                if not took then
                    exports['mythic_notify']:SendAlert('error', 'You do not have the correct tool')
                    return
                end
                LockPick(playerPed, veh, tool)
            end, tool.itemName, count)
        else
            LockPick(playerPed, veh, tool)
        end
    else
        exports['mythic_notify']:SendAlert('error', 'Not at driver door')
    end
end)

function LockPick(playerPed, veh, tool)
    Citizen.CreateThread(function()
        isLockPicking = true
        lockPickingVehicle = veh
        TriggerAlarm(veh, tool)

        if tool.animation ~= nil and tool.lib ~= nil then
            ESX.Streaming.RequestAnimDict(tool.lib, function()
                TaskPlayAnim(playerPed, tool.lib, tool.animation, 8.0, -8, -1, 49, 0, 0, 0, 0)
            end)
        end
        if tool.scenario then
            TaskStartScenarioInPlace(playerPed, tool.scenario, 0, true)
        end
        inAnimation = true
        Citizen.Wait(tool.time)

        inAnimation = false
        ClearPedTasksImmediately(playerPed)
        PlayVehicleDoorOpenSound(veh, 0)
        SetVehicleDoorsLockedForAllPlayers(veh, false)
        SetVehicleDoorsLocked(veh, 1)
        isLockPicking = false
        exports['mythic_notify']:SendAlert('success', 'Door is open!')
    end)
end

function TriggerAlarm(veh, tool)
    local random = math.random(100)
    if random <= tool.alarmChance and GetVehicleDoorLockStatus(veh) == 2 then
        SetVehicleAlarm(veh, true)
        StartVehicleAlarm(veh)
    end
end

Citizen.CreateThread(function()
    while true do
        if inAnimation then
            Citizen.Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1)
            EnableControlAction(0, 2)
        else
            Citizen.Wait(500)
        end
    end
end)
