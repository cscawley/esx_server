ESX = nil

local hasDrugs = false

cachedPeds = {}

--Clean ped cache to avoid memory leaks
Citizen.CreateThread(function()
    while true do
        cachedPeds = {}
        Citizen.Wait(300000)
    end
end)

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

    PlayerData = ESX.GetPlayerData()
end)

function canSell(pedId)
    return hasDrugs ~= nil and hasDrugs and not IsPedSittingInAnyVehicle(pedId)
end

function CanSellTo(pedId)
    return DoesEntityExist(pedId) and not IsPedDeadOrDying(pedId) and not IsPedAPlayer(pedId) and not IsPedFalling(pedId) and not cachedPeds[pedId] and not IsEntityAMissionEntity(ped)
end

function GetPedInFront()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    local plyPos = GetEntityCoords(plyPed, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local closestPed = GetPedInFront()
        local closestpedCoords = GetEntityCoords(closestPed)
        local dist = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, closestpedCoords.x, closestpedCoords.y, closestpedCoords.z, true)
        if dist <= 2 then

            local cs = canSell(PlayerPedId())
            local cst = CanSellTo(closestPed)

            if cs and cst then
                ESX.ShowHelpNotification("~INPUT_CONTEXT~ to Sell Drugs")
            end

            if IsControlJustReleased(0, 38) and cs and cst then
                ESX.TriggerServerCallback('disc-drugsales:getOnlinePolice',
                        function(online)
                            if Config.CopsNeeded > online then
                                exports['mythic_notify']:SendAlert('error', "Not enough cops in town! Need " .. Config.CopsNeeded)
                            else
                                if not cachedPeds[closestPed] then
                                    showNotification = false
                                    TryToSell(closestPed, pedCoords)
                                else
                                    exports['mythic_notify']:SendAlert('inform', "You've already talked to me? Don't come up to me again.")
                                end
                            end
                        end)
            end
        end
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    while true do
        ESX.TriggerServerCallback('disc-drugsales:hasDrugs', function(hD)
            if hasDrugs ~= hD then
                if hD then
                    exports['mythic_notify']:SendAlert('inform', "You have drugs!")
                else
                    exports['mythic_notify']:SendAlert('inform', "Your drugs are done!")
                end
                hasDrugs = hD
            end
        end)
        Citizen.Wait(5000)
    end
end)
