let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

function! CountFunctionLines()
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

if exists('g:function_lines') && !empty(g:function_lines)
    let sign_id = 1
    for function_lines in g:function_lines
        if ((function_lines['end_line']) - (function_lines['start_line'] + 1)) > 25
            execute 'sign place' sign_id 'line=' . (function_lines['end_line'] + 1) . ' name=end_sign buffer=' . bufnr('%')
            let sign_id += 1
        endif
    endfor
else
    echo "No functions found!"
endif
endfunction

" Add autocmds to trigger function line counting
augroup FunctionLineCounting
    autocmd!
    autocmd BufReadPost * call CountFunctionLines()
    autocmd BufWinEnter * call CountFunctionLines()
augroup END

sign define func_sign text=ƒ texthl=Search
sign define end_sign text=! texthl=Error