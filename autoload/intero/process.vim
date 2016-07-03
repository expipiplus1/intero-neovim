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
    let b:intero_buffer_id = s:start_buffer(10)
    return b:intero_buffer_id
endfunction

function! s:start_buffer(height)
    " Starts an Intero REPL in a split below the current buffer. Returns the
    " ID of the buffer.
    exe 'below ' . a:height . ' split'
    terminal! stack ghci --with-ghc intero
    let l:buffer_id = bufnr('%')
    call feedkeys("\<C-\>\<C-n>\<C-w>k")
    return l:buffer_id
endfunction

function! intero#process#load_current_module()
    " Loads the current module into the active Intero buffer. If no buffer
    " exists, it creates it.
    if exists('b:intero_buffer_id')
        let l:current_module = intero#util#path_to_module(expand('%'))
        let l:current_buffer = bufnr('%')

    else
        call intero#process#start()
        call intero#process#load_current_module()
    endif
endfunction
