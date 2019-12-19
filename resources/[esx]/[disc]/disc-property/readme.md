# Description

Adds a property mechanic

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-property.sql`

Start using `start disc-property`

# Explanation

The focus of this property mod is to create non instanced properties. This means 1 person owns the property and
can give out keys to other players. Players with keys have access to the property and garage as well as all the cupboards.

# Features

- Kitchen to make food
- House Keys
- Shared Garage
- Rooms with shared cupboards (items are stored in individual cupboards)
- Viewing of property if not sold

# Config
```
{
    name = '3655 Wild Oats Drive', --Name of property as listed in DB
    price = 1000000, -- Price of Property
    view = {
        coords = vector3(-178.56, 502.66, 136.84), --Viewing Coordinates
    },
    inside = {
        coords = vector3(-174.2, 497.67, 137.67), --Inside of Property
        heading = 188.88
    },
    outside = {
        coords = vector3(-175.46, 502.15, 137.42), --Outside of Property
        heading = 51.9
    },
    kitchen = {
        coords = vector3(-167.03, 495.42, 137.65) --Kitchen of Property
    },
    garage = {
        coords = vector3(-188.73, 500.61, 134.64), --Garage of Property
        heading = 0.0
    },
    rooms = { --Rooms of Property
        {
            clothes = {
                coords = vector3(-167.33, 487.49, 133.84)
            },
            cupboard = {
                coords = vector3(-170.26, 482.09, 133.84)
            }
        },
        {
            clothes = {
                coords = vector3(-174.88, 493.43, 130.04)
            },
            cupboard = {
                coords = vector3(-174.83, 489.88, 130.04)
            }
        }
    }
},
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [Disc-InventoryHUD](https://github.com/DiscworldZA/gta-resources/tree/master/disc-inventoryhud)
