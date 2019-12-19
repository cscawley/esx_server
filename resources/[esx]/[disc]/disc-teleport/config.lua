Config = {}

Config.Locale = 'en'

Config.Teleporters = {
    {
        name = 'Test Teleport',
        coords = vector3(-1995.75, 288.11, 91.6),
        destination = vector3(1463.97, 1129.19, 114.32),
        heading = 245.0,
        colour = { r = 255, g = 0, b = 0 },
        allowVehicles = true,
        job = 'police',
    },
    {
        name = 'Test Teleport 2',
        coords = vector3(1463.97, 1133.9, 114.32),
        destination = vector3(-1995.75, 288.11, 91.6),
        heading = 245.0,
        colour = { r = 255, g = 0, b = 0 },
        allowVehicles = true,
        job = 'all',
        grades = {
            'recruit',
            'officer'
        }
    }
}
