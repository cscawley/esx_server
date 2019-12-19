# Description

Add vehicle lock pick mechanics

- Blowtorch
- Lock pick

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-vehiclepick.sql`

Start using `start disc-vehiclepick`

# Config
Tool
```
lockpick = {
        itemName = 'lockpick', --DB Item Name
        time = 10000, --Time in MS for operation
        animation = "WORLD_HUMAN_WELDING", --Scenario to play
        use = true --Remove item when used
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)