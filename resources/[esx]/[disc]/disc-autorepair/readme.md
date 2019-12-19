# Description

This mod adds the following:

- Auto Vehicle Repair
- 7 Stages of repair

You can repair your vehicle at these locations for a price

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-autorepair`

# Usage
In a vehicle, drive up and press `E`

You will exit the vehicle and be notified when the repair is complete

Vehicle is locked while repairing

# Configuration

Prices For Repair per HP (HP Ranges from 0 - 1000)
```
Config.EnginePricePerHP = 5
Config.BodyPricePerHP = 2
```

Stage time in ms
```
Config.StageTime = 10000
```

Vehicle Repair Locations
```
Config.VehicleRepair = {
   name = 'Vehicle Repair', --Name of Blip
   coords = vector3(1150.12, -776.67, 57.6) --Location of Repair place
}
```


# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [Disc-GcPhone](https://github.com/DiscworldZA/gta-resources/tree/master/disc-gcphone)