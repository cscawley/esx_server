TryToSell = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sell()
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        serverId = GetPlayerServerId(PlayerId())
        message = 'Dispatch Message: Drug Sale Attempt in progress'
        TriggerServerEvent('esx_addons_gcphone:startCall', 'police', message, coords)
        exports['mythic_notify']:SendAlert('error', "Are you stupid? Don't ever contact me again.")
    end
    ClearPedTasks(PlayerPedId())
end

Sell = function()
    ESX.TriggerServerCallback("disc-drugsales:sellDrug", function(soldDrug)
        if soldDrug then
            exports['mythic_notify']:SendAlert('success', "Thanks! Here's $" .. soldDrug)
        else
            exports['mythic_notify']:SendAlert('error', "Well don't try to waste my time if you don't even have something to sell?")
        end
    end)
end

function PlayAnim(ped, lib, anim, r)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, -8, -1, r and 49 or 0, 0, 0, 0, 0)
    end)
end


