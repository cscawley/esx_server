# Description

Allow compensation for specific jobs

# Installation
Add to resource folder `[esx]` or `[disc]`

Execute SQL : `disc-compensation.sql`

Start using `start disc-compensation`

# Usage

Command `/compensate` opens menu of nearby players, select player and follow prompts

# Config
```
{
    lawyer = { --job
         'judge' --grade
}
```
```
Config.CompensationPercentage = 10 --%
```
```
Config.AllowSelfCompensation = false
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
