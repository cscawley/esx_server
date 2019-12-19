# Description

Add a panic button command which will report to all player of same job (plays a alert sound)

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-panic`

# Usage
```/panic``` triggers the panic button to all players with the same job

# Configuration

```
Config.AllowedJobs = { 'police', 'ambulance' }
Config.CooldownTime = 10000 --ms
```


# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)