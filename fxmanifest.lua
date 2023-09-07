fx_version 'cerulean'
game 'gta5'
lua54 'yes' 
author 'AngelicXS'
version '1.0'

client_script {
    'client.lua'
}

server_script {
    'server.lua',
    '@mysql-async/lib/MySQL.lua'
}

shared_scripts {
   'config.lua',
   '@ox_lib/init.lua',
} 
