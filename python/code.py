import vim
import re

# Define the pattern for a function
pattern = r"\b[a-zA-Z_][a-zA-Z0-9_]*\s+([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*\{.*?\}"

# Get the buffer content as a single string
content = "\n".join(vim.current.buffer)

# Search for the pattern in the buffer
match = re.search(pattern, content, re.DOTALL)

if match:
    # Extract match start and end positions
    start_pos = match.start()
    end_pos = match.end()
    matched_text = match.group()

    # Calculate the line numbers
    lines = content[:start_pos].splitlines()
    start_line = len(lines)
    end_line = start_line + matched_text.count("\n")
    
    # Print or use the match results
    vim.command(f'echo "Match found from line {start_line} to {end_line}"')
else:
    vim.command('echo "No match found."')

