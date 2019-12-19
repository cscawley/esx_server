function ShowViewProperty(property)

    local propData = GetPropertyDataForProperty(property)

    if propData == nil then
        return
    end

    local options = {
        { label = _U('view'), action = function()
            EnterProperty(property)
        end, },
        { label = _U('buy') .. propData.price, action = function()
            ShowConfirmBuy(property)
        end }
    }

    local menu = {
        title = _U('view'),
        name = 'view_property',
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowManageProperty(property)
    local options = {
        { label = _U('givekeys'), action = function()
            ShowGiveKeys(property)
        end },
        { label = _U('takekeys'), action = function()
            ShowKeyUsers(property)
        end },
        { label = _U('sell'), action = function()
            ShowConfirmSell(property)
        end }
    }

    local menu = {
        name = 'property_management',
        title = _U('manage'),
        options = options
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowConfirmSell(property)
    local options = {
        { label = _U('yes'), action = function()
            SellProperty(property)
        end },
        { label = _U('no'), action = function()
            ESX.UI.Menu.Close('confirm_sell')
        end }
    }

    local menu = {
        name = 'confirm_sell',
        title = _U('confirm'),
        options = options
    }

    TriggerEvent('disc-base:openMenu', menu)
end

function SellProperty(property)
    TriggerServerEvent('disc-property:sellProperty', property)
    ESX.UI.Menu.CloseAll()
    exports['mythic_notify']:SendAlert('success', _U('sold'))
    TriggerEvent('disc-property:forceUpdatePropertyData')
end

function ShowConfirmBuy(property)
    local options = {
        { label = _U('yes'), action = function()
            BuyProperty(property)
        end },
        { label = _U('no'), action = function()
            ESX.UI.Menu.Close('confirm_buy')
        end }
    }

    local menu = {
        name = 'confirm_buy',
        title = _U('confirm'),
        options = options
    }

    TriggerEvent('disc-base:openMenu', menu)
end

function BuyProperty(property)
    ESX.TriggerServerCallback('disc-property:buyProperty', function(bought)
        if bought then
            ESX.UI.Menu.CloseAll()
            exports['mythic_notify']:SendAlert('success', _U('bought'))
            TriggerEvent('disc-property:forceUpdatePropertyData')
        else
            exports['mythic_notify']:SendAlert('error', _U('notenough'))
        end
    end, property)
end

function ShowGiveKeys(property)
    local menu = {
        type = 'dialog',
        name = 'searching_users',
        title = _U('name'),
        action = function(value)
            ShowSearchedUsers(value, property)
        end
    }
    TriggerEvent('disc-base:openMenu', menu)
end

function ShowSearchedUsers(value, property)
    ESX.TriggerServerCallback('disc-property:searchUsers', function(results)
        if #results == 0 then
            exports['mythic_notify']:SendAlert('error', _U('nobodyfound'))
            return
        end
        local options = {}
        for k, v in pairs(results) do
            table.insert(options,
                    {
                        label = v.firstname .. ' ' .. v.lastname, action = function(value, m)
                        TriggerServerEvent('disc-property:GiveKeys', property, v.identifier)
                        exports['mythic_notify']:SendAlert('success', _U('gavekeys') .. v.firstname .. ' ' .. v.lastname)
                        ESX.UI.Menu.CloseAll()
                    end
                    })
        end
        local menu = {
            type = 'default',
            name = 'property_civ_select',
            title = _U('select'),
            options = options
        }
        TriggerEvent('disc-base:openMenu', menu)
    end, value)
end

function ShowKeyUsers(property)
    ESX.TriggerServerCallback('disc-property:getKeyUsers', function(results)
        if #results == 0 then
            exports['mythic_notify']:SendAlert('error', _U('nobodyfound'))
            return
        end
        local options = {}
        for k, v in pairs(results) do
            table.insert(options,
                    {
                        label = v.firstname .. ' ' .. v.lastname, action = function(value, m)
                        TriggerServerEvent('disc-property:TakeKeys', property, v.identifier)
                        exports['mythic_notify']:SendAlert('success', _U('tookkeys') .. v.firstname .. ' ' .. v.lastname)
                        ESX.UI.Menu.CloseAll()
                    end
                    })
        end
        local menu = {
            type = 'default',
            name = 'property_civ_select',
            title = _U('select'),
            options = options
        }
        TriggerEvent('disc-base:openMenu', menu)
    end, property)
end
