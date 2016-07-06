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
endfunction

function! intero#repl#get_last_response()
    echom s:get_last_response()
endfunction

""""""""""
" Private:
""""""""""

function! s:get_last_response()
    " Returns the previous response.
    let l:last_line = s:get_last_line()
    let l:lines = split(s:get_prev_matching(l:last_line[0:-1]), '\n')
    return join(l:lines[0:-2], "\n")
endfunction

function! s:get_prev_matching(str)
    call s:switch_to_repl()

    normal! GV
    let l:i_save = @i
    
    exe "silent! normal! ?" . a:str . "\<CR>\"iY"
    let l:ret = @i
    let @i = l:i_save

    call s:return_from_repl()

    return l:ret
endfunction

function! s:get_last_line()
    return s:get_line_repl(0)
endfunction

function! s:send(str)
    " Sends a:str to the Intero REPL.
    if !exists('g:intero_buffer_id')
        echomsg "Intero not running."
        return
    endif
    call jobsend(g:intero_job_id, add([a:str], ''))
endfunction

function! s:switch_to_repl()
    " Switches to the REPL. Use with return_from_repl.
    let s:current_window = winnr()
    let l:i_win = intero#util#get_intero_window()

    if l:i_win == -1
        " Intero window not found. Open and close it.
        call intero#process#open()
        let l:i_win = intero#util#get_intero_window()
        exe 'silent! ' . l:i_win . ' wincmd w'
    else
        " Intero window available. Don't close it.
        exe 'silent! ' . l:i_win . ' wincmd w'
        let b:dont_close_intero_window = 1
    endif
endfunction

function! s:return_from_repl()
    " Returns to the current window from the REPL.
    if ! exists('s:current_window')
        echom "No current window."
        return
    endif

    if exists('b:dont_close_intero_window')
        unlet b:dont_close_intero_window
    else
        call intero#process#hide()
    endif

    exe s:current_window . 'wincmd w'
endfunction

function! s:get_line_repl(n)
    " Retrieves the second to last line from the Intero repl. The most recent
    " line will always be a prompt.
    call s:switch_to_repl()
    let l:ret = s:get_line(a:n)
    call s:return_from_repl()
    return l:ret
endfunction

function! s:get_line(n)
    " Grabs the line `n` from the current buffer.
    if a:n < 1
        let l:move = ''
    else
        let l:move = a:n . 'k'
    endif
    try
        let l:save = @i
        edit
        exec 'normal! G' . l:move . '"iyyG'
        let l:line = @i
    finally
        let @i = l:save
    endtry

    return substitute(l:line, "\%x00", "", "g")
endfunction
