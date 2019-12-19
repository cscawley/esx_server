local markers = {}
local drawingMarkers = {}
local CurrentMarker = nil
local blips = {}

local HasAlreadyEnteredMarker

RegisterCommand('clearmarkers', function()
    drawingMarkers = {}
    markers = {}
end)

RegisterNetEvent('disc-base:registerMarker')
AddEventHandler('disc-base:registerMarker', function(marker)
    if marker.coords == nil then
        print('Needs Coords for marker')
        return
    end
    if marker.shouldDraw == nil then
        marker.shouldDraw = function()
            return true
        end
    else
        marker.shouldDraw()
    end

    if marker.command then
        RegisterCommand(marker.command.key, function(src, args, raw)
            local command = marker.command.key
            if args and marker.command.args then
                command = command .. ' ' .. marker.command.args
            end
            if raw == command then
                TriggerEvent('disc-base:triggerCurrentMarkerAction')
            end
        end)
    end

    if Config.Debug then
        print('[Disc-Base] Registering Marker ' .. marker.name)
    end
    if markers[marker.name] ~= nil then
        marker.changed = true
        markers[marker.name] = marker
    elseif marker.name ~= nil then
        markers[marker.name] = marker
    else
        table.insert(marker.name)
    end

end)

RegisterNetEvent('disc-base:removeMarker')
AddEventHandler('disc-base:removeMarker', function(name)
    markers[name] = nil
    drawingMarkers[name] = nil
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local isInMarker = false
        local lastMarker
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        for k, v in pairs(markers) do
            if v.shouldDraw() then
                local distance = #(coords - v.coords)
                if (drawingMarkers[k] == nil or v.changed) and distance <= Config.DrawDistance then
                    markers[k].changed = false
                    drawingMarkers[k] = v
                elseif drawingMarkers[k] ~= nil then
                    drawingMarkers[k].distance = distance
                    if distance > Config.DrawDistance then
                        drawingMarkers[k] = nil
                    end
                end
                if distance < v.size.x then
                    if v.enableE then
                        EnableControlAction(0, 38)
                    end
                    isInMarker = true
                    lastMarker = v
                end
            end
        end

        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('disc-base:hasEnteredMarker', lastMarker)
        end
        if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('disc-base:hasExitedMarker')
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k, v in pairs(drawingMarkers) do
            if v.show3D then
                if v.distance ~= nil and v.distance <= Config.Draw3DDistance then
                    ESX.Game.Utils.DrawText3D(v.coords, v.msg, 0.5)
                end
            elseif v.type ~= -1 then
                DrawMarker(v.type, v.coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.size.x, v.size.y, v.size.z, v.colour.r, v.colour.g, v.colour.b, 100, getOrElse(v.bob, false), true, 2, getOrElse(v.rotate, true), false, false, false)
            end
        end

    end
end)

AddEventHandler('disc-base:hasExitedMarker', function()
    CurrentMarker = nil
    ESX.UI.Menu.CloseAll()
end)

AddEventHandler('disc-base:hasEnteredMarker', function(marker)
    if marker.show3D then
        PlaySound(GetSoundId(), "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
    end
    CurrentMarker = marker
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentMarker then
            if not CurrentMarker.show3D and CurrentMarker.msg then
                ESX.ShowHelpNotification(CurrentMarker.msg)
            end

            if IsControlJustReleased(0, 38) then
                if CurrentMarker.action ~= nil then
                    CurrentMarker.action(CurrentMarker)
                end
            end
        end
    end
end)

RegisterNetEvent('disc-base:triggerCurrentMarkerAction')
AddEventHandler('disc-base:triggerCurrentMarkerAction', function()
    if CurrentMarker and CurrentMarker.action ~= nil then
        CurrentMarker.action(CurrentMarker)
    end
end)

RegisterNetEvent('disc-base:registerBlip')
AddEventHandler('disc-base:registerBlip', function(blip)

    if blip.coords == nil then
        print("Coords needed for Blip")
        return
    end

    local _blip = AddBlipForCoord(blip.coords)
    SetBlipSprite(_blip, getOrElse(blip.sprite, 1))
    SetBlipAsShortRange(_blip, true)
    SetBlipDisplay(_blip, getOrElse(blip.display, 4))

    if blip.scale then
        SetBlipScale(_blip, getOrElse(blip.scale, 0.5))
    end
    SetBlipColour(_blip, getOrElse(blip.colour, 1))
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(getOrElse(blip.name, "Blip Missing Name"))
    EndTextCommandSetBlipName(_blip)
    blips[getOrElse(blip.id, #blips + 1)] = {
        _blip = _blip,
        blip = blip
    }
end)

RegisterNetEvent('disc-base:updateBlip')
AddEventHandler('disc-base:updateBlip', function(blip, debug)
    if blip.id == nil or blips[blip.id] == nil then
        return
    end
    local _blip = blips[blip.id]._blip

    if blip.coords then

        if _blip and GetBlipCoords(_blip) ~= blip.coords then
            RemoveBlip(_blip)
            local tempBlip = blips[blip.id].blip
            blips[blip.id] = nil
            tempBlip.coords = blip.coords
            tempBlip.display = blip.display
            TriggerEvent('disc-base:registerBlip', tempBlip)
            return
        end

    end

    if blip.sprite then
        SetBlipSprite(_blip, blip.sprite)
    end
    if blip.display then
        SetBlipDisplay(_blip, blip.display)
    end
    if blip.scale then
        SetBlipScale(_blip, getOrElse(blip.scale, 0.5))
    end
    if blip.colour then
        SetBlipScale(_blip, blip.colour)
    end
    if blip.name then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blip.name)
        EndTextCommandSetBlipName(_blip)
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource:find('disc') then
        TriggerEvent('disc-base:hasExitedMarker')
    end
end)
