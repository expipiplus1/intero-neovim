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
    let s:buffer_id = s:start_buffer(10)
    echom "Buffer ID: " . s:buffer_id
    return s:buffer_id
endfunction

function! intero#process#kill()
    " Kills the intero buffer, if it exists.
    if exists('s:buffer_id')
        exe 'bd! ' . s:buffer_id
    else
        echo "No Intero process loaded."
    endif
endfunction

function! intero#process#load_current_module()
    " Loads the current module into the active Intero buffer. If no buffer
    " exists, it creates it.
    if exists('s:buffer_id')
        let l:current_module = intero#util#path_to_module(expand('%'))
        let l:current_buffer = bufnr('%')
        echo "finish meee"
    else
        call intero#process#start()
        call intero#process#load_current_module()
    endif
endfunction

""""""""""
" Private:
""""""""""
function! s:start_buffer(height)
    " Starts an Intero REPL in a split below the current buffer. Returns the
    " ID of the buffer.
    exe 'below ' . a:height . ' split'
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
    if exists('s:buffer_id')
        
    else

    endif
endfunction

