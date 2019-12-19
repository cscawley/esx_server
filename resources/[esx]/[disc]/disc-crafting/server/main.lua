ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-crafting:getInventory', function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    local itemsObject = {}
    for k, esxItem in ipairs(player.getInventory()) do
        if esxItem.count > 0 then
            local item = {
                id = esxItem.name,
                itemId = esxItem.name,
                qty = esxItem.count,
                label = esxItem.label,
            }
            table.insert(itemsObject, item)
        end
    end

    cb(player.identifier, itemsObject)
end)

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

RegisterServerEvent('disc-crafting:craft')
AddEventHandler('disc-crafting:craft', function(bench, craftingData)
    for k, recipeName in pairs(bench.recipes) do
        local recipe = Config.Recipes[recipeName]
        if recipe.fuzzy then

            local make = true
            local recipeItems = {}
            local craftingItems = {}

            for i = 1, #recipe.items, 1 do
                if recipeItems[recipe.items[i]] == nil then
                    recipeItems[recipe.items[i]] = 0
                end
                if craftingItems[craftingData[i].itemId] == nil then
                    craftingItems[craftingData[i].itemId] = 0
                end
                recipeItems[recipe.items[i]] = recipeItems[recipe.items[i]] + 1
                craftingItems[craftingData[i].itemId] = craftingItems[craftingData[i].itemId] + 1
            end

            if #recipeItems ~= #craftingItems then
                break
            end

            for recipeK, v in pairs(recipeItems) do
                if craftingItems[recipeK] == nil or v ~= craftingItems[recipeK] then
                    make = false
                    break
                end
            end

            if make then
                local player = ESX.GetPlayerFromId(source)
                for _, v in ipairs(recipe.items) do
                    player.removeInventoryItem(v, 1)
                end
                player.addInventoryItem(recipe.item, recipe.count)
                TriggerClientEvent('disc-crafting:crafted', source)
            end

        else
            if #recipe.items ~= #craftingData then
                break
            end
            local make = true
            for i = 1, #recipe.items, 1 do
                if recipe.items[i] ~= craftingData[i].itemId then
                    make = false
                end
            end

            if make then
                local player = ESX.GetPlayerFromId(source)
                for k, v in ipairs(recipe.items) do
                    player.removeInventoryItem(v, 1)
                    Citizen.Wait(1000)
                end
                player.addInventoryItem(recipe.item, recipe.count)
                TriggerClientEvent('disc-crafting:crafted', source)
            end
        end
    end
end)