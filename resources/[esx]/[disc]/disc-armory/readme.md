# Description

This mod adds the following:

- Armory to any job

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-armory`

# Configuration
Armories
```
{
    name = 'Police', --Armory Name
    coords = vector3(459.45, -981.20, 30.69), --Armory Location
    job = 'police', --Armory Job
    weapons = { --Armory Sells these weapons
        { name = 'WEAPON_FLASHLIGHT', price = 500 },
        { name = 'WEAPON_NIGHTSTICK', price = 500 },
        { name = 'WEAPON_HANDCUFFS', price = 2000 },
        { name = 'WEAPON_STUNGUN', price = 2000 },
        { name = 'WEAPON_PISTOL', price = 5000 },
        { name = 'WEAPON_SMG', price = 10000 },
        { name = 'WEAPON_CARBINERIFLE', price = 15000 },
        { name = 'WEAPON_SPECIALCARBINE', price = 20000 },
    }
}
```

List of all Weapons
```
Config.Weapons
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)