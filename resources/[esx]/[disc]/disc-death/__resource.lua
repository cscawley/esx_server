resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Disc Death'

version '1.0.1'

client_scripts {
    'config.lua',
    'client/main.lua',
    'client/death.lua',
}

server_scripts {
    'config.lua',
    'server/main.lua',
    'server/death.lua',
    "@mysql-async/lib/MySQL.lua"
}
