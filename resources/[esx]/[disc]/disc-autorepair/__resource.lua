resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Disc AutoRepair'

version '1.0.0'

client_scripts {
    'client/main.lua',
    'config.lua',
}

server_scripts {
    'config.lua',
    'server/main.lua'
}
