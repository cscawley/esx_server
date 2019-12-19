ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

ESX.RegisterServerCallback('disc-armory:getStoredWeapons', function(source, cb, armory)
    MySQL.Async.fetchAll("SELECT * FROM armory WHERE armory_job = @armory", {
        ['@armory'] = armory
    }, function(results)
        cb(results)
    end)
end)

ESX.RegisterServerCallback('disc-armory:modifyWeaponCount', function(source, cb, armory, weapon, count)
    MySQL.Async.fetchAll("SELECT * FROM armory WHERE armory_job= @armory and weapon = @weapon", {
        ['@armory'] = armory,
        ['@weapon'] = weapon
    }, function(weapons)
        if #weapons > 0 then
            if weapons[1].count + count == 0 then
                MySQL.Async.execute('DELETE FROM armory WHERE weapon = @weapon and armory_job = @armory', {
                    ['@armory'] = armory,
                    ['@weapon'] = weapon,
                }, function(rows)
                    cb(true)
                end)
            elseif weapons[1].count + count < 0 then
                cb(false)
            else
                MySQL.Async.execute('UPDATE armory SET count = count + @count where weapon = @weapon and armory_job = @armory', {
                    ['@armory'] = armory,
                    ['@weapon'] = weapon,
                    ['@count'] = count
                }, function(rows)
                    cb(true)
                end)
            end
        else
            if count < 0 then
                cb(false)
            else
                MySQL.Async.execute('INSERT INTO armory (armory_job, weapon, count) VALUES (@armory, @weapon, @count)', {
                    ['@armory'] = armory,
                    ['@weapon'] = weapon,
                    ['@count'] = count
                }, function(rows)
                    cb(true)
                end)
            end
        end
    end)
end)
