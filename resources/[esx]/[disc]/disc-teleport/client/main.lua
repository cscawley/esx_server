ESX = nil
ESXLoaded = false

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
    ESXLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    while not ESXLoaded do
        Citizen.Wait(10)
    end
    for k, v in pairs(Config.Teleporters) do
        local marker = {
            name = v.name .. '_teleporter',
            type = 2,
            coords = v.coords,
            colour = v.colour,
            size = vector3(2.0, 2.0, 2.0),
            msg = _U('tpkey') .. v.name,
            action = function()
                Teleport(v)
            end,
            shouldDraw = function()
                return v.job == 'all' or ShowTeleport(v, ESX.PlayerData.job)
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function ShowTeleport(config, job)
    local show = job.name == config.job
    if show and config.grades then
        local found = false
        for k, v in pairs(config.grades) do
            if v == job.grade_name then
                found = true
            end
        end
        show = found
    end
    return show
end

function Teleport(teleporter)
    local entity = GetPlayerPed(-1)
    if teleporter.allowVehicles and IsPedSittingInAnyVehicle(entity) then
        entity = GetVehiclePedIsIn(entity)
        if not ESX.Game.IsSpawnPointClear(teleporter.destination, 3.0) then
            exports['mythic_notify']:SendAlert('error', _U('blocked'))
            return
        end
    end
    local x, y, z = table.unpack(teleporter.destination)
    DoScreenFadeOut(200)
    Citizen.Wait(200)
    SetEntityCoords(entity, x, y, z, 0, 0, 0, false)
    SetEntityHeading(entity, teleporter.heading)
    PlaceObjectOnGroundProperly(entity)
    exports['mythic_notify']:SendAlert('success', _U('ported'))
    TriggerEvent('disc-base:hasExitedMarker')
    Citizen.Wait(700)
    DoScreenFadeIn(200)
end
