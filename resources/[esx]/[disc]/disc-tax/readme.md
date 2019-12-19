# Description

Add a taxing mechanic

Runs tax every day at TaxTime and deducts based on bracket

# Installation
Add to resource folder `[esx]` or `[disc]`

Start using `start disc-tax`

# Config
Time to run Taxing
```
Config.TaxTime = {
    h = 00,
    m = 00
}
```
Tax money on hand
```
Config.TaxMoney = true
```

Tax Brackets
```
--Increasing Order
Config.TaxBrackets = {
    default = {
        percent = 10
    },
    {
        low = 0,
        high = 200000,
        percent = 5
    },
    {
        low = 200000,
        high = 500000,
        percent = 10
    }
}
```

# Requirements

- [Disc-Base](https://github.com/DiscworldZA/gta-resources/tree/master/disc-base)
