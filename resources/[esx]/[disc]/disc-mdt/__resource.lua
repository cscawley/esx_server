resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    'config/config.lua',
    'config/configcolours.lua',
    'client/main.lua',
    'client/vehicles.lua',
    'client/civilians.lua',
    'client/crimes.lua',
    'client/report.lua',
    'client/bolo.lua',
    'utils/utils.lua',
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'server/main.lua',
    'server/vehicles.lua',
    'server/report.lua',
    'server/civilians.lua',
    'server/crimes.lua',
    'server/bolo.lua',
    'utils/utils.lua',
}

ui_page "web/html/index.html"

files {
    "web/html/main.js",
    "web/html/index.html",
    "web/html/notification.wav",
}
