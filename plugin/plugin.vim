let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

python3 << EOF
import sys
from os.path import normpath, join
import vim

plugin_root_dir = vim.eval('s:plugin_root_dir')
python_root_dir = normpath(join(plugin_root_dir, '..', 'python'))
sys.path.insert(0, python_root_dir)
import code

code.get_lines()
EOF

sign define func_sign text=ƒ texthl=Search
sign define end_sign text=! texthl=Error

if exists('g:function_lines') && !empty(g:function_lines)
	echo "Functions found:"
	let sign_id = 1
	for function_lines in g:function_lines
		if ((function_lines['end_line']) - (function_lines['start_line'] + 1)) > 25
			execute 'sign place' sign_id 'line=' . (function_lines['end_line'] + 1) . ' name=end_sign buffer=1'
			let sign_id += 1
		endif
	endfor
	autocmd BufLeave * execute 'sign unplace * buffer=' . bufnr('%')
else
	echo "No functions found!"
endif

