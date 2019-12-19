function OpenKitchen(property)

    local options = {
        { label = _U('cook'), action = MakeFood }
    }

    if IsPlayerOwnerOf(property) then
        table.insert(options, { label = _U('manage'), action = function()
            ShowManageProperty(property)
        end })
    end

    local menu = {
        name = 'kitchen',
        title = _U('kitchen'),
        options = options
    }

    TriggerEvent('disc-base:openMenu', menu)
end

function MakeFood()
    TriggerServerEvent('disc-base:givePlayerItem', Config.FoodItem, 1)
end
