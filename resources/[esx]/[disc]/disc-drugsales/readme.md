# Description

This mod adds the following:

- NPC Drug Sales

Drug sales has a percentage chance of failing and notifying the cops

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-drugsales`

##Steps

- Insert Drug Items into `essentialmode.items` table on your database
- Configure with your drug items

# Usage
If you have drugs you can walk up to an NPC and sell them the drugs.

# Configuration

Drug Items
```
weed = {
        name = 'weed', --Item Name
        priceMin = 200, --Minimum Payout
        priceMax = 500, --Maximum Payout
        sellCountMin = 1, --Minimum Amount Selling
        sellCountMax = 5 --Maximum Amount Selling
    }
```

Cops Needed
```
Config.CopsNeeded = 2 --Amount of cops needed to be able to sell
```

Waiting Time
```
Config.DiscussTime = 5000 --Time(ms) Civilian is standing still while selling
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [Disc-GcPhone](https://github.com/DiscworldZA/gta-resources/tree/master/disc-gcphone)
- [ESX Police Job](https://github.com/ESX-Org/esx_policejob)
