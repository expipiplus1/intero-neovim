function! intero#diagnostics#ensure_intero_installed()
    let l:version = system('stack exec --verbosity silent -- intero --version')
    if v:shell_error
        echom "Intero not installed."
        execute "! stack build intero"
    endif
endfunction
