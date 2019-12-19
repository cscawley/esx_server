# Description

This mod adds the following:

- Drug Runs

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-drugsales`

# Steps

- Insert Drug Items into `essentialmode.items` table on your database
- Configure with your drug items

# Usage
1. Go to start location
2. Pay the price
3. Get random drug items
4. Get Random Locations to deliver to sent by phone

# Configuration

Drug Items
```
{ 
    name = 'Oxy', --Name of Drug
    item = 'oxy', --Name of Item
    price = { 
        500,
        2000
    } 
}
```

Price to Pay for Starting Run
```
Config.StartPrice = 2000
```

Starting Points
```
Config.StartingPoints --List of Starting Points
```

Delivery Points
```
Config.DeliveryPoints --List of Delivery Points
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
- [Disc-GcPhone](https://github.com/DiscworldZA/gta-resources/tree/master/disc-gcphone)


# To Do

- Add NPC to accept drugs
- Add failure to deliver and NPC robbing you
