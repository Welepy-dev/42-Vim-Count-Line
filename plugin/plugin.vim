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

" Check if there are any functions found
if exists('g:function_lines') && !empty(g:function_lines)
    let sign_id = 1
    " Initialize a list to store details of long functions
    let long_functions = []

    " Iterate through the functions
    for function_lines in g:function_lines
        let func_length = (function_lines['end_line']) - (function_lines['start_line'] + 1)
        " Check if the function length exceeds the threshold (e.g., 25 lines)
        if func_length > 25
            " Place a sign at the end of the function
            execute 'sign place' sign_id 'line=' . (function_lines['end_line'] + 1) . ' name=end_sign buffer=' . bufnr('%')
            let sign_id += 1

            " Add the function details to the long_functions list
            call add(long_functions, 'Function: ' . function_lines['name'] . ', Lines: ' . func_length)
        endif
    endfor

    " If long functions are found, display their details in the command-line area
    if !empty(long_functions)
        echo join(long_functions, "\n")
    else
        echo "No functions exceeding the line threshold found."
    endif
else
    echo "No functions found in the current buffer."
endif
endfunction

" Add autocmds to trigger function line counting
augroup FunctionLineCounting
    autocmd!
    autocmd BufReadPost * call CountFunctionLines()
    autocmd BufWinEnter * call CountFunctionLines()
augroup END

" Define the sign for long functions
sign define end_sign text=⚠️ texthl=Error
