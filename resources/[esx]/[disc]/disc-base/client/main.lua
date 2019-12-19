ESX = nil
PlayerData = nil

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

--[[
	Usage: 
		All optional
		menu = {
			type = 'default'
			title = 'title',
			name = 'name',
			align = 'bottom-right'
			options = {
				{
					label = 'label',
					action = function(action)
				}
			},
			close = function()
		}
		TriggerEvent('disc-base:openMenu', menu)
]]

RegisterNetEvent('disc-base:openMenu')
AddEventHandler('disc-base:openMenu', function(menu)

    local type = getOrElse(menu.type, 'default')

    if type == 'default' then
        OpenDefaultMenu(menu)
    elseif type == 'dialog' then
        OpenDialogMenu(menu)
    elseif type == 'list' then
        OpenListMenu(menu)
    elseif type == 'confirmation' then
        OpenConfirmationMenu(menu)
    end
end)

function OpenDefaultMenu(menu)

    local emptyMenu = { { label = 'Empty Menu', action = nil } }

    local elements = {}
    local actions = {}

    for k, v in pairs(getOrElse(menu.options, emptyMenu)) do
        local key = getOrElse(v.value, k)
        table.insert(elements, { label = v.label, value = key })
        actions[key] = v.action
    end

    if menu.onOpen then
        menu.onOpen()
    end

    ESX.UI.Menu.Open(getOrElse(menu.type, 'default'), GetCurrentResourceName(), getOrElse(menu.name, getOrElse(menu.title, 'default-menu-name')), {
        title = getOrElse(menu.title, 'default-menu-title'),
        align = getOrElse(menu.align, 'bottom-right'),
        elements = getOrElse(elements, emptyMenu)
    }, function(data, m)
        if getOrElse(actions[data.current.value], nil) then
            actions[data.current.value](data.current, m)
        else
            exports['mythic_notify']:SendAlert('error', 'This menu has no action!')
        end
    end, function(data, m)
        if getOrElse(menu.close, nil) then
            menu.close()
        end
        m.close()
    end, function(data, m)
        if menu.onChange then
            menu.onChange(data, m)
        end
    end)
end

function OpenDialogMenu(menu)
    ESX.UI.Menu.Open(getOrElse(menu.type, 'dialog'), GetCurrentResourceName(), getOrElse(menu.name, getOrElse(menu.title, 'default-menu-name')), {
        title = getOrElse(menu.title, 'default-menu-title'),
        align = getOrElse(menu.align, 'middle')
    },
            function(data, m)
                if getOrElse(menu.action, nil) then
                    menu.action(data.value)
                    m.close()
                else
                    exports['mythic_notify']:SendAlert('error', 'This menu has no action!')
                end
            end,
            function(data, m)
                if getOrElse(menu.close, nil) then
                    menu.close()
                end
                m.close()
            end)
end

function OpenListMenu(menu)

    local elements = {
        head = menu.head or {},
        rows = menu.rows or {}
    }

    for k, v in pairs(menu.options) do
        local cols = {}
        for _, v2 in pairs(v) do
            table.insert(cols, v2)
        end
        table.insert(elements.rows, {
            data = v,
            cols = cols
        })
    end

    ESX.UI.Menu.Open('list', GetCurrentResourceName(), menu.name or 'default_list_menu', elements, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end)
end

function OpenConfirmationMenu(menu)
    local options = {
        { label = 'Yes', action = menu.confirmation },
        { label = 'No', action = menu.denial },
    }

    local confirmation = {
        title = 'Confirmation',
        name = 'confirmation_' .. menu.name,
        options = options
    }

    OpenDefaultMenu(confirmation)
end


