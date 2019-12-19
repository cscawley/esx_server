ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterCommand("bill", function(src, args, raw)
    local player = ESX.GetPlayerFromId(src)
    local society = GetSociety(player)
    if society ~= nil then
        local billing = {
            sourcePlayer = player,
            society = society
        }
        TriggerClientEvent("disc-billing:bill", src, billing)
    end
end)

function GetSociety(player)
    for k, v in pairs(Config.Billing) do
        if v.job == player.job.name then
            return v.society
        end
    end
    return nil
end
