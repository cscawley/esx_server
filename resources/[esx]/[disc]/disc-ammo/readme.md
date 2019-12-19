# Description

This mod adds the following:

- Ability to add ammo items for adding ammo

# Usage

- Equip Weapon
- Use Item

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-ammo.sql`

Start using `start disc-ammo`

# Configuration
```
Config.EnableInventoryHUD = true -- Compatible with Disc-InventoryHUD
Config.ReloadTime = 2000 --ms

Config.Ammo = {
    {
        name = 'disc_ammo_pistol',
        weapons = {
            `WEAPON_PISTOL`,
            `WEAPON_SNSPISTOL`
        },
        count = 30
    },
    {
            name = 'disc_ammo_pistol_large',
            weapons = {
                `WEAPON_PISTOL`,
                `WEAPON_SNSPISTOL`
            },
            count = 60
        }
}
```


# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [Disc-InventoryHUD](https://github.com/DiscworldZA/gta-resources/tree/master/disc-inventoryhud) (Optional)