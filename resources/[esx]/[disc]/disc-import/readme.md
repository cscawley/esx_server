# Description

Add a simple importing mechanic

- Drive to a pick up location and pick up the crate
- Drive back to the start location and unpack the crate

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-import.sql`

Start using `start disc-import`

# Config
```
{
    StartingLocation = vector3(913.18, -3341.56, 5.9),
    PickupLocation = vector3(896.23, -3340.9, 5.9),
    Illegal = false,
    Price = 3000,
    Item = 'lockpick',
    Quantity = 10,
    Vehicle = 'Burrito3',
    VehicleSpawnLocation = vector3(913.18, -3341.56, 5.9),
    VehicleSpawnHeading = 0.0
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)