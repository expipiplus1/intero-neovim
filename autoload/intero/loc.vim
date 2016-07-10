""""""""""
" Location:
"
" This file contains code for parsing locations and jumping to them.
""""""""""

function! intero#loc#go_to_def()
    let l:module = intero#util#path_to_module(expand('%'))
    let l:line = line('.')
    let l:identifier = intero#util#get_haskell_identifier()
    let l:winview = winsaveview()
    normal! |
    call search(l:identifier, '', l:line)
    let l:beg_col = intero#util#getcol()
    let l:end_col = l:beg_col + len(l:identifier)
    let l:cmd = join([':loc-at', l:module, l:line, l:beg_col, l:line, l:end_col, l:identifier], ' ')
    echo l:cmd
    call winrestview(l:winview)
    call intero#repl#eval(l:cmd)
endfunction
