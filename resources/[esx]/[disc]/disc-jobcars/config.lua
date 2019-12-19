Config = {}

Config.ClaimPrice = 1000

Config.Shops = {
    {
        name = 'Police',
        job = 'police',
        coords = vector3(454.6, -1017.4, 28.4),
        heading = 0.0,
        shopCoords = vector3(144.15, -712.22, 32.2),
        colour = { r = 55, b = 255, g = 55 },
        cars = {
            recruit = {
                { name = 'Police', model = 'police', price = 150000 },
            },
            sergeant = {
                { name = 'Police', model = 'police', price = 150000 },
            }
        }
    },
    {
        name = 'Ambulance',
        job = 'ambulance',
        coords = vector3(454.6, -1020.4, 28.4),
        heading = 0.0,
        shopCoords = vector3(446.7, -1355.6, 43.5),
        colour = { r = 255, b = 55, g = 55 },
        cars = {
            doctor = {
                { name = 'Ambulance', model = 'reaper', price = 100000 }
            }
        }
    }
}
