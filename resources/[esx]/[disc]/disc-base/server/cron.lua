local cronJobs = {}

RegisterServerEvent('disc-base:registerPeriodCron')
AddEventHandler('disc-base:registerPeriodCron', function(cron, time)
    if cron == nil then
        cron = function()
            print('This is a cron')
        end
    end

    if time == nil then
        print('Invalid Time')
        return
    end

    if time.h == nil or time.m == nil or time.s == nil then
        print('Invalid Time')
        return
    end

    local ms = time.s * 1000
    ms = ms + (time.m * 60 * 1000)
    ms = ms + (time.h * 60 * 60 * 1000)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(ms)
            cron()
        end
    end)

end)

RegisterServerEvent('disc-base:registerTimeCron')
AddEventHandler('disc-base:registerTimeCron', function(cron, time)
    local job = {}

    if cron == nil then
        cron = function()
            print('This is a cron')
        end
    end

    if time == nil then
        print('Invalid Time')
        return
    end

    if time.h == nil or time.m == nil then
        return
    end
    job.cronFunction = cron
    job.time = time
    table.insert(cronJobs, job)
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        Citizen.Wait(0)
        local time = os.date("*t")
        for k, v in pairs(cronJobs) do
            if time.hour == v.time.h and time.min == v.time.m then
                Citizen.CreateThread(function()
                    v.cronFunction()
                end)
            end
        end
        Citizen.Wait(60 * 1000)
    end
end)