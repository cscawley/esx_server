Config = {}

Config.Recipes = {
    bread = {
        fuzzy = true,
        items = {
            'bread', 'chips', 'bread'
        },
        item = 'bread',
        count = 2
    },
    weed = {
        fuzzy = false,
        items = {
            'weed', 'weed', 'weed'
        },
        item = 'bread',
        count = 3
    }
}

Config.Benches = {
    {
        name = 'Bakery',
        coords = vector3(-63.28, -1082.79, 26.95),
        recipes = {
            'bread', 'weed'
        }
    }
}