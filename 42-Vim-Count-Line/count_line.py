import vim

def greet_user():
    # Get the current user's name
    user_name = vim.eval("g:python_plugin_user_name")
    vim.command(f'echo "Hello, {user_name}! Welcome to Vim!"')

def reverse_text():
    # Get the current line's text
    line = vim.current.line
    # Reverse the text
    vim.current.line = line[::-1]

