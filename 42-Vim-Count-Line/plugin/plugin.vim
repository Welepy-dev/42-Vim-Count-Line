" Set a global variable for the plugin
let g:python_plugin_user_name = "Vim User"

" Map commands to Python functions
command! GreetUser call py3eval('greet_user()')
command! ReverseLine call py3eval('reverse_text()')

