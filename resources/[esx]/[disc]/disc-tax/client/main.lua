RegisterNetEvent('disc-tax:notifyOfPay')
AddEventHandler('disc-tax:notifyOfPay', function(amount)
    exports['mythic_notify']:SendAlert('inform', 'You paid tax: $' .. amount)
end)
