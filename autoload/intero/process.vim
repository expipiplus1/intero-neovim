"""""""""""
" Process:
"
" This file contains functions for working with the Intero process. This
" includes ensuring that Intero is installed, starting/killing the
" process, hiding/showing the REPL, and loading the current module.
"""""""""""

"""""""""""
" Public Functions:
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
    let g:intero_buffer_id = s:start_buffer(10)
    echom "Buffer ID: " . g:intero_buffer_id
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
    call s:hide_buffer()
endfunction

function! intero#process#open()
    " Opens the Intero REPL. If the REPL isn't currently running, then this
    " creates it. If the REPL is already running, this is a noop.
    let l:intero_win = s:get_intero_window()
    if l:intero_win != -1
        return
    elseif exists('g:intero_buffer_id')
        let l:current_window = winnr()
        call s:open_window(10)
        exe 'buffer ' . g:intero_buffer_id
        exe l:current_window . 'wincmd w'
    else
        call intero#process#start()
    endif
endfunction

function! intero#process#load_current_module()
    " Loads the current module into the active Intero buffer. If no buffer
    " exists, it creates it.
    if exists('g:intero_buffer_id')
        let l:current_module = intero#util#path_to_module(expand('%'))
        let l:intero_window = s:get_intero_window()
        exe l:intero_window . 'wincmd w'
        if mode() != 'i'
            call feedkeys('i')
        endif
        call feedkeys(":load " . l:current_module . "\<ENTER>")
    else
        call intero#process#start()
        sleep '10m'
        call intero#process#load_current_module()
    endif
endfunction

""""""""""
" Private:
""""""""""
function! s:send_repl(cmd)
    " Finds the REPL buffer and sends a:cmd to the buffer.
    call feedkeys("\<C-\>\<C-n>\<C-w>k")
endfunction

function! s:start_buffer(height)
    " Starts an Intero REPL in a split below the current buffer. Returns the
    " ID of the buffer.
    exe 'below ' . a:height . ' split'
    set bufhidden=hide
    set hidden
    terminal! stack ghci --with-ghc intero
    let l:buffer_id = bufnr('%')
    call feedkeys("\<C-\>\<C-n>\<C-w>k")
    return l:buffer_id
endfunction

function! s:open_window(height)
    " Opens a window of a:height and moves it to the very bottom.
    exe 'below ' . a:height . ' split'
    normal! <C-w>J
endfunction

function! s:hide_buffer()
    " This closes the Intero REPL buffer without killing the process.
    let l:window_number = s:get_intero_window()
    if l:window_number > 0
        exe l:window_number . 'wincmd c'
    endif
endfunction

function! s:get_intero_window()
    " Returns the window ID that the Intero process is on, or -1 if it isn't
    " found.
    return bufwinnr('stack ghci --with-ghc intero')
endfunction

function! s:open_buffer(height)
    if exists('g:intero_buffer_id')
        
    else

    endif
endfunction

