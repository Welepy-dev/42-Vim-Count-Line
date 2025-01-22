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

if exists('g:function_lines') && !empty(g:function_lines)
    echo "Functions found:"
    for function_lines in g:function_lines
        if function_lines['end_line'] > 25
			sign place 1 line=function_lines['start_line'] name=func_sign buffer=1
		endif
    endfor
	autocmd BufLeave * execute 'sign unplace * buffer=' . bufnr('%')
else
    echo "No functions found!"
endif

