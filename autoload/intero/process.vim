"""""""""""
" Process:
"
" This file contains functions for working with the Intero process. This
" includes ensuring that Intero is installed, starting/killing the
" process, and hiding/showing the REPL.
"""""""""""

function! intero#process#ensure_installed()
    " This function ensures that intero is installed. If `stack` exits with a
    " non-0 exit code, that means it failed to find the executable.
    "
    " TODO: Verify that we have a version of intero that the plugin can work
    " with.
    let l:version = system('stack exec --verbosity silent -- intero --version')
    if v:shell_error
        echom "Intero not installed."
        execute "! stack build intero"
    endif
endfunction

function! intero#process#start()
    " Starts an intero terminal buffer, initially only occupying a small area.
    " Returns the intero buffer id.
    if !exists('g:intero_buffer_id')
        let g:intero_buffer_id = s:start_buffer(10)
    endif
    return g:intero_buffer_id
endfunction

function! intero#process#kill()
    " Kills the intero buffer, if it exists.
    if exists('g:intero_buffer_id')
        exe 'bd! ' . g:intero_buffer_id
        unlet g:intero_buffer_id
    else
        echo "No Intero process loaded."
    endif
endfunction

function! intero#process#hide()
    " Hides the current buffer without killing the process.
    silent! call s:hide_buffer()
endfunction

function! intero#process#open()
    " Opens the Intero REPL. If the REPL isn't currently running, then this
    " creates it. If the REPL is already running, this is a noop. Returns the
    " window ID.
    let l:intero_win = intero#util#get_intero_window()
    if l:intero_win != -1
        return l:intero_win
    elseif exists('g:intero_buffer_id')
        let l:current_window = winnr()
        silent! call s:open_window(10)
        exe 'silent! buffer ' . g:intero_buffer_id
        normal! G
        exe 'silent! ' . l:current_window . 'wincmd w'
    else
        call intero#process#start()
        return intero#process#open()
    endif
endfunction

""""""""""
" Private:
""""""""""

function! s:term_buffer(job_id, data, event)
    " let g:intero_last_response = intero#repl#get_last_response()
endfunction

function! s:on_response()
    let l:mode = mode()
    if ! (l:mode =~ "c")
        let l:current_response = intero#repl#get_last_response()
        if !exists('s:previous_response')
            let s:previous_response = l:current_response
            for r in l:current_response
                echom r
            endfor
        else 
            if l:current_response != s:previous_response
                let s:previous_response = l:current_response
                for r in s:previous_response
                    echom r
                endfor
                echo join(s:previous_response, "\n")
            endif
        endif
    endif
endfunction

function! s:start_buffer(height)
    " Starts an Intero REPL in a split below the current buffer. Returns the
    " ID of the buffer.
    exe '10new'
    let l:opts = { 'on_stdout': function('s:term_buffer') }
    let g:intero_job_id = termopen("stack ghci --with-ghc intero", l:opts)
    set bufhidden=hide
    set noswapfile
    set hidden
    let l:buffer_id = bufnr('%')
    quit
    "call feedkeys("\<ESC>")
    call timer_start(100, 's:on_response', {'repeat':-1})
    return l:buffer_id
endfunction

function! s:open_window(height)
    " Opens a window of a:height and moves it to the very bottom.
    exe 'below ' . a:height . ' split'
    normal! <C-w>J
endfunction

function! s:hide_buffer()
    " This closes the Intero REPL buffer without killing the process.
    let l:window_number = intero#util#get_intero_window()
    if l:window_number > 0
        exec 'silent! ' . l:window_number . 'wincmd c'
    endif
endfunction
