fx_version 'cerulean'
game 'gta5'

name 'benny_blackmarket'
description 'Blackmarket system med UI'
author 'Benny'
version '1.0.0'

shared_scripts {
    'config.lua',
    '@st_libs/init.lua',
    '@ox_lib/init.lua',
}

st_libs {
    'callback',
    'interaction',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

lua54 'yes'
