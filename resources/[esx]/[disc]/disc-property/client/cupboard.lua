function OpenCupboard(room)
    TriggerEvent('disc-inventoryhud:openInventory', {
        type = 'cupboard',
        owner = room
    })
end
