""""""""""
" Repl:
"
" This file contains code for sending commands to the Intero REPL.
""""""""""

function! intero#repl#eval(...)
    " Given no arguments, this requests an expression from the user and
    " evaluates it in the Intero REPL.
    if a:0 == 0
        call inputsave()
        let l:eval = input("Command: ")
        call inputrestore()
    elseif a:0 == 1
        let l:eval = a:1
    else
        echomsg "Call with nothing for eval or with command string."
        return
    endif

    call s:send(l:eval)
endfunction

function! intero#repl#load_current_module()
    " Loads the current module, inferred from the given filename.
    call intero#repl#eval(':l ' . intero#util#path_to_module(expand('%')))
endfunction

function! intero#repl#type()
    " Gets the type at the current point.
    let l:line = line('.')
    let l:col = intero#util#getcol()
    let l:module = intero#util#path_to_module(expand('%'))
    call intero#repl#eval(
        \ join([':type-at', l:module, l:line, l:col, l:line, l:col, 'it'], ' '))
    echomsg s:get_line_repl()
endfunction

""""""""""
" Private:
""""""""""
function! s:send(str)
    " Sends a:str to the Intero REPL.
    if !exists('g:intero_buffer_id')
        echomsg "Intero not running."
        return
    endif
    call jobsend(g:intero_job_id, add([a:str], ''))
endfunction

function! s:get_line_repl()
    " Retrieves the second to last line from the Intero repl. The most recent
    " line will always be a prompt.
    let l:current_window = winnr()

    let l:i_win = intero#util#get_intero_window()

    if l:i_win == -1
        " Intero window not found. Open and close it.
        call intero#process#open()
        let l:i_win = intero#util#get_intero_window()
        exe 'silent! ' . l:i_win . ' wincmd w'
        let l:ret = s:get_line(0)
        call intero#process#hide()
    else
        " Intero window available. Don't close it.
        exe l:i_win . ' wincmd w'
        let l:ret = s:get_line(0)
    endif
    exe l:current_window . 'wincmd w'
    return l:ret
endfunction

function! s:get_line(n)
    " Grabs the line `n` a
    try
        let l:save = @i
        edit
        exec 'normal! G' . a:n . 'k"iyyG'
        let l:line = @i
    finally
        let @i = l:save
    endtry

    return substitute(l:line, "\%x00", "", "g")
endfunction
