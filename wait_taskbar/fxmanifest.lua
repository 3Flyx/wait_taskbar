fx_version 'cerulean'
game 'gta5'
lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/style.css',
    'html/js/script.js',

    'html/css/bootstrap.min.css',
    'html/js/jquery.min.js',
}

exports {
    'Progress',
    'ProgressWithStartEvent',
    'ProgressWithTickEvent',
    'ProgressWithStartAndTick'
}

client_script '@wait_loader/c_loader.lua'
server_script '@wait_loader/s_loader.lua'
my_data 'client_files' { "client/main.lua" }