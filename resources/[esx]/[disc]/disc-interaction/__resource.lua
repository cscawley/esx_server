resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

ui_page 'html/ui.html'

version '1.0.0'

client_scripts {
    'client/main.lua',
    'client/vehicle.lua',
    'client/citizen.lua',
    'config.lua',
}

server_scripts {
    'server/main.lua',
    'server/citizen.lua',
    'config.lua',
}

files {
    'html/ui.html',
    'html/css/style.min.css',
    'html/js/ui.js',
    'html/js/config.js',
    'html/css/jquery-ui.min.css',
    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
    'html/js/jquery-ui.min.js',
    'html/js/bootstrap.min.js',
    'html/js/popper.min.js',

    -- IMAGES
    'html/img/*.png',
    'html/success.wav',
    'html/fail.wav',
}

dependencies {
    'es_extended'
}