import re
import vim

def get_lines():

	file_path = vim.eval('expand("%:p")')

	if not file_path:
		vim.command('echo "Error: No file is currently loaded."')
		return
	
	try:
		with open(file_path, 'r') as f:
			code = f.read()
	except Exception as e:
		vim.command(f'echo "Error reading file: {e}"')
		return


	pattern = r"""
	\b[a-zA-Z_][a-zA-Z0-9_]*\s+\**([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*\{
	"""


	matches = re.finditer(pattern, code, re.DOTALL | re.VERBOSE)

	function_lines = []

	for match in matches:
		func_start_index = match.start()
		func_signature = match.group(0)
		func_start_line = code[:func_start_index].count('\n') + 1
		start = match.end()
		stack = 1

		for i, char in enumerate(code[start:], start=start):
			if char == '{':
				stack += 1
			elif char == '}':
				stack -= 1
			if stack == 0:
				func_end_index = i + 1
				func_end_line = code[:func_end_index].count('\n')
				function_lines.append({
					"name": func_signature.split('(')[0].strip(),
					"start_line": func_start_line,
					"end_line": func_end_line,
					"body": code[func_start_index:func_end_index]
				})
				break
	vim.vars['function_lines'] = function_lines

