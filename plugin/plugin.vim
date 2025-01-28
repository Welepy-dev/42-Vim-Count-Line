let s:plugin_root_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" Function to count function lines and place signs
function! CountFunctionLines()
    " Run the Python script to get updated function details
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

    " Clear all existing signs before placing new ones
    execute 'sign unplace * buffer=' . bufnr('%')

    " Check if there are any functions found
    if exists('g:function_lines') && !empty(g:function_lines)
        let sign_id = 1

        " Iterate through the functions
        for function_lines in g:function_lines
            let func_length = (function_lines['end_line']) - (function_lines['start_line'] + 1)

            " Check if the function length exceeds the threshold (e.g., 25 lines)
            if func_length > 25
                " Place a sign at the end of the function
                execute 'sign place' sign_id 'line=' . (function_lines['end_line'] + 1) . ' name=end_sign buffer=' . bufnr('%')
                let sign_id += 1
            endif
        endfor
    endif
endfunction

" Function to dynamically display function info in the command-line area
function! ShowFunctionInfo()
    " Get the current line number
    let current_line = line(".")

    " Check if g:function_lines exists
    if exists('g:function_lines') && !empty(g:function_lines)
        for function_lines in g:function_lines
            " Check if the cursor is at the end of a long function
            if current_line == function_lines['end_line'] && function_lines['end_line'] - function_lines['start_line'] > 25
                let lines = function_lines['end_line'] - function_lines['start_line']
                echo "Function: " . function_lines['name'] . " (" . lines . " lines)"
                return
            endif
        endfor
    endif

    " Clear the command-line area if no relevant information is found
    echo ""
endfunction

" Trigger the function to update signs and lines dynamically on text changes
autocmd TextChanged,TextChangedI * call CountFunctionLines()

" Trigger the function to update the command-line info dynamically on cursor movement
autocmd CursorMoved,CursorMovedI * call ShowFunctionInfo()

" Update function line counting on file load or save
augroup FunctionLineCounting
    autocmd!
    autocmd BufReadPost * call CountFunctionLines()
    autocmd BufWritePost * call CountFunctionLines()
augroup END

" Define the sign for long functions
sign define end_sign text=⚠️ texthl=Error

