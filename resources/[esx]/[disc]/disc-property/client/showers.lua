ESX = nil
---------------------------------------------------------- Config ----------------------------------------------------------
local command = true -- command /dirty sets you dirty
local isDirty = false -- if false then you are clean by default
local TreDMe = true -- you can download 3dme here: https://github.com/Sheamle/3dme
local scriptStatus = false -- Set to true if u want to use dirty as status
---------------------------------------------------------- Script --------------------------------------------------------
Citizen.CreateThread(function()
	if Config.Dirty == true then
	while true do
		Citizen.Wait(2700000)
		local dirtyRisk = math.random(100)
		if not isDirty and not scriptStatus and dirtyRisk <= 5 then -- 5% chance that u will get dirty with esx_status turned off
			isDirty = true
			Wait(500)
		end
	end
	end
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if isDirty then
			TriggerServerEvent('disc-property:sync', GetPlayerServerId(PlayerId()), 'flugor')
			if TreDMe then
				TriggerServerEvent('3dme:shareDisplay', _U('smell1'))
			end
			Wait(500)
		end
	end
end)

AddEventHandler('esx_status:loaded', function(status)
	if scriptStatus then
	TriggerEvent('esx_status:registerStatus', 'dirty', 0, '#593400', function(status)
		return true
	end, function(status)
		status.add(500)
	end)

	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5000)
			local playerPed  = PlayerPedId()
			TriggerEvent('esx_status:getStatus', 'dirty', function(status)
				if status.val >= 750000 then
					isDirty = true
				else
				Wait(500)
				end
			end)
		end
	end)
	end
end)

RegisterNetEvent('disc-property:syncFlugor')
AddEventHandler('disc-property:syncFlugor', function(ped, stop)
		local Player = ped
		local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))
		local particleDictionary = "core"
		local particleName = "ent_amb_fly_swarm"
		RequestNamedPtfxAsset(particleDictionary)

		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end

		SetPtfxAssetNextCall(particleDictionary)
		bone = GetPedBoneIndex(PlayerPed, 11816)
		effect = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.2, false, false, false)
		Wait(25)
		effect2 = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.2, false, false, false)
		Wait(25)
		effect3 = StartParticleFxLoopedOnPedBone(particleName, PlayerPed, 0.0, 0.0, -0.6, 0.0, 0.0, 20.0, bone, 2.2, false, false, false)
		Wait(25)
		effect4 = StartParticleFxLoopedOnPedBone("exp_grd_bzgas_smoke", PlayerPed, 0.0, -0.6, -0.2, 0.0, 0.0, 20.0, bone, 0.7, false, false, false)
		Wait(600)
		StopParticleFxLooped(effect, 0)
		Wait(25)
		StopParticleFxLooped(effect2, 0)
		Wait(25)
		StopParticleFxLooped(effect3, 0)
		Wait(25)
		StopParticleFxLooped(effect4, 0)
end)

RegisterNetEvent('disc-property:shower')
AddEventHandler('disc-property:shower', function(property)
local coords = GetEntityCoords(GetPlayerPed(-1))
    				for v, property in pairs(Config.Properties) do
					if GetDistanceBetweenCoords(coords, property.shower.coords, true) < 1.5 then
						isDirty = false
						local hashSkin = GetHashKey("mp_m_freemode_01") 
    						local x, y, z = table.unpack(property.shower.coords)
						TeleportPlayerTo(x, y, z, property.shower.heading)	
						FreezeEntityPosition(GetPlayerPed(-1), true)
						if GetEntityModel(GetPlayerPed(-1)) == hashSkin then -- kille
							TriggerEvent('skinchanger:getSkin', function(skin)
								local clothesSkin = {
								['tshirt_1'] = 15, ['tshirt_2'] = 0,
								['torso_1'] = 15, ['torso_2'] = 0,
								['arms'] = 15,
								['pants_1'] = 61, ['pants_2'] = 5,
								['shoes_1'] = 34, ['shoes_2'] = 0,
								['helmet_1'] = -1, ['helmet_2'] = 0,
							}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
						end)
						else
							TriggerEvent('skinchanger:getSkin', function(skin)
								local clothesSkin = {
								['tshirt_1'] = 15, ['tshirt_2'] = 0,
								['torso_1'] = 15, ['torso_2'] = 0,
								['arms'] = 15,
								['pants_1'] = 15, ['pants_2'] = 0,
								['shoes_1'] = 35, ['shoes_2'] = 0,
								['helmet_1'] = -1, ['helmet_2'] = 0,
							}
							TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
							end)
						end
						Citizen.Wait(500)
						TriggerServerEvent('disc-property:sync', GetPlayerServerId(PlayerId()), 'vatten', x, y, z, property.shower.heading)
						Citizen.Wait(2500)
						if scriptStatus then
							TriggerEvent('esx_status:set', 'dirty', 0)
						end
						Citizen.Wait(1000)
						TriggerServerEvent('disc-property:sync', GetPlayerServerId(PlayerId()), 'flugor')
						Citizen.Wait(6500)
						FreezeEntityPosition(GetPlayerPed(-1), false)
end
end
end)

RegisterNetEvent('disc-property:syncWater')
AddEventHandler('disc-property:syncWater', function(ped, x, y, z)
		local Player = ped
		local PlayerPed = GetPlayerPed(GetPlayerFromServerId(ped))
		local particleDictionary = "core"
		local particleName = "exp_sht_steam"
		local animDictionary = 'mp_safehouseshower@male@'
		local animDictionary2 = 'mp_safehouseshower@female@'
		local animName = 'male_shower_idle_b'
		local animName2 = 'shower_idle_b'
		RequestAnimDict(animDictionary)

		while not HasAnimDictLoaded(animDictionary) do
			Citizen.Wait(0)
		end

		local hashSkin = GetHashKey("mp_m_freemode_01") 
		RequestAnimDict(animDictionary2)

		while not HasAnimDictLoaded(animDictionary2) do
			Citizen.Wait(0)
		end		
		TaskPlayAnim(PlayerPed, animDictionary, animName, 8.0, -8.0, -1, 0, 0, false, false, false)
		RequestNamedPtfxAsset(particleDictionary)

		while not HasNamedPtfxAssetLoaded(particleDictionary) do
			Citizen.Wait(0)
		end

		SetPtfxAssetNextCall(particleDictionary)
		local coords = GetEntityCoords(playerPed)
		local effect = StartParticleFxLoopedAtCoord(particleName, x, y, z+2.6, 0.0, 180.0, 0.0, 5.0, false, false, false, false)
		Wait(25)
		Wait(10000)
		DeleteEntity(prop)
		while not DoesParticleFxLoopedExist(effect) do
		Wait(5)
		end
		StopParticleFxLooped(effect, 0)
		Wait(25)
		StopParticleFxLooped(effect, 0)
		ClearPedTasks(PlayerPed)
		DoScreenFadeOut(200)
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		Citizen.Wait(200)
		DoScreenFadeIn(200)
		TriggerEvent('skinchanger:loadSkin', skin)
		Wait(25)
		StopParticleFxLooped(effect, 0)
		end)
		SetPedWetnessHeight(PlayerPed, 1.0)
end)

RegisterCommand("dirty", function(source)  
	if command then
		if scriptStatus then
			TriggerEvent('esx_status:set', 'dirty', 750000)
                        exports['mythic_notify']:SendAlert('error', _U('smell'))
		else
			isDirty = not isDirty
		end
	else
                        exports['mythic_notify']:SendAlert('error', _U('commanderr'))
	end
end, false)
