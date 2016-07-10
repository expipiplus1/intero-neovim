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
    call winrestview(l:winview)
    call intero#repl#send(l:cmd)
    call timer_start(100, 's:do_the_hop', { 'repeat': 1 }) 
endfunction

function! s:do_the_hop()
    let l:response = join(intero#repl#get_last_response(), "\n")
    let l:split = split(l:response, ':')
    let l:pack_or_path = l:split[0]
    let l:module_or_loc = l:split[1]

    if l:module_or_loc =~ '[\h\+\.\?]\+'
        echo l:response
    else
        echom "it is a location"
        let l:loc_split = split(l:module_or_loc, '-')
        let l:start = substitute(l:loc_split[0], '[\(\)]', '', 'g')
        let l:end = substitute(l:loc_split[1], '[\(\)]', '', 'g')
        let l:start_split = split(l:start, ',')
        let l:start_row = l:start_split[0]
        let l:start_col = l:start_split[1]
""        let l:end_split = split(l:end, ',')
""        let l:end_row = l:end_split[0]
""        let l:end_col = l:end_split[1]
       
        exec 'edit +' . l:start_row . ' ' . l:pack_or_path
        call cursor(l:start_row, l:start_col)
    endif
endfunction
