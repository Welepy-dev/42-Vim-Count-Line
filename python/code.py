import vim
import re

# Define the sign (only needs to be done once)
vim.command('sign define MatchSign text=> texthl=Search')

# Get the buffer content as a string
content = "\n".join(vim.current.buffer)

# Define a regex pattern
pattern = r"\b[a-zA-Z_][a-zA-Z0-9_]*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*\{.*?\}"

# Find matches and place signs in the gutter
for match in re.finditer(pattern, content, re.DOTALL):
    # Calculate the start line
    start_pos = match.start()
    start_line = content[:start_pos].count("\n") + 1

    # Place a sign in the gutter
    vim.command(f'sign place {start_line} line={start_line} name=MatchSign buffer={vim.current.buffer.number}')

