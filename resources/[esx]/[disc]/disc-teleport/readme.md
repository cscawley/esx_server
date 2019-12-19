# Description

This mod adds the following:

- Teleporters
- Allows Vehicles (configurable)

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-teleport`

# Configuration

Config.Teleporters
```
{
    name = 'Test Teleport 2',
    coords = vector3(1463.97, 1133.9, 114.32),
    destination = vector3(-1995.75, 288.11, 91.6),
    heading = 245.0,
    colour = { r = 255, g = 0, b = 0 },
    allowVehicles = true,
    job = 'police',
    grades = {
        'recruit',
        'officer'
    }
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)