description 'Disc GCPhone'

version '1.0.0'

client_script {
    "client/main.lua"
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    "server/main.lua"
}
