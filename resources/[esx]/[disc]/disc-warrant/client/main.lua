ESX = nil

local CurrentWarrant = {}

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

    local options = {
        { label = 'Search for Warrant', action = ShowSearchMenu },
        { label = 'List Warrants', action = ListWarrants },
        { label = 'Create Warrant', action = ShowCreateWarrantMenu }
    }

    local menu = {
        name = 'warrant_menu',
        title = 'Warrants',
        options = options
    }
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, 166) and ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            TriggerEvent('disc-base:openMenu', menu)
        end
    end
end)

function ShowSearchMenu()
    local menu = {
        type = 'dialog',
        title = 'Civilian Name or Surname',
        action = ShowSearchedMenu
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowSearchedMenu(value)
    ESX.TriggerServerCallback('disc-warrant:searchWarrants', function(results)
        ShowWarrants(results)
    end, value)
end

function ListWarrants()
    ESX.TriggerServerCallback('disc-warrant:allWarrants', function(results)
        ShowWarrants(results)
    end)
end

function ShowWarrants(warrants)
    if #warrants == 0 then
        exports['mythic_notify']:SendAlert('error', 'No Warrants found!')
        return
    end
    local options = {}
    for _, v in pairs(warrants) do
        table.insert(options,
                {
                    label = ('<span style="color:yellow;">Warrant</span>: <span style="color:blue;">%s</span> - <span style="color:green;">%s %s</span>'):format(v.code, getOrElse(v.firstname, 'Unknown'), getOrElse(v.lastname, 'Unknown')),
                    action = function()
                        ShowManageWarrant(v)
                    end
                }
        )
    end

    local menu = {
        name = 'warrant_results',
        title = 'Warrants',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowManageWarrant(warrant)
    local options = {
        { label = 'Send Warrant Info', action = function()
            ESX.UI.Menu.CloseAll()
            SendWarrant(warrant)
        end },
        { label = 'Activate / Deactivate Warrant', action = function()
            ESX.UI.Menu.CloseAll()
            SwapWarrantState(warrant)
        end },
    }
    local menu = {
        name = 'warrant_manage',
        title = 'Manage Warrant',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)

end

function SwapWarrantState(warrant)
    warrant.active = not warrant.active
    if warrant.active then
        exports['mythic_notify']:SendAlert('success', 'Activating Warrant')
    else
        exports['mythic_notify']:SendAlert('success', 'Deactivating Warrant')
    end
    TriggerServerEvent('disc-warrant:setWarrantState', warrant)
end

function SendWarrant(warrant)
    exports['mythic_notify']:SendAlert('inform', 'Requesting Warrant Information!')
    local random = math.random(Config.WaitTime.Min, Config.WaitTime.Max)
    Citizen.Wait(random)
    local message = 'Warrant for ' .. getOrElse(warrant.firstname, 'Unknown') .. ' ' .. getOrElse(warrant.lastname, 'Unknown') .. '\nDescription: ' .. warrant.char_description .. '\nCrime: ' .. warrant.crime_description
    local serverId = GetPlayerServerId(PlayerId())
    ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
        TriggerServerEvent('disc-gcphone:sendMessageFrom', 'warrants', number, message, serverId)
    end)
end

function ShowCrimeCode()
    local menu = {
        type = 'dialog',
        name = 'warrant_code',
        title = 'Crime Code',
        action = function(value)
            CurrentWarrant.code = value
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowCreateWarrantMenu()
    CurrentWarrant = {}
    local options = {
        { label = 'Crime Code', action = ShowCrimeCode },
        { label = 'Crime Description', action = ShowCrimeDescription },
        { label = 'Civilian Description', action = ShowCharacterDescription },
        { label = 'Civilian Name', action = ShowCharSearch },
        { label = 'Create', action = CreateWarrant },
    }
    local menu = {
        type = 'default',
        name = 'warrant_create_menu',
        title = 'Create Warrant',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowCrimeDescription()
    local menu = {
        type = 'dialog',
        name = 'warrant_crime_description',
        title = 'Crime Description',
        action = function(value)
            CurrentWarrant.crime_description = value
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowCharacterDescription()
    local menu = {
        type = 'dialog',
        name = 'warrant_civ_description',
        title = 'Civilian Description',
        action = function(value)
            CurrentWarrant.char_description = value
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowCharSearch()
    local menu = {
        type = 'dialog',
        name = 'warrant_civ_searching',
        title = 'Civilian Name or Surname',
        action = DoCharSearch
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function DoCharSearch(value)
    ESX.TriggerServerCallback('disc-warrant:searchUsers', function(results)
        if #results == 0 then
            exports['mythic_notify']:SendAlert('error', 'No civilian found')
            return
        end
        local options = {}
        for k, v in pairs(results) do
            table.insert(options,
                    {
                        label = v.firstname .. ' ' .. v.lastname, action = function(value, m)
                        CurrentWarrant.identifier = v.identifier
                        m.close()
                    end
                    })
        end
        local menu = {
            type = 'default',
            name = 'warrant_civ_search',
            title = 'Select Civilian',
            options = options
        }
        TriggerEvent('disc-base:openMenu', menu)
    end, value)
end

function CreateWarrant(value, m)
    if CurrentWarrant.code == nil then
        CurrentWarrant.code = 'None'
    end
    if CurrentWarrant.char_description == nil then
        CurrentWarrant.char_description = 'None'
    end
    if CurrentWarrant.crime_description == nil then
        CurrentWarrant.crime_description = 'None'
    end
    ESX.UI.Menu.CloseAll()
    TriggerServerEvent('disc-warrant:createWarrant', CurrentWarrant)
    exports['mythic_notify']:SendAlert('success', 'Created Warrant!')
end

