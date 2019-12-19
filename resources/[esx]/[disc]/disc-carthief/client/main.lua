ESX = nil
local PlayerData = {}
local currentZone = ''
local LastZone = ''
local CurrentAction = nil
local CurrentActionMsg = ''
local CurrentActionData = {}

local alldeliveries = {}
local randomdelivery = 1
local isTaken = 0
local isDelivered = 0
local car = 0
local copblip
local deliveryblip
local isJammerActive = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

--Add all deliveries to the table
Citizen.CreateThread(function()
    local deliveryids = 1
    for k, v in pairs(Config.Delivery) do
        table.insert(alldeliveries, {
            id = deliveryids,
            posx = v.Pos.x,
            posy = v.Pos.y,
            posz = v.Pos.z,
            payment = v.Payment,
            car = v.Cars,
        })
        deliveryids = deliveryids + 1
    end
end)

function SpawnCar()
    ESX.TriggerServerCallback('disc-carthief:isActive', function(isActive, isCooldownActive)
        if isCooldownActive == 1 then
            exports['mythic_notify']:SendAlert('error', "Cooldown is active!")
        elseif isActive == 0 then
            ESX.TriggerServerCallback('disc-carthief:anycops', function(anycops)
                if anycops >= Config.CopsRequired then

                    --Get a random delivery point
                    randomdelivery = math.random(1, #alldeliveries)

                    --Delete vehicles around the area (not sure if it works)
                    ClearAreaOfVehicles(Config.VehicleSpawnPoint.Pos.x, Config.VehicleSpawnPoint.Pos.y, Config.VehicleSpawnPoint.Pos.z, 10.0, false, false, false, false, false)

                    --Delete old vehicle and remove the old blip (or nothing if there's no old delivery)
                    SetEntityAsNoLongerNeeded(car)
                    DeleteVehicle(car)
                    RemoveBlip(deliveryblip)


                    --Get random car
                    randomcar = math.random(1, #alldeliveries[randomdelivery].car)

                    --Spawn Car
                    local vehiclehash = GetHashKey(alldeliveries[randomdelivery].car[randomcar])
                    RequestModel(vehiclehash)
                    while not HasModelLoaded(vehiclehash) do
                        RequestModel(vehiclehash)
                        Citizen.Wait(100)
                    end
                    car = CreateVehicle(vehiclehash, Config.VehicleSpawnPoint.Pos.x, Config.VehicleSpawnPoint.Pos.y, Config.VehicleSpawnPoint.Pos.z, 0.0, true, false)
                    SetEntityAsMissionEntity(car, true, true)

                    --Teleport player in car
                    TaskWarpPedIntoVehicle(GetPlayerPed(-1), car, -1)

                    --Set delivery blip
                    deliveryblip = AddBlipForCoord(alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz)
                    SetBlipSprite(deliveryblip, 1)
                    SetBlipDisplay(deliveryblip, 4)
                    SetBlipScale(deliveryblip, 1.0)
                    SetBlipColour(deliveryblip, 5)
                    SetBlipAsShortRange(deliveryblip, true)
                    BeginTextCommandSetBlipName("STRING")
                    AddTextComponentString("Delivery point")
                    EndTextCommandSetBlipName(deliveryblip)

                    SetBlipRoute(deliveryblip, true)

                    --Register acitivity for server
                    TriggerServerEvent('disc-carthief:registerActivity', 1)

                    --For delivery blip
                    isTaken = 1

                    --For delivery blip
                    isDelivered = 0
                else
                    exports['mythic_notify']:SendAlert('error', "Not enough cops in town!")
                end
            end)
        else
            exports['mythic_notify']:SendAlert('error', "There is already a car robbery in progress!")
        end
    end)
end

function FinishDelivery()
    if (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) and GetEntitySpeed(car) < 3 then

        local EngineDamageFactor = math.max(GetVehicleEngineHealth(car) / 1000, 0.4)
        local BodyDamageFactor = math.max(GetVehicleBodyHealth(car) / 1000, 0.4)

        --Delete Car
        SetEntityAsNoLongerNeeded(car)
        DeleteEntity(car)

        --Remove delivery zone
        RemoveBlip(deliveryblip)
        --Pay the poor fella
        local finalpayment = math.floor(alldeliveries[randomdelivery].payment * EngineDamageFactor * BodyDamageFactor)

        exports['mythic_notify']:SendAlert('success', "You finished the robbery, Here is your payment! You earned $" .. finalpayment)

        TriggerServerEvent('disc-carthief:pay', finalpayment)

        --Register Activity
        TriggerServerEvent('disc-carthief:registerActivity', 0)

        --For delivery blip
        isTaken = 0

        --For delivery blip
        isDelivered = 1

        --Stop jammer
        isJammerActive = 0

        --Remove Last Cop Blips
        TriggerServerEvent('disc-carthief:stopalertcops')

    else
        exports['mythic_notify']:SendAlert('error', "You have to use the car that was provided for you and you must come to a full stop.")
    end
end

function AbortDelivery()

    if isTaken == 1 and isDelivered == 0 then

        exports['mythic_notify']:SendAlert('error', "Mission failed!")

        --Delete Car
        SetEntityAsNoLongerNeeded(car)
        DeleteEntity(car)

        --Remove delivery zone
        RemoveBlip(deliveryblip)

        --Register Activity
        TriggerServerEvent('disc-carthief:registerActivity', 0)

        --For delivery blip
        isTaken = 0

        --For delivery blip
        isDelivered = 1

        --Stop jammer
        isJammerActive = 0

        --Remove Last Cop Blips
        TriggerServerEvent('disc-carthief:stopalertcops')
    end
end

function Buy()
    ESX.TriggerServerCallback('disc-carthief:buyJammer', function(bought)
        if bought == 1 then
            exports['mythic_notify']:SendAlert('inform', "You bought a Jammer!")
        elseif bought == -1 then
            exports['mythic_notify']:SendAlert('error', "You need $" .. Config.JammerPrice .. " (Dirty) to buy a jammer")
        elseif bought == 0 then
            exports['mythic_notify']:SendAlert('error', "You already have a jammer!")
        end
    end)
end

RegisterNetEvent('disc-carthief:jammerActive')
AddEventHandler('disc-carthief:jammerActive', function()
    if isTaken == 1 and isDelivered == 0 and (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
        isJammerActive = 1
        exports['mythic_notify']:SendAlert('inform', "Activating Jammer!")
        TriggerServerEvent('disc-carthief:removeJammer')
    end
end)

--Check if player left car
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
            exports['mythic_notify']:SendAlert('error', "You have 1 minute to get back in the car")
            Wait(50000)
            if isTaken == 1 and isDelivered == 0 and not (GetVehiclePedIsIn(GetPlayerPed(-1), false) == car) then
                exports['mythic_notify']:SendAlert('error', "You have 10 seconds to get back in the car")
                Wait(10000)
                AbortDelivery()
            end
        end
    end
end)

-- Send location
Citizen.CreateThread(function()
    while true do
        if isTaken == 1 and IsPedInAnyVehicle(GetPlayerPed(-1)) and isJammerActive == 0 then
            Citizen.Wait(Config.BlipUpdateTime)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            TriggerServerEvent('disc-carthief:alertcops', coords.x, coords.y, coords.z)
        elseif isJammerActive == 1 then
            TriggerServerEvent('disc-carthief:activatedJammerCops')
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(5000)
        elseif isTaken == 1 and not IsPedInAnyVehicle(GetPlayerPed(-1)) then
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(Config.BlipUpdateTime)
        elseif isTaken == 0 then
            TriggerServerEvent('disc-carthief:stopalertcops')
            Citizen.Wait(Config.BlipUpdateTime)
        else
            Citizen.Wait(5000)
        end
    end
end)


--Cancel after x minutes to avoid abuse
Citizen.CreateThread(function()
    while true do
        if isTaken == 1 then
            Citizen.Wait(Config.FinishTime * 60 * 1000)
            AbortDelivery()
        else
            Citizen.Wait(5000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isJammerActive == 1 then
            Citizen.Wait(Config.JammerTime * 60 * 1000)
            isJammerActive = 0
        else
            Citizen.Wait(5000)
        end
    end
end)

RegisterNetEvent('disc-carthief:removecopblip')
AddEventHandler('disc-carthief:removecopblip', function()
    RemoveBlip(copblip)
end)

RegisterNetEvent('disc-carthief:activatedJammerCops')
AddEventHandler('disc-carthief:activatedJammerCops', function()
    exports['mythic_notify']:SendAlert('error', "Criminals have activated their signal jammer! Beware!")
end)

RegisterNetEvent('disc-carthief:setcopblip')
AddEventHandler('disc-carthief:setcopblip', function(cx, cy, cz)
    RemoveBlip(copblip)
    copblip = AddBlipForCoord(cx, cy, cz)
    SetBlipSprite(copblip, 161)
    SetBlipScale(copblipy, 2.0)
    SetBlipColour(copblip, 8)
    PulseBlip(copblip)
end)

RegisterNetEvent('disc-carthief:setcopnotification')
AddEventHandler('disc-carthief:setcopnotification', function()
    exports['mythic_notify']:SendAlert('inform', "Car stealing in progress. Vehicle tracker will be active on your radar")
end)

AddEventHandler('disc-carthief:hasEnteredMarker', function(zone)
    if LastZone == 'menucarthief' then
        CurrentAction = 'carthief_menu'
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to steal a car'
        CurrentActionData = { zone = zone }
    elseif LastZone == 'cardelivered' then
        CurrentAction = 'cardelivered_menu'
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to drop the car off'
        CurrentActionData = { zone = zone }
    elseif LastZone == 'shop' then
        CurrentAction = 'shop'
        CurrentActionMsg = 'Press ~INPUT_CONTEXT~ to buy a jammer $' .. Config.JammerPrice .. ' (Dirty)'
        CurrentActionData = { zone = zone }
    end
end)

AddEventHandler('disc-carthief:hasExitedMarker', function(zone)
    CurrentAction = nil
    ESX.UI.Menu.CloseAll()
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local isInMarker = false
        local currentZone = nil

        if (GetDistanceBetweenCoords(coords, Config.Zones.VehicleSpawner.Pos.x, Config.Zones.VehicleSpawner.Pos.y, Config.Zones.VehicleSpawner.Pos.z, true) < 3) then
            isInMarker = true
            currentZone = 'menucarthief'
            LastZone = 'menucarthief'
        end

        if (GetDistanceBetweenCoords(coords, Config.Zones.Shop.Pos.x, Config.Zones.Shop.Pos.y, Config.Zones.Shop.Pos.z, true) < 3) then
            isInMarker = true
            currentZone = 'shop'
            LastZone = 'shop'
        end

        if isTaken == 1 and (GetDistanceBetweenCoords(coords, alldeliveries[randomdelivery].posx, alldeliveries[randomdelivery].posy, alldeliveries[randomdelivery].posz, true) < 3) then
            isInMarker = true
            currentZone = 'cardelivered'
            LastZone = 'cardelivered'
        end

        if isInMarker and not HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = true
            TriggerEvent('disc-carthief:hasEnteredMarker', currentZone)
        end
        if not isInMarker and HasAlreadyEnteredMarker then
            HasAlreadyEnteredMarker = false
            TriggerEvent('disc-carthief:hasExitedMarker', LastZone)
        end
    end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustReleased(0, 38) then
                if CurrentAction == 'carthief_menu' then
                    SpawnCar()
                    CurrentAction = nil
                elseif CurrentAction == 'cardelivered_menu' then
                    FinishDelivery()
                    CurrentAction = nil
                elseif CurrentAction == 'shop' then
                    Buy()
                end
            end
        end
    end
end)

-- Display markers
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(GetPlayerPed(-1))

        for k, v in pairs(Config.Zones) do
            if (v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
                DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
            end
        end

    end
end)

-- Display markers for delivery place
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if isTaken == 1 and isDelivered == 0 then
            local coords = GetEntityCoords(GetPlayerPed(-1))
            v = alldeliveries[randomdelivery]
            if (GetDistanceBetweenCoords(coords, v.posx, v.posy, v.posz, true) < Config.DrawDistance) then
                DrawMarker(1, v.posx, v.posy, v.posz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 5.0, 5.0, 1.0, 204, 204, 0, 100, false, false, 2, false, false, false, false)
            end
        end
    end
end)

-- Create Blips for Car Spawner
Citizen.CreateThread(function()
    info = Config.Zones.VehicleSpawner
    info.blip = AddBlipForCoord(info.Pos.x, info.Pos.y, info.Pos.z)
    SetBlipSprite(info.blip, info.Id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 1.0)
    SetBlipColour(info.blip, info.Colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.Title)
    EndTextCommandSetBlipName(info.blip)
end)