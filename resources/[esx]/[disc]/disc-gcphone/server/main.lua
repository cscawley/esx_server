ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function getPhoneRandomNumber()
    local numBase0 = math.random(100, 999)
    local numBase1 = math.random(0, 9999)
    local num = string.format("%03d-%04d", numBase0, numBase1)
    return num
end

RegisterServerEvent('disc-gcphone:sendRandomMessage')
AddEventHandler('disc-gcphone:sendRandomMessage', function(number, message, serverId)
    TriggerEvent('gcPhone:_internalAddMessage', getPhoneRandomNumber(), number, message, 0, function(smsMess)
        TriggerClientEvent("gcPhone:receiveMessage", serverId, smsMess)
    end)
end)

RegisterServerEvent('disc-gcphone:sendMessageFrom')
AddEventHandler('disc-gcphone:sendMessageFrom', function(from, number, message, serverId)
    TriggerEvent('gcPhone:_internalAddMessage', from, number, message, 0, function(smsMess)
        TriggerClientEvent("gcPhone:receiveMessage", serverId, smsMess)
    end)
end)

RegisterServerEvent('disc-gcphone:sendMessageTo')
AddEventHandler('disc-gcphone:sendMessageTo', function(number, message, serverId)
    TriggerEvent('esx_addons_gcphone:startCall', number, message, serverId)
end)

ESX.RegisterServerCallback('disc-gcphone:getNumber', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = player.identifier
    }, function(result)
        if result[1] ~= nil then
            return cb(result[1].phone_number)
        end
        return cb(nil)
    end)
end)
