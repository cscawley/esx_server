# Description

Add a Job Car garage for any job

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-jobcars.sql`

Start using `start disc-jobcars`

# Config
```
{
    name = 'Police', --Shop Name
    job = 'police', --Shop Job
    coords = vector3(454.6, -1017.4, 28.4), --Garage Location
    shopCoords = vector3(144.15, -712.22, 32.2), --Shop Location
    colour = { r = 55, b = 255, g = 55 }, --Garage Marker Colour
    cars = { --Car List
        recruit = { --Job Grade
            { 
                name = 'Police', --Car Name
                model = 'police', --Car Model
                price = 150000 --Car Price
            },
        }
    }
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [ESX_VehicleShop](https://github.com/ESX-Org/esx_vehicleshop)

# To Do

- Add Displaying of vehicles when buying